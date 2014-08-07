//
//  THDraggableImage.h
//  TAN
//
//  Created by Zachary Drossman on 7/31/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCamera2ViewController.h"

@interface THDraggableView : UIView <THCameraDelegateProtocol>

@property (nonatomic) CGRect snapToFrame;
@property (nonatomic) CGRect superViewFrame;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) NSString *name;
@end
