//
//  THViewController.h
//  playingWithPhotos
//
//  Created by Zachary Drossman on 7/30/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UICameraButton.h"

@protocol THCameraDelegateProtocol <NSObject>

-(void)didTakePhoto:(UIImage *)image;

@end

@interface THCamera2ViewController : UIViewController <THCameraButtonDelegate>

@property (strong, nonatomic) IBOutlet UIButton *flashButton;
@property (nonatomic, weak) id <THCameraDelegateProtocol> delegate;

@property (strong, nonatomic) IBOutlet UICameraButton *takePhotoButton;

@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (weak, nonatomic) IBOutlet UISegmentedControl *frontBackToggle;
@property (strong, nonatomic) UIImage *photoToCapture;
@property (nonatomic) BOOL frontCamera;
@property (nonatomic) BOOL haveCapturedImage;

@property (nonatomic) CGRect photoCropRect;
- (IBAction)toggleBetweenCameras:(id)sender;

@end
