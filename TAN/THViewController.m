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
#import "BASSquareCropperViewController.h"
#import "THPictureAddition.h"
//#import "THViewController+Autolayout.h"

//#import "UIImage+Resize.h"

typedef void(^ButtonReplacementBlock)(void);

@interface THViewController () <UINavigationControllerDelegate, THCameraDelegateProtocol, BASSquareCropperDelegate>

@end

@implementation THViewController

#pragma mark - Getters
-(NSArray *)toolbarButtonsArray
{
    UIBarButtonItem *horizontalSplitButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1074-grid-2"] style:UIBarButtonItemStylePlain target:self action:@selector(choosePosition)];
    
    UIBarButtonItem *verticalSplitButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1074-grid-2B rotated"] style:UIBarButtonItemStylePlain target:self action:nil];

    UIBarButtonItem *textOverlay = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1174-choose-font-toolbar"] style:UIBarButtonItemStylePlain target:self action:@selector(setTextOverlayToImages)];
    
    UIBarButtonItem *polaroidFrameButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"polaroidIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPolaroidIcon:)];
    
    _toolbarButtonsArray = @[horizontalSplitButton, verticalSplitButton, textOverlay, polaroidFrameButton];
    
    return _toolbarButtonsArray;
}

-(NSDictionary *)metrics{
 
    if (!_metrics)
    {
        _metrics = @{@"cameraViewTop":@64, @"cameraViewBottom":@0, @"toolbarHeight":@44, @"cameraViewBottomAnimated":@460};

    }
    
    return _metrics;
    
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.takingPhoto = NO;
    self.originalOrder = YES;
    self.currentPosition =YES;
    [self baseInit];
    [self setupPhotos];
    //[self setupInitialStateOfImageViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupInitialStateOfImageViews];
    
}

- (void)baseInit
{
    self.nowView = [[UIView alloc] init];
    self.thenView = [[UIView alloc] init];
    self.cameraContainerView = [[UIView alloc] init];
    
    self.thenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toolbar = [[UIToolbar alloc] init];
//    self.pictureAddition = [[THPictureAddition alloc] init];
    
    [self.view addSubview:self.nowView];
    [self.view addSubview:self.thenView];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.cameraContainerView];

//    self.nowImageView.frame = self.nowView.frame;
//    self.thenImageView.frame = self.thenView.frame;
    
    [self.nowView addSubview:self.nowButton];
    [self.thenView addSubview:self.thenButton];
    
    [self.toolbar setItems:self.toolbarButtonsArray];
}


#pragma mark - setup
-(void)setupCropper
{

//    self.cropperContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
//    self.cropperContainerView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:self.cropperContainerView];
//    self.cropperContainerView.hidden = NO;
    
    UIImage *image = [UIImage imageNamed:@"testImage"];
    BASSquareCropperViewController *cropperVC = [[BASSquareCropperViewController alloc] initWithImage:image minimumCroppedImageSideLength:20];
    
    cropperVC.squareCropperDelegate = self;

//        [self addChildViewController:self.cropperVC];
//    self.cropperVC.view.frame = self.cropperContainerView.bounds;

    //[self.cropperContainerView addSubview:self.cropperVC.view];
    
    [self presentViewController:cropperVC animated:YES completion:^{
    }];
}

- (void)setupCamera
{
    self.cameraVC = [[THCamera2ViewController alloc] init];
    
    [self addChildViewController:self.cameraVC];
    [self.cameraContainerView addSubview:self.cameraVC.view];
    self.cameraContainerView.frame = self.view.bounds;
    self.cameraVC.view.frame = self.cameraContainerView.bounds;
    self.cameraVC.delegate = self;
}

-(void)setupSubviewAutolayout
{
        //TODO: STEVE
}

