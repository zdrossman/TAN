//
//  THViewController+Animations.m
//  TAN
//
//  Created by Zachary Drossman on 8/10/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THViewController+Autolayout.h"

@implementation THViewController (Autolayout)

-(void)performAnimation{
    
    if (self.currentPosition == YES) {
        
        [self leftAndRightSwitch];
    }else
    {
        [self topAndBottomSwitch];
    }
    
}

-(void)leftAndRightSwitch{
    
    if (!self.originalOrder)
    {
        [self.view bringSubviewToFront:self.thenImageView];
    }
    else
    {
        [self.view bringSubviewToFront:self.nowImageView];
    }
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.view removeConstraints:self.verticalDTIVConstraints];
        [self.view removeConstraints:self.verticalDNIVConstraints];
        [self.view removeConstraints:self.horizontalIVConstraints];
        
        self.verticalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(94)-[_leftImageView]-(74)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
        self.verticalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_rightImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
        self.horizontalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_leftImageView(==130)]-(15)-[_rightImageView(==160)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
        
        
        [self.view addConstraints:self.verticalDTIVConstraints];
        [self.view addConstraints:self.verticalDNIVConstraints];
        [self.view addConstraints:self.horizontalIVConstraints];
        // [self generateStandardToolbarConstraints];
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self removeAllConstraints];
            
            self.verticalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(94)-[_leftImageView]-(74)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
            self.horizontalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightImageView(==160)]-(15)-[_leftImageView(==130)]-(15)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
            
            self.verticalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_rightImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
            
            [self generateStandardToolbarConstraints];
            
            [self.view addConstraints:self.verticalDTIVConstraints];
            [self.view addConstraints:self.verticalDNIVConstraints];
            [self.view addConstraints:self.horizontalIVConstraints];
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [self.view removeConstraints:self.verticalDTIVConstraints];
                [self.view removeConstraints:self.horizontalIVConstraints];
                
                
                self.verticalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_leftImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
                self.horizontalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightImageView(==160)][_leftImageView(==_rightImageView)]|" options:0 metrics:nil views:self.leftRightViewsDictionary];
                
                // [self generateStandardToolbarConstraints];
                
                [self.view addConstraints:self.verticalDTIVConstraints];
                [self.view addConstraints:self.horizontalIVConstraints];
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                
                self.originalOrder = !self.originalOrder;
                
            }];
            
        }];
        
    }];
    
}

-(void)topAndBottomSwitch{
    
    if (!self.originalOrder)
    {
        [self.view bringSubviewToFront:self.thenImageView];
    }
    else
    {
        [self.view bringSubviewToFront:self.nowImageView];
    }
    
    self.nowImageView.layer.shadowOffset = CGSizeMake(0,0);
    self.nowImageView.layer.shadowRadius = 25;
    
    [UIView animateWithDuration:0.13 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
        NSLog(@"Animation for setupPhotos called");
        
        
        
        //        self.thenImageView.layer.shadowOffset = CGSizeMake(20,50);
        //        self.thenImageView.layer.shadowRadius = 50;
        //        self.thenImageView.layer.shadowOpacity = 1;
        //
        [self.view removeConstraints:self.horizontalDTIVConstraints];
        [self.view removeConstraints:self.verticalIVConstraints];
        [self.view removeConstraints:self.horizontalDNIVConstraints];
        
        
        self.horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topImageView(==290)]-(15)-|" options:0 metrics:nil views:self.viewsDictionary];
        self.horizontalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.viewsDictionary];
        self.verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(79)-[_topImageView(==200)]-(15)-[_bottomImageView(==230)]" options:0 metrics:nil views:self.viewsDictionary];
        
        [self.view addConstraints:self.horizontalDTIVConstraints];
        [self.view addConstraints:self.verticalIVConstraints];
        [self.view addConstraints:self.horizontalDNIVConstraints];
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            NSLog(@"Animation for setupPhotos called");
            [self removeAllConstraints];
            
            
            self.horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topImageView(==290)]-(15)-|" options:0 metrics:nil views:self.viewsDictionary];
            
            self.verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomImageView(==230)]-(15)-[_topImageView(==200)]" options:0 metrics:nil views:self.viewsDictionary];
            
            self.horizontalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.viewsDictionary];
            
            
            
            [self generateStandardToolbarConstraints];
            [self.view addConstraints:self.horizontalDTIVConstraints];
            [self.view addConstraints:self.horizontalDNIVConstraints];
            [self.view addConstraints:self.verticalIVConstraints];
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            anim.fromValue = [NSNumber numberWithFloat:1.0];
            anim.toValue = [NSNumber numberWithFloat:0.0];
            anim.duration = 0.3;
            [self.nowImageView.layer addAnimation:anim forKey:@"shadowOpacity"];
            self.nowImageView.layer.shadowOpacity = 0.0;
            
            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [self.view removeConstraints:self.horizontalDTIVConstraints];
                [self.view removeConstraints:self.verticalIVConstraints];
                
                
                self.horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topImageView]|" options:0 metrics:nil views:self.viewsDictionary];
                self.verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomImageView(==230)][_topImageView(==230)]" options:0 metrics:nil views:self.viewsDictionary];
                
                
                self.nowImageView.layer.shadowOffset = CGSizeMake(0,0);
                //                  self.nowImageView.layer.shadowRadius = 0;
                //                  self.nowImageView.layer.shadowOpacity = 0;
                
                
                [self.view addConstraints:self.horizontalDTIVConstraints];
                [self.view addConstraints:self.verticalIVConstraints];
                
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                self.originalOrder = !self.originalOrder;
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


@end
