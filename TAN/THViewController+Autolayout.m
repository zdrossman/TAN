//
//  THViewController+Animations.m
//  TAN
//
//  Created by Zachary Drossman on 8/10/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THViewController+Autolayout.h"

@implementation THViewController (Autolayout)

#pragma mark - Scroll View Layout
- (void)layoutThenAndNowScrollViews
{
    self.nowScrollView.hidden = NO;
    
    self.toolbar.alpha = 1;
    self.toolbar.hidden = NO;
        
    if (self.horizontalSplit) {
        [self layoutHorizontalSplitOfScrollViews];
    }
    else {
        [self layoutVerticalSplitOfScrollViews];
    }
    
    [self removeSubviewConstraints];

    [self layoutThenSubviews];
    [self layoutNowSubviews];
}

- (void)layoutThenSubviews
{
    self.verticalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_thenImageView(thenImageHeight)]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    self.horizontalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_thenImageView(thenImageWidth)]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    [self.thenScrollView addConstraints:self.verticalThenImageConstraints];
    [self.thenScrollView addConstraints:self.horizontalThenImageConstraints];
}

- (void)layoutNowSubviews
{
    self.verticalNowImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nowImageView(nowImageHeight)]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    self.horizontalNowImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nowImageView(nowImageWidth)]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    [self.nowScrollView addConstraints:self.verticalNowImageConstraints];
    [self.nowScrollView addConstraints:self.horizontalNowImageConstraints];
}


- (void)layoutHorizontalSplitOfScrollViews {
    
    [self removeThenScrollViewAndNowScrollViewConstraints];
    
    self.verticalISVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(124)-[_topScrollView(==230)][_bottomScrollView(==_topScrollView)-(124)-]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalThenScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topScrollView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalNowScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomScrollView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addThenScrollViewAndNowScrollViewConstraints];
    
    [self layoutToolbarOfStandardHeight];
    
}

- (void)layoutVerticalSplitOfScrollViews {
    
    [self removeThenScrollViewAndNowScrollViewConstraints];

    self.horizontalISVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftScrollView(==160)][_rightScrollView(==_leftScrollView)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalThenScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(124)-[_leftScrollView]-(124)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(124)-[_rightScrollView]-(124)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self addThenScrollViewAndNowScrollViewConstraints];
    
    [self layoutToolbarOfStandardHeight];
    
}


#pragma mark - Scroll View Vertical Split Animations
- (void)switchImagesAcrossVerticalSplit{
    
    [self bringLeftSubviewToFront];
    [self animateLayoutVerticalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewWithCompletion:^{
        
        [self animateLayoutVerticalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewAndSwitchedPlacesWithCompletion:^{
            
            [self animateLayoutVerticalSplitThenScrollViewSwitchedWithNowScrollViewOnSamePlaneWithCompletion:^{
                self.thenOnLeftOrTop = !self.thenOnLeftOrTop;
            }];
        }];
    }];
}

//TODO: Add comment explaining animation
- (void)layoutVerticalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewWithCompletion {
    
    [self removeThenScrollViewAndNowScrollViewConstraints];
    
    self.verticalThenScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(143)-[_leftScrollView]-(143)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(128)-[_rightScrollView]-(128)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.horizontalISVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_leftScrollView(==130)]-(15)-[_rightScrollView(==160)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self addThenScrollViewAndNowScrollViewConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutVerticalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutVerticalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewWithCompletion];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutVerticalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewAndSwitchedPlaces {
    
    [self removeThenScrollViewAndNowScrollViewConstraints];
    
    self.verticalThenScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(143)-[_leftScrollView]-(143)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(128)-[_rightScrollView]-(128)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.horizontalISVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightScrollView(==160)]-(15)-[_leftScrollView(==130)]-(15)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self addThenScrollViewAndNowScrollViewConstraints];
    
    [self layoutToolbarOfStandardHeight];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutVerticalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewAndSwitchedPlacesWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutVerticalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewAndSwitchedPlaces];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutVerticalSplitThenScrollViewSwitchedWithNowScrollViewOnSamePlane {
    
    [self.view removeConstraints:self.verticalThenScrollViewConstraints];
    [self.view removeConstraints:self.horizontalISVConstraints];
    
    self.verticalThenScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(128)-[_leftScrollView]-(128)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.horizontalISVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightScrollView(==160)][_leftScrollView(==_rightScrollView)]|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self.view addConstraints:self.verticalThenScrollViewConstraints];
    [self.view addConstraints:self.horizontalISVConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutVerticalSplitThenScrollViewSwitchedWithNowScrollViewOnSamePlaneWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutVerticalSplitThenScrollViewSwitchedWithNowScrollViewOnSamePlane];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

