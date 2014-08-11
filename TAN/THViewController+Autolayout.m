//
//  THViewController+Animations.m
//  TAN
//
//  Created by Zachary Drossman on 8/10/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THViewController+Autolayout.h"

@implementation THViewController (Autolayout)

#pragma mark - Container View Layout
- (void)layoutThenAndNowContainerViews
{
    self.cameraContainerView.hidden = YES;
    self.nowView.hidden = NO;
    self.toolbar.alpha = 1;
    self.toolbar.hidden = NO;
    
    [self.view removeConstraints:self.view.constraints];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.cameraContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cameraContainerView removeConstraints:self.cameraContainerView.constraints];
    
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolbar removeConstraints:self.toolbar.constraints];
    
    self.cropperContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cropperContainerView removeConstraints:self.cropperContainerView.constraints];
    
    if (self.horizontalSplit) {
        [self layoutHorizontalSplitOfContainerViews];
    }
    else {
        [self layoutVerticalSplitOfContainerViews];
    }
    
    [self removeSubviewConstraints];
    
    [self layoutThenSubviews];
    [self layoutNowSubviews];
    
    [self.view layoutIfNeeded];
}

- (void)layoutThenSubviews
{
    self.verticalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_thenButton]|" options:0 metrics:nil views:self.subviewsDictionary];
    
    self.horizontalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_thenButton]|" options:0 metrics:nil views:self.subviewsDictionary];
    
    [self.thenView addConstraints:self.verticalThenImageConstraints];
    [self.thenView addConstraints:self.horizontalThenImageConstraints];
}

- (void)layoutNowSubviews
{
    self.verticalNowImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nowButton]|" options:0 metrics:nil views:self.subviewsDictionary];
    
    self.horizontalNowImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nowButton]|" options:0 metrics:nil views:self.subviewsDictionary];
    
    [self.nowView addConstraints:self.verticalNowImageConstraints];
    [self.nowView addConstraints:self.horizontalNowImageConstraints];
}


- (void)layoutHorizontalSplitOfContainerViews {
    
    [self removeThenViewAndNowViewConstraints];
    
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_topImageView(==230)][_bottomImageView(==_topImageView)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addThenViewAndNowViewConstraints];
    
    [self layoutToolbarOfStandardHeight];
    
    [self.view layoutIfNeeded];
}

- (void)layoutVerticalSplitOfContainerViews {
    
    self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftImageView(==160)][_rightImageView(==_leftImageView)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_leftImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_rightImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self addThenViewAndNowViewConstraints];
    
    [self layoutToolbarOfStandardHeight];
    
}


#pragma mark - Container View Vertical Split Animations
- (void)switchImagesAcrossVerticalSplit{
    
    [self bringLeftSubviewToFront];
    [self animateLayoutVerticalSplitThenViewOnDifferentPlaneThanNowViewWithCompletion:^{
        
        [self animateLayoutVerticalSplitThenViewOnDifferentPlaneThanNowViewAndSwitchedPlacesWithCompletion:^{
            
            [self animateLayoutVerticalSplitThenViewSwitchedWithNowViewOnSamePlaneWithCompletion:^{
                self.thenOnLeftOrTop = !self.thenOnLeftOrTop;
            }];
        }];
    }];
}

//TODO: Add comment explaining animation
- (void)layoutVerticalSplitThenViewOnDifferentPlaneThanNowViewWithCompletion {
    
    [self removeThenViewAndNowViewConstraints];
    
    self.verticalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(94)-[_leftImageView]-(74)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_rightImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_leftImageView(==130)]-(15)-[_rightImageView(==160)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self addThenViewAndNowViewConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutVerticalSplitThenViewOnDifferentPlaneThanNowViewWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutVerticalSplitThenViewOnDifferentPlaneThanNowViewWithCompletion];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutVerticalSplitThenViewOnDifferentPlaneThanNowViewAndSwitchedPlaces {
    
    [self removeThenViewAndNowViewConstraints];
    
    self.verticalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(94)-[_leftImageView]-(74)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_rightImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightImageView(==160)]-(15)-[_leftImageView(==130)]-(15)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self addThenViewAndNowViewConstraints];
    
    [self layoutToolbarOfStandardHeight];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutVerticalSplitThenViewOnDifferentPlaneThanNowViewAndSwitchedPlacesWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutVerticalSplitThenViewOnDifferentPlaneThanNowViewAndSwitchedPlaces];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutVerticalSplitThenViewSwitchedWithNowViewOnSamePlane {
    
    [self.view removeConstraints:self.verticalThenViewConstraints];
    [self.view removeConstraints:self.horizontalICVConstraints];
    
    self.verticalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_leftImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightImageView(==160)][_leftImageView(==_rightImageView)]|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self.view addConstraints:self.verticalThenViewConstraints];
    [self.view addConstraints:self.horizontalICVConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutVerticalSplitThenViewSwitchedWithNowViewOnSamePlaneWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutVerticalSplitThenViewSwitchedWithNowViewOnSamePlane];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

