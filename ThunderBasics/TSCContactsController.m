 //
//  RCHContactsController.m
//  ARC Hazards
//
//  Created by Matt Cheetham on 25/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE Design Ltd. All rights reserved.
//

#import "TSCContactsController.h"
#import "TSCPerson.h"

@interface TSCContactsController () <CNContactPickerDelegate>

@property (nonatomic, strong) UINavigationController *presentedPersonViewController;

@property (nonatomic, strong) id <NSObject> contactObserver;

@end

@implementation TSCContactsController

static TSCContactsController *sharedController = nil;

+ (TSCContactsController *)sharedController
{
    @synchronized(self) {
        if (sharedController == nil) {
            sharedController = [self new];
        }
    }
    
    return sharedController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.contactObserver = [[NSNotificationCenter defaultCenter] addObserverForName:CNContactStoreDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TSCAddressBookChangeNotification object:nil];
        }];
    }
    return self;
}

- (void)presentPeoplePickerWithCompletion:(TSCPeoplePickerPersonSelectedCompletion)completion inViewController:(UIViewController *)presentingViewController
{
    self.TSCPeoplePickerPersonSelectedCompletion = completion;
    
    CNContactPickerViewController *contactViewController = [CNContactPickerViewController new];
    contactViewController.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        presentingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        contactViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [presentingViewController presentViewController:contactViewController animated:true completion:nil];
}

#pragma mark - Converting and extracting users

- (TSCPerson *)personWithRecordIdentifier:(NSString *)identifier
{
    
    CNContact *newContact = [self contactForLegacyIdentifier:identifier];
    
    if (newContact) {
        return [[TSCPerson alloc] initWithContact:newContact];
    } else {
        return nil;
    }
    
    return nil;
}

- (void)extractAllContactsWithCompletion:(TSCAllContactsCompletion)completion
{
    
    CNContactStore *store = [CNContactStore new];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:[self contactKeysToFetch]];
    NSError *error = nil;
    
    NSMutableArray *contacts = [NSMutableArray new];
    [store enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [contacts addObject:[[TSCPerson alloc] initWithContact:contact]];
    }];
    
    if (error) {
        
        if (completion) {
            completion(nil, error);
        }
    } else {
        
        if (completion) {
            completion(contacts, nil);
        }
    }
}

- (CNContact *)contactForIdentifier:(NSString *)identifier
{
    CNContactStore *store = [CNContactStore new];
    return [store unifiedContactWithIdentifier:identifier keysToFetch:[self contactKeysToFetch] error:nil];
}

- (CNContact *)contactForLegacyIdentifier:(id)identifier
{
    if ([identifier isKindOfClass:[NSString class]]) {
        
        CNContactStore *store = [CNContactStore new];
        return [store unifiedContactWithIdentifier:(NSString *)identifier keysToFetch:[self contactKeysToFetch] error:nil];
    }
    
    if ([identifier isKindOfClass:[NSNumber class]]) {
        
        CNContactStore *store = [CNContactStore new];
        __block CNContact *newContact;
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:[self contactKeysToFetch]];
        
        [store enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            if ([[contact valueForKey:@"_iOSLegacyIdentifier"] isKindOfClass:[NSNumber class]]) {
                
                NSNumber *contactID = (NSNumber *)[contact valueForKey:@"_iOSLegacyIdentifier"];
                if ([contactID isEqualToNumber:(NSNumber *)identifier]) {
                    
                    newContact = contact;
                    *stop = true;
                }
            }
        }];
        
        return newContact;
    }

    return nil;
}

#pragma mark - Presenting/Editing contacts

- (CNContactViewController *)personViewControllerForRecordIdentifier:(NSString *)identifier
{
    CNContactViewController *contactViewController = [CNContactViewController viewControllerForContact:[self contactForLegacyIdentifier:identifier]];
    return contactViewController;
}

- (void)presentPersonWithRecordIdentifier:(NSString *)identifier inViewController:(UIViewController *)viewController
{
    UIViewController *view = [self personViewControllerForRecordIdentifier:identifier];
    view.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDismissPeopleView:)];
    
    self.presentedPersonViewController = [[UINavigationController alloc] initWithRootViewController:view];
    [viewController presentViewController:self.presentedPersonViewController animated:true completion:nil];
}

- (void)handleDismissPeopleView:(UIBarButtonItem *)button
{
    if (self.presentedPersonViewController.viewControllers.count > 0 && [self.presentedPersonViewController.viewControllers[0] isKindOfClass:[CNContactViewController class]]) {
        
        CNContactViewController *viewController = (CNContactViewController *)self.presentedPersonViewController.viewControllers[0];
        TSCPerson *editedPerson = [self personWithRecordIdentifier:viewController.contact.identifier];
        [editedPerson updateWithCNContact:viewController.contact];
    }
    
    [self.presentedPersonViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - People lookup

- (NSArray *)peopleForArrayOfIdentifiers:(NSArray *)array
{
    NSMutableArray *peopleArray = [NSMutableArray array];
    
    for (id uniqueIdentifier in array) {
        
        TSCPerson *person = [self personWithRecordIdentifier:uniqueIdentifier];
        
        if (person) {
            [peopleArray addObject:person];
        }
    }
    
    return peopleArray;
}

- (NSArray *)addressbookIdsforPeople:(NSArray *)people
{
    NSMutableArray *addressbookIdsArray = [NSMutableArray new];
    
    for (TSCPerson *person in people) {
        
        if(person.recordIdentifier) {
            [addressbookIdsArray addObject:person.recordIdentifier];
        }
    }
    
    return [NSArray arrayWithArray:addressbookIdsArray];
}


#pragma mark - Contact View Controller Delegate

- (BOOL)contactViewController:(CNContactViewController *)viewController shouldPerformDefaultActionForContactProperty:(CNContactProperty *)property
{
    return false;
}

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    
}

#pragma mark - CNContactPickerDelegate

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    self.TSCPeoplePickerPersonSelectedCompletion(nil, nil);
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    TSCPerson *selectedPerson = [[TSCPerson alloc] initWithContact:contact];
    self.TSCPeoplePickerPersonSelectedCompletion(selectedPerson, nil);
}

#pragma mark - Helpers

- (NSArray *)contactKeysToFetch
{
    return @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactNicknameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactImageDataKey, CNContactThumbnailImageDataKey, [CNContactViewController descriptorForRequiredKeys]];
}

@end