- (UIButton *)nowButton
{
    if (self.nowImage)
    {
        [_nowButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_nowButton setImage:self.nowImage forState:UIControlStateNormal];
        [_nowButton addTarget:self
                           action:@selector(setupCropper)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nowButton;
}

-(void)setupPhotos
{

    self.cameraContainerView.hidden = YES;
    self.nowView.hidden = NO;
    self.toolbar.alpha = 1;
    self.toolbar.hidden = NO;
    self.currentPosition = YES;
    
    [self.view removeConstraints:self.view.constraints];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.cameraContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cameraContainerView removeConstraints:self.cameraContainerView.constraints];
    
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolbar removeConstraints:self.toolbar.constraints];
    
    self.cropperContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cropperContainerView removeConstraints:self.cropperContainerView.constraints];

    [self setVerticalSplit];
    [self removeSubviewConstraints];
    [self layoutThenView];
    [self layoutNowView];
    [self.view layoutIfNeeded];

    self.nowView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.thenView.layer.backgroundColor = [UIColor yellowColor].CGColor;

    //FIXIT: Should i keep this line? self.thenImageView.alpha =1.0;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *testButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Test2" style:UIBarButtonItemStylePlain target:self action:@selector(replaceToolbarWithButtons:)];
    
    UIBarButtonItem *testButton4 = [[UIBarButtonItem alloc] initWithTitle:@"Animate" style:UIBarButtonItemStylePlain target:self action:@selector(performAnimation)];

    UIBarButtonItem *testButton5 = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStylePlain target:self action:@selector(choosePosition)];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)],testButton2, testButton4,testButton5];
    
    [self setupCamera];

}


#pragma mark - Layout and Animations
-(void)performAnimation{
    
    if (self.currentPosition == YES) {
        
        [self leftAndRightSwitch];
    }else
    {
        [self topAndBottomSwitch];
    }
    
}

-(NSArray *)verticalCameraConstraints
{
    
    if (!_verticalCameraConstraints)
    {
        _verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView(==cameraViewBottom)]" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
    }
    
    return _verticalCameraConstraints;
}

-(NSArray *)horizontalCameraConstraints
{
    if (!_horizontalCameraConstraints)
    {
        _horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
    }
    
    return _horizontalCameraConstraints;
    
}

- (void)layoutCamera
{
    
//    self.nowImageView.layer.backgroundColor = [UIColor redColor].CGColor;
//    self.thenImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    self.cameraContainerView.hidden = NO;
    self.cameraContainerView.backgroundColor = [UIColor purpleColor];
    [self.view removeConstraints:self.verticalCameraConstraints];
    [self.view removeConstraints:self.horizontalCameraConstraints];

    [self.view addConstraints:self.horizontalCameraConstraints];
    [self.view addConstraints:self.verticalCameraConstraints];
    
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.view removeConstraints:self.horizontalCameraConstraints];
        [self.view removeConstraints:self.verticalCameraConstraints];
        
        self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
        
        self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView(==cameraViewBottomAnimated)]" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
        
        [self.view addConstraints:self.horizontalCameraConstraints];
        [self.view addConstraints:self.verticalCameraConstraints];
        
        
        [self.view layoutIfNeeded];
        
