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
- (void)layoutThenAndNowContainerViews
{
    self.nowContainerView.hidden = NO;
    
    self.toolbar.alpha = 1;
    self.toolbar.hidden = NO;
        
    if (self.horizontalSplit) {
        [self layoutHorizontalSplitOfContainerViews];
    }
    else {
        [self layoutVerticalSplitOfContainerViews];
    }

    [self removeContainerViewConstraints];
    [self removeSubviewConstraints];

    [self layoutNowSubviews];

    [self layoutThenSubviews];
}

- (void)layoutThenSubviews
{
    self.verticalThenScrollViewConstraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_thenScrollView]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    self.horizontalThenScrollViewConstraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_thenScrollView]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    self.verticalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_thenImageView(thenImageHeight)]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    self.horizontalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_thenImageView(thenImageWidth)]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    [self.thenContainerView addConstraints:self.horizontalThenScrollViewConstraints];
    [self.thenContainerView addConstraints:self.verticalThenScrollViewConstraints];
    
    [self.thenScrollView addConstraints:self.verticalThenImageConstraints];
    [self.thenScrollView addConstraints:self.horizontalThenImageConstraints];
}

- (void)layoutNowSubviews
{
    
    self.verticalNowScrollViewConstraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nowScrollView]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    self.horizontalNowScrollViewConstraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nowScrollView]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    self.verticalNowImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nowImageView(nowImageHeight)]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    self.horizontalNowImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nowImageView(nowImageWidth)]|" options:0 metrics:self.metrics views:self.subviewsDictionary];
    
    [self.nowContainerView addConstraints:self.horizontalNowScrollViewConstraints];
    [self.nowContainerView addConstraints:self.verticalNowScrollViewConstraints];

    [self.nowScrollView addConstraints:self.verticalNowImageConstraints];
    [self.nowScrollView addConstraints:self.horizontalNowImageConstraints];
}

- (void)layoutHorizontalSplitOfContainerViews {
    
    [self removeThenContainerViewAndNowContainerViewConstraints];
    
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(124)-[_topContainerView(==230)][_bottomContainerView(==_topContainerView)-(124)-]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalNowContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topContainerView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalThenContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomContainerView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addThenContainerViewAndNowContainerViewConstraints];
    
    [self layoutToolbarOfStandardHeight];
    
}

- (void)layoutVerticalSplitOfContainerViews {
    
    [self removeThenContainerViewAndNowContainerViewConstraints];

    self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftContainerView(==160)][_rightContainerView(==_leftContainerView)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalThenContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(124)-[_leftContainerView]-(124)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(124)-[_rightContainerView]-(124)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self addThenContainerViewAndNowContainerViewConstraints];
    
    [self layoutToolbarOfStandardHeight];
    
}


#pragma mark - Scroll View Vertical Split Animations
- (void)switchImagesAcrossVerticalSplit{
    
    [self bringLeftSubviewToFront];
    [self animateLayoutVerticalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewWithCompletion:^{
        
        [self animateLayoutVerticalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewAndSwitchedPlacesWithCompletion:^{
            
            [self animateLayoutVerticalSplitThenContainerViewSwitchedWithNowContainerViewOnSamePlaneWithCompletion:^{
                self.thenOnLeftOrTop = !self.thenOnLeftOrTop;
            }];
        }];
    }];
}

