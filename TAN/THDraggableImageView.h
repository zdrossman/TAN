//
//  THDraggableImage.h
//  TAN
//
//  Created by Zachary Drossman on 7/31/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THDraggableImageView : UIView

@property (strong, nonatomic) UIImage *image;
@property (nonatomic) CGRect snapToFrame;

@end
