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

typedef void(^ButtonReplacementBlock)(void);

@interface THViewController ()

@property (strong, nonatomic) UIImage *thenImage;
@property (strong, nonatomic) UIImage *nowImage;
@property (nonatomic) BOOL takingPhoto;
@property (strong, nonatomic) THDraggableImageView *draggableThenImageView;
@property (strong, nonatomic) THDraggableImageView *draggableNowImageView;
@property (nonatomic) CGRect originalThenImageFrame;
@property (strong, nonatomic) UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIView *cameraContainerView;
@property (strong, nonatomic) THCamera2ViewController *cameraVC;
@property (strong, nonatomic) NSDictionary *viewsDictionary;
@property (strong, nonatomic) UIToolbar *toolbar;

@property (strong, nonatomic) NSArray *horizontalToolbarConstraints;
@property (strong, nonatomic) NSArray *verticalToolbarConstraints;
@end

@implementation THViewController



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.takingPhoto = NO;
    [self baseInit];
    [self setupPhotoAutoLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupInitialStateOfImageViews];
}

- (void)baseInit
{
    self.draggableThenImageView = [[THDraggableImageView alloc] init];
    self.draggableNowImageView = [[THDraggableImageView alloc] init];
    self.cameraVC = [[THCamera2ViewController alloc] init];
    self.toolbar = [[UIToolbar alloc] init];
    self.cameraContainerView = [[UIView alloc] init];
    
    
    [self.view addSubview:self.draggableThenImageView];
    [self.view addSubview:self.draggableNowImageView];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.cameraContainerView];

    
    [self addChildViewController:self.cameraVC];
    [self.cameraContainerView addSubview:self.cameraVC.view];
    self.cameraContainerView.frame = self.view.bounds;
    self.cameraVC.view.frame = self.cameraContainerView.bounds;
    self.cameraContainerView.backgroundColor = [UIColor blueColor];
    self.cameraVC.view.backgroundColor = [UIColor orangeColor];
    UIBarButtonItem *alignmentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1074-grid-2"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *textOverlay = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1174-choose-font-toolbar"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    [self.toolbar setItems:@[alignmentButton,textOverlay]];
    
    self.draggableNowImageView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.draggableThenImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    self.cameraContainerView.backgroundColor = [UIColor greenColor];
    self.cameraVC.view.backgroundColor = [UIColor orangeColor];
    
    
}

-(void)setupPhotoAutoLayout
{
    self.cameraContainerView.hidden = YES;
    self.draggableNowImageView.hidden = NO;
    self.toolbar.alpha = 1;
    self.toolbar.hidden = NO;
    
    self.draggableNowImageView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.draggableThenImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    self.cameraContainerView.backgroundColor = [UIColor greenColor];
    self.cameraVC.view.backgroundColor = [UIColor orangeColor];
    
    [self removeAllConstraints];
    
    NSArray *verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide][_draggableThenImageView][_draggableNowImageView(==_draggableThenImageView)]" options:0 metrics:nil views:self.viewsDictionary];
    
    NSArray *horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_draggableThenImageView]|" options:0 metrics:nil views:self.viewsDictionary];
    
    NSArray *horizontalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_draggableNowImageView]|" options:0 metrics:nil views:self.viewsDictionary];
    
    self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==44)]|" options:0 metrics:nil views:self.viewsDictionary];
    
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
    
    [self.view addConstraints:verticalIVConstraints];
    [self.view addConstraints:horizontalDNIVConstraints];
    [self.view addConstraints:horizontalDTIVConstraints];
    [self.view addConstraints:self.horizontalToolbarConstraints];
    [self.view addConstraints:self.verticalToolbarConstraints];
    
    [self.view layoutIfNeeded];
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStylePlain target:self action:@selector(slideToolbarDownWithCompletionBlock:)];
    
    UIBarButtonItem *testButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Test2" style:UIBarButtonItemStylePlain target:self action:@selector(replaceToolbarWithButtons:)];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)],testButton2];;

}

- (void)removeAllConstraints;
{
    [self.view removeConstraints:self.view.constraints];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;

    [self.cameraContainerView removeConstraints:self.cameraContainerView.constraints];
    self.cameraContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.draggableThenImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.draggableThenImageView removeConstraints:self.draggableThenImageView.constraints];
    
    self.draggableNowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.draggableNowImageView removeConstraints:self.draggableNowImageView.constraints];

    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolbar removeConstraints:self.toolbar.constraints];
}

