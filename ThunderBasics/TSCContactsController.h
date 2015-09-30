//
//  TSCContactsController.h
//  ARC Hazards
//
//  Created by Matt Cheetham on 25/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE Design Ltd. All rights reserved.
//

@import AddressBook;
@import AddressBookUI;
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
typedef void (^TSCAllContactsCompletion)(NSArray *people, NSError *error);

/**
 @abstract This property keeps reference to the completion block so that it can be called when a contact has been succesfully selected
 */
@property (nonatomic, copy) void (^TSCPeoplePickerPersonSelectedCompletion)(TSCPerson *selectedPerson, NSError *error);

/**
 @abstract The dispatch queue for accessing the address book on
 */
@property (nonatomic, strong, readonly) dispatch_queue_t addressBookQueue;

+ (TSCContactsController *)sharedController;

/**
 Presents a picker to select a contact with a completion
 @param completion The completion block to be fired once a user has selected a contact or cancelled
 @param presentingViewController The view controller that wishes to present the picker
 */
- (void)presentPeoplePickerWithCompletion:(TSCPeoplePickerPersonSelectedCompletion)completion inViewController:(UIViewController *)presentingViewController;

/**
 Generates a `TSCPerson` object for the given NSNumber
 @param number The number that references a record ID in the users contacts
 @return `RCHPerson` filled with contact information
 */
- (TSCPerson *)personWithRecordNumber:(NSNumber *)number __attribute((deprecated("Please use -personWithRecordIdentifier: instead")));

/**
 Generates a `TSCPerson` object for the given `ABRecordID`
 @param identifier The `ABRecordID` that references a person in the users contacts
 @return `TSCPerson` filled with contact information
 */
- (TSCPerson *)personWithRecordID:(ABRecordID)identifier;

/**
 Generated a `TSCPerson` object for the record reference
 @param ref The `ABRecordRef` to convert into a `TSCPerson`
 @return `TSCPerson` filled with contact information
 */
- (TSCPerson *)personWithRecordRef:(ABRecordRef)ref;

/**
 Generates a `TSCPerson` object for the given identifier
 @param identifier The `NSString` (Contacts Framework) or `NSNumber` (ABAdressBookRef) to convert into a `TSCPerson`
 @return `TSCPerson` filled with contact information
*/
- (TSCPerson *)personWithRecordIdentifier:(id)identifier;

/**
 Converts a `NSNumber` to a `ABRecordID`
 @param number The number to convert
 @return `ABRecordID` from the NSNumber
*/
- (ABRecordID)recordIDForNumber:(NSNumber *)number;

/**
 Converts a `ABRecordID` into a `ABRecordRef`
 @param recordID The `ABRecordID` to look up in the address book and extract a contact for
 @return An `ABRecordRef` representation of the record ID
 */
- (ABRecordRef)recordRefForRecordID:(ABRecordID)recordID;

/**
 Extracts all people from all address book sources
 @param completion The completion block to be fired once all contacts have been found and returns an `NSArray` of `TSCPersonObjects`
 */
- (void)extractAllContactsWithCompletion:(TSCAllContactsCompletion)completion;

/**
 Generates a `ABPersonViewController` for presenting a contact in the address book.
 @param number The number of the record to display in the view controller
 @return A view controller that can be pushed or presented to show the user in the address book
 */
- (ABPersonViewController *)personViewControllerForRecordNumber:(NSNumber *)number;

/**
 Generates a `ABPersonViewController` for presenting a contact in the address book.
 @param recordID The recordID of the record to display in the view controller
 @return A view controller that can be pushed or presented to show the user in the address book
 */
- (ABPersonViewController *)personViewControllerForRecordID:(ABRecordID)recordID;

/**
 Presents an address book view for a record number
 @param number The `NSNumber` for the person that needs to be displayed to the user
 @param viewController The view controller that wishes to present the picker
 **/
- (void)presentPersonWithRecordNumber:(NSNumber *)number inViewController:(UIViewController *)viewController;

/**
 Presents an address book view for a record ID
 @param recordID The ABRecordID for the person that needs to be displayed to the user
 @param viewController The view controller that wishes to present the picker
 **/
- (void)presentPersonwithRecordID:(ABRecordID)recordID inViewController:(UIViewController *)viewController;

/**
 Extracts an array of TSCPerson objects for the provided identifiers
 @param array An array of NSNumber objects that identify contacts in the addressbook database
 @return An array of `TSCPerson` objects
 */
- (NSArray *)peopleForArrayOfIdentifiers:(NSArray *)array;

/**
 Extracts an array of Addressbook Ids objects for the provided identifiers
 @param people An array of `TSCPeople` objects
 @return An array of NSNumbers that identify contacts in the addressbook database
 */
- (NSArray *)addressbookIdsforPeople:(NSArray *)people;

@end