//        [self.view bringSubviewToFront:self.thenImageView];
//        self.thenImageView.alpha = 0.5;
//        self.thenImageView.hidden = NO;
        

        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self.view removeConstraints:self.horizontalCameraConstraints];
            [self.view removeConstraints:self.verticalCameraConstraints];
            [self.view removeConstraints:self.horizontalToolbarConstraints];
            [self.view removeConstraints:self.verticalToolbarConstraints];
            
            [self.toolbar setItems:nil animated:YES];
            self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
            
            self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView(==524)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
            
            self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
            
            self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
            
            [self.view addConstraints:self.horizontalCameraConstraints];
            [self.view addConstraints:self.verticalCameraConstraints];
            [self.view addConstraints:self.horizontalToolbarConstraints];
            [self.view addConstraints:self.verticalToolbarConstraints];
            
            [self.view layoutIfNeeded];
            
            }completion:^(BOOL finished) {
                self.nowView.hidden = YES;
                
                //TODO: Add constraints for moving THENphoto to "preview"
                //TODO: Change layout constraints and size of image to fit small image space. set alpha of then image view to 0.
                //TODO: self.view bringSubviewToFront:thenImageView
                
                if (self.horizontalThenViewConstraints)
                {
                    [self.view removeConstraints:self.horizontalThenViewConstraints];
                }
                
                if (self.horizontalICVConstraints)
                {
                    [self.view removeConstraints:self.horizontalICVConstraints];
                }
                
                if (self.verticalICVConstraints)
                {
                    [self.view removeConstraints:self.verticalICVConstraints];
                }
                
                if (self.verticalThenViewConstraints)
                {
                    [self.view removeConstraints:self.verticalThenViewConstraints];
                }
                
                self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(25)-[_leftImageView]" options:0 metrics:nil views:self.leftRightViewsDictionary];
                
                self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(400)-[_leftImageView]" options:0 metrics:nil views:self.leftRightViewsDictionary];
                [self.view addConstraints:self.horizontalThenViewConstraints];
                [self.view addConstraints:self.verticalICVConstraints];
                
                [self.view layoutIfNeeded];
         
                [self.view bringSubviewToFront:self.thenView];
                self.thenView.alpha = 0;
                self.thenView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                self.thenView.hidden = NO;

                [self.view removeConstraints:self.horizontalToolbarConstraints];
                [self.view removeConstraints:self.verticalToolbarConstraints];

                [self slideToolbarUpWithCompletionBlock:nil];
                
            [UIView animateWithDuration:1 animations:^{
                self.thenView.alpha = 1;
            }];
            
                

            }];
    
    self.navigationItem.rightBarButtonItem = nil;
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setupPhotoAutoLayout)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(returnToPhotosFromCamera)];
    
    }];
}

-(void)returnToPhotosFromCamera
{
    [self resignCamera];
    
    //[self setupPhotos];
}

-(void)resignCamera{
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.thenView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.cameraContainerView];
        self.thenView.alpha = 1;
        self.thenView.transform = CGAffineTransformMakeScale(1, 1);
        self.nowView.hidden = NO;
        if (self.horizontalICVConstraints)
        {
        [self.view removeConstraints:self.horizontalICVConstraints];
        }
        
        if (self.horizontalNowViewConstraints)
        {
        [self.view removeConstraints:self.horizontalNowViewConstraints];
        }
        
        if (self.horizontalThenViewConstraints)
        {
            [self.view removeConstraints:self.horizontalThenViewConstraints];
        }
        
        if (self.verticalICVConstraints)
        {
        [self.view removeConstraints:self.verticalICVConstraints];
        }
        
        if (self.verticalNowViewConstraints)
        {
        [self.view removeConstraints:self.verticalNowViewConstraints];
        }
        
        if (self.verticalThenImageConstraints)
        {
        [self.view removeConstraints:self.verticalThenViewConstraints];
        }
        
        [self setVerticalSplit];
        [self removeSubviewConstraints];
        [self layoutThenView];
        [self layoutNowView];
        
        self.thenView.backgroundColor = [UIColor yellowColor];
        
        self.nowView.hidden = NO;
        [self.view layoutIfNeeded];

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self layoutToolbar];

        } completion:^(BOOL finished) {

            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [self layoutToolbar];
                
                    [self.view removeConstraints:self.horizontalCameraConstraints];
                    [self.view removeConstraints:self.verticalCameraConstraints];
                    
                    
                    self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
                    
                    self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView(==0)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
                    
                    [self.view addConstraints:self.horizontalCameraConstraints];
                    [self.view addConstraints:self.verticalCameraConstraints];
                    
                    [self.view layoutIfNeeded];
            } completion:nil];
            
            }];
        
        
    }];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setupPhotos)];
    
}


