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

@interface THViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *thenImage;
@property (strong, nonatomic) UIImage *nowImage;
@property (strong, nonatomic) IBOutlet THDraggableView *draggableImageView;
@end

@implementation THViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    [self setupInitialState];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.nowImage = [UIImage imageNamed:@"coffee.jpg"];
    
}

- (void)setupInitialState
{
    if (!self.nowImage)
    {
        self.thenImage = [UIImage imageNamed:@"blue.jpg"];
        self.nowImage = [UIImage imageNamed:@"blossom.jpg"];
    }
    
    self.imageView.image = self.thenImage;
    
    self.draggableImageView.snapToFrame = AVMakeRectWithAspectRatioInsideRect(self.thenImage.size, self.imageView.frame);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)name:@"didDragNowImageThroughMeridian"
                                               object:nil];
}

- (void) receiveNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"didDragNowImageThroughMeridian"])
        NSLog (@"Successfully received the test notification!");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editTapped:(id)sender {
    
    if (self.imageView.image == self.thenImage)
    {
    self.imageView.image = [self imageByCombiningImage:self.thenImage withImage:self.nowImage ];
    }
    else
    {
        self.imageView.image = self.thenImage;
    }
}


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

- (void) dealloc
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
