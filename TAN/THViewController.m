//
//  THViewController.m
//  TAN
//
//  Created by Zachary Drossman on 7/31/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THViewController.h"
#import "THDraggableImageView.h"
@interface THViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *thenImage;
@property (strong, nonatomic) UIImage *nowImage;
@property (strong, nonatomic) IBOutlet THDraggableImageView *draggableImageView;

@end

@implementation THViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.nowImage)
    {
        self.draggableImageView.image = self.nowImage;
    }
    else
    {
        self.draggableImageView.image = [UIImage imageNamed:@"blossom.jpg"];
    }
    
    self.draggableImageView.snapToFrame = self.imageView.frame;
    
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



@end