- (void)setupInitialStateOfImageViews
{
    if (!self.nowImage)
    {
        self.thenImage = [UIImage imageNamed:@"blossom.jpg"];
        //self.nowImage = [UIImage imageNamed:@"blossom.jpg"];
    }
    //    self.nowImageView.image = self.nowImage;
    
//    self.thenImageView.frame = CGRectMake(0,self.view.frame.origin.y + 64, self.view.frame.size.width, (self.view.frame.size.height - 64)/2);
    
    [self.thenButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.thenButton.clipsToBounds = YES;
    
//    self.thenImageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.nowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.thenButton setImage:self.thenImage forState:UIControlStateNormal];
    [self.thenButton addTarget:self action:@selector(setupCropper) forControlEvents:UIControlEventTouchUpInside];
}


- (void)replaceToolbarWithButtons:(ButtonReplacementBlock)buttonReplacementBlock
{
    [self animateToolbarOfHeightZeroAtBottomOfScreen:^{
        [self.toolbar setItems:self.toolbarButtonsArray animated:NO];
        [self slideToolbarUpWithCompletionBlock:^{
            NSLog(@"Completed toolbar button update.");
        }];
    }];
}

- (void)animateToolbarOfHeightZeroAtBottomOfScreen:(void (^)(void))completionBlock;
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self toolbarOfHeightZeroAtBottomOfScreen];
        [self.view layoutIfNeeded];

    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

- (void)toolbarOfHeightZeroAtBottomOfScreen

{
    [self.view removeConstraints:self.horizontalToolbarConstraints];
    [self.view removeConstraints:self.verticalToolbarConstraints];
    [self.toolbar setItems:nil animated:YES];
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self.view addConstraints:self.horizontalToolbarConstraints];
    [self.view addConstraints:self.verticalToolbarConstraints];
}

- (void)layoutToolbar
{
    if (self.toolbar.frame.size.height > 0)
    {
        [self.view removeConstraints:self.horizontalToolbarConstraints];
        [self.view removeConstraints:self.verticalToolbarConstraints];
        [self.toolbar setItems:nil animated:YES];
        self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
        
        self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
        
        [self.view addConstraints:self.horizontalToolbarConstraints];
        [self.view addConstraints:self.verticalToolbarConstraints];
        [self.view layoutIfNeeded];
    }
    else
    {
        [self.view removeConstraints:self.horizontalToolbarConstraints];
        [self.view removeConstraints:self.verticalToolbarConstraints];
        
        [self generateStandardToolbarConstraints];
        
        [self.view layoutIfNeeded];
    }
}

-(void)slideToolbarUpWithCompletionBlock:(void (^)(void))completionBlock;
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view removeConstraints:self.horizontalToolbarConstraints];
        [self.view removeConstraints:self.verticalToolbarConstraints];
        
        [self generateStandardToolbarConstraints];
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completionBlock)
        {
            completionBlock();
        };
    }];
}

-(NSDictionary *)topBottomViewsDictionary
{
    id _cameraView = self.cameraContainerView;
    id _topLayoutGuide = self.topLayoutGuide;
    id _topImageView = self.thenView;
    id _bottomImageView = self.nowView;
    
    if (self.originalOrder)
    {

        _topImageView = self.thenView;
        _bottomImageView = self.nowView;

    }
    else
    {
        _bottomImageView = self.thenView;
        _topImageView = self.nowView;
    }
    
    _topBottomViewsDictionary = NSDictionaryOfVariableBindings(_topImageView, _bottomImageView, _toolbar, _topLayoutGuide, _cameraView);
    
    
    return _topBottomViewsDictionary;
}

-(NSDictionary *)leftRightViewsDictionary{
    
    id _leftImageView = self.thenView;
    id _rightImageView = self.nowView;
    id _cameraView = self.cameraContainerView;
    
    if (self.originalOrder)
    {
        
        _leftImageView = self.thenView;
        _rightImageView = self.nowView;
        
    }
    else
    {
        _rightImageView = self.thenView;
        _leftImageView = self.nowView;
    }
    
       _leftRightViewsDictionary = NSDictionaryOfVariableBindings(_leftImageView, _rightImageView,_cameraView,_toolbar);
    
    return _leftRightViewsDictionary;
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
        self.thenButton.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        if (finished)
        {
            
            
            self.thenButton.transform = CGAffineTransformMakeTranslation(0, 0);
            self.thenButton.transform = CGAffineTransformScale(self.thenButton.transform, 1,1);
            
            [UIView animateWithDuration:0.2 animations:^{
                self.thenButton.alpha = 1;
                
                
            }];
        }
    }];

}
- (void)cameraTapped:(id)sender {
    
    [self layoutCamera];
}

