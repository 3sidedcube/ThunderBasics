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

- (instancetype)initWithABRecordRef:(ABRecordRef)ref
{
    if (self = [super init]) {
        
        self.source = TSCPersonSourceABAddressBook;
        [self updateWithABRecordRef:ref];
        
        self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:TSCAddressBookChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                
            TSCContactsController *contactsController = [TSCContactsController sharedController];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [self updateWithABRecordRef:[contactsController recordRefForRecordID:[contactsController recordIDForNumber:self.recordNumber]]];
#pragma clang diagnostic pop
        }];
    }
    return self;
}

- (instancetype)initWithContact:(CNContact *)contact
{
    if (self = [super init]) {
        
        self.source = TSCPersonSourceContactsFramework;
        [self updateWithCNContact:contact];
        
        if (NSStringFromClass([CNContactStore class])) {
            
            self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:TSCAddressBookChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                
                TSCContactsController *contactsController = [TSCContactsController sharedController];
                [self updateWithCNContact:[contactsController contactForIdentifier:self.recordIdentifier]];
            }];
        }
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
    self.firstName = nil;
    self.lastName = nil;
    self.numbers = nil;
    self.email = nil;
    self.photo = nil;
    self.largeImage = nil;
    self.recordIdentifier = nil;
    self.hasPlaceholderImage = false;
    
    self.recordIdentifier = contact.identifier;
    self.firstName = contact.givenName;
    self.lastName = contact.familyName;
    
    if (!self.firstName && !self.lastName) {
        self.firstName = contact.nickname;
    }
    
    if (!self.firstName) {
        self.firstName = @"";
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

- (void)updateWithABRecordRef:(ABRecordRef)ref
{
    self.mobileNumber = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.numbers = nil;
    self.email = nil;
    self.photo = nil;
    self.largeImage = nil;
    self.recordIdentifier = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.recordNumber = nil;
#pragma clang diagnostic pop    
    self.hasPlaceholderImage = false;
    
    CFTypeRef firstNameRef = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
    self.firstName = (__bridge NSString *)firstNameRef;
    if (firstNameRef) {
        CFRelease(firstNameRef);
    }
    
    CFTypeRef lastNameRef = ABRecordCopyValue(ref, kABPersonLastNameProperty);
    self.lastName = (__bridge NSString *)lastNameRef;
    if (lastNameRef) {
        CFRelease(lastNameRef);
    }
    
    if(!self.firstName && !self.lastName) {
        
        CFTypeRef companyNameFor = ABRecordCopyValue(ref, kABPersonOrganizationProperty);
        self.firstName = (__bridge NSString *)companyNameFor;
        if (firstNameRef) {
            CFRelease(firstNameRef);
        }
        
    }
    
    if(!self.firstName) {
        
        self.firstName = @"";
        
    }
    
    ABMultiValueRef phoneRef = ABRecordCopyValue(ref, kABPersonPhoneProperty);
    CFArrayRef numbersRef = ABMultiValueCopyArrayOfAllValues(phoneRef);
    NSArray *numbers = (__bridge NSArray *)numbersRef;
    self.numbers = numbers;
    
    if (phoneRef) {
        CFRelease(phoneRef);
    }
    if (numbersRef) {
        CFRelease(numbersRef);
    }
    
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(ref, kABPersonPhoneProperty);
    
    for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
        
        CFStringRef numberRef = ABMultiValueCopyValueAtIndex(phoneNumbers, i);
        CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phoneNumbers, i);
        NSString *phoneNumber = (__bridge NSString *)numberRef;

        
        if (locLabel != NULL) {
            
            if (CFStringCompare(locLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo || CFStringCompare(locLabel, kABPersonPhoneIPhoneLabel, 0) == kCFCompareEqualTo) {
                self.mobileNumber = phoneNumber;
            }
        }
        
        if (numberRef) {
            CFRelease(numberRef);
        }
        if (locLabel) {
            CFRelease(locLabel);
        }
    }
    if (phoneNumbers) {
        CFRelease(phoneNumbers);
    }
    
    ABMultiValueRef emailsPropertyRef = ABRecordCopyValue(ref, kABPersonEmailProperty);
    CFArrayRef emailsRef = ABMultiValueCopyArrayOfAllValues(emailsPropertyRef);
    NSArray *emails = (__bridge NSArray *)emailsRef;
    self.email = [emails firstObject];
    if (emailsPropertyRef) {
        CFRelease(emailsPropertyRef);
    }
    if (emailsRef) {
        CFRelease(emailsRef);
    }
    
    CFDataRef photoRef = ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatThumbnail);
    NSData *photoData = (__bridge NSData *)photoRef;
    self.photo = [UIImage imageWithData:photoData];
    if (photoRef) {
        CFRelease(photoRef);
    }
    
    
    CFDataRef originalPhotoRef = ABPersonCopyImageDataWithFormat(ref, kABPersonImageFormatOriginalSize);
    NSData *originalPhotoData = (__bridge NSData *)originalPhotoRef;
    self.largeImage = [UIImage imageWithData:originalPhotoData];
    if (originalPhotoRef) {
        CFRelease(originalPhotoRef);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.recordNumber = [NSNumber numberWithInt:(int)ABRecordGetRecordID(ref)];
#pragma clang diagnostic pop
    self.recordIdentifier = [NSNumber numberWithInt:(int)ABRecordGetRecordID(ref)];
    
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

- (NSString *)fullName
{
    if (self.firstName && self.lastName) {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    }
    
    if (self.firstName) {
        return self.firstName;
    }
    
    if (self.lastName) {
        return self.lastName;
    }
    
    return nil;
}

- (NSString *)rowTitle
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
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