//TODO: Add comment explaining animation
- (void)layoutVerticalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewWithCompletion {
    
    [self removeThenContainerViewAndNowContainerViewConstraints];
    
    self.verticalThenContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(143)-[_leftContainerView]-(143)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(128)-[_rightContainerView]-(128)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_leftContainerView(==130)]-(15)-[_rightContainerView(==160)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self addThenContainerViewAndNowContainerViewConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutVerticalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutVerticalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewWithCompletion];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutVerticalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewAndSwitchedPlaces {
    
    [self removeThenContainerViewAndNowContainerViewConstraints];
    
    self.verticalThenContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(143)-[_leftContainerView]-(143)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(128)-[_rightContainerView]-(128)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightContainerView(==160)]-(15)-[_leftContainerView(==130)]-(15)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self addThenContainerViewAndNowContainerViewConstraints];
    
    [self layoutToolbarOfStandardHeight];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutVerticalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewAndSwitchedPlacesWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutVerticalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewAndSwitchedPlaces];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutVerticalSplitThenContainerViewSwitchedWithNowContainerViewOnSamePlane {
    
    [self.view removeConstraints:self.verticalThenContainerViewConstraints];
    [self.view removeConstraints:self.horizontalICVConstraints];
    
    self.verticalThenContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(128)-[_leftContainerView]-(128)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightContainerView(==160)][_leftContainerView(==_rightContainerView)]|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self.view addConstraints:self.verticalThenContainerViewConstraints];
    [self.view addConstraints:self.horizontalICVConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutVerticalSplitThenContainerViewSwitchedWithNowContainerViewOnSamePlaneWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutVerticalSplitThenContainerViewSwitchedWithNowContainerViewOnSamePlane];
        
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
    
    [self animateLayoutHorizontalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewWithCompletion:^{
        
        //        self.thenImageView.layer.shadowOffset = CGSizeMake(20,50);
        //        self.thenImageView.layer.shadowRadius = 50;
        //        self.thenImageView.layer.shadowOpacity = 1;
        //
        
        [self animateLayoutHorizontalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewAndSwitchedPlacesWithCompletion:^{
            
            NSLog(@"Animation for setupPhotos called");
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            anim.fromValue = [NSNumber numberWithFloat:1.0];
            anim.toValue = [NSNumber numberWithFloat:0.0];
            anim.duration = 0.3;
            [self.nowImageView.layer addAnimation:anim forKey:@"shadowOpacity"];
            self.nowImageView.layer.shadowOpacity = 0.0;
            
            [self animateLayoutHorizontalSplitThenContainerViewSwitchedWithNowContainerViewOnSamePlaneWithCompletion:^{
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


- (void)layoutHorizontalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewWithCompletion {
    
    [self removeThenContainerViewAndNowContainerViewConstraints];
    
    self.horizontalThenContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topContainerView(==290)]-(15)-|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalNowContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomContainerView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(79)-[_topContainerView(==200)]-(15)-[_bottomContainerView(==230)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addThenContainerViewAndNowContainerViewConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutHorizontalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutHorizontalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewWithCompletion];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutHorizontalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewAndSwitchedPlaces {
    
    [self removeThenContainerViewAndNowContainerViewConstraints];
    
    self.horizontalNowContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topContainerView(==290)]-(15)-|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomContainerView(==230)]-(15)-[_topContainerView(==200)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalThenContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomContainerView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addThenContainerViewAndNowContainerViewConstraints];
    
    [self layoutToolbarOfStandardHeight];

    [self.view layoutIfNeeded];
}

- (void)animateLayoutHorizontalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewAndSwitchedPlacesWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutHorizontalSplitThenContainerViewOnDifferentPlaneThanNowContainerViewAndSwitchedPlaces];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutHorizontalSplitThenContainerViewSwitchedWithNowContainerViewOnSamePlane {
    
    [self.view removeConstraints:self.horizontalNowContainerViewConstraints];
    [self.view removeConstraints:self.verticalICVConstraints];
    
    
    self.horizontalThenContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topContainerView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomContainerView(==230)][_topContainerView(==230)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    
    self.nowImageView.layer.shadowOffset = CGSizeMake(0,0);
    //                  self.nowImageView.layer.shadowRadius = 0;
    //                  self.nowImageView.layer.shadowOpacity = 0;
    
    
    [self.view addConstraints:self.horizontalThenContainerViewConstraints];
    [self.view addConstraints:self.verticalICVConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutHorizontalSplitThenContainerViewSwitchedWithNowContainerViewOnSamePlaneWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutHorizontalSplitThenContainerViewSwitchedWithNowContainerViewOnSamePlane];
        
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
        [self.view bringSubviewToFront:self.thenContainerView];
    }
    else
    {
        [self.view bringSubviewToFront:self.nowContainerView];
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
    self.nowContainerView.hidden = YES;

    [self removeThenContainerViewAndNowContainerViewConstraints];
    
    self.horizontalThenContainerViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(25)-[_leftContainerView]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(400)-[_leftContainerView]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    //unusual scenario in which we cannot use our standard add constraint methods
    [self.view addConstraints:self.horizontalNowContainerViewConstraints];
    [self.view addConstraints:self.verticalICVConstraints];
    
    [self.view layoutIfNeeded];
    
    [self.view bringSubviewToFront:self.thenScrollView];
    
    self.thenContainerView.alpha = 0;
    self.thenContainerView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    self.thenContainerView.hidden = NO;
    
    //[self removeToolbarConstraints];
    
    //[self slideToolbarUpWithCompletionBlock:nil];
    
    [UIView animateWithDuration:1 animations:^{
        self.thenContainerView.alpha = 1;
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


- (void)animateThenContainerViewFadeInWithCompletion:(void (^)(void))completionBlock
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


- (void)animateThenContainerViewFadeOutWithCompletion:(void (^)(void))completionBlock
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
    
    [self animateThenContainerViewFadeOutWithCompletion:^{
        
        [self.view bringSubviewToFront:self.cameraContainerView];
        self.nowContainerView.hidden = NO;
        self.thenContainerView.transform = CGAffineTransformIdentity;
        self.thenContainerView.alpha = 1;
        
        if (setupViewsBehindCameraBlock)
        {
            setupViewsBehindCameraBlock();
        }
        
        [self.view layoutIfNeeded];
        [self layoutBaseNavbar];

        [self animateLayoutToolbarOfHeightZeroAtBottomOfScreenWithCompletion:^{
            
            [self.toolbar setItems:self.baseToolbarItems animated:NO]; //technically not a property...

            [self animateLayoutToolbarOfStandardHeightWithCompletion:^{
                
                [UIView animateWithDuration:0.25 animations:^{
                    [self removeCameraConstraints];
                    self.horizontalCameraConstraints = nil;
                    self.verticalCameraConstraints = nil;
                    [self addCameraConstraints]; //resets to default from getter
                    
                    [self.view layoutIfNeeded];
                    
                    if(completionBlock)
                    {
                        completionBlock();
                    }
                }];
            }];
        }];
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
        [self.view layoutIfNeeded];

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
- (void)removeThenContainerViewAndNowContainerViewConstraints {
    if (self.horizontalSplit)
    {
        if (self.verticalICVConstraints) {
            [self.view removeConstraints:self.verticalICVConstraints];
        }
        
        if (self.horizontalNowContainerViewConstraints) {
            [self.view removeConstraints:self.horizontalNowContainerViewConstraints];
        }
        
        if (self.horizontalThenContainerViewConstraints) {
            [self.view removeConstraints:self.horizontalThenContainerViewConstraints];
        }
    }
    else
    {
        if (self.horizontalICVConstraints) {
            [self.view removeConstraints:self.horizontalICVConstraints];
        }
        
        if (self.verticalNowContainerViewConstraints) {
            [self.view removeConstraints:self.verticalNowContainerViewConstraints];
        }
        
        if (self.verticalThenContainerViewConstraints) {
            [self.view removeConstraints:self.verticalThenContainerViewConstraints];
        }
    }
}

- (void)addThenContainerViewAndNowContainerViewConstraints {
    if (self.horizontalSplit)
    {
        [self.view addConstraints:self.verticalICVConstraints];
        [self.view addConstraints:self.horizontalNowContainerViewConstraints];
        [self.view addConstraints:self.horizontalThenContainerViewConstraints];
    }
    else
    {
        [self.view addConstraints:self.horizontalICVConstraints];
        [self.view addConstraints:self.verticalNowContainerViewConstraints];
        [self.view addConstraints:self.verticalThenContainerViewConstraints];
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
    
    self.thenContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenContainerView removeConstraints:self.thenContainerView.constraints];
    
    self.nowContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowContainerView removeConstraints:self.nowContainerView.constraints];

    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolbar removeConstraints:self.toolbar.constraints];
    
    self.secondaryToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.secondaryToolbar removeConstraints:self.secondaryToolbar.constraints];
}

- (void)removeContainerViewConstraints {
    
    self.thenContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenContainerView removeConstraints:self.thenContainerView.constraints];
    
    self.nowContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowContainerView removeConstraints:self.nowContainerView.constraints];
}

- (void)removeSubviewConstraints {
    self.nowContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowContainerView removeConstraints:self.nowContainerView.constraints];
    
    self.thenScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenScrollView removeConstraints:self.thenScrollView.constraints];

    self.nowScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowScrollView removeConstraints:self.nowScrollView.constraints];

//    self.thenContentView.translatesAutoresizingMaskIntoConstraints = YES;
//    self.thenContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.thenScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.thenImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.nowLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowLabel removeConstraints:self.nowLabel.constraints];

    self.thenLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenLabel removeConstraints:self.thenLabel.constraints];

}