-(void)toggleCamera
{
    //self.cameraContainerView.hidden = !self.cameraContainerView.hidden;
    //self.nowImageView.hidden = !self.nowImageView.hidden;
}

-(void)didTakePhoto:(UIImage *)image
{
    self.nowImage = image;
    [self.toolbar setItems:self.toolbarButtonsArray animated:NO];
//    [self setupPhotos];
    [self resignCamera];

}

- (void)hideImagePicker{
    [self resignCamera];
}

- (void)showPicker:(UIButton *)btn{
    
    self.cameraContainerView.hidden = NO;
}


- (void)returnToPhotoView
{
    if (YES) //replace with bool property pictureTaken
    {
        self.nowView.hidden = NO;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.thenButton.alpha = 0;
        
//            [self.nowImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.nowImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Now"] forState:UIControlStateNormal];
            
            
        } completion:^(BOOL finished) {
            if (finished)
            {
                
                
                self.thenButton.transform = CGAffineTransformMakeTranslation(0, 504);
                self.thenButton.transform = CGAffineTransformScale(self.thenButton.transform, 1,1);
                
//                [self.nowImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.nowImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Now"] forState:UIControlStateNormal];

                
                [UIView animateWithDuration:0.2 animations:^{
                    self.thenButton.alpha = 1;
                    
                    
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

- (void)squareCropperDidCropImage:(UIImage *)croppedImage inCropper:(BASSquareCropperViewController *)cropper
{
    [self.thenButton setImage:croppedImage forState:UIControlStateNormal];
    [cropper dismissViewControllerAnimated:NO completion:nil];
}

- (void)squareCropperDidCancelCropInCropper:(BASSquareCropperViewController *)cropper
{
    [cropper dismissViewControllerAnimated:NO completion:nil];
}

- (void)setTextOverlayToImages
{
    NSLog(@"textOverlayButton tapped");
    [self.thenButton setImage:[self.pictureAddition applyTextOverlayToImage:self.thenImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Then"] forState:UIControlStateNormal];

    [self.thenButton setImage:[self.pictureAddition applyTextOverlayToImage:self.nowImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Now"] forState:UIControlStateNormal];

}

- (void)didTapPolaroidIcon:(id)sender
{
    CGRect rect = CGRectMake(0, 0, 320, 320);
    
    UIImageView *combinedImageView = [[UIImageView alloc] initWithFrame:rect];
    
    UIImage *resizedimage = [self.pictureAddition resizeImage:self.nowImage ForPolaroidFrame:rect];
    
    UIImage *combinedImage = [self.pictureAddition imageByCombiningImage:[UIImage imageNamed:@"polaroidFrame.png"] withImage:resizedimage secondImagePlacement:CGPointMake(20.0,16.0)];
    
    combinedImageView.image = combinedImage;
    [self.view addSubview:combinedImageView];
}


- (void)choosePosition{
    
    if (self.currentPosition ==YES) {
        
        //Top to Bottom Animation Transition
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self setHorizontalSplit];
            
        } completion:^(BOOL finished) {
            
            self.currentPosition = NO;
            
        }];
        
    }
    else{
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            //Left to Right Animation Transition
            [self setVerticalSplit];
        } completion:^(BOOL finished) {
            
            self.currentPosition = YES;
            
        }];
    }
}

- (void)setHorizontalSplit{
    [self removeAllConstraints];
    self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_topImageView(==230)][_bottomImageView(==_topImageView)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    self.horizontalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self.view addConstraints:self.verticalICVConstraints];
    [self.view addConstraints:self.horizontalNowViewConstraints];
    [self.view addConstraints:self.horizontalThenViewConstraints];
    
    [self generateStandardToolbarConstraints];
    
    [self.view layoutIfNeeded];
    
}

- (void)setVerticalSplit{
    
    self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftImageView(==160)][_rightImageView(==_leftImageView)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_leftImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    self.verticalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_rightImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
    
    [self.view addConstraints:self.horizontalICVConstraints];
    [self.view addConstraints:self.verticalNowViewConstraints];
    [self.view addConstraints:self.verticalThenViewConstraints];
    
    [self generateStandardToolbarConstraints];
    
}

- (void)leftAndRightSwitch{
    
    if (!self.originalOrder)
    {
        [self.view bringSubviewToFront:self.thenView];
    }
    else
    {
        [self.view bringSubviewToFront:self.nowView];
    }
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.view removeConstraints:self.verticalThenViewConstraints];
        [self.view removeConstraints:self.verticalNowViewConstraints];
        [self.view removeConstraints:self.horizontalICVConstraints];
        
        self.verticalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(94)-[_leftImageView]-(74)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
        self.verticalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_rightImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
        self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_leftImageView(==130)]-(15)-[_rightImageView(==160)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
        
        
        [self.view addConstraints:self.verticalThenViewConstraints];
        [self.view addConstraints:self.verticalNowViewConstraints];
        [self.view addConstraints:self.horizontalICVConstraints];
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self.view removeConstraints:self.verticalThenViewConstraints];
            [self.view removeConstraints:self.verticalNowViewConstraints];
            [self.view removeConstraints:self.horizontalICVConstraints];
            
            self.verticalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(94)-[_leftImageView]-(74)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
            self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightImageView(==160)]-(15)-[_leftImageView(==130)]-(15)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
            
            self.verticalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_rightImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
            
            [self generateStandardToolbarConstraints];
            
            [self.view addConstraints:self.verticalThenViewConstraints];
            [self.view addConstraints:self.verticalNowViewConstraints];
            [self.view addConstraints:self.horizontalICVConstraints];
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [self.view removeConstraints:self.verticalThenViewConstraints];
                [self.view removeConstraints:self.horizontalICVConstraints];
                
                
                self.verticalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_leftImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
                self.horizontalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rightImageView(==160)][_leftImageView(==_rightImageView)]|" options:0 metrics:nil views:self.leftRightViewsDictionary];
                
                // [self generateStandardToolbarConstraints];
                
                [self.view addConstraints:self.verticalThenViewConstraints];
                [self.view addConstraints:self.horizontalICVConstraints];
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                
                self.originalOrder = !self.originalOrder;
                
            }];
            
        }];
        
    }];
    
}

