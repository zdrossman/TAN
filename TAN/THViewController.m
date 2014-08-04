//
//  THViewController.m
//  TAN
//
//  Created by Zachary Drossman on 7/31/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THViewController.h"
#import "THDraggableView.h"
#import "THCamera2ViewController.h"
#import "THDraggableImageView.h"
//#import "UIImage+Resize.h"

@interface THViewController ()

@property (strong, nonatomic) UIImage *thenImage;
@property (strong, nonatomic) UIImage *nowImage;
@property (nonatomic) BOOL takingPhoto;
@property (strong, nonatomic) IBOutlet THDraggableImageView *draggableThenImageView;
@property (strong, nonatomic) IBOutlet THDraggableImageView *draggableNowImageView;
@property (nonatomic) CGRect originalThenImageFrame;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) IBOutlet UIView *cameraContainerView;
@property (strong, nonatomic) THCamera2ViewController *cameraVC;
@end

@implementation THViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.cameraContainerView.backgroundColor = [UIColor clearColor];
    self.takingPhoto = NO;
    [self setupInitialState];
    
    
    self.cameraContainerView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupInitialState];
}

- (void)goBackToBeginning
{
    self.takingPhoto = !self.takingPhoto;

    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    
    self.navigationItem.rightBarButtonItem = cameraButton;
    self.navigationItem.leftBarButtonItem = doneButton;
    [self toggleCamera];
    
    CGRect initialFrame = CGRectMake(0,64,self.view.frame.size.width,(self.view.frame.size.height - 64)/2);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.draggableThenImageView.frame = initialFrame;
    }];

}
- (IBAction)cameraTapped:(id)sender {
    
    self.takingPhoto = !self.takingPhoto;
    if (self.takingPhoto)
    {
        UIBarButtonItem *cancelButton;
        
        self.draggableNowImageView.hidden = YES;

        if (!self.draggableNowImageView.image)
        {
        cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBackToBeginning)];
        }
        else
        {
        cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cameraTapped:)];
        }
        
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.rightBarButtonItem = nil;

        self.cameraContainerView.hidden = !self.cameraContainerView.hidden;
        
//        [UIView animateWithDuration:0.5 animations:^{
//        
//        self.draggableThenImageView.frame = CGRectMake(25,380,100,100);
//            //self.draggableThenImageView.contentMode = UIViewContentModeScaleAspectFit;
//        }];

    }
    else
    {

        self.draggableNowImageView.hidden = NO;

        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
        
        self.navigationItem.rightBarButtonItem = cameraButton;
        self.navigationItem.leftBarButtonItem = doneButton;
        [self toggleCamera];
        
        CGRect initialFrame = CGRectMake(0,self.view.frame.origin.y + (self.view.frame.size.height/2) + 64, self.view.frame.size.width, (self.view.frame.size.height - 64)/2);

        [UIView animateWithDuration:0.4 animations:^{
            
        self.draggableThenImageView.image = [self.draggableThenImageView applyOverlayToImage:self.thenImage withPostion:CGPointMake(0,0) withTextSize:60.0 withText:@"Then"];
        self.draggableThenImageView.frame = initialFrame;
        }];
    }
    
}

-(void)toggleCamera
{
    self.cameraContainerView.hidden = !self.cameraContainerView.hidden;
    //self.draggableNowImageView.hidden = !self.draggableNowImageView.hidden;
}

- (void)setupInitialState
{
    if (!self.nowImage)
    {
        self.thenImage = [UIImage imageNamed:@"blue.jpg"];
        self.nowImage = [UIImage imageNamed:@"blossom.jpg"];
    }
    
    self.draggableThenImageView.image = self.thenImage;
//    self.draggableNowImageView.image = self.nowImage;
    
    
    self.draggableThenImageView.frame = CGRectMake(0,self.view.frame.origin.y + 64, self.view.frame.size.width, (self.view.frame.size.height - 64)/2);
    
    self.draggableThenImageView.clipsToBounds = YES;
    
    
    self.draggableNowImageView.name = @"camera";
    self.draggableThenImageView.name = @"flower";
    
    self.draggableNowImageView.snapToFrame = AVMakeRectWithAspectRatioInsideRect(self.thenImage.size, self.draggableThenImageView.frame);
    
    self.draggableThenImageView.snapToFrame = AVMakeRectWithAspectRatioInsideRect(self.thenImage.size, self.draggableNowImageView.frame);
    
    self.draggableThenImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.draggableNowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)editTapped:(id)sender {
//    
//    if (self.imageView.image == self.thenImage)
//    {
//    self.imageView.image = [self imageByCombiningImage:self.thenImage withImage:self.nowImage ];
//    }
//    else
//    {
//        self.imageView.image = self.thenImage;
//    }
//}


#pragma mark - Core Graphics methods
- (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    UIImage *image = nil;
    
    CGSize newImageSize = CGSizeMake(firstImage.size.width + secondImage.size.width, MAX(firstImage.size.height, secondImage.size.height));
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(newImageSize);
        
    }
    [firstImage drawAtPoint:CGPointMake(0, 0)];
    
    [secondImage drawAtPoint:CGPointMake(firstImage.size.width,0 )];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    NSLog(@"New Image Size : (%f, %f)", image.size.width, image.size.height);
    
    UIGraphicsEndImageContext();
    
    
    return image;
}

//- (void) dealloc
//{
//    // If you don't remove yourself as an observer, the Notification Center
//    // will continue to try and send notification objects to the deallocated
//    // object.
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

-(void)didTakePhoto:(UIImage *)image
{
    self.draggableNowImageView.image = image;
    [self cameraTapped:nil];
    self.draggableNowImageView.hidden = NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cameraSegue"])
    {
        self.cameraVC = segue.destinationViewController;
        self.cameraVC.delegate = self;
    }
}

@end
