//
//  THCameraButton.m
//  cameraButton
//
//  Created by Heidi Anne Kaiulani Hansen on 8/3/14.
//  Copyright (c) 2014 Heidi Hansen. All rights reserved.
//

#import "THCameraButton.h"
#define DegreesToRadians(x) ((x) * M_PI / 180.0)

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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat buttonRadius = rect.size.width/2;
    CGFloat buttonRing = buttonRadius - (buttonRadius/5.5);
    CGFloat buttonFill = buttonRing - (buttonRadius/12);
    
    CGPathAddArc(path, NULL, buttonRadius, buttonRadius, buttonRadius - 2, DegreesToRadians(0), DegreesToRadians(360), 0);
    CGPathMoveToPoint(path, NULL, buttonRadius, buttonRadius);
    CGPathAddArc(path, NULL, buttonRadius, buttonRadius, buttonRing, DegreesToRadians(0), DegreesToRadians(360), 0);
    CGPathMoveToPoint(path, NULL, buttonRadius, buttonRadius);
    CGPathAddArc(path, NULL, buttonRadius, buttonRadius, buttonFill, DegreesToRadians(0), DegreesToRadians(360), 0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGContextAddPath(context, path);
    CGContextEOFillPath(context);
    CGPathRelease(path);
    
    UIGraphicsEndImageContext();
}

@end
