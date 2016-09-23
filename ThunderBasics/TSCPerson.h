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
@import Contacts;

/**
 A TSCPerson is an object representation of a person in a users addressbook.
 */
@interface TSCPerson : NSObject


/**
 Takes a CNContact from Contacts framework and converts it into a TSCPerson
 @param contact A CNContact object obtained using the Contacts framework
 */
- (instancetype _Nonnull)initWithContact:(CNContact  * _Nonnull )contact;

/**
 Updates the current model using a `CNContact`
 @param contact The contact to update the current person model with
 */
- (void)updateWithCNContact:(CNContact * _Nonnull)contact;

/**
 Updates the current model using a `TSCPerson`
 @param person The person to update the current person model with
 */
- (void)updateWithPerson:(TSCPerson * _Nonnull)person;

/**
 The initials of the person generated from any available first and last names
 */
- (NSString * _Nonnull)initials;

/**
 Generates a placeholder image using the users initials
 @param initials An NSString of initials to put into the placeholder image
 @return An image consisting of a grey circle with overlaying initial text.
 */
- (UIImage * _Nonnull)contactPlaceholderWithInitials:(NSString * _Nonnull)initials;

/**
 The persons first name, if one could be found
 */
@property (nonatomic, copy) NSString * _Nullable firstName;

/**
 The persons last name, if one could be found
 */
@property (nonatomic, copy) NSString * _Nullable lastName;

/**
 The persons full name
 @discussion Generated using the available `firstName` and `lastName` properties
 */
@property (nonatomic, copy) NSString * _Nullable fullName;

/**
 The persons company name
 @discussion The company name associated with the person/contact
 */
@property (nonatomic, copy) NSString * _Nullable companyName;

/**
 An array of numbers extracted from the addressbook for the person
 */
@property (nonatomic, strong) NSArray <NSString *> * _Nullable numbers;

/**
 An email address for the person, if one could be found
 */
@property (nonatomic, copy) NSString * _Nullable email;

/**
 A photo of the person at thumbnail resolution
 */
@property (nonatomic, strong) UIImage * _Nullable photo;

/**
 A photo of the person at it's original resolution
 */
@property (nonatomic, strong) UIImage * _Nullable largeImage;


/**
 The record ID of the record in relation to where it was extracted from
 @note Before iOS 9 this record ID could change and Apple recommends implementing checks to make sure you get the expected person back when using this ID.
 */
@property (nonatomic, strong) NSString * _Nullable recordIdentifier;

/**
 The persons mobile number, if available.
 @discussion This is populated using any number set to mobile or iPhone in the contact record
 */
@property (nonatomic, copy) NSString * _Nullable mobileNumber;

/**
 If the user has no photo set, a placeholder will be generated and this boolean will be set to true
 @return YES if the model has generated a placeholder for a missing photo
 */
@property (nonatomic, assign) BOOL hasPlaceholderImage;

/**
 The observer object that listens for changes in the address book
 */
@property (nonatomic, strong) id <NSObject> _Nullable observer;

@end
