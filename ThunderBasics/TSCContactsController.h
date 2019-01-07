//
//  TSCContactsController.h
//  ARC Hazards
//
//  Created by Matt Cheetham on 25/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE Design Ltd. All rights reserved.
//

@import AddressBook;
@import AddressBookUI;
@import Contacts;
@import ContactsUI;
@import UIKit;

@class TSCPerson;

#import <Foundation/Foundation.h>

static NSString *TSCAddressBookErrorDomain = @"com.threesidedcube.addressbook";
#define TSCAddressBookChangeNotification @"AdressBookEdited"

/**
 The contacts controller is responsible for handling all interaction with the users address book. There are convenience methods for giving the user the option to select a contact, automatically handling authentication and returning an RCHPerson in the block
 */
@interface TSCContactsController : NSObject

/**
 The block that will be called when a people picker has been used and person has been selected
 */
typedef void (^TSCPeoplePickerPersonSelectedCompletion)(TSCPerson *selectedPerson, NSError *error);

/**
 The block that will be called when all people from the contacts framework or address book framework have been pulled
 */
typedef void (^TSCAllContactsCompletion)(NSArray <TSCPerson *> *people, NSError *error);

/**
 @abstract This property keeps reference to the completion block so that it can be called when a contact has been succesfully selected
 */
@property (nonatomic, copy) void (^TSCPeoplePickerPersonSelectedCompletion)(TSCPerson *selectedPerson, NSError *error);

/**
 @abstract The dispatch queue for accessing the address book on
 */
@property (nonatomic, strong, readonly) dispatch_queue_t addressBookQueue;

/**
 Returns the singleton instance of a `TSCContactsController`
 */
+ (TSCContactsController *)sharedController;

/**
 Presents a picker to select a contact with a completion
 @param completion The completion block to be fired once a user has selected a contact or cancelled
 @param presentingViewController The view controller that wishes to present the picker
 */
- (void)presentPeoplePickerWithCompletion:(TSCPeoplePickerPersonSelectedCompletion)completion inViewController:(UIViewController *)presentingViewController;

/**
 Presents a picker to select a contact with a completion
 @param completion The completion block to be fired once a user has selected a contact or cancelled
 @param presentingViewController The view controller that wishes to present the picker
 @param statusBarStyle The status bar style to use for the presented view controller
 */
- (void)presentPeoplePickerWithCompletion:(TSCPeoplePickerPersonSelectedCompletion)completion inViewController:(UIViewController *)presentingViewController statusBarStyle:(UIStatusBarStyle)statusBarStyle;

/**
 Generates a `TSCPerson` object for the given identifier
 @param identifier The `NSString` identifier of the `CNContact` to convert into a `TSCPerson`
 @return `TSCPerson` filled with contact information
*/
- (TSCPerson *)personWithRecordIdentifier:(NSString *)identifier;


/**
 Returns the CNContact object for a certain identifier
 @param identifier The `NSString` identifier of the `CNContact` to convert into a `TSCPerson`
 */
- (CNContact *)contactForIdentifier:(NSString *)identifier;

/**
 If you have a legacy contact from ABAddressBook you can use this to retrieve your contact
 @param identifier Either an `NSString` identifier (CNContacts) or `NSNumber` identifier for the contact (ABAddressBook)
 */
- (CNContact *)contactForLegacyIdentifier:(id)identifier;

/**
 Extracts all people from all address book sources
 @param completion The completion block to be fired once all contacts have been found and returns an `NSArray` of `TSCPersonObjects`
 */
- (void)extractAllContactsWithCompletion:(TSCAllContactsCompletion)completion;


/**
 Generates a `CNContactViewController` for presenting a contact in the address book.
 @param number The number of the record to display in the view controller
 @return A view controller that can be pushed or presented to show the user in the address book
 */
- (CNContactViewController *)personViewControllerForRecordIdentifier:(NSString *)identifier;


/**
 Presents an address book view for a record id
 @param identifier The identifier for the person that needs to be displayed to the user
 @param viewController The view controller that wishes to present the picker
 **/
- (void)presentPersonWithRecordIdentifier:(NSString *)identifier inViewController:(UIViewController *)viewController;

/**
 Presents an address book view for a record id
 @param identifier The identifier for the person that needs to be displayed to the user
 @param viewController The view controller that wishes to present the picker
 @param statusBarStyle The status bar style to apply to the person view controller
 **/
- (void)presentPersonWithRecordIdentifier:(NSString *)identifier inViewController:(UIViewController *)viewController statusBarStyle:(UIStatusBarStyle)statusBarStyle;


/**
 Extracts an array of TSCPerson objects for the provided identifiers
 @param array An array of NSNumber objects that identify contacts in the addressbook database
 @return An array of `TSCPerson` objects
 */
- (NSArray <TSCPerson *> *)peopleForArrayOfIdentifiers:(NSArray *)array;

/**
 Extracts an array of Addressbook Ids objects for the provided identifiers
 @param people An array of `TSCPeople` objects
 @return An array of NSNumbers that identify contacts in the addressbook database
 */
- (NSArray <NSString *> *)addressbookIdsforPeople:(NSArray <TSCPerson *> *)people;

@end
