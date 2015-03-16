//
//  TSCDatabase.h
//  ThunderBasics
//
//  Created by Phillip Caudell on 18/02/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

@import Foundation;
@class TSCObject;

/**
 `TSCDatabase` is a wrapper class for FMDBDatabase. It allows for:
 
 - Easy loading of databases.
 - Inserting objects subclassing from `TSCObject` to databases.
 - Retrievein objects subclassing form `TSCObject` from a database.
 */
@interface TSCDatabase : NSObject

///---------------------------------------------------------------------------------------
/// @name Initializing a TSCDatabase Object
///---------------------------------------------------------------------------------------

/**
 Initializes the `TSCDatabaseObject`
 @param path The path to the database which should be loaded.
 */
+ (id)databaseWithPath:(NSString *)path;

/**
 Initializes the `TSCDatabaseObject`
 @param path The path to the database which should be loaded.
 */
- (id)initWithDatabasePath:(NSString *)path;

///---------------------------------------------------------------------------------------
/// @name Database path properties
///---------------------------------------------------------------------------------------

/**
 @abstract The path of the database.
 */
@property (nonatomic, copy) NSString *databasePath;

/**
 @abstract The path of the cached database.
 @discussion The database is moved to a cached location where in which file editing is allowed. This keeps track of where that cached version is kept.
 */
@property (nonatomic, copy) NSString *cachedDatabasePath;

/**
 @abstract The directory which database caches are stored in.
 */
@property (nonatomic, readonly) NSString *databaseCacheDirectory;

///---------------------------------------------------------------------------------------
/// @name Updating the database
///---------------------------------------------------------------------------------------

/**
 Registers an object class to a certain table within the database.
 @param classToRegister The class of object which should be registered to the specified table name.
 @param tableName The table for which the specified class should be added (or removed e.t.c.) to.
 @discussion Any class of object must be registered with this method before it is used in a `TSCDatabase`.
 */
+ (void)registerClass:(Class)classToRegister toTableName:(NSString *)tableName;

/**
 Inserts an object subclassing from `TSCObject` into the currently loaded database.
 @param object The object to insert into the database.
 */
- (BOOL)insertObject:(TSCObject *)object;

/**
 Removes an object subclassing from `TSCObject` from the currently loaded database.
 @param object The object to remove from the database.
 */
- (BOOL)removeObject:(TSCObject *)object;

/**
 Updates an object subclassing from `TSCObject` in the currently loaded database.
 @param object The object to edit in the database.
 */
- (BOOL)updateObject:(TSCObject *)object;

///---------------------------------------------------------------------------------------
/// @name Retrieving objects from the database
///---------------------------------------------------------------------------------------

/**
 Returns an array of all the objects from the currently loaded database of a certain class.
 @param classToSelect The class of object to be returned in the array.
 */
- (NSArray *)objectsOfClass:(Class)classToSelect;

/**
 Returns an array of all the objects from the currently loaded database of a certain class which correspond to an addition sql query. This can be used for example to get all of the instances of an object which correspond to a certain identifying parameter.
 @param classToSelect The class of object to be returned in the array.
 @param sql An extra sql query which can be used to refine the objects which are returned.
 */
- (NSArray *)objectsOfClass:(Class)classToSelect withSQL:(NSString *)sql;

@end
