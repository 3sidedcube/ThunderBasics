//
//  TSCDatabase.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 18/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSCDatabase : NSObject

@property (nonatomic, strong) NSString *databasePath;

+ (id)databaseWithPath:(NSString *)path;
- (id)initWithDatabasePath:(NSString *)path;
+ (void)registerClass:(Class)classToRegister toTableName:(NSString *)tableName;
- (BOOL)insertObject:(TSCObject *)object;
- (BOOL)removeObject:(TSCObject *)object;
- (BOOL)updateObject:(TSCObject *)object;

@end
