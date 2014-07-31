//
//  THDraggableImage.m
//  TAN
//
//  Created by Zachary Drossman on 7/31/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THDraggableImageView.h"

typedef enum snapPosition {
    SnapPositionBottom = 0,
    SnapPositionLeft = 1,
    SnapPositionTop = 2,
    SnapPositionRight = 3,
    SnapPositionReturn = 4,
} SnapPosition;

@interface THDraggableImageView ()

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) CGPoint originalPoint;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation THDraggableImageView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {

        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    
    self.backgroundColor = [UIColor greenColor];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    [self loadImageViewAndStyle];

}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}


- (void)loadImageViewAndStyle
{
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [self addSubview:self.imageView];
//    [self layoutSubviews];
//    [self setNeedsDisplay];
    self.layer.shadowOffset = CGSizeMake(7,7);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
}

- (void) dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
    
    CGPoint snapToFrameCenter = CGPointMake(self.snapToFrame.origin.x + self.snapToFrame.size.width / 2, self.snapToFrame.origin.y + self.snapToFrame.size.height / 2);
    
    NSInteger dangerZone = 20;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            
        case UIGestureRecognizerStateChanged:{
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
            break;
        };
           
        case UIGestureRecognizerStateEnded:{
            
            if (fabs((self.center.x) - (snapToFrameCenter.x)) >= fabs((self.center.y) - (snapToFrameCenter.y)))
            {
                if (self.center.x > (snapToFrameCenter.x + dangerZone))
                {
                    [self snapToPosition:SnapPositionRight];
                }
                else if (self.center.x < (snapToFrameCenter.x - dangerZone))
                {
                    [self snapToPosition:SnapPositionLeft];
                }
                else
                {
                    [self snapToPosition:SnapPositionReturn];
                }
            }
            else if (fabs((self.center.x) - (snapToFrameCenter.x)) < fabs((self.center.y) - (snapToFrameCenter.y)))
            {
                if (self.center.y < (snapToFrameCenter.y - dangerZone))
                {
                    [self snapToPosition:SnapPositionTop];
                }
                else if (self.center.y > (snapToFrameCenter.y + dangerZone))
                {
                    [self snapToPosition:SnapPositionBottom];
                }
                else
                {
                    [self snapToPosition:SnapPositionReturn];
                }
            }
            
            
        };
            
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
            
    }
    
}

- (void)snapToPosition:(SnapPosition)snapPosition
{
    CGPoint topLeft = self.snapToFrame.origin;
    CGPoint topRight = CGPointMake(self.snapToFrame.origin.x + self.snapToFrame.size.width, self.snapToFrame.origin.y);
    CGPoint bottomLeft = CGPointMake(self.snapToFrame.origin.x, self.snapToFrame.origin.y + self.snapToFrame.size.height);
    CGPoint bottomRight = CGPointMake(self.snapToFrame.origin.x + self.snapToFrame.size.width, self.snapToFrame.origin.y + self.snapToFrame.size.height);
    
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

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}


-(void)setImage:(UIImage *)image
{
    _image = image;
    [self refresh];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)refresh {
    self.imageView.image = self.image;
}

@end
