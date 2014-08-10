//
//  THDraggableImage.m
//  TAN
//
//  Created by Zachary Drossman on 7/31/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THDraggableView.h"
#import <AVFoundation/AVFoundation.h>

typedef enum snapPosition {
    SnapPositionBottom = 0,
    SnapPositionLeft = 1,
    SnapPositionTop = 2,
    SnapPositionRight = 3,
    SnapPositionReturn = 4,
} SnapPosition;

typedef enum pushDirection {
    PushDirectionFromTop = 0,
    PushDirectionFromBottom = 1,
    PushDirectionFromLeft = 2,
    PushDirectionFromRight = 3,
} PushDirection;

@interface THDraggableView ()

@property (nonatomic) CGPoint originalPoint;
@property (nonatomic) CGRect originalFrame;
@property (nonatomic) PushDirection pushDirection;
@property (nonatomic) NSInteger counter;
@end

@implementation THDraggableView


#pragma mark - Initialization / View Controller Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {

        [self baseInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    
    self.backgroundColor = [UIColor clearColor];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    if (self.superViewFrame.size.width == 0)
    {
        self.superViewFrame = CGRectMake(0,0,320,568);
    }
    
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveNotification:)name:@"didReceivePushFromAnotherView"
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)name:@"getFrame"
                                               object:nil];

}





- (void) dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
    
    [self.superview bringSubviewToFront:self];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            
//            [UIView animateWithDuration:0.2 animations:^{
//                self.frame = CGRectMake(self.frame.origin.x + 10, self.frame.origin.y + 10, self.frame.size.width - 20, self.frame.size.height - 20);
//            }];
            
            NSLog(@"SnapToFrameDetails BEFORE drag and BEFORE snapLogic: %f %f %f %f",self.snapToFrame.origin.x, self.snapToFrame.origin.y, self.snapToFrame.size.width, self.snapToFrame.size.height);
            
           // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didReceivePushFromAnotherView" object:nil];
            
            self.originalPoint = self.center;
            self.originalFrame = self.frame;
            break;
        };
            
        case UIGestureRecognizerStateChanged:{
            
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
            NSLog(@"Object: %@ Self.center.y = %f", self, self.center.y);
            
//            if (fabs(xDistance *568/320) < fabs(yDistance))
//            {
                //if dragged object is on top
                if (self.frame.origin.y < self.snapToFrame.origin.y && self.center.y > self.snapToFrame.origin.y)
                {
                    NSLog(@"Push From Top (to bottom)");
                    self.pushDirection = PushDirectionFromTop;
//                    [[NSNotificationCenter defaultCenter]
//                     postNotificationName:@"didReceivePushFromAnotherView"
//                     object:self];
                }
                
                //if dragged object is on bottom
                else if (self.frame.origin.y > self.snapToFrame.origin.y)
                {
                    
                    // if dragging has moved quarter Y up to edge of top image view
                    if (self.center.y < self.snapToFrame.size.height)
                    {
                        NSLog(@"Push From Bottom (to top)");
                        
                        self.pushDirection = PushDirectionFromBottom;
//                        [[NSNotificationCenter defaultCenter]
//                         postNotificationName:@"didReceivePushFromAnotherView"
//                         object:self];
                    }
                }
            //}
//            else
//            {
//                if (self.frame.origin.x < self.snapToFrame.origin.x && self.center.x > self.snapToFrame.origin.x)
//                {
//                    NSLog(@"Push From Top (to bottom)");
//                    self.pushDirection = PushDirectionFromLeft;
//                    [[NSNotificationCenter defaultCenter]
//                     postNotificationName:@"didReceivePushFromAnotherView"
//                     object:self];
//                }
//
//            }
//            NSLog(@"BREAK");
            break;
        };
           
        case UIGestureRecognizerStateEnded:{
            
//            NSLog(@"Center Y: %f",self.center.y);
//            NSLog(@"SnapToFrame Height: %f", self.snapToFrame.size.height);
//            NSLog(@"SnapToFrame Origin Y: %f", self.snapToFrame.origin.y);
//            
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(receiveNotification:)name:@"didReceivePushFromAnotherView"
//                                                       object:nil];
            
            NSLog(@"SnapToFrameDetails AFTER drag but BEFORE snapLogic: %f %f %f %f",self.snapToFrame.origin.x, self.snapToFrame.origin.y, self.snapToFrame.size.width, self.snapToFrame.size.height);

            [self checkSnapLogic];
            
            NSLog(@"SnapToFrameDetails AFTER drag and AFTER snapLogic: %f %f %f %f",self.snapToFrame.origin.x, self.snapToFrame.origin.y, self.snapToFrame.size.width, self.snapToFrame.size.height);

            break;
            
            };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
            
    }
    
}

- (void) receiveNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"didReceivePushFromAnotherView"])
    {
        THDraggableView *dragViewThatSentNotification = notification.object;
        self.pushDirection = dragViewThatSentNotification.pushDirection;
        
        [self moveViewBeingPushed];
    }
    
    if ([[notification name] isEqualToString:@"getFrame"])
    {
        THDraggableView *dragViewThatSentNotification = notification.object;
        
        self.snapToFrame = dragViewThatSentNotification.frame;
//        AVMakeRectWithAspectRatioInsideRect(dragViewThatSentNotification.image.size, dragViewThatSentNotification.frame);
        
        NSLog(@"SnapToFrameDetails AFTER getFrame is called: %f %f %f %f",self.snapToFrame.origin.x, self.snapToFrame.origin.y, self.snapToFrame.size.width, self.snapToFrame.size.height);

    }
}

