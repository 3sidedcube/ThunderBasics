//
//  NSDictionary+TSCDictionary.h
//  Roboto Lite
//
//  Created by Phillip Caudell on 31/01/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TSCDictionary)

- (NSDictionary *)serialisableRepresentation;
- (NSData *)JSONRepresentation;

@end
