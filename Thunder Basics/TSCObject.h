//
//  TSCObject.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 18/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSCObject : NSObject

@property (nonatomic, strong) NSString *identifier;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)serialisableRepresentation;
- (NSData *)JSONRepresentation;
+ (BOOL)isSerialisable:(id)object;

@end
