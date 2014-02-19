//
//  TSCDatabase.m
//  ThunderBasics
//
//  Created by Phillip Caudell on 18/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCDatabase.h"
#import "FMDatabase.h"

@interface TSCDatabase ()

@property (nonatomic, strong) NSMutableDictionary *map;

- (id)initDatabaseManager;
+ (id)databaseManager;

@end

@implementation TSCDatabase

static TSCDatabase *databaseManager = nil;

- (id)initDatabaseManager
{
    if (self = [super init]) {
        
        self.map = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (id)databaseManager
{
    @synchronized(self) {
        
        if (databaseManager == nil) {
            databaseManager = [[self alloc] initDatabaseManager];
        }
    }
    
    return databaseManager;
}

+ (id)databaseWithPath:(NSString *)path
{
    TSCDatabase *database = [[TSCDatabase alloc] initWithDatabasePath:path];
    
    return database;
}

- (id)initWithDatabasePath:(NSString *)path
{
    if (self = [super init]) {
        
        self.databasePath = path;

        [self TSC_setupWithPath:path];
    }

    return self;
}

- (void)TSC_setupWithPath:(NSString *)path
{
    NSString *databaseName = [self.databasePath lastPathComponent];
    NSString *cachedDatabasePath = [self.databaseCacheDirectory stringByAppendingPathComponent:databaseName];
    
    BOOL isDatabaseInCache = [[NSFileManager defaultManager] fileExistsAtPath:cachedDatabasePath];
    
    if (!isDatabaseInCache) {
        
        [[NSFileManager defaultManager] copyItemAtPath:path toPath:cachedDatabasePath error:nil];
    }
    
    _cachedDatabasePath = cachedDatabasePath;
}

- (NSString *)databaseCacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)registerClass:(Class)classToRegister toTableName:(NSString *)tableName
{
    [[[TSCDatabase databaseManager] map] setObject:tableName forKey:NSStringFromClass(classToRegister)];
}

- (BOOL)insertObject:(TSCObject *)object
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.cachedDatabasePath];
    
    NSDictionary *queryInfo = [self TSC_queryInfoWithObject:object];
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", queryInfo[@"table"], queryInfo[@"scheme"], queryInfo[@"values"]];
    
    BOOL result = [db executeUpdate:query withParameterDictionary:object.serialisableRepresentation];
    
    [db close];
    
    return result;
}

- (BOOL)removeObject:(TSCObject *)object
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.cachedDatabasePath];
    
    NSDictionary *queryInfo = [self TSC_queryInfoWithObject:object];
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uniqueIdentifier = (:uniqueIdentifier)", queryInfo[@"table"]];
    
    BOOL result = [db executeUpdate:query withParameterDictionary:object.serialisableRepresentation];
    
    [db close];
    
    return result;
}

- (BOOL)updateObject:(TSCObject *)object
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.cachedDatabasePath];
    
    NSDictionary *queryInfo = [self TSC_queryInfoWithObject:object];
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE uniqueIdentifier = (:uniqueIdentifier)", queryInfo[@"table"], queryInfo[@"keyAndValues"]];
    
    BOOL result = [db executeUpdate:query withParameterDictionary:object.serialisableRepresentation];
    
    [db close];
    
    return result;
}

- (NSDictionary *)TSC_queryInfoWithObject:(TSCObject *)object
{
    NSDictionary *dictionary = object.serialisableRepresentation;
    NSString *values = [@":" stringByAppendingString:[dictionary.allKeys componentsJoinedByString:@", :"]];
    NSString *scheme = [dictionary.allKeys componentsJoinedByString:@", "];
    NSString *table = [[TSCDatabase databaseManager] map][NSStringFromClass([object class])];
    
    NSMutableArray *keyAndValues = [NSMutableArray array];
    
    for (NSString *key in dictionary.allKeys) {
        
        NSString *keyAndValue = [NSString stringWithFormat:@"%@ = :%@", key, key];
        [keyAndValues addObject:keyAndValue];
    }
    
    NSString *keyAndValuesJoined = [keyAndValues componentsJoinedByString:@", "];
    
    return @{@"table": table, @"scheme" : scheme, @"values" : values, @"keyAndValues" : keyAndValuesJoined};
}

@end