#pragma mark - Scroll View Horizontal Split Animations
- (void)switchImagesAcrossHorizontalSplit{
    
    [self bringLeftSubviewToFront];
    
    self.nowImageView.layer.shadowOffset = CGSizeMake(0,0);
    self.nowImageView.layer.shadowRadius = 25;
    
    [self animateLayoutHorizontalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewWithCompletion:^{
        
        //        self.thenImageView.layer.shadowOffset = CGSizeMake(20,50);
        //        self.thenImageView.layer.shadowRadius = 50;
        //        self.thenImageView.layer.shadowOpacity = 1;
        //
        
        [self animateLayoutHorizontalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewAndSwitchedPlacesWithCompletion:^{
            
            NSLog(@"Animation for setupPhotos called");
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            anim.fromValue = [NSNumber numberWithFloat:1.0];
            anim.toValue = [NSNumber numberWithFloat:0.0];
            anim.duration = 0.3;
            [self.nowImageView.layer addAnimation:anim forKey:@"shadowOpacity"];
            self.nowImageView.layer.shadowOpacity = 0.0;
            
            [self animateLayoutHorizontalSplitThenScrollViewSwitchedWithNowScrollViewOnSamePlaneWithCompletion:^{
                self.thenOnLeftOrTop = !self.thenOnLeftOrTop;
            }];
        }];
    }];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:1.0];
    anim.duration = 0.3;
    [self.nowImageView.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.nowImageView.layer.shadowOpacity = 1.0;
    
}


- (void)layoutHorizontalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewWithCompletion {
    
    [self removeThenScrollViewAndNowScrollViewConstraints];
    
    self.horizontalThenScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topScrollView(==290)]-(15)-|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalNowScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomScrollView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.verticalISVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(79)-[_topScrollView(==200)]-(15)-[_bottomScrollView(==230)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addThenScrollViewAndNowScrollViewConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutHorizontalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutHorizontalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewWithCompletion];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutHorizontalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewAndSwitchedPlaces {
    
    [self removeThenScrollViewAndNowScrollViewConstraints];
    
    self.horizontalThenScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topScrollView(==290)]-(15)-|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.verticalISVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomScrollView(==230)]-(15)-[_topScrollView(==200)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalNowScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomScrollView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addThenScrollViewAndNowScrollViewConstraints];
    
    [self layoutToolbarOfStandardHeight];

    [self.view layoutIfNeeded];
}

- (void)animateLayoutHorizontalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewAndSwitchedPlacesWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutHorizontalSplitThenScrollViewOnDifferentPlaneThanNowScrollViewAndSwitchedPlaces];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutHorizontalSplitThenScrollViewSwitchedWithNowScrollViewOnSamePlane {
    
    [self.view removeConstraints:self.horizontalThenScrollViewConstraints];
    [self.view removeConstraints:self.verticalISVConstraints];
    
    
    self.horizontalThenScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topScrollView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.verticalISVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomScrollView(==230)][_topScrollView(==230)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    
    self.nowImageView.layer.shadowOffset = CGSizeMake(0,0);
    //                  self.nowImageView.layer.shadowRadius = 0;
    //                  self.nowImageView.layer.shadowOpacity = 0;
    
    
    [self.view addConstraints:self.horizontalThenScrollViewConstraints];
    [self.view addConstraints:self.verticalISVConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutHorizontalSplitThenScrollViewSwitchedWithNowScrollViewOnSamePlaneWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutHorizontalSplitThenScrollViewSwitchedWithNowScrollViewOnSamePlane];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

- (void)bringLeftSubviewToFront
{
    if (!self.thenOnLeftOrTop)
    {
        [self.view bringSubviewToFront:self.thenScrollView];
    }
    else
    {
        [self.view bringSubviewToFront:self.nowScrollView];
    }
}


#pragma mark - Camera Layout and Animations
- (void)layoutCameraFromTopOfScreenToToolbar
{
    [self removeCameraConstraints];
    
    self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
    
    self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView(==568)]" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
    
    [self addCameraConstraints];
    
    [self.view layoutIfNeeded];
    
}

- (void)layoutCameraFromTopOfScreenToBottomOfScreenPlusHideToolbar
{
    [self removeCameraConstraints];
    [self removeToolbarConstraints];
    
    [self.toolbar setItems:nil animated:YES];
    self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    //self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView(==524)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addCameraConstraints];
    [self addToolbarConstraints];
    
    [self.view layoutIfNeeded];
    
}

