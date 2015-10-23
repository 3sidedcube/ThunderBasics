 //
//  RCHContactsController.m
//  ARC Hazards
//
//  Created by Matt Cheetham on 25/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE Design Ltd. All rights reserved.
//

#import "TSCContactsController.h"
#import "TSCPerson.h"

@interface TSCContactsController () <ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate, CNContactPickerDelegate>

@property (nonatomic, strong) UINavigationController *presentedPersonViewController;
@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong, readwrite) dispatch_queue_t addressBookQueue;
@property (nonatomic, strong, readwrite) dispatch_queue_t externalAddressBookQueue;

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
        
        if (!NSStringFromClass([CNContact class])) {
            
            self.addressBookQueue = dispatch_queue_create([@"TSCContactsControllerQueue for TSCContactsController" UTF8String], DISPATCH_QUEUE_SERIAL);
            self.externalAddressBookQueue = dispatch_queue_create([@"TSCContactsControllerQueue external for TSCContactsController" UTF8String], DISPATCH_QUEUE_SERIAL);
        } else {
            
            self.contactObserver = [[NSNotificationCenter defaultCenter] addObserverForName:CNContactStoreDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                [[NSNotificationCenter defaultCenter] postNotificationName:TSCAddressBookChangeNotification object:nil];
            }];
        }
    }
    return self;
}

- (ABAddressBookRef)addressBook
{
    if (!_addressBook) {
        
        dispatch_sync(self.externalAddressBookQueue, ^{
            
            ABAddressBookRef dummyExternalAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRegisterExternalChangeCallback(dummyExternalAddressBook, TSCAddressBookInternalChangeCallback, (__bridge void *)(self)); // Create a dummy external address book which recieves notifications because it is external to the one we will actuall be using.
        });
        
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRegisterExternalChangeCallback(_addressBook, TSCAddressBookExternalChangeCallback, (__bridge void *)(self)); // This listens out for changes made in the contacts app.
    }
    return _addressBook;
}

- (void)presentPeoplePickerWithCompletion:(TSCPeoplePickerPersonSelectedCompletion)completion inViewController:(UIViewController *)presentingViewController
{
    self.TSCPeoplePickerPersonSelectedCompletion = completion;
    
    if (NSStringFromClass([CNContactPickerViewController class])) {
        
        CNContactPickerViewController *contactViewController = [CNContactPickerViewController new];
        contactViewController.delegate = self;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            presentingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            contactViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        [presentingViewController presentViewController:contactViewController animated:true completion:nil];
        
    } else {
     
        dispatch_sync(self.addressBookQueue, ^{
            
            //Request access
            ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
                
                if (error) {
                    
                    self.TSCPeoplePickerPersonSelectedCompletion(nil, (__bridge NSError *)(error));
                    return;
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    if (granted) {
                        
                        ABPeoplePickerNavigationController *viewController = [self sharedPeoplePicker];
                        viewController.peoplePickerDelegate = self;
                        
                        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                            
                            presentingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                            viewController.modalPresentationStyle = UIModalPresentationFormSheet;
                        }
                        [presentingViewController presentViewController:viewController animated:true completion:nil];
                    } else {
                        
                        self.TSCPeoplePickerPersonSelectedCompletion(nil, [NSError errorWithDomain:TSCAddressBookErrorDomain code:401 userInfo:nil]);
                    }
                }];
            });
        });
    }
}

- (ABPeoplePickerNavigationController *)sharedPeoplePicker {
    
    static ABPeoplePickerNavigationController *_sharedPicker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedPicker = [[ABPeoplePickerNavigationController alloc] init];
    });
    
    return _sharedPicker;
}

#pragma mark - Converting and extracting users

- (TSCPerson *)personWithRecordIdentifier:(id)identifier
{
    if ([identifier isKindOfClass:[NSNumber class]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self personWithRecordNumber:(NSNumber *)identifier];
#pragma clang diagnostic pop
    } else {
        return [self personWithRecordString:(NSString *)identifier];
    }
    
    return nil;
}

