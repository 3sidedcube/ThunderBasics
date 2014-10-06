//
//  NSArray+TSCArray.h
//  Roboto Lite
//
//  Created by Phillip Caudell on 24/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (TSCArray)

- (NSArray *)serialisableRepresentation;
- (NSData *)JSONRepresentation;
+ (NSArray *)arrayWithArrayOfDictionaries:(NSArray *)dictionaries rootInstanceType:(Class)classType;

@end