- (void)topAndBottomSwitch{
    
    if (!self.originalOrder)
    {
        [self.view bringSubviewToFront:self.thenButton];
    }
    else
    {
        [self.view bringSubviewToFront:self.nowButton];
    }
    
    self.nowButton.layer.shadowOffset = CGSizeMake(0,0);
    self.nowButton.layer.shadowRadius = 25;
    
    [UIView animateWithDuration:0.13 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
        NSLog(@"Animation for setupPhotos called");
        
        
        
        //        self.thenImageView.layer.shadowOffset = CGSizeMake(20,50);
        //        self.thenImageView.layer.shadowRadius = 50;
        //        self.thenImageView.layer.shadowOpacity = 1;
        //
        [self.view removeConstraints:self.horizontalThenViewConstraints];
        [self.view removeConstraints:self.verticalICVConstraints];
        [self.view removeConstraints:self.horizontalNowViewConstraints];
        
        
        self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topImageView(==290)]-(15)-|" options:0 metrics:nil views:self.topBottomViewsDictionary];
        self.horizontalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
        self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(79)-[_topImageView(==200)]-(15)-[_bottomImageView(==230)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
        
        [self.view addConstraints:self.horizontalThenViewConstraints];
        [self.view addConstraints:self.verticalICVConstraints];
        [self.view addConstraints:self.horizontalNowViewConstraints];
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            NSLog(@"Animation for setupPhotos called");
            
            [self.view removeConstraints:self.horizontalThenViewConstraints];
            [self.view removeConstraints:self.verticalICVConstraints];
            [self.view removeConstraints:self.horizontalNowViewConstraints];
            
            
            self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topImageView(==290)]-(15)-|" options:0 metrics:nil views:self.topBottomViewsDictionary];
            
            self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomImageView(==230)]-(15)-[_topImageView(==200)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
            
            self.horizontalNowViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
            
            
            
            [self generateStandardToolbarConstraints];
            [self.view addConstraints:self.horizontalThenViewConstraints];
            [self.view addConstraints:self.horizontalNowViewConstraints];
            [self.view addConstraints:self.verticalICVConstraints];
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            anim.fromValue = [NSNumber numberWithFloat:1.0];
            anim.toValue = [NSNumber numberWithFloat:0.0];
            anim.duration = 0.3;
            [self.nowButton.layer addAnimation:anim forKey:@"shadowOpacity"];
            self.nowButton.layer.shadowOpacity = 0.0;
            
            [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                [self.view removeConstraints:self.horizontalThenViewConstraints];
                [self.view removeConstraints:self.verticalICVConstraints];
                
                
                self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topImageView]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
                self.verticalICVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomImageView(==230)][_topImageView(==230)]" options:0 metrics:nil views:self.topBottomViewsDictionary];
                
                
                self.nowButton.layer.shadowOffset = CGSizeMake(0,0);
                //                  self.nowImageView.layer.shadowRadius = 0;
                //                  self.nowImageView.layer.shadowOpacity = 0;
                
                
                [self.view addConstraints:self.horizontalThenViewConstraints];
                [self.view addConstraints:self.verticalICVConstraints];
                
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                self.originalOrder = !self.originalOrder;
            }];
            
        }];
        
        
    }];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:1.0];
    anim.duration = 0.3;
    [self.nowButton.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.nowButton.layer.shadowOpacity = 1.0;
    
}

