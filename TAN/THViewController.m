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
#import "THViewController+Autolayout.h"

//#import "UIImage+Resize.h"

typedef void(^ButtonReplacementBlock)(void);

@interface THViewController () <UINavigationControllerDelegate, THCameraDelegateProtocol, BASSquareCropperDelegate>

@end

@implementation THViewController

#pragma mark - Getters

- (NSArray *)baseToolbarItems
{
    UIImage *switchIcon;
    SEL splitSelector;
    
    if (self.horizontalSplit)
    {
        switchIcon = [UIImage imageNamed:@"1074-grid-2B rotated"];
        splitSelector = @selector(switchImagesAcrossHorizontalSplit);
    }
    else
    {
        switchIcon = [UIImage imageNamed:@"1074-grid-2"];
        splitSelector = @selector(switchImagesAcrossVerticalSplit);
    }
    UIBarButtonItem *switchSubviewsButton = [[UIBarButtonItem alloc] initWithImage:switchIcon style:UIBarButtonItemStylePlain target:self action:splitSelector];
   
    UIBarButtonItem *textOverlay = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1174-choose-font-toolbar"] style:UIBarButtonItemStylePlain target:self action:@selector(setTextOverlayToImages)];
    
    UIBarButtonItem *polaroidFrameButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"polaroidIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPolaroidIcon:)];
    
    return self.toolbarButtonsArray = @[switchSubviewsButton, textOverlay, polaroidFrameButton];
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
    self.horizontalSplit = NO;
    self.thenOnLeftOrTop = YES;
    //self.thenImage = [UIImage imageNamed:@"funnyBabyPNG"];
    //[self initPreviewPanel];
    [self layoutEditingPanel];

    
}

- (void)initPreviewPanel
{
    [self setupCropper:nil];
//    [self setupPreviewViews];
//    [self layoutPreviewPanel];
}

- (void)setupPreviewViews
{
    self.originalOrder = YES;
    
    self.thenImage = [UIImage imageNamed:@"funnyBabyPNG"];
    
    self.navigationController.navigationBar.alpha = 0;
    self.navigationController.navigationBar.hidden = YES;

    self.thenView = [[UIView alloc] init];
    [self.view addSubview:self.thenView];
    
    self.thenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.thenButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.thenButton.clipsToBounds = YES;
    [self.thenButton setImage:self.thenImage forState:UIControlStateNormal];
    [self.thenButton addTarget:self action:@selector(setupCropper:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.thenView addSubview:self.thenButton];
}

- (void)layoutPreviewPanel
{
    
    [self.view removeConstraints:self.view.constraints];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    
    [self.thenView removeConstraints:self.thenView.constraints];
    self.thenView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.thenButton removeConstraints:self.thenButton.constraints];
    self.thenButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.editButton removeConstraints:self.editButton.constraints];
    self.editButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    id _leftImageView = self.thenView;
    
    NSDictionary *layoutDictionary = NSDictionaryOfVariableBindings(_thenButton, _leftImageView, _editButton);
    
    self.horizontalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_thenButton]|" options:0 metrics:nil views:layoutDictionary];
    
    self.verticalThenImageConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_thenButton]|" options:0 metrics:nil views:layoutDictionary];
    
    self.horizontalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftImageView]|" options:0 metrics:nil views:layoutDictionary];
    
    self.verticalThenViewConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_leftImageView]-(64)-|" options:0 metrics:nil views:layoutDictionary];
    
    NSArray *verticalEditButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(500)-[_editButton]" options:0 metrics:nil views:layoutDictionary];
    
    NSArray *horizontalEditButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(150)-[_editButton]" options:0 metrics:nil views:layoutDictionary];
    
    [self.view addConstraints:self.horizontalThenViewConstraints];
    [self.view addConstraints:self.verticalThenViewConstraints];
    
    [self.view addConstraints:verticalEditButtonConstraints];
    [self.view addConstraints:horizontalEditButtonConstraints];
    
    [self.thenView addConstraints:self.verticalThenImageConstraints];
    [self.thenView addConstraints:self.horizontalThenImageConstraints];
    
    [self.view layoutIfNeeded];
    
}
- (void)layoutEditingPanel{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    self.takingPhoto = NO;
    self.originalOrder = YES;
    self.currentPosition =YES;
    [self baseInit];
    [self setupEditView];
    [self setupInitialStateOfImageViews];
    //[self layoutCamera];


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self setupInitialStateOfImageViews];
    
}

- (void)baseInit{

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
    
    [self.toolbar setItems:self.baseToolbarItems]; //technically not a property...
}


