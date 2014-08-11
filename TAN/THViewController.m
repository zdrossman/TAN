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
#import "THTextOverlay.h"

//#import "UIImage+Resize.h"

typedef void(^ButtonReplacementBlock)(void);

@interface THViewController () <UINavigationControllerDelegate, THCameraDelegateProtocol, BASSquareCropperDelegate>

@end

@implementation THViewController

#pragma mark - Getters

-(NSArray *)baseToolbarItems {
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
   
    UIBarButtonItem *textOverlay = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1174-choose-font-toolbar"] style:UIBarButtonItemStylePlain target:self action:@selector(textOverlayTapped)];
    
    UIBarButtonItem *polaroidFrameButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"polaroidIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapPolaroidIcon:)];
    
    return self.toolbarButtonsArray = @[switchSubviewsButton, textOverlay, polaroidFrameButton];
}


-(NSDictionary *)metrics {
 
    if (!_metrics)
    {
    
        _metrics = @{@"cameraViewTop":@64, @"cameraViewBottom":@0, @"toolbarHeight":@44, @"cameraViewBottomAnimated":@460};
    }
    
    return _metrics;
    
}

- (UIButton *)nowButton {
    
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

-(NSArray *)verticalCameraConstraints {

    if (!_verticalCameraConstraints)
    {
        _verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cameraView(==0)]" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
    }
    
    return _verticalCameraConstraints;
}

- (NSArray *)horizontalCameraConstraints {
    if (!_horizontalCameraConstraints)
    {
        _horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:self.metrics views:self.topBottomViewsDictionary];
    }
    
    return _horizontalCameraConstraints;
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

-(NSDictionary *)subviewsDictionary
{
    if (!_subviewsDictionary)
    {
        _subviewsDictionary = NSDictionaryOfVariableBindings(_thenButton, _nowButton);
    }
    
    return _subviewsDictionary;
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

- (void)layoutEditingPanel{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    self.takingPhoto = NO;
    [self baseInit];
    [self removeAllTopLevelViewConstraints];
    [self setupEditView];
    [self setupCamera];
    [self setupInitialStateOfImageViews];
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)baseInit{

    self.nowView = [[UIView alloc] init];
    self.thenView = [[UIView alloc] init];
    self.cameraContainerView = [[UIView alloc] init];
    
    self.thenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toolbar = [[UIToolbar alloc] init];
//    self.pictureAddition = [[THPictureAddition alloc] init];
    
    
    self.nowTextImageView.hidden = YES;
    self.thenTextImageView.hidden = YES;
    
    [self.view addSubview:self.nowView];
    [self.view addSubview:self.thenView];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.cameraContainerView];

    [self.nowView addSubview:self.nowButton];
    [self.thenView addSubview:self.thenButton];
    
    [self.toolbar setItems:self.baseToolbarItems]; //technically not a property...
}


#pragma mark - Setup
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

-(void)setupEditView
{
    self.nowView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.thenView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    self.cameraContainerView.hidden = YES;
    
    //FIXIT: Should i keep this line? self.thenImageView.alpha =1.0;
    [self layoutThenAndNowContainerViews];
    [self layoutBaseNavbar];
    
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
    [self animateLayoutToolbarOfHeightZeroAtBottomOfScreenWithCompletion:^{
        [self.toolbar setItems:self.toolbarButtonsArray animated:NO];
        [self animateLayoutToolbarOfStandardHeightWithCompletion:^{
            NSLog(@"Completed toolbar button update.");
        }];
    }];
}


- (void)resignCamera
{
    [self.toolbar setItems:self.toolbarButtonsArray animated:NO];
    [self animateCameraResignWithSetupViewsBlock:^{
        [self setupEditView];
    } AndCompletion:^{
        [self setupCamera];
    }];
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

- (void)setupCameraNavigationBar
{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(resignCamera)];
}

#pragma mark - buttonTaps
- (void)cameraTapped:(id)sender {
    
    [self layoutCamera];
    [self setupCameraNavigationBar];
}

- (void)textOverlayTapped {
    
    self.thenTextImageView = [[UIImageView alloc] init];
    THTextOverlay *thenTextOverlay = [[THTextOverlay alloc] initWithImageText:@"Then" Font:[UIFont systemFontOfSize:20] FontSize:20 TextAlignment:NSTextAlignmentLeft ForViewFrameToDrawIn:self.thenButton.frame];
    self.thenTextImage = [thenTextOverlay imageFromText];
    self.thenTextImageView.image = self.thenTextImage;
    
    self.nowTextImageView = [[UIImageView alloc] init];
    THTextOverlay *nowTextOverlay = [[THTextOverlay alloc] initWithImageText:@"Now" Font:[UIFont systemFontOfSize:20] FontSize:20 TextAlignment:NSTextAlignmentRight ForViewFrameToDrawIn:self.thenButton.frame];
    self.nowTextImage = [nowTextOverlay imageFromText];
    self.nowTextImageView.image = self.nowTextImage;
    
    
    [self.nowView addSubview:self.nowTextImageView];
    [self.thenView addSubview:self.thenTextImageView];
    
    //self.thenTextImageView.backgroundColor = [UIColor orangeColor];
    //self.nowTextImageView.backgroundColor = [UIColor whiteColor];

    self.textImageViewsDictionary = NSDictionaryOfVariableBindings(_thenTextImageView, _nowTextImageView);
    [self layoutTextImageViews];
    
    self.nowTextImageView.hidden = !self.nowTextImageView.hidden;
    self.thenTextImageView.hidden = !self.thenTextImageView.hidden;

}

#pragma mark - CropperDelegate
- (void)squareCropperDidCancelCropInCropper:(BASSquareCropperViewController *)cropper
{
    [cropper dismissViewControllerAnimated:NO completion:nil];
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



#pragma mark - FrameDelegate
- (void)didTapPolaroidIcon:(id)sender
{
    CGRect rect = CGRectMake(0, 0, 320, 320);
    
    UIImageView *combinedImageView = [[UIImageView alloc] initWithFrame:rect];
    
    //    UIImage *resizedimage = [self.pictureAddition resizeImage:self.nowImage ForPolaroidFrame:rect];
    
    //    UIImage *combinedImage = [self.pictureAddition imageByCombiningImage:[UIImage imageNamed:@"polaroidFrame.png"] withImage:resizedimage secondImagePlacement:CGPointMake(20.0,16.0)];
    
    //    combinedImageView.image = combinedImage;
    [self.view addSubview:combinedImageView];
}

#pragma mark - CameraDelegate
-(void)takePhotoTapped:(UIImage *)image
{
    if (image)
    {
        self.nowImage = image;
    }
    
    [self resignCamera];
}

#pragma mark - TextOverlayDelegate
- (void)setTextOverlayToImages
{
    //    [self.thenImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.thenImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Then"] forState:UIControlStateNormal];
    
    //    [self.nowImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.nowImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Now"] forState:UIControlStateNormal];
    
}


@end
