//
//  UILabel+TSCLabel.m
//  ThunderBasics
//
//  Created by Simon Mitchell on 26/05/2015.
//  Copyright (c) 2015 3 SIDED CUBE. All rights reserved.
//

#import "UILabel+TSCLabel.h"

@implementation UILabel (TSCLabel)

- (void)sizeToFit:(CGSize)size
{
    CGSize constrainedSize = [self sizeThatFits:size];
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(size.width, constrainedSize.height);
    self.frame = frame;
}

@end
