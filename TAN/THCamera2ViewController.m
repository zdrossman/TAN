
//  THViewController.m
//  playingWithPhotos
//
//  Created by Zachary Drossman on 7/30/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THCamera2ViewController.h"
#import "THCameraButton.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface THCamera2ViewController ()

@property (strong, nonatomic) UIView *videoPreview;
//@property (nonatomic) CGFloat videoPreviewWidth;
@property (nonatomic) CGFloat excessSpacePerSide;
@end

@implementation THCamera2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.videoPreviewWidth = (self.view.bounds.size.height - 64) / 2;
    self.excessSpacePerSide = 60;
    
    UIView *leftCropView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.excessSpacePerSide, 500)];
    UIView *rightCropView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.excessSpacePerSide, 64, self.excessSpacePerSide, 500)];
    
    leftCropView.backgroundColor = [UIColor blackColor];
    leftCropView.alpha = 0.7;
    
    rightCropView.backgroundColor = [UIColor blackColor];
    rightCropView.alpha = 0.7;
    
    self.videoPreview = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,568)];
    [self.view addSubview:self.videoPreview];
    NSLog(@"Self.view frame: %f %f %f %f ", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"self bounds: %f %f %f %f ", self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.videoPreview.backgroundColor = [UIColor blackColor];
    self.videoPreview.clipsToBounds = YES;
	// Do any additional setup after loading the view, typically from a nib.
    self.frontCamera = YES;
    //cameraSwitch.selectedSegmentIndex = 0;
        [self.view addSubview:leftCropView];
    [self.view addSubview:rightCropView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.takePhotoButton = [[THCameraButton alloc] initWithFrame:CGRectMake(125,485,70,70)];
    [self.takePhotoButton addTarget:self action:@selector(takePhotoTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.takePhotoButton];

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
	captureVideoPreviewLayer.bounds = self.videoPreview.bounds;
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    
    captureVideoPreviewLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.view.backgroundColor = [UIColor clearColor];
	[self.videoPreview.layer addSublayer:captureVideoPreviewLayer];
    [self.videoPreview bringSubviewToFront:self.takePhotoButton];
    CALayer *viewLayer = [self.view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [self.view bounds];
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
    
    UIGraphicsBeginImageContext(CGSizeMake(320, 400));
    [image drawInRect: CGRectMake(0, 0, 320, 400)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect cropRect = CGRectMake(60,0,200,400);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    self.stillImageOutput = nil;
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
    
    [self.delegate takePhotoTapped:croppedImage];

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

- (void)takePhotoTapped:(id)sender {
    
//    if (!self.haveCapturedImage) {
//        self.imageFeed.hidden = YES; //hide the live video feed
//        self.flashButton.hidden = YES;
//        self.frontBackToggle.hidden = YES;
        [self capImage];
//    }
//    else {
//        self.imageFeed.hidden = NO;
//        self.haveCapturedImage = NO;
//        self.flashButton.hidden = NO;
//        self.frontBackToggle.hidden = NO;
//    }
}


@end