- (void)setupCameraAutolayout
{
    
    self.draggableNowImageView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.draggableThenImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    self.cameraContainerView.backgroundColor = [UIColor greenColor];
    self.cameraVC.view.backgroundColor = [UIColor orangeColor];
    self.cameraContainerView.hidden = NO;

    [self removeAllConstraints];

    __block NSArray *horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
    __block NSArray *verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(64)-[_cameraView(==0)]" options:0 metrics:nil views:self.viewsDictionary];
    
    __block NSArray *horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
    __block NSArray *verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==44)]|" options:0 metrics:nil views:self.viewsDictionary];
    
    [self.view addConstraints:horizontalCameraConstraints];
    [self.view addConstraints:verticalCameraConstraints];
    [self.view addConstraints:verticalToolbarConstraints];
    [self.view addConstraints:horizontalToolbarConstraints];
    
    [self.view layoutIfNeeded];
    
    self.draggableThenImageView.hidden = YES;
    self.draggableThenImageView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self removeAllConstraints];
        
        horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
        
        verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(64)-[_cameraView(==460)]" options:0 metrics:nil views:self.viewsDictionary];

        verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==44)]|" options:0 metrics:nil views:self.viewsDictionary];
        
        horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
        
        [self.view addConstraints:verticalToolbarConstraints];
        [self.view addConstraints:horizontalCameraConstraints];
        [self.view addConstraints:verticalCameraConstraints];
        [self.view addConstraints:horizontalToolbarConstraints];
        
        [self.view layoutIfNeeded];
        
        //TODO: Add constraints for moving THENphoto to "preview"
        [self.view bringSubviewToFront:self.draggableThenImageView];
        self.draggableThenImageView.alpha = 0.5;
        self.draggableThenImageView.hidden = NO;
        
    } completion:^(BOOL finished) {
        self.draggableNowImageView.hidden = YES;
    }];
   
    [UIView animateWithDuration:0.45 animations:^{
        
        //TODO: Finish animation of camera downward / toolbar downward.
        [self removeAllConstraints];
    
        horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
        
       verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(44)-[_cameraView(==460)][_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
        
        horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
        
        verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(44)-[_cameraView(==460)]|" options:0 metrics:nil views:self.viewsDictionary];
        
        [self.view addConstraints:horizontalCameraConstraints];
        [self.view addConstraints:verticalCameraConstraints];
        [self.view addConstraints:horizontalToolbarConstraints];
        [self.view addConstraints:verticalToolbarConstraints];
        
        [self.view layoutIfNeeded];

    }completion:^(BOOL finished) {
        self.draggableNowImageView.hidden = YES;
    }];

    
    
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setupPhotoAutoLayout)];
    

}

- (void)setupInitialStateOfImageViews
{
    if (!self.nowImage)
    {
        self.thenImage = [UIImage imageNamed:@"funnyBabyPNG"];
        self.nowImage = [UIImage imageNamed:@"blossom.jpg"];
    }
    
    self.draggableThenImageView.image = self.thenImage;
    //    self.draggableNowImageView.image = self.nowImage;
    
//    self.draggableThenImageView.frame = CGRectMake(0,self.view.frame.origin.y + 64, self.view.frame.size.width, (self.view.frame.size.height - 64)/2);
    
    self.draggableThenImageView.clipsToBounds = YES;
    
    self.draggableNowImageView.name = @"camera";
    self.draggableThenImageView.name = @"flower";
    
    self.draggableNowImageView.snapToFrame = AVMakeRectWithAspectRatioInsideRect(self.thenImage.size, self.draggableThenImageView.frame);
    
    self.draggableThenImageView.snapToFrame = AVMakeRectWithAspectRatioInsideRect(self.thenImage.size, self.draggableNowImageView.frame);
    
    self.draggableThenImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.draggableNowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
}


- (void)replaceToolbarWithButtons:(ButtonReplacementBlock)buttonReplacementBlock
{
    
    [self slideToolbarDownWithCompletionBlock:^{
        [self slideToolbarUpWithCompletionBlock:nil];
         
         }];
}

-(void)slideToolbarDownWithCompletionBlock:(void (^)(void))completionBlock;
{
//    [self.view removeConstraints:self.horizontalToolbarConstraints];
//    [self.view removeConstraints:self.verticalToolbarConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view removeConstraints:self.horizontalToolbarConstraints];
        [self.view removeConstraints:self.verticalToolbarConstraints];
        [self.toolbar setItems:nil animated:YES];
        self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
        
        self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.viewsDictionary];
        
        [self.view addConstraints:self.horizontalToolbarConstraints];
        [self.view addConstraints:self.verticalToolbarConstraints];
        [self.view layoutIfNeeded];

    } completion:^(BOOL finished) {
        completionBlock();
    }];
}

-(void)slideToolbarUpWithCompletionBlock:(void (^)(void))completionBlock;
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view removeConstraints:self.horizontalToolbarConstraints];
        [self.view removeConstraints:self.verticalToolbarConstraints];
        
        self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
        
        self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==44)]|" options:0 metrics:nil views:self.viewsDictionary];
        
        [self.view addConstraints:self.horizontalToolbarConstraints];
        [self.view addConstraints:self.verticalToolbarConstraints];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        completionBlock();
    }];
}

-(NSDictionary *)viewsDictionary
{
    if (!_viewsDictionary)
    {
        id _cameraView = self.cameraContainerView;
        id _topLayoutGuide = self.topLayoutGuide;
        _viewsDictionary = NSDictionaryOfVariableBindings(_draggableThenImageView, _draggableNowImageView, _toolbar, _topLayoutGuide, _cameraView);
        //_viewsDictionary = NSDictionaryOfVariableBindings( _topLayoutGuide, _cameraView);

    }
    
    return _viewsDictionary;
}