- (void)generateStandardToolbarConstraints
{
    
    self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==44)]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.topBottomViewsDictionary];
    
    [self.view addConstraints:self.horizontalToolbarConstraints];
    [self.view addConstraints:self.verticalToolbarConstraints];
    
}

- (void)removeAllConstraints
{
    [self.view removeConstraints:self.view.constraints];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.cameraContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cameraContainerView removeConstraints:self.cameraContainerView.constraints];
    
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolbar removeConstraints:self.toolbar.constraints];
    
    self.cropperContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cropperContainerView removeConstraints:self.cropperContainerView.constraints];
}

- (void)removeSubviewConstraints
{
    self.nowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowView removeConstraints:self.nowView.constraints];
    
    self.thenView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenView removeConstraints:self.thenView.constraints];
    
    self.thenButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenButton removeConstraints:self.thenButton.constraints];
    
    self.nowButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowButton removeConstraints:self.nowButton.constraints];
    
}

- (void)layoutThenView
{
    self.verticalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_thenButton]|" options:0 metrics:nil views:self.subviewsDictionary];
    
    self.horizontalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_thenButton]|" options:0 metrics:nil views:self.subviewsDictionary];
    
    [self.thenView addConstraints:self.verticalThenImageConstraints];
    [self.thenView addConstraints:self.horizontalThenImageConstraints];
}

- (void)layoutNowView
{
    self.verticalNowImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nowButton]|" options:0 metrics:nil views:self.subviewsDictionary];
    
    self.horizontalNowImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nowButton]|" options:0 metrics:nil views:self.subviewsDictionary];
    
    [self.nowView addConstraints:self.verticalNowImageConstraints];
    [self.nowView addConstraints:self.horizontalNowImageConstraints];
}

-(NSDictionary *)subviewsDictionary
{
  if (!_subviewsDictionary)
  {
      _subviewsDictionary = NSDictionaryOfVariableBindings(_thenButton, _nowButton);
  }
    return _subviewsDictionary;
}

@end
