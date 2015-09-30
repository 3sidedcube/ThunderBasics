//
//  TSCCoreSpotlightIndexItem.h
//  ThunderBasics
//
//  Created by Simon Mitchell on 29/09/2015.
//  Copyright © 2015 threesidedcube. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreSpotlight;

@protocol TSCCoreSpotlightIndexItem <NSObject>

- (CSSearchableItemAttributeSet *)searchableAttributeSet;

@end
