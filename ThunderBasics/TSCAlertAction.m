//
//  TSCAlertAction.m
//  ThunderBasics
//
//  Created by Phillip Caudell on 19/06/2014.
//  Copyright (c) 2014 3 SIDED CUBE. All rights reserved.
//

#import "TSCAlertAction.h"

@interface TSCAlertAction ()

- (instancetype)initWithTitle:(NSString *)title style:(TSCAlertActionStyle)style handler:(TSCAlertActionHandler)handler;

@end

@implementation TSCAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(TSCAlertActionStyle)style handler:(TSCAlertActionHandler)handler
{
    return [[TSCAlertAction alloc] initWithTitle:title style:style handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title style:(TSCAlertActionStyle)style handler:(TSCAlertActionHandler)handler
{
    if (self = [super init]) {
        
        _title = title;
        _style = style;
        _handler = handler;
    }
    
    return self;
}

@end