- (void)goBackToBeginning
{
    self.takingPhoto = !self.takingPhoto;

    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    
    self.navigationItem.rightBarButtonItem = cameraButton;
    self.navigationItem.leftBarButtonItem = doneButton;
    [self toggleCamera];
    
    //CGRect initialFrame = CGRectMake(0,64,self.view.frame.size.width,(self.view.frame.size.height - 64)/2);
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.draggableThenImageView.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        if (finished)
        {
            
            
            self.draggableThenImageView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.draggableThenImageView.transform = CGAffineTransformScale(self.draggableThenImageView.transform, 1,1);
            
            [UIView animateWithDuration:0.2 animations:^{
                self.draggableThenImageView.alpha = 1;
                
                
            }];
        }
    }];

}
- (void)cameraTapped:(id)sender {
    
    [self setupCameraAutolayout];
    
//    self.takingPhoto = YES;
//    if (self.takingPhoto)
//    {
//        UIBarButtonItem *cancelButton;
//        
//        if (!self.draggableNowImageView.image)
//        {
//        cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBackToBeginning)];
//        }
//        else
//        {
//        cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cameraTapped:)];
//        }
//        
//        self.navigationItem.leftBarButtonItem = cancelButton;
//        self.navigationItem.rightBarButtonItem = nil;
//        
//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            self.draggableThenImageView.alpha = 0;
//            
//            
//        } completion:^(BOOL finished) {
//            if (finished)
//            {
//                
//                
//                self.draggableThenImageView.transform = CGAffineTransformMakeTranslation(50, 800);
//                self.draggableThenImageView.transform = CGAffineTransformScale(self.draggableThenImageView.transform, 0.3,0.3);
//                self.draggableThenImageView.layer.shadowOffset = CGSizeMake(7,7);
//                self.draggableThenImageView.layer.shadowRadius = 5;
//                self.draggableThenImageView.layer.shadowOpacity = 0.5;
//                
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.draggableThenImageView.alpha = .5;
//                    
//                    
//                }];
//            }
//        }];
//
//    }
//    else
//    {
//
//        self.draggableNowImageView.hidden = NO;
//
//        UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)];
//        
//        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
//        
//        self.navigationItem.rightBarButtonItem = cameraButton;
//        self.navigationItem.leftBarButtonItem = doneButton;
//        [self toggleCamera];
//        
//        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            self.draggableThenImageView.alpha = 0;
//            
//        } completion:^(BOOL finished) {
//            if (finished)
//            {
//                
//                
//                self.draggableThenImageView.transform = CGAffineTransformMakeTranslation(0, 504);
//                self.draggableThenImageView.transform = CGAffineTransformScale(self.draggableThenImageView.transform, 1,1);
//                
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.draggableThenImageView.alpha = 1;
//                    
//                    
//                }];
//            }
//        }];
//
//
//    }
    
}

-(void)toggleCamera
{
    //self.cameraContainerView.hidden = !self.cameraContainerView.hidden;
    //self.draggableNowImageView.hidden = !self.draggableNowImageView.hidden;
}


-(void)didTakePhoto:(UIImage *)image
{
    self.draggableNowImageView.image = image;
    [self returnToPhotoView];
}

- (void)returnToPhotoView
{
    if (YES) //replace with bool property pictureTaken
    {
        self.draggableNowImageView.hidden = NO;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.draggableThenImageView.alpha = 0;
            
            self.draggableNowImageView.image = [self.draggableNowImageView applyOverlayToImage:self.draggableNowImageView.image withPostion:CGPointMake(0,0) withTextSize:200.0 withText:@"Now"];
            
            
        } completion:^(BOOL finished) {
            if (finished)
            {
                
                
                self.draggableThenImageView.transform = CGAffineTransformMakeTranslation(0, 504);
                self.draggableThenImageView.transform = CGAffineTransformScale(self.draggableThenImageView.transform, 1,1);
                
                self.draggableThenImageView.image = [self.draggableThenImageView applyOverlayToImage:self.thenImage withPostion:CGPointMake(0,0) withTextSize:60.0 withText:@"Then"];
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.draggableThenImageView.alpha = 1;
                    
                    
                }];
            }
        }];
        
    }
    else
    {
        
    }
    
    
}



#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"cameraSegue"])
    {
        self.cameraVC = segue.destinationViewController;
        //self.cameraVC.photoCropRect = AVMakeRectWithAspectRatioInsideRect(self.draggableThenImageView.image.size, self.draggableThenImageView.frame);
       // NSLog(@"%f %f %f %f",self.cameraVC.photoCropRect.origin.x, self.cameraVC.photoCropRect.origin.y, self.cameraVC.photoCropRect.size.width, self.cameraVC.photoCropRect.size.height);
        self.cameraVC.delegate = self;
    }
}

#pragma mark - CoreGraphics
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