- (void)animateLayoutCameraFromTopOfScreenToBottomOfScreenPlusHideToolbarWithCompletion:(void (^)(void))completionBlock
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutCameraFromTopOfScreenToBottomOfScreenPlusHideToolbar];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
 
}
- (void)animateLayoutCameraFromTopOfScreenToToolbarWithCompletion:(void (^)(void))completionBlock
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutCameraFromTopOfScreenToToolbar];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

- (void)layoutCameraPIP
{
    self.nowScrollView.hidden = YES;

    [self removeThenScrollViewAndNowScrollViewConstraints];
    
    self.horizontalThenScrollViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(25)-[_leftScrollView]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    self.verticalISVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(400)-[_leftScrollView]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    //unusual scenario in which we cannot use our standard add constraint methods
    [self.view addConstraints:self.horizontalThenScrollViewConstraints];
    [self.view addConstraints:self.verticalISVConstraints];
    
    [self.view layoutIfNeeded];
    
    [self.view bringSubviewToFront:self.thenScrollView];
    
    self.thenScrollView.alpha = 0;
    self.thenScrollView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    self.thenScrollView.scrollEnabled = NO;
    self.thenScrollView.hidden = NO;
    
    //[self removeToolbarConstraints];
    
    //[self slideToolbarUpWithCompletionBlock:nil];
    
    [UIView animateWithDuration:1 animations:^{
        self.thenScrollView.alpha = 1;
    }];
}


- (void)layoutCamera
{
    
    [self removeCameraConstraints]; //necessary in case calling from a place where there were previous constraints!
    [self addCameraConstraints]; //resets the constraints using getter methods, since the layout arrays will be nil
    [self.view bringSubviewToFront:self.cameraContainerView];
    
    [self.view layoutIfNeeded];
    
    self.cameraContainerView.hidden = NO;

    [self animateLayoutCameraFromTopOfScreenToToolbarWithCompletion:^{
        [self animateLayoutCameraFromTopOfScreenToBottomOfScreenPlusHideToolbarWithCompletion:^{
//            [self layoutCameraPIP];
        }];
    }];
}


- (void)animateThenScrollViewFadeInWithCompletion:(void (^)(void))completionBlock
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.thenScrollView.alpha = 1;
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}


- (void)animateThenScrollViewFadeOutWithCompletion:(void (^)(void))completionBlock
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.thenScrollView.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

- (void)animateCameraResignWithSetupViewsBlock:(void (^)(void))setupViewsBehindCameraBlock AndCompletion:(void (^)(void))completionBlock {
    
    [self animateThenScrollViewFadeOutWithCompletion:^{
        
        [self.view bringSubviewToFront:self.cameraContainerView];
        self.nowScrollView.hidden = NO;
        self.thenScrollView.transform = CGAffineTransformIdentity;
        self.thenScrollView.alpha = 1;
        
        if (setupViewsBehindCameraBlock)
        {
            setupViewsBehindCameraBlock();
        }
        
        [self.view layoutIfNeeded];
        [self layoutBaseNavbar];

//        [self animateLayoutToolbarOfHeightZeroAtBottomOfScreenWithCompletion:^{
//            
//            [self.toolbar setItems:self.baseToolbarItems animated:NO]; //technically not a property...
//
//            [self animateLayoutToolbarOfStandardHeightWithCompletion:^{
//                
//                [UIView animateWithDuration:0.25 animations:^{
//                    [self removeCameraConstraints];
//                    self.horizontalCameraConstraints = nil;
//                    self.verticalCameraConstraints = nil;
//                    [self addCameraConstraints]; //resets to default from getter
//                    
//                    [self.view layoutIfNeeded];
//                    
//                    if(completionBlock)
//                    {
//                        completionBlock();
//                    }
//                }];
//            }];
//        }];
    }];
}

#pragma mark - Toolbar layout and animation

- (void)layoutToolbar
{
    if (self.toolbar.frame.size.height > 0)
    {
        [self layoutToolbarOfHeightZeroAtBottomOfScreen];
    }
    else
    {
        [self layoutToolbarOfStandardHeight];
    }
}


- (void)animateLayoutToolbarOfHeightZeroAtBottomOfScreenWithCompletion:(void (^)(void))completionBlock
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self layoutToolbarOfHeightZeroAtBottomOfScreen];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

- (void)layoutToolbarOfHeightZeroAtBottomOfScreen {
    [self removeToolbarConstraints];
    
    [self.toolbar setItems:nil animated:YES]; //Where does this line of code belong?
    
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addToolbarConstraints];
}

