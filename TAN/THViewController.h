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
@property (strong, nonatomic) UIView *cameraContainerView;
@property (strong, nonatomic) UIView *thenContainerView;
@property (strong, nonatomic) UIView *nowContainerView;

@property (strong, nonatomic) UIScrollView *nowScrollView;
@property (strong, nonatomic) UIScrollView *thenScrollView;
@property (strong, nonatomic) THCamera2ViewController *cameraVC;

@property (strong, nonatomic) UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIImageView *thenImageView;
@property (strong, nonatomic) UIImageView *nowImageView;
@property (strong, nonatomic) UIView *contentViewForThenImage;
@property (strong, nonatomic) UIView *contentViewForNowImage;
@property (strong, nonatomic) UIView *contentViewForSecondaryToolbar;
@property (strong, nonatomic) UIImage *thenImage;
@property (strong, nonatomic) UIImage *nowImage;
@property (strong, nonatomic) UILabel *thenLabel;
@property (strong, nonatomic) UILabel *nowLabel;

@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) NSArray *baseToolbarItems;
@property (strong, nonatomic) NSArray *textToolbarItems;
@property (strong, nonatomic) NSArray *stickerToolbarItems;
@property (strong, nonatomic) NSArray *frameToolbarItems;
@property (strong, nonatomic) NSArray *layoutToolbarItems;

//@property (strong, nonatomic) NSMutableArray *typefaceFields;
@property (strong, nonatomic) NSMutableArray *dataFields;
@property (strong, nonatomic) UIView *topSpacer;
@property (strong, nonatomic) UIButton *editButton;
@property (strong, nonatomic) UIBarButtonItem *returnButton;
@property (strong, nonatomic) UIBarButtonItem *spacerBBI;

#pragma mark - LayoutConstraint Properties
@property (strong, nonatomic) NSDictionary *topBottomViewsDictionary;
@property (strong, nonatomic) NSDictionary *leftRightViewsDictionary;
@property (strong, nonatomic) NSDictionary *subviewsDictionary;
@property (strong, nonatomic) NSDictionary *labelsDictionary;

@property (strong, nonatomic) NSArray *horizontalToolbarConstraints;
@property (strong, nonatomic) NSArray *verticalToolbarConstraints;

@property (strong, nonatomic) NSArray *verticalCameraConstraints;
@property (strong, nonatomic) NSArray *horizontalCameraConstraints;

@property (strong, nonatomic) NSArray *verticalNowImageConstraints;
@property (strong, nonatomic) NSArray *verticalThenImageConstraints;
@property (strong, nonatomic) NSArray *horizontalNowImageConstraints;
@property (strong, nonatomic) NSArray *horizontalThenImageConstraints;

@property (strong, nonatomic) NSArray *verticalThenScrollViewConstraints;
@property (strong, nonatomic) NSArray *verticalNowScrollViewConstraints;
@property (strong, nonatomic) NSArray *horizontalThenScrollViewConstraints;
@property (strong, nonatomic) NSArray *horizontalNowScrollViewConstraints;

@property (strong, nonatomic) NSArray *horizontalICVConstraints;
@property (strong, nonatomic) NSArray *verticalThenContainerViewConstraints;
@property (strong, nonatomic) NSArray *verticalNowContainerViewConstraints;
@property (strong, nonatomic) NSArray *horizontalThenContainerViewConstraints;
@property (strong, nonatomic) NSArray *horizontalNowContainerViewConstraints;
@property (strong, nonatomic) NSArray *verticalICVConstraints;

@property (strong, nonatomic) NSArray *horizontalImageScrollViewContentSizeConstraints;
@property (strong, nonatomic) NSArray *verticalImageScrollViewContentSizeConstraints;

@property (strong, nonatomic) NSArray *horizontalToolbarScrollViewContentSizeConstraints;
@property (strong, nonatomic) NSArray *verticalToolbarScrollViewContentSizeConstraints;

@property (strong, nonatomic) NSArray *horizontalScrollViewConstraints;
@property (strong, nonatomic) NSArray *verticalScrollViewConstraints;
@property (strong, nonatomic) NSArray *thenLabelConstraints;
@property (strong, nonatomic) NSArray *nowLabelConstraints;

@property (strong, nonatomic) NSArray *verticalSecondaryToolbarConstraints;
@property (strong, nonatomic) NSArray *horizontalSecondaryToolbarConstraints;
@property (strong, nonatomic) UIScrollView *secondaryToolbar;

@property (strong, nonatomic) NSDictionary *metrics;

@property (strong, nonatomic) UIFont *labelsFont;
@property (strong, nonatomic) UIColor *chosenColor;
#pragma mark - Other Properties
@property (nonatomic) BOOL takingPhoto;
@property (nonatomic) BOOL editMode;
@property (nonatomic) BOOL horizontalSplit;
@property (nonatomic) BOOL thenOnLeftOrTop;

@property (strong, nonatomic) NSArray *typefaceButtonArray;
@property (strong, nonatomic) NSArray *fontColorButtonArray;
@property (strong, nonatomic) NSMutableArray *buttonColorArray;
//@property (nonatomic) THPictureAddition *pictureAddition;

- (void)cameraTapped:(id)sender;
- (void)setupCameraNavigationBar;
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
