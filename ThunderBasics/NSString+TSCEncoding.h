//
//  NSString+TSCEncoding.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 09/01/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TSCEncoding)

- (NSString *)urlEncodedString;

- (NSString *)stringByStrippingHTML;

@end