#pragma mark - Container View Horizontal Split Animations
- (void)switchImagesAcrossHorizontalSplit{
    
    [self bringLeftSubviewToFront];
    
    self.nowButton.layer.shadowOffset = CGSizeMake(0,0);
    self.nowButton.layer.shadowRadius = 25;
    
    [self animateLayoutHorizontalSplitThenViewOnDifferentPlaneThanNowViewWithCompletion:^{
        
        //        self.thenImageView.layer.shadowOffset = CGSizeMake(20,50);
        //        self.thenImageView.layer.shadowRadius = 50;
        //        self.thenImageView.layer.shadowOpacity = 1;
        //
        
        [self animateLayoutHorizontalSplitThenViewOnDifferentPlaneThanNowViewAndSwitchedPlacesWithCompletion:^{
            
            NSLog(@"Animation for setupPhotos called");
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            anim.fromValue = [NSNumber numberWithFloat:1.0];
            anim.toValue = [NSNumber numberWithFloat:0.0];
            anim.duration = 0.3;
            [self.nowButton.layer addAnimation:anim forKey:@"shadowOpacity"];
            self.nowButton.layer.shadowOpacity = 0.0;
            
            [self animateLayoutHorizontalSplitThenViewSwitchedWithNowViewOnSamePlaneWithCompletion:^{
                self.thenOnLeftOrTop = !self.thenOnLeftOrTop;
            }];
        }];
    }];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:1.0];
    anim.duration = 0.3;
    [self.nowButton.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.nowButton.layer.shadowOpacity = 1.0;
    
}


- (void)layoutHorizontalSplitThenViewOnDifferentPlaneThanNowViewWithCompletion {
    
    [self removeThenViewAndNowViewConstraints];
    
    self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topImageView(==290)]-(15)-|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(79)-[_topImageView(==200)]-(15)-[_bottomImageView(==230)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addThenViewAndNowViewConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutHorizontalSplitThenViewOnDifferentPlaneThanNowViewWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutHorizontalSplitThenViewOnDifferentPlaneThanNowViewWithCompletion];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutHorizontalSplitThenViewOnDifferentPlaneThanNowViewAndSwitchedPlaces {
    
    [self removeThenViewAndNowViewConstraints];
    
    self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topImageView(==290)]-(15)-|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomImageView(==230)]-(15)-[_topImageView(==200)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.horizontalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self addThenViewAndNowViewConstraints];
    
    [self layoutToolbarOfStandardHeight];

    [self.view layoutIfNeeded];
}

- (void)animateLayoutHorizontalSplitThenViewOnDifferentPlaneThanNowViewAndSwitchedPlacesWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutHorizontalSplitThenViewOnDifferentPlaneThanNowViewAndSwitchedPlaces];
        
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

//TODO: Add comment explaining animation
- (void)layoutHorizontalSplitThenViewSwitchedWithNowViewOnSamePlane {
    
    [self.view removeConstraints:self.horizontalThenViewConstraints];
    [self.view removeConstraints:self.verticalICVConstraints];
    
    
    self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomImageView(==230)][_topImageView(==230)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    
    self.nowButton.layer.shadowOffset = CGSizeMake(0,0);
    //                  self.nowImageView.layer.shadowRadius = 0;
    //                  self.nowImageView.layer.shadowOpacity = 0;
    
    
    [self.view addConstraints:self.horizontalThenViewConstraints];
    [self.view addConstraints:self.verticalICVConstraints];
    
    [self.view layoutIfNeeded];
}

- (void)animateLayoutHorizontalSplitThenViewSwitchedWithNowViewOnSamePlaneWithCompletion:(void (^)(void))completionBlock {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self layoutHorizontalSplitThenViewSwitchedWithNowViewOnSamePlane];
        
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
        [self.view bringSubviewToFront:self.thenView];
    }
    else
    {
        [self.view bringSubviewToFront:self.nowView];
    }
}


