//
//  THViewController.h
//  playingWithPhotos
//
//  Created by Zachary Drossman on 7/30/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol THCameraDelegateProtocol <NSObject>

-(void)didTakePhoto:(UIImage *)image;

@end

@interface THCamera2ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *flashButton;
@property (nonatomic, weak) id <THCameraDelegateProtocol> delegate;

@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *nowImageView;

@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (weak, nonatomic) IBOutlet UIView *imageFeed;

@property (weak, nonatomic) IBOutlet UISegmentedControl *frontBackToggle;

@property (strong, nonatomic) UIImage *photoToCapture;
@property (nonatomic) BOOL frontCamera;
@property (nonatomic) BOOL haveCapturedImage;

- (IBAction)toggleBetweenCameras:(id)sender;
- (IBAction)snapImage:(id)sender;

@end
