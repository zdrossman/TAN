//
//  THDraggableImageView.h
//  TAN
//
//  Created by Zachary Drossman on 8/1/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THDraggableView.h"
#import "THCameraDelegateProtocol.h"

@interface THDraggableImageView : THDraggableView <THCameraDelegateProtocol>

@property (strong, nonatomic) UIImage *image;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat textSize;
@property (strong, nonatomic) NSString *imageText;

- (void)loadImageView;
-(UIImage *)applyOverlayToImage:(UIImage *)image withPostion:(CGPoint)postion withTextSize:(CGFloat)textSize withText:(NSString *)text;

@end
