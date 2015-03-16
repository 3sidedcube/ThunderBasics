//
//  RCHContactsController.m
//  ARC Hazards
//
//  Created by Matt Cheetham on 25/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE Design Ltd. All rights reserved.
//

#import "TSCContactsController.h"
#import "TSCPerson.h"

@interface TSCContactsController () <ABPeoplePickerNavigationControllerDelegate, ABPersonViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *presentedPersonViewController;
@property (nonatomic, assign) ABAddressBookRef addressBook;

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

- (ABAddressBookRef)addressBook
{
    if (!_addressBook) {
        
        ABAddressBookRef dummyExternalAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRegisterExternalChangeCallback(dummyExternalAddressBook, TSCAddressBookInternalChangeCallback, (__bridge void *)(self)); // Create a dummy external address book which recieves notifications because it is external to the one we will actuall be using.
        _addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRegisterExternalChangeCallback(_addressBook, TSCAddressBookExternalChangeCallback, (__bridge void *)(self)); // This listens out for changes made in the contacts app.
    }
    return _addressBook;
}

- (void)presentPeoplePickerWithCompletion:(TSCPeoplePickerPersonSelectedCompletion)completion inViewController:(UIViewController *)presentingViewController
{
    self.TSCPeoplePickerPersonSelectedCompletion = completion;
    
    //Request access
    ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
        
        if (error) {
            
            self.TSCPeoplePickerPersonSelectedCompletion(nil, (__bridge NSError *)(error));
            return;
        }
        
        
        if (granted) {
            
            ABPeoplePickerNavigationController *viewController = [ABPeoplePickerNavigationController new];
            viewController.peoplePickerDelegate = self;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                presentingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                viewController.modalPresentationStyle = UIModalPresentationFormSheet;
            }
            [presentingViewController presentViewController:viewController animated:YES completion:nil];
        } else {
            
            self.TSCPeoplePickerPersonSelectedCompletion(nil, nil);
        }
    });
}

#pragma mark - Converting and extracting users

- (TSCPerson *)personWithRecordNumber:(NSNumber *)number
{
    ABRecordID recordIdentifier = [self recordIDForNumber:number];
    return [self personWithRecordID:recordIdentifier];
}

- (TSCPerson *)personWithRecordID:(ABRecordID)identifier
{
    ABRecordRef personRecord = ABAddressBookGetPersonWithRecordID(self.addressBook, identifier);
    
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

void TSCAddressBookInternalChangeCallback (ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    [TSCContactsController sharedController].addressBook = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:TSCAddressBookChangeNotification object:nil];
}

void TSCAddressBookExternalChangeCallback (ABAddressBookRef addressBook, CFDictionaryRef info, void *context)
{
    [TSCContactsController sharedController].addressBook = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:TSCAddressBookChangeNotification object:nil];
}

- (ABRecordRef)recordRefForRecordID:(ABRecordID)recordID
{
    ABRecordRef personRecord = ABAddressBookGetPersonWithRecordID(self.addressBook, recordID);
    
    if(personRecord != NULL) {
        return personRecord;
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

- (void)presentPersonWithRecordNumber:(NSNumber *)number inViewController:(UIViewController *)viewController
{
    [self presentPersonwithRecordID:[self recordIDForNumber:number] inViewController:viewController];
}

- (void)presentPersonwithRecordID:(ABRecordID)recordID inViewController:(UIViewController *)viewController
{
    ABPersonViewController *view = [self personViewControllerForRecordID:recordID];
    view.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDismissPeopleView:)];
    
    self.presentedPersonViewController = [[UINavigationController alloc] initWithRootViewController:view];
    [viewController presentViewController:self.presentedPersonViewController animated:YES completion:nil];
}

- (void)handleDismissPeopleView:(UIBarButtonItem *)button
{
    if (self.presentedPersonViewController.viewControllers.count > 0 && [self.presentedPersonViewController.viewControllers[0] isKindOfClass:[ABPersonViewController class]]) {
        
        ABPersonViewController *viewController = (ABPersonViewController *)self.presentedPersonViewController.viewControllers[0];
        TSCPerson *editedPerson = [self personWithRecordRef:viewController.displayedPerson];
        [editedPerson updateWithABRecordRef:viewController.displayedPerson];
    }
    [self.presentedPersonViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - People lookup

- (NSArray *)peopleForArrayOfIdentifiers:(NSArray *)array
{
    NSMutableArray *peopleArray = [NSMutableArray array];
    
    for (NSNumber *uniqueIdentifier in array) {
        
        TSCPerson *person = [self personWithRecordNumber:uniqueIdentifier];
        
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
        if(person.recordNumber) {
            [addressbookIdsArray addObject:person.recordNumber];
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
    return YES;
    
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    TSCPerson *selectedPerson = [self personWithRecordRef:person];
    self.TSCPeoplePickerPersonSelectedCompletion(selectedPerson, nil);
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return YES;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    TSCPerson *selectedPerson = [self personWithRecordRef:person];
    self.TSCPeoplePickerPersonSelectedCompletion(selectedPerson, nil);
}

#pragma mark - Person View Controller Delegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)valueIdentifier
{
    return YES;
}

@end