#pragma mark - Camera Layout and Animations
- (void)layoutCameraFromTopOfScreenToToolbar
{
    [self removeCameraConstraints];
    
    self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
    
    self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView(==cameraViewBottomAnimated)]" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
    
    [self addCameraConstraints];
    
    [self.view layoutIfNeeded];
    
}

- (void)layoutCameraFromTopOfScreenToBottomOfScreenPlusHideToolbar
{
    [self removeCameraConstraints];
    [self removeToolbarConstraints];
    
    [self.toolbar setItems:nil animated:YES];
    self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView(==524)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
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
    self.nowView.hidden = YES;

    [self removeThenViewAndNowViewConstraints];
    
    self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(25)-[_leftImageView]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(400)-[_leftImageView]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    //unusual scenario in which we cannot use our standard add constraint methods
    [self.view addConstraints:self.horizontalThenViewConstraints];
    [self.view addConstraints:self.verticalICVConstraints];
    
    [self.view layoutIfNeeded];
    
    [self.view bringSubviewToFront:self.thenView];
    
    self.thenView.alpha = 0;
    self.thenView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.thenView.hidden = NO;
    
    [self removeToolbarConstraints];
    
    //[self slideToolbarUpWithCompletionBlock:nil];
    
    [UIView animateWithDuration:1 animations:^{
        self.thenView.alpha = 1;
    }];
}


- (void)layoutCamera
{
    self.cameraContainerView.hidden = NO;
    self.cameraContainerView.backgroundColor = [UIColor purpleColor];
    
    [self removeCameraConstraints]; //necessary in case calling from a place where there were previous constraints!
    [self addCameraConstraints]; //resets the constraints using getter methods, since the layout arrays will be nil
    [self.view layoutIfNeeded];
    
    [self animateLayoutCameraFromTopOfScreenToToolbarWithCompletion:^{
        
        [self animateLayoutCameraFromTopOfScreenToBottomOfScreenPlusHideToolbarWithCompletion:^{

            [self layoutCameraPIP];
            [self layoutCameraNavigationBar];
        }];
    }];
}


- (void)layoutCameraNavigationBar
{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(returnToPhotosFromCamera)];
}


#pragma mark - Toolbar layout and animation
- (void)animateToolbarOfHeightZeroAtBottomOfScreenWithCompletion:(void (^)(void))completionBlock
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
    
    [self.view layoutIfNeeded];
    
}

-(void)animateLayoutToolbarOfStandardHeight:(void (^)(void))completionBlock;
{
    [UIView animateWithDuration:0.3 animations:^{
        
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
- (void)removeThenViewAndNowViewConstraints {
    if (self.horizontalSplit)
    {
        if (self.verticalICVConstraints) {
            [self.view removeConstraints:self.verticalICVConstraints];
        }
        
        if (self.horizontalNowViewConstraints) {
            [self.view removeConstraints:self.horizontalNowViewConstraints];
        }
        
        if (self.horizontalThenViewConstraints) {
            [self.view removeConstraints:self.horizontalThenViewConstraints];
        }
    }
    else
    {
        if (self.horizontalICVConstraints) {
            [self.view removeConstraints:self.horizontalICVConstraints];
        }
        
        if (self.verticalNowViewConstraints) {
            [self.view removeConstraints:self.verticalNowViewConstraints];
        }
        
        if (self.verticalThenViewConstraints) {
            [self.view removeConstraints:self.verticalThenViewConstraints];
        }
    }
}

- (void)addThenViewAndNowViewConstraints {
    if (self.horizontalSplit)
    {
        [self.view addConstraints:self.verticalICVConstraints];
        [self.view addConstraints:self.horizontalNowViewConstraints];
        [self.view addConstraints:self.horizontalThenViewConstraints];
    }
    else
    {
        [self.view addConstraints:self.horizontalICVConstraints];
        [self.view addConstraints:self.verticalNowViewConstraints];
        [self.view addConstraints:self.verticalThenViewConstraints];
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
    
    self.cropperContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cropperContainerView removeConstraints:self.cropperContainerView.constraints];
}

- (void)removeSubviewConstraints {
    self.nowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowView removeConstraints:self.nowView.constraints];
    
    self.thenView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenView removeConstraints:self.thenView.constraints];
    
    self.thenButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenButton removeConstraints:self.thenButton.constraints];
    
    self.nowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowButton removeConstraints:self.nowButton.constraints];
    
}

//- (void)addSubviewConstraints {
//
//    [self.nowView addConstraints:self.c];
//    [self.thenView addConstraints:self.thenButton];
//    
//}
@end
