//
//  TSCPerson.h
//  Thunder Alert
//
//  Created by Sam Houghton on 28/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AddressBook;
@import UIKit;

/**
 A TSCPerson is an object representation of a person in a users addressbook.
 */
@interface TSCPerson : NSObject

/**
 Takes a ABRecordRef from the addressbook and converts it into a TSCPerson
 @param ref A `ABRecordRef` extracted from an `ABAddressBook`
 @return A populated TSCObject
 */
- (instancetype)initWithABRecordRef:(ABRecordRef)ref;

/**
 Updates the current model using an `ABRecordRef`
 @param ref The record Ref to update the current person model with
 */
- (void)updateWithABRecordRef:(ABRecordRef)ref;

/**
 The initials of the person generated from any available first and last names
 */
- (NSString *)initials;

/**
 Generates a placeholder image using the users initials
 @param initials An NSString of initials to put into the placeholder image
 @return An image consisting of a grey circle with overlaying initial text.
 */
- (UIImage *)contactPlaceholderWithIntitials:(NSString *)initials;

/**
 The persons first name, if one could be found
 */
@property (nonatomic, copy) NSString *firstName;

/**
 The persons last name, if one could be found
 */
@property (nonatomic, copy) NSString *lastName;

/**
 The persons full name
 @discussion Generated using the available `firstName` and `lastName` properties
 */
@property (nonatomic, copy) NSString *fullName;

/**
 An array of numbers extracted from the addressbook for the person
 */
@property (nonatomic, strong) NSArray *numbers;

/**
 An email address for the person, if one could be found
 */
@property (nonatomic, copy) NSString *email;

/**
 A photo of the person at thumbnail resolution
 */
@property (nonatomic, strong) UIImage *photo;

/**
 A photo of the person at it's original resolution
 */
@property (nonatomic, strong) UIImage *largeImage;

/**
 The record ID number of the record in relation to the addressbook it was extracted from
 @note This record ID could change and Apple recommends implementing checks to make sure you get the expected person back when using this ID.
 */
@property (nonatomic, strong) NSNumber *recordNumber;

/**
 The persons mobile number, if available.
 @discussion This is populated using any number set to mobile or iPhone in the contact record
 */
@property (nonatomic, copy) NSString *mobileNumber;

/**
 If the user has no photo set, a placeholder will be generated and this boolean will be set to true
 @return YES if the model has generated a placeholder for a missing photo
 */
@property (nonatomic, assign) BOOL hasPlaceholderImage;

/**
 The observer object that listens for changes in the address book
 */
@property (nonatomic, strong) id <NSObject> observer;

@end