- (TSCPerson *)personWithRecordString:(NSString *)recordIdentifier
{
    if (NSStringFromClass([CNContact class])) {
        
        CNContact *newContact = [self contactForIdentifier:recordIdentifier];
        
        if (newContact) {
            return [[TSCPerson alloc] initWithContact:newContact];
        } else {
            return nil;
        }
    }
    
    return nil;
}

- (TSCPerson *)personWithRecordNumber:(NSNumber *)number
{
    if (NSStringFromClass([CNContact class])) {
        
        CNContact *newContact = [self contactForIdentifier:number];
        
        if (newContact) {
            return [[TSCPerson alloc] initWithContact:newContact];
        } else {
            return nil;
        }
        
    } else {
        
        ABRecordID recordIdentifier = [self recordIDForNumber:number];
        return [self personWithRecordID:recordIdentifier];
    }
}

- (TSCPerson *)personWithRecordID:(ABRecordID)identifier
{
    __block ABRecordRef personRecord;
    
    dispatch_sync(self.addressBookQueue, ^{
        personRecord = ABAddressBookGetPersonWithRecordID(self.addressBook, identifier);
    });
    
    if(personRecord != NULL) {
        return [self personWithRecordRef:personRecord];
    }
    return nil;
}

- (TSCPerson *)personWithRecordRef:(ABRecordRef)ref
{
    TSCPerson *newPerson = [[TSCPerson alloc] initWithABRecordRef:ref];
    return newPerson;
}

- (ABRecordID)recordIDForNumber:(NSNumber *)number
{
    ABRecordID recordIdentifier = (ABRecordID)[number intValue];
    return recordIdentifier;
}

- (void)extractAllContactsWithCompletion:(TSCAllContactsCompletion)completion
{
    if (NSStringFromClass([CNContact class])) {
        
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
        
    } else {
        
        dispatch_sync(self.addressBookQueue, ^{
            
            ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
                
                if (error) {
                    
                    if (completion) {
                        completion(nil, (__bridge NSError *)(error));
                    }
                    return;
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    if (granted) {
                        
                        __block NSMutableArray *addressBookArray = [NSMutableArray new];
                        __block NSMutableArray *people = [NSMutableArray new];
                        
                        dispatch_async(self.addressBookQueue, ^{
                            
                            NSArray *sources = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllSources(self.addressBook);
                            
                            for (id addressBookSouce in sources) {
                                
                                NSArray *contacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering([self addressBook], (__bridge ABRecordRef)(addressBookSouce), kABPersonSortByLastName);
                                [addressBookArray addObjectsFromArray:contacts];
                                
                                // Removes call due to Zombie object crash when call method multiple times, There should be no reason to release this as we don't retain it ourselves so shouldn't be a memory leak. Will leave here incase it causes other issues. Simon :)
                                //                            CFRelease((__bridge CFTypeRef)(addressBookSouce));
                            }
                            
                            for (id person in addressBookArray) {
                                [people addObject:[self personWithRecordRef:(__bridge ABRecordRef)person]];
                            }
                            
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                
                                if (completion) {
                                    completion([NSArray arrayWithArray:people], nil);
                                }
                            }];
                        });
                        
                    } else {
                        
                        if (completion) {
                            completion(nil, [NSError errorWithDomain:TSCAddressBookErrorDomain code:401 userInfo:nil]);
                        }
                    }
                }];
            });
        });
    }
}

void TSCAddressBookInternalChangeCallback (ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TSCAddressBookChangeNotification object:nil];
}

void TSCAddressBookExternalChangeCallback (ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    dispatch_sync([[TSCContactsController sharedController] addressBookQueue], ^{
        
        [TSCContactsController sharedController].addressBook = nil;
    });
    [[NSNotificationCenter defaultCenter] postNotificationName:TSCAddressBookChangeNotification object:nil];
}