#pragma mark - setup
-(void)setupCropper:(id)sender
{

//    self.cropperContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
//    self.cropperContainerView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:self.cropperContainerView];
//    self.cropperContainerView.hidden = NO;
    
    UIButton *button = sender;
    NSString *imageName;
    UIImage *imageToCrop;
    if (button == self.nowButton && self.nowButton)
    {
            imageName = @"Now";
    }
    else if (button == self.thenButton && self.thenButton)
    {
        imageName = @"Then";
    }
    
    if (sender)
    {
        imageToCrop = button.imageView.image;
    }
    else
    {
        imageToCrop = self.thenImage;
    }

        
    BASSquareCropperViewController *cropperVC = [[BASSquareCropperViewController alloc] initWithImage:imageToCrop ImageName:imageName MinimumCroppedImageSideLength:160];
    
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
                           action:@selector(setupCropper:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nowButton;
}

-(void)setupEditView
{
    self.nowView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.thenView.layer.backgroundColor = [UIColor yellowColor].CGColor;

    //FIXIT: Should i keep this line? self.thenImageView.alpha =1.0;
    [self layoutThenAndNowContainerViews];
    [self layoutBaseNavbar];
    [self setupCamera];
}



#pragma mark - Layout and Animations
-(void)performAnimation{
    
    if (self.currentPosition == YES) {
        
        [self switchImagesAcrossVerticalSplit];
    }else
    {
        [self switchImagesAcrossHorizontalSplit];
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


-(void)returnToPhotosFromCamera
{
    [self resignCamera];
    
    //[self setupEditView];
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
        
        [self layoutThenAndNowContainerViews];
        
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
            [self.toolbar setItems:self.baseToolbarItems animated:YES]; //technically not a property...
            [self layoutBaseNavbar];
        }];
    }];
    
}

- (void)setupInitialStateOfImageViews
{
    self.thenImage = [UIImage imageNamed:@"funnyBabyPNG"];
    
    [self.thenButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.thenButton.clipsToBounds = YES;
    [self.thenButton setImage:self.thenImage forState:UIControlStateNormal];
    [self.thenButton addTarget:self action:@selector(setupCropper:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)replaceToolbarWithButtons:(ButtonReplacementBlock)buttonReplacementBlock
{
    [self animateToolbarOfHeightZeroAtBottomOfScreenWithCompletion:^{
        [self.toolbar setItems:self.toolbarButtonsArray animated:NO];
        [self animateLayoutToolbarOfStandardHeight:^{
            NSLog(@"Completed toolbar button update.");
        }];
    }];
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
        
        [self layoutToolbarOfStandardHeight];
        
        [self.view layoutIfNeeded];
    }
}


-(NSDictionary *)topBottomViewsDictionary
{
    id _cameraView = self.cameraContainerView;
    id _topLayoutGuide = self.topLayoutGuide;
    id _topImageView = self.thenView;
    id _bottomImageView = self.nowView;
    
    if (self.thenOnLeftOrTop)
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
    
    if (self.thenOnLeftOrTop)
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
    [self resignCamera];
    [self setupEditView];
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

- (void)squareCropperDidCropImage:(UIImage *)croppedImage withImageName:(NSString *)name inCropper:(BASSquareCropperViewController *)cropper
{
    if ([name isEqualToString:@"Then"])
    {
        [self.thenButton setImage:croppedImage forState:UIControlStateNormal];
    }
    else if ([name isEqualToString:@"Now"])
    {
        [self.nowButton setImage:croppedImage forState:UIControlStateNormal];
    }
    else
    {
        [self layoutEditingPanel];
        [self.thenButton setImage:croppedImage forState:UIControlStateNormal];
    }
        
    [cropper dismissViewControllerAnimated:NO completion:^{
        if (self.editMode == NO)
        {
            self.editMode = YES;
        }
    }];
}



- (void)squareCropperDidCancelCropInCropper:(BASSquareCropperViewController *)cropper
{
    [cropper dismissViewControllerAnimated:NO completion:nil];
}

- (void)setTextOverlayToImages
{
//    [self.thenImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.thenImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Then"] forState:UIControlStateNormal];

//    [self.nowImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.nowImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Now"] forState:UIControlStateNormal];

}

- (void)didTapPolaroidIcon:(id)sender
{
    CGRect rect = CGRectMake(0, 0, 320, 320);
    
    UIImageView *combinedImageView = [[UIImageView alloc] initWithFrame:rect];
    
//    UIImage *resizedimage = [self.pictureAddition resizeImage:self.nowImage ForPolaroidFrame:rect];
    
//    UIImage *combinedImage = [self.pictureAddition imageByCombiningImage:[UIImage imageNamed:@"polaroidFrame.png"] withImage:resizedimage secondImagePlacement:CGPointMake(20.0,16.0)];
    
//    combinedImageView.image = combinedImage;
    [self.view addSubview:combinedImageView];
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
