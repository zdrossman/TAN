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

@interface THViewController : UIViewController <THCameraDelegateProtocol>

@property (strong, nonatomic) UIImageView *thenImageView;
@property (strong, nonatomic) UIImageView *nowImageView;

@end




//TODO: Present user with cropped photo taker - WEEK 2
//TODO: Crop resulting photo from camera at needed ratio of 2:1 - WEEK 2
//TODO: Crop THEN photo at needed ratio of 2:1 - WEEK 2
//TODO: Remainder of animations/layoutconstraints for all views - WEEK 2
//TODO: Make "then" image preview larger in camera - WEEK 2
//TODO: Manage text overlay - WEEK 2
//TODO: Get photos to show on screen... - WEEK 2
//TODO: PRESENTATION

//TODO: Integrate sticker example (with dragging?) - WEEK 2/3
//TODO: Other features - timehop watermark color toggle, banner placement, full length banner - WEEK 2


//TODO: Figure out flash and zoom in camera... - WEEK 3
//TODO: Manage horizontal photo taking (is there anything to manage even?!) - WEEK 3 - YES THERE IS. DON'T ROTATE CAMERA VIEW.
//TODO: Integrate into TimeHop - WEEK 3
//TODO: Mixpanel analytics - WEEK 3
//TODO: Save new photo / metadata to TimeHop api and/or coredata - WEEK 3
//TODO: Make layout constraint "metrics" dictionary extensible for different size phones - WEEK 3
//TODO: Combine all images into a single image for saving - WEEK 3
//TODO: Clean up code, further - WEEK 3

//DONE: Update THViewController with standard ImageViews - WEEK 2