- (ABRecordRef)recordRefForRecordID:(ABRecordID)recordID
{
    __block ABRecordRef personRecord;
    
    dispatch_sync(self.addressBookQueue, ^{
        personRecord = ABAddressBookGetPersonWithRecordID(self.addressBook, recordID);
    });
    
    if(personRecord != NULL) {
        return personRecord;
    }
    return nil;
}

- (CNContact *)contactForIdentifier:(id)identifier
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

- (ABPersonViewController *)personViewControllerForRecordNumber:(NSNumber *)number
{
    return [self personViewControllerForRecordID:[self recordIDForNumber:number]];
}

- (ABPersonViewController *)personViewControllerForRecordID:(ABRecordID)recordID
{
    ABPersonViewController *view = [[ABPersonViewController alloc] init];
    view.displayedPerson = [self recordRefForRecordID:recordID];
    view.personViewDelegate = self;
    
    return view;
}

- (UIViewController *)personViewControllerForRecordIdentifier:(id)identifier
{
    if (NSStringFromClass([CNContactViewController class])) {
        
        CNContactViewController *contactViewController = [CNContactViewController viewControllerForContact:[self contactForIdentifier:identifier]]; 
        return contactViewController;
    }
    
    if ([identifier isKindOfClass:[NSNumber class]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self personViewControllerForRecordNumber:identifier];
#pragma clang diagnostic pop
    }
    
    return nil;
}

- (void)presentPersonWithRecordNumber:(NSNumber *)number inViewController:(UIViewController *)viewController
{
    [self presentPersonwithRecordID:[self recordIDForNumber:number] inViewController:viewController];
}

- (void)presentPersonwithRecordID:(ABRecordID)recordID inViewController:(UIViewController *)viewController
{
    ABPersonViewController *view = [self personViewControllerForRecordID:recordID];
    view.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDismissPeopleView:)];
    
    self.presentedPersonViewController = [[UINavigationController alloc] initWithRootViewController:view];
    [viewController presentViewController:self.presentedPersonViewController animated:true completion:nil];
}

- (void)presentPersonWithRecordIdentifier:(id)identifier inViewController:(UIViewController *)viewController
{
    UIViewController *view = [self personViewControllerForRecordIdentifier:identifier];
    view.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDismissPeopleView:)];
    
    self.presentedPersonViewController = [[UINavigationController alloc] initWithRootViewController:view];
    [viewController presentViewController:self.presentedPersonViewController animated:true completion:nil];
}

- (void)handleDismissPeopleView:(UIBarButtonItem *)button
{
    if (self.presentedPersonViewController.viewControllers.count > 0 && [self.presentedPersonViewController.viewControllers[0] isKindOfClass:[ABPersonViewController class]]) {
        
        ABPersonViewController *viewController = (ABPersonViewController *)self.presentedPersonViewController.viewControllers[0];
        TSCPerson *editedPerson = [self personWithRecordRef:viewController.displayedPerson];
        [editedPerson updateWithABRecordRef:viewController.displayedPerson];
        
    } else if (self.presentedPersonViewController.viewControllers.count > 0 && [self.presentedPersonViewController.viewControllers[0] isKindOfClass:[CNContactViewController class]]) {
        
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

#pragma mark - People picker delegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    //Handle dismissing
    self.TSCPeoplePickerPersonSelectedCompletion(nil, nil);
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    TSCPerson *selectedPerson = [self personWithRecordRef:person];
    self.TSCPeoplePickerPersonSelectedCompletion(selectedPerson, nil);
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
    
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    TSCPerson *selectedPerson = [self personWithRecordRef:person];
    self.TSCPeoplePickerPersonSelectedCompletion(selectedPerson, nil);
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    TSCPerson *selectedPerson = [self personWithRecordRef:person];
    self.TSCPeoplePickerPersonSelectedCompletion(selectedPerson, nil);
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

#pragma mark - Person View Controller Delegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)valueIdentifier
{
    return YES;
}

#pragma mark - Helpers

- (NSArray *)contactKeysToFetch
{
    return @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactNicknameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactImageDataKey, CNContactThumbnailImageDataKey, [CNContactViewController descriptorForRequiredKeys]];
}

@end
