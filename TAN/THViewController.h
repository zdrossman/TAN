//
//  THViewController.h
//  TAN
//
//  Created by Zachary Drossman on 7/31/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCamera2ViewController.h"
#import "THDraggableImageView.h"
#import "THCamera2ViewController.h"
#import "THDraggableImageView.h"
#import "BASSquareCropperViewController.h"
#import "THPictureAddition.h"
@interface THViewController : UIViewController

#pragma mark - Object Properties
@property (strong, nonatomic) UIView *cropperContainerView;
@property (strong, nonatomic) BASSquareCropperViewController *cropperVC;
@property (strong, nonatomic) THCamera2ViewController *cameraVC;
@property (strong, nonatomic) UIView *cameraContainerView;
@property (strong, nonatomic) UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) NSArray *toolbarButtonsArray;
@property (strong, nonatomic) UIImage *thenImage;
@property (strong, nonatomic) UIImage *nowImage;
@property (strong, nonatomic) UIButton *thenImageView;
@property (strong, nonatomic) UIButton *nowImageView;
@property (strong, nonatomic) UIView *nowView;
@property (strong, nonatomic) UIView *thenView;


#pragma mark - LayoutConstraint Properties
@property (strong, nonatomic) NSDictionary *viewsDictionary;
@property (strong, nonatomic) NSDictionary *leftRightViewsDictionary;

@property (strong, nonatomic) NSArray *horizontalToolbarConstraints;
@property (strong, nonatomic) NSArray *verticalToolbarConstraints;
@property (strong, nonatomic) NSArray *verticalCameraConstraints;
@property (strong, nonatomic) NSArray *horizontalCameraConstraints;
@property (strong, nonatomic) NSArray *horizontalDTIVConstraints;
@property (strong, nonatomic) NSArray *horizontalDNIVConstraints;
@property (strong, nonatomic) NSArray *verticalIVConstraints;
@property (strong, nonatomic) NSDictionary *metrics;

@property (strong, nonatomic) NSArray *horizontalIVConstraints;
@property (strong, nonatomic) NSArray *verticalDTIVConstraints;
@property (strong, nonatomic) NSArray *verticalDNIVConstraints;

#pragma mark - Other Properties
@property (nonatomic) BOOL takingPhoto;
@property (nonatomic) BOOL originalOrder;
@property (nonatomic) BOOL currentPosition;
@property (strong, nonatomic) THPictureAddition *pictureAddition;


- (void)removeAllConstraints;
- (void)generateStandardToolbarConstraints;

@end




//TODO: Present user with cropped photo taker - WEEK 2 - ZACH
//TODO: Crop resulting photo from camera at needed ratio of 2:1 - WEEK 2 - ZACH
//TODO: Crop THEN photo at needed ratio of 2:1 - WEEK 2
//TODO: Make images fit together! - STEVE/ZACH
//TODO: Remainder of animations/layoutconstraints for all views - WEEK 2 - STEVE
//TODO: Make "then" image preview larger in camera - WEEK 2 - STEVE
//TODO: Manage text overlay - WEEK 2 - HEIDI
//TODO: PRESENTATION - ZACH
//TODO: Integrate sticker example (with dragging?) - WEEK 2/3 - HEIDI


//TODO: Other features - timehop watermark color toggle, banner placement, full length banner - WEEK 2
//TODO: Figure out flash and zoom in camera... - WEEK 3
//TODO: Manage horizontal photo taking (is there anything to manage even?!) - WEEK 3 - YES THERE IS. DON'T ROTATE CAMERA VIEW.
//TODO: Integrate into TimeHop - WEEK 3
//TODO: Mixpanel analytics - WEEK 3
//TODO: Save new photo / metadata to TimeHop api and/or coredata - WEEK 3
//TODO: Make layout constraint "metrics" dictionary extensible for different size phones - WEEK 3
//TODO: Combine all images into a single image for saving - WEEK 3
//TODO: Clean up code, further - WEEK 3
//TODO: Image mirroring for front camera?


//DONE: Update THViewController with standard ImageViews - WEEK 2
//DONE: Get photos to show on screen... - WEEK 2