- (void)moveViewBeingPushed
{
    CGRect newFrame;
    
    switch (self.pushDirection) {
        case PushDirectionFromLeft:
            newFrame = CGRectMake(self.superViewFrame.origin.x + self.superViewFrame.size.width/2,self.superViewFrame.origin.y,self.superViewFrame.size.width/2,self.superViewFrame.size.height);
            
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:@"getFrame"
//             object:self];
            
            break;
            
        case PushDirectionFromRight:
            newFrame = CGRectMake(self.superViewFrame.origin.x,self.superViewFrame.origin.y,self.superViewFrame.size.width/2,self.superViewFrame.size.height);
            
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:@"getFrame"
//             object:self];
            
            break;
            
        case PushDirectionFromTop:
            newFrame = CGRectMake(self.superViewFrame.origin.x,self.superViewFrame.origin.y, self.superViewFrame.size.width,self.superViewFrame.size.height/2);
            
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:@"getFrame"
//             object:self];
            
            break;
            
        case PushDirectionFromBottom:
            newFrame = CGRectMake(self.superViewFrame.origin.x,self.superViewFrame.origin.y + self.superViewFrame.size.height/2,self.superViewFrame.size.width,self.superViewFrame.size.height/2);
            
//            [[NSNotificationCenter defaultCenter]
//             postNotificationName:@"getFrame"
//             object:self];
            
            break;
            
        default:
            newFrame = self.frame;
            
            break;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = newFrame;
    }];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"getFrame"
     object:self];


}

- (void)checkSnapLogic
{

    CGPoint snapToFrameCenter = CGPointMake(self.snapToFrame.origin.x + self.snapToFrame.size.width / 2, self.snapToFrame.origin.y + self.snapToFrame.size.height / 2);
    
    //            if (fabs((self.center.x) - (snapToFrameCenter.x)) >= fabs((self.center.y) - (snapToFrameCenter.y)))
    //            {
    //                if (self.center.x > (snapToFrameCenter.x + dangerZone))
    //                {
    //                    [self snapToPosition:SnapPositionRight];
    //                }
    //                else if (self.center.x < (snapToFrameCenter.x - dangerZone))
    //                {
    //                    [self snapToPosition:SnapPositionLeft];
    //                }
    //                else
    //                {
    //                    [self snapToPosition:SnapPositionReturn];
    //                }
    //            }
    //            else
    if (fabs((self.center.x) - (snapToFrameCenter.x)) < fabs((self.center.y) - (snapToFrameCenter.y)))
    {
        if (self.center.y < (snapToFrameCenter.y))
        {
            [self snapToPosition:SnapPositionTop];
        }
        else if (self.center.y > (snapToFrameCenter.y))
        {
            [self snapToPosition:SnapPositionBottom];
        }
        else
        {
            [self snapToPosition:SnapPositionReturn];
        }
    }
    else
    {
        [self snapToPosition:SnapPositionReturn];
    }
    

}

- (void)snapToPosition:(SnapPosition)snapPosition
{

    
    CGPoint bottomCenter = CGPointMake(self.snapToFrame.origin.x + self.snapToFrame.size.width/2, self.snapToFrame.origin.y + self.snapToFrame.size.height);
    CGPoint rightCenter = CGPointMake(self.snapToFrame.origin.x + self.snapToFrame.size.width, self.snapToFrame.origin.y + self.snapToFrame.size.height/2);
    CGPoint topCenter = CGPointMake(self.snapToFrame.origin.x + self.snapToFrame.size.width/2, self.snapToFrame.origin.y);
    CGPoint leftCenter = CGPointMake(self.snapToFrame.origin.x, self.snapToFrame.origin.y + self.snapToFrame.size.height/2);
    
    [UIView animateWithDuration:0.2 animations:^{
        switch (snapPosition) {
            case SnapPositionBottom:
                self.center = CGPointMake(bottomCenter.x, bottomCenter.y + self.bounds.size.height /2);
                break;
                
            case SnapPositionLeft:
                self.center = CGPointMake(leftCenter.x - self.bounds.size.width / 2, leftCenter.y);
                break;
                
            case SnapPositionRight:
                self.center = CGPointMake(rightCenter.x + self.bounds.size.width / 2, rightCenter.y);
                break;
                
            case SnapPositionTop:
                self.center = CGPointMake(topCenter.x, topCenter.y - self.bounds.size.height /2);
                break;
                
            case SnapPositionReturn:
                self.center = self.originalPoint;
                break;
        }
        
    }];
}

#pragma mark - dealloc
- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

//    CGPoint topLeft = self.snapToFrame.origin;
//    CGPoint topRight = CGPointMake(self.snapToFrame.origin.x + self.snapToFrame.size.width, self.snapToFrame.origin.y);
//    CGPoint bottomLeft = CGPointMake(self.snapToFrame.origin.x, self.snapToFrame.origin.y + self.snapToFrame.size.height);
//    CGPoint bottomRight = CGPointMake(self.snapToFrame.origin.x + self.snapToFrame.size.width, self.snapToFrame.origin.y + self.snapToFrame.size.height);

//            [UIView animateWithDuration:0.2 animations:^{
//                self.frame = CGRectMake(self.frame.origin.x - 10, self.frame.origin.y - 10, self.frame.size.width + 20, self.frame.size.height + 20);
//            }];


@end