- (void)removeLabelConstraints {
    
    self.nowLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view removeConstraints:self.nowLabel.constraints];
    
    self.thenLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view removeConstraints:self.thenLabel.constraints];
    
}
- (void)layoutTextLabels
{
    [self removeLabelConstraints];
    
    NSLayoutConstraint *thenLabelLeft = [NSLayoutConstraint constraintWithItem:self.thenLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.thenContainerView attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    
    NSLayoutConstraint *thenLabelTop = [NSLayoutConstraint constraintWithItem:self.thenLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.thenContainerView attribute:NSLayoutAttributeTop multiplier:1 constant:20];
    
    NSLayoutConstraint *nowLabelRight = [NSLayoutConstraint constraintWithItem:self.nowLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.nowContainerView attribute:NSLayoutAttributeRight multiplier:1 constant:-20];
    
    NSLayoutConstraint *nowLabelBottom = [NSLayoutConstraint constraintWithItem:self.nowLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.nowContainerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
    
//    NSArray *horizontalAndLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_andLabel]|" options:0 metrics:nil views:self.labelsDictionary];
//    
//    NSArray *verticalAndLabelConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_andLabel]|" options:0 metrics:nil views:self.labelsDictionary];

    
    self.thenLabelConstraints = @[thenLabelLeft,thenLabelTop];
    self.nowLabelConstraints = @[nowLabelBottom, nowLabelRight];
    [self.view addConstraints:self.thenLabelConstraints];
    [self.view addConstraints:self.nowLabelConstraints];

    [self.view layoutIfNeeded];

    
}



- (void)buildSecondaryToolbarWithButtonArray:(NSArray *)buttonArray {
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addButtonsWithButtonArray:buttonArray];
    [self addSpacers];
}

- (void)addButtonsWithButtonArray:(NSArray *)buttonArray {
    self.dataFields = [NSMutableArray array];
    for (NSInteger i = 0; i < [buttonArray count]; ++i) {
        [self addButtonFromButtonArray:buttonArray AtIndex:i];
    }
}

- (void)addButtonFromButtonArray:(NSArray *)buttonArray AtIndex:(NSInteger)index {
    UIButton *button = buttonArray[index];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentViewForSecondaryToolbar addSubview:button];
    [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentViewForSecondaryToolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[button]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [self.dataFields addObject:button];
}

- (void)addSpacers {
    [self addTopSpacer];
    for (NSInteger i = 1, count = [self.dataFields count]; i < count; ++i) {
        [self addSpacerFromBottomOfView:self.dataFields[i - 1]
                            toTopOfView:self.dataFields[i]];
    }
    [self addBottomSpacer];
}

- (void)addTopSpacer {
    UIView *spacer = [self newSpacer];
    UIButton *button = self.dataFields[0];
    
    [self.contentViewForSecondaryToolbar addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[spacer(==20)][button]" options:0 metrics:nil
                               views:NSDictionaryOfVariableBindings(spacer, button)]];
    self.topSpacer = spacer;
}

