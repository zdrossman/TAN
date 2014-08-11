//
//  THViewController+Autolayout.h
//  TAN
//
//  Created by Zachary Drossman on 8/10/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THViewController.h"

@interface THViewController (Autolayout)

- (void)switchImagesAcrossVerticalSplit;
- (void)switchImagesAcrossHorizontalSplit;
- (void)setVerticalSplit;
- (void)setHorizontalSplit;
- (void)removeAllConstraints;
- (void)layoutCamera;
- (void)layoutToolbarOfStandardHeight;
- (void)animateToolbarOfHeightZeroAtBottomOfScreenWithCompletion:(void (^)(void))completionBlock;
- (void)animateLayoutToolbarOfStandardHeight:(void (^)(void))completionBlock;
- (void)layoutBaseNavbar;

@end
