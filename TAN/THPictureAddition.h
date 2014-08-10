//
//  THPictureAddition.h
//  TAN
//
//  Created by Heidi Anne Kaiulani Hansen on 8/8/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THViewController.h"

@interface THPictureAddition : NSObject

@property (strong, nonatomic) UIImage *thenImage;
@property (strong, nonatomic) UIImage *nowImage;


- (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage secondImagePlacement:(CGPoint) xy;

-(UIImage *)applyTextOverlayToImage:(UIImage *)image Position:(CGPoint)position TextSize:(CGFloat)textSize Text:(NSString *)text;
-(UIImage *)resizeImage:(UIImage *)image ForPolaroidFrame:(CGRect)rect;
@end
