//
//  THViewController+Autolayout.h
//  TAN
//
//  Created by Zachary Drossman on 8/10/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THViewController.h"

@interface THViewController (Autolayout)

/* ************************************************************

//NOTES
//Must set boolean values for horizontalSplit and leftOrTopThen
//
************************************************************ */

- (void)removeAllConstraints;
- (void)layoutCamera;
- (void)layoutToolbarOfStandardHeight;
- (void)animateLayoutToolbarOfHeightZeroAtBottomOfScreenWithCompletion:(void (^)(void))completionBlock;
- (void)animateLayoutToolbarOfStandardHeightWithCompletion:(void (^)(void))completionBlock;
- (void)layoutBaseNavbar;
- (void)removeAllTopLevelViewConstraints;
- (void)removeSubviewConstraints;

- (void)layoutThenAndNowContainerViews;
- (void)layoutHorizontalSplitOfContainerViews;
- (void)layoutVerticalSplitOfContainerViews;
- (void)switchImagesAcrossVerticalSplit;
- (void)switchImagesAcrossHorizontalSplit;
- (void)animateCameraResignWithSetupViewsBlock:(void (^)(void))setupViewsBehindCameraBlock AndCompletion:(void (^)(void))completionBlock;
- (void)layoutTextImageViews;

@end