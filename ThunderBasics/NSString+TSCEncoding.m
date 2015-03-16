//
//  NSString+TSCEncoding.m
//  ThunderBasics
//
//  Created by Simon Mitchell on 09/01/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import "NSString+TSCEncoding.h"

@implementation NSString (TSCEncoding)

- (NSString *)urlEncodedString
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

-(NSString *)stringByStrippingHTML {
    
    NSRange htmlTagRange;
    NSString *string = [NSString stringWithFormat:@"%@",self];
    while ((htmlTagRange = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        string = [string stringByReplacingCharactersInRange:htmlTagRange withString:@""];
    }
    return string;
}

@end
