//
//  THViewController.m
//  playingWithPhotos
//
//  Created by Zachary Drossman on 7/30/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THCamera2ViewController.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface THCamera2ViewController ()

@end

@implementation THCamera2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.frontCamera = YES;
    //cameraSwitch.selectedSegmentIndex = 0;
    self.nowImageView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self initializeCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) capImage { //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
   // NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}

//AVCaptureSession to show live video feed in view
- (void) initializeCamera {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
    
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	captureVideoPreviewLayer.frame = self.view.bounds;
    captureVideoPreviewLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.view.backgroundColor = [UIColor clearColor];
	[self.imageFeed.layer addSublayer:captureVideoPreviewLayer];

    UIView *view = [self imageFeed];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
      //  NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
               // NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
                //NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!self.frontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
            //NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (self.frontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
            //NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:self.stillImageOutput];
    
	[session startRunning];
}

- (void) processImage:(UIImage *)image { //process captured image, crop, resize and rotate
    
    self.haveCapturedImage = YES;
    
    UIGraphicsBeginImageContext(CGSizeMake(768, 1022));
    [image drawInRect: CGRectMake(0, 0, 768, 1022)];
    //NSLog(@"Bounds Height:%f Bounds Width:%f",self.view.bounds.size.height, self.view.bounds.size.width);
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect cropRect = CGRectMake(0, 130, 768, 768);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    
    //self.nowImageView.image = croppedImage;
    
    [self.delegate didTakePhoto:croppedImage];
    
    CGImageRelease(imageRef);
    
    //adjust image orientation based on device orientation
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
       // NSLog(@"landscape left image");
        [self adjustImageOrientationByDegrees:-90];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
      //  NSLog(@"landscape right");
        
        [self adjustImageOrientationByDegrees:90];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
      //  NSLog(@"upside down");
        
        [self adjustImageOrientationByDegrees:-180];
    }
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
      //  NSLog(@"upside upright");
        
        [self adjustImageOrientationByDegrees:0];
    }
    
}

- (void)adjustImageOrientationByDegrees:(NSInteger)integer
{
    //[UIView beginAnimations:@"rotate" context:nil];
    //[UIView setAnimationDuration:0.5];
    //self.imageFeed.transform = CGAffineTransformMakeRotation(DegreesToRadians(integer));
    //[UIView commitAnimations];
}

- (IBAction)toggleBetweenCameras:(id)sender { //switch cameras front and rear cameras
    if (self.frontBackToggle.selectedSegmentIndex == 0) {
        self.frontCamera = YES;
        [self initializeCamera];
    }
    else {
        self.frontCamera = NO;
        [self initializeCamera];
    }
}

- (IBAction)snapImage:(id)sender {
    if (!self.haveCapturedImage) {
        self.nowImageView.image = nil; //remove old image from view
        self.nowImageView.hidden = NO; //show the captured image view
        self.imageFeed.hidden = YES; //hide the live video feed
        self.flashButton.hidden = YES;
        self.frontBackToggle.hidden = YES;
        [self capImage];
    }
    else {
        self.nowImageView.hidden = YES;
        self.imageFeed.hidden = NO;
        self.haveCapturedImage = NO;
        self.flashButton.hidden = NO;
        self.frontBackToggle.hidden = NO;
    }
}


@end