- (UIView *)newSpacer {
    UIView *spacer = [[UIView alloc] init];
    spacer.hidden = YES; // Views participate in layout even when hidden.
    spacer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentViewForSecondaryToolbar addSubview:spacer];
    [self.contentViewForSecondaryToolbar addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[spacer]|" options:0 metrics:nil
                               views:NSDictionaryOfVariableBindings(spacer)]];
    return spacer;
}

- (void)addSpacerFromBottomOfView:(UIView *)overView toTopOfView:(UIView *)underView {
    UIView *spacer = [self newSpacer];
    id topSpacer = self.topSpacer;
    [self.contentViewForSecondaryToolbar addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[overView][spacer(==topSpacer)][underView]" options:0 metrics:nil
                               views:NSDictionaryOfVariableBindings(spacer, overView, underView, topSpacer)]];
}

- (void)addBottomSpacer {
    id topSpacer = self.topSpacer;
    UIView *spacer = [self newSpacer];
    UIButton *button = self.dataFields.lastObject;
    [self.contentViewForSecondaryToolbar addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[button][spacer(==topSpacer)]|" options:0 metrics:nil
                               views:NSDictionaryOfVariableBindings(spacer, button, topSpacer)]];
}

- (void)layoutSecondaryToolbar
{
    [self removeSecondaryToolbarConstraints];
    [self removeContentViewForSecondaryToolbarConstraints];
    
    id _secondaryToolbar = self.secondaryToolbar;
    id contentView = self.contentViewForSecondaryToolbar;

    NSDictionary *secondaryToolbarDictionary = NSDictionaryOfVariableBindings(_secondaryToolbar, contentView);
    
    
    NSArray *verticalContentViewForSecondaryToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView(==66)]|"
                                                                                                         options:0
                                                                                                         metrics:nil
                                                                                                           views:secondaryToolbarDictionary];
    
    NSArray *horizontalContentViewForSecondaryToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView(==1000)]|"
                                                                                                           options:0
                                                                                                           metrics:nil
                                                                                                             views:secondaryToolbarDictionary];
    
    
    self.verticalSecondaryToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_secondaryToolbar(==contentView)]-(44)-|" options:0 metrics:nil views:secondaryToolbarDictionary];
    self.horizontalSecondaryToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_secondaryToolbar(==320)]|" options:0 metrics:nil views:secondaryToolbarDictionary];
    
    [self addSecondaryToolbarConstraints];

    [self.secondaryToolbar addConstraints:verticalContentViewForSecondaryToolbarConstraints];
    
    [self.secondaryToolbar addConstraints:horizontalContentViewForSecondaryToolbarConstraints];

    
    self.secondaryToolbar.backgroundColor = [UIColor blueColor];
    
    [self buildSecondaryToolbarWithButtonArray:self.typefaceButtonArray];
    
}

- (void)removeContentViewForSecondaryToolbarConstraints
{
    self.contentViewForSecondaryToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentViewForSecondaryToolbar removeConstraints:self.contentViewForSecondaryToolbar.constraints];
}

- (void)removeSecondaryToolbarConstraints
{
    
    self.secondaryToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    //[self.secondaryToolbar removeConstraints:self.secondaryToolbar.constraints];
    
    if (self.verticalSecondaryToolbarConstraints)
    {
    [self.view removeConstraints:self.verticalSecondaryToolbarConstraints];
    }
    
    if (self.horizontalSecondaryToolbarConstraints)
    {
    [self.view removeConstraints:self.horizontalSecondaryToolbarConstraints];
    }

}

- (void)addSecondaryToolbarConstraints
{
    [self.view addConstraints:self.verticalSecondaryToolbarConstraints];
    [self.view addConstraints:self.horizontalSecondaryToolbarConstraints];
}
@end
