//
//  THCameraButton.m
//  cameraButton
//
//  Created by Heidi Anne Kaiulani Hansen on 8/3/14.
//  Copyright (c) 2014 Heidi Hansen. All rights reserved.
//

#import "THCameraButton.h"

@interface THCameraButton ()

@end

@implementation THCameraButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *circleRect = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [circleRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blueColor] setStroke];
    [circleRect setLineWidth:6];
    
    [circleRect stroke];
}

//    UIGraphicsBeginImageContext(canvasSize);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //code from THCameraButton(subclass of UIButton), testing in this new UIView subclass
//    self.backgroundColor = [UIColor blueColor];
    
//    self.layer.borderWidth = 6;
//    self.layer.opacity = 0.5;
//    self.layer.borderColor = [UIColor blackColor].CGColor;
//    self.layer.
//    self.layer.cornerRadius = rect.size.width / 2;
    
    //sets inner circle frame
//    CGFloat borderDim = self.layer.borderWidth;
//    CGRect circFrame = CGRectMake((0 + borderDim), (0 + borderDim), (rect.size.width - (borderDim *2)), (rect.size.height - (borderDim *2)));
    
    //creates inner circle
//    UIView *innerCircle = [[UIView alloc]init];
//    innerCircle.frame = circFrame;
//    innerCircle.backgroundColor = [UIColor whiteColor];
//    innerCircle.layer.cornerRadius = circFrame.size.width / 2;
//    innerCircle.layer.borderColor = [UIColor blackColor].CGColor;
//    innerCircle.layer.borderWidth = 2;
//    [self addSubview:innerCircle];


@end
