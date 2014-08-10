//
//  THViewController+Autolayout.h
//  TAN
//
//  Created by Zachary Drossman on 8/10/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THViewController.h"

@interface THViewController (Autolayout)

- (void)leftAndRightSwitch;
- (void)topAndBottomSwitch;
- (void)setVerticalSplit;
- (void)setHorizontalSplit;
- (void)generateStandardToolbarConstraints;
- (void)removeAllConstraints;

@end
