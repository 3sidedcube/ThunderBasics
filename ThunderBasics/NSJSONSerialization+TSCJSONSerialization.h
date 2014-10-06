//
//  NSJSONSerialization+TSCJSONSerialization.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 19/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (TSCJSONSerialization)

+ (id)JSONObjectWithResource:(NSString *)name ofType:(NSString *)type options:(NSJSONReadingOptions)opt error:(NSError **)error;
+ (id)JSONObjectWithFile:(NSString *)path options:(NSJSONReadingOptions)opt error:(NSError **)error;

@end
