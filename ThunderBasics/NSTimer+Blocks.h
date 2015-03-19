//
//  NSTimer+Blocks.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 02/03/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A useful category that adds block support for NSTimers
 */
@interface NSTimer (Blocks)

/**
 Schedules a timer to begin running immediately. Fires a block when the timer reaches it's designated interval
 @param inTimeInterval How long after creation the block should be called
 @param inBlock The block to call once the timer has reached it's designated interval
 @param inRepeats Whether or not the timer should repeat once fired
 */
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

/**
 Creates a timer that fires a block when the timer reaches it's designated interval
 @param inTimeInterval How long after creation the block should be called
 @param inBlock The block to call once the timer has reached it's designated interval
 @param inRepeats Whether or not the timer should repeat once fired
 */
+ (instancetype)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end