- (void)layoutToolbarOfStandardHeight {
    
    [self removeToolbarConstraints];
    
    self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==44)]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addToolbarConstraints];
}

-(void)animateLayoutToolbarOfStandardHeightWithCompletion:(void (^)(void))completionBlock;
{
    [UIView animateWithDuration:0.3 animations:^{

        [self layoutToolbarOfStandardHeight];

    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        };
    }];
}


#pragma mark - Navbar Layout
- (void)layoutBaseNavbar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)]];
}

#pragma mark - Constraint Addition and Removal
- (void)removeThenScrollViewAndNowScrollViewConstraints {
    if (self.horizontalSplit)
    {
        if (self.verticalISVConstraints) {
            [self.view removeConstraints:self.verticalISVConstraints];
        }
        
        if (self.horizontalNowScrollViewConstraints) {
            [self.view removeConstraints:self.horizontalNowScrollViewConstraints];
        }
        
        if (self.horizontalThenScrollViewConstraints) {
            [self.view removeConstraints:self.horizontalThenScrollViewConstraints];
        }
    }
    else
    {
        if (self.horizontalISVConstraints) {
            [self.view removeConstraints:self.horizontalISVConstraints];
        }
        
        if (self.verticalNowScrollViewConstraints) {
            [self.view removeConstraints:self.verticalNowScrollViewConstraints];
        }
        
        if (self.verticalThenScrollViewConstraints) {
            [self.view removeConstraints:self.verticalThenScrollViewConstraints];
        }
    }
}

- (void)addThenScrollViewAndNowScrollViewConstraints {
    if (self.horizontalSplit)
    {
        [self.view addConstraints:self.verticalISVConstraints];
        [self.view addConstraints:self.horizontalNowScrollViewConstraints];
        [self.view addConstraints:self.horizontalThenScrollViewConstraints];
    }
    else
    {
        [self.view addConstraints:self.horizontalISVConstraints];
        [self.view addConstraints:self.verticalNowScrollViewConstraints];
        [self.view addConstraints:self.verticalThenScrollViewConstraints];
    }
}

- (void)removeCameraConstraints {
    if (self.verticalCameraConstraints) {
        [self.view removeConstraints:self.verticalCameraConstraints];
    }
    
    if (self.horizontalCameraConstraints) {
    [self.view removeConstraints:self.horizontalToolbarConstraints];
    }
}

- (void)addCameraConstraints {
    [self.view addConstraints:self.horizontalCameraConstraints];
    [self.view addConstraints:self.verticalCameraConstraints];
}


- (void)removeToolbarConstraints {
    if (self.horizontalToolbarConstraints) {
        [self.view removeConstraints:self.horizontalToolbarConstraints];
    }
    
    if (self.verticalToolbarConstraints) {
        [self.view removeConstraints:self.verticalToolbarConstraints];
    }
}

- (void)addToolbarConstraints {
    [self.view addConstraints:self.horizontalToolbarConstraints];
    [self.view addConstraints:self.verticalToolbarConstraints];
}


- (void)removeAllTopLevelViewConstraints {
    [self.view removeConstraints:self.view.constraints];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.cameraContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cameraContainerView removeConstraints:self.cameraContainerView.constraints];
    
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolbar removeConstraints:self.toolbar.constraints];
}

- (void)removeSubviewConstraints {
    self.nowScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowScrollView removeConstraints:self.nowScrollView.constraints];
    
    self.thenScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenScrollView removeConstraints:self.thenScrollView.constraints];
    
    self.thenContentView.translatesAutoresizingMaskIntoConstraints = YES;
    self.thenContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.thenScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.thenImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.nowLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowLabel removeConstraints:self.nowLabel.constraints];

    self.thenLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenLabel removeConstraints:self.thenLabel.constraints];

}

- (void)layoutTextLabels
{
    
    NSLayoutConstraint *thenLabelLeft = [NSLayoutConstraint constraintWithItem:self.thenLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.thenScrollView attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    
    NSLayoutConstraint *thenLabelTop = [NSLayoutConstraint constraintWithItem:self.thenLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.thenScrollView attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    
    self.horizontalLabelConstraints = @[thenLabelLeft,thenLabelTop];
    
    [self.view addConstraints:self.horizontalLabelConstraints];
    [self.view layoutIfNeeded];
    
    self.horizontalLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_thenLabel(==_thenScrollView)]" options:0 metrics:nil views:self.subviewsDictionary];
    
    self.verticalLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_thenLabel(==_thenScrollView)]" options:0 metrics:nil views:self.subviewsDictionary];

    
}

@end
