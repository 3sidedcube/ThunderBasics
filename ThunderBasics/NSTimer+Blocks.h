//
//  NSTimer+Blocks.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 02/03/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Blocks)

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end
