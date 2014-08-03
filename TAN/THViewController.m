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

@interface THViewController ()

@property (strong, nonatomic) UIImage *thenImage;
@property (strong, nonatomic) UIImage *nowImage;
@property (strong, nonatomic) IBOutlet THDraggableView *draggableNowImageView;
@property (strong, nonatomic) IBOutlet THDraggableImageView *draggableThenImageView;
@property (nonatomic) CGRect originalThenImageFrame;
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupInitialState];
}

- (void)setupInitialState
{
    if (!self.nowImage)
    {
        self.thenImage = [UIImage imageNamed:@"blue.jpg"];
    }
    
    self.draggableThenImageView.image = self.thenImage;
    self.draggableNowImageView.name = @"camera";
    self.draggableThenImageView.name = @"flower";
    self.draggableNowImageView.snapToFrame = AVMakeRectWithAspectRatioInsideRect(self.thenImage.size, self.draggableThenImageView.frame);
    
    self.draggableThenImageView.snapToFrame = AVMakeRectWithAspectRatioInsideRect(self.thenImage.size, self.draggableNowImageView.frame);
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

@end
