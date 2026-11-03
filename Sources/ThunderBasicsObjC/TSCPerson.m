//
//  TSCPerson.m
//  Thunder Alert
//
//  Created by Sam Houghton on 28/11/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCPerson.h"
#import "TSCContactsController.h"

typedef NS_ENUM(NSUInteger, TSCPersonSource) {
    TSCPersonSourceABAddressBook = 0,
    TSCPersonSourceContactsFramework = 1
};

@interface TSCPerson ()

@property (nonatomic, assign) TSCPersonSource source;

@end

@implementation TSCPerson

- (instancetype)initWithContact:(CNContact *)contact
{
    if (self = [super init]) {
        
        self.source = TSCPersonSourceContactsFramework;
        [self updateWithCNContact:contact];
        
        self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:TSCAddressBookChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            TSCContactsController *contactsController = [TSCContactsController sharedController];
            [self updateWithCNContact:[contactsController contactForLegacyIdentifier:self.recordIdentifier]];
        }];
        
        self.contact = contact;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}

- (void)updateWithCNContact:(CNContact *)contact
{
    self.mobileNumber = nil;
    self.email = nil;
    self.photo = nil;
    self.largeImage = nil;
    self.hasPlaceholderImage = false;
    self.contact = contact;
    
    self.recordIdentifier = contact.identifier;
    self.firstName = contact.givenName.length > 0 ? contact.givenName : nil;
    self.lastName = contact.familyName.length > 0 ? contact.familyName : nil;
    self.companyName = contact.organizationName.length > 0 ? contact.organizationName : nil;
    
    if (!self.firstName && !self.lastName) {
        self.firstName = contact.nickname.length > 0 ? contact.nickname : nil;
    }
    
    NSMutableArray *phoneNumbers = [NSMutableArray new];
    for (CNLabeledValue *phoneNumberLabel in contact.phoneNumbers) {
        
        CNPhoneNumber *number = phoneNumberLabel.value;
        [phoneNumbers addObject:number.stringValue];
        
        if ([phoneNumberLabel.label isEqualToString:CNLabelPhoneNumberiPhone] || [phoneNumberLabel.label isEqualToString:CNLabelPhoneNumberMobile]) {
            self.mobileNumber = number.stringValue;
        }
    }
    self.numbers = phoneNumbers;
    
    if (contact.emailAddresses.firstObject) {
        
        CNLabeledValue *emailAddress = contact.emailAddresses.firstObject;
        self.email = emailAddress.value;
    }
    
    if (contact.imageData) {
        self.largeImage = [UIImage imageWithData:contact.imageData];
    }
    
    if (contact.thumbnailImageData) {
        self.photo = [UIImage imageWithData:contact.thumbnailImageData];
    }
    
    if (!self.photo) {
        
        self.hasPlaceholderImage = YES;
        self.photo = [self contactPlaceholderWithInitials:self.initials];
    }
}

- (void)updateWithPerson:(TSCPerson *)person
{
    self.firstName = person.firstName;
    self.lastName = person.lastName;
    self.mobileNumber = person.mobileNumber;
    self.fullName = person.fullName;
    self.numbers = person.numbers;
    self.email = person.email;
    self.photo = person.photo;
    self.largeImage = person.largeImage;
    self.hasPlaceholderImage = person.hasPlaceholderImage;
}

- (void)setFirstName:(NSString *)firstName
{
    _firstName = firstName;
    [self updateFullName];
}

- (void)setLastName:(NSString *)lastName
{
    _lastName = lastName;
    [self updateFullName];
}

- (void)updateFullName
{
    if (self.firstName && self.lastName) {
        self.fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    } else if (self.firstName) {
        self.fullName = self.firstName;
    } else if (self.lastName) {
        self.fullName = self.lastName;
    }
}

- (NSString *)rowTitle
{
    if (self.fullName) {
        return self.fullName;
    }
    
    if (self.mobileNumber) {
        return self.mobileNumber;
    }
    
    if (self.numbers.firstObject) {
        return self.numbers.firstObject;
    }
    
    if (self.mobileNumber) {
        return self.mobileNumber;
    }
    
    if (self.numbers.firstObject) {
        return self.numbers.firstObject;
    }
    
    if (self.email) {
        return self.email;
    }
    
    return nil;
}

- (NSString *)rowSubtitle
{
    if (self.numbers.count > 0) {
        return [NSString stringWithFormat:@"%@", self.numbers[0]];
    }
    
    return nil;
}

- (UIImage *)rowImage
{
    return self.photo;
}

- (NSString *)initials
{
    NSMutableString *intialString = [NSMutableString string];
    
    if (self.firstName.length > 0) {
        [intialString appendString:[self.firstName substringToIndex:1]];
    }
    
    if (self.lastName.length > 0) {
        [intialString appendString:[self.lastName substringToIndex:1]];
    }
    
    if (self.companyName.length > 0 && intialString.length == 0) {
        [intialString appendString:[self.companyName substringToIndex:1]];
    }
    
    if (intialString.length == 0) {
        intialString = [@"?" mutableCopy];
    }
    
    return intialString;
}

#pragma mark - Image generation

- (UIImage *)contactPlaceholderWithInitials:(NSString *)initials
{
    CGRect rect = CGRectMake(0, 0, 126, 126);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2.0);
    
    [[UIColor colorWithRed:203.0/255.0 green:194.0/255.0 blue:188.0/255.0 alpha:1.0] setFill];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:rect];
    circlePath.lineWidth = 6.0;
    [circlePath fill];
    
    CGRect textRect;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    CGSize textSize = [initials sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:52],NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSMutableDictionary *topAttributes = [NSMutableDictionary new];
    topAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:246.0/255.0 green:241.0/255.0 blue:236.0/255.0 alpha:1.0];
    topAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:52];
    topAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    textRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - textSize.height)/2, rect.size.width, textSize.height);
    
    [initials drawInRect:textRect withAttributes:topAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)contactPlaceholderWithIntitials:(NSString *)initials
{
    return [self contactPlaceholderWithInitials:initials];
}


@end
