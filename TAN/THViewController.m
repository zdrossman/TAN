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
#import "THPictureAddition.h"
#import "THViewController+Autolayout.h"

//#import "UIImage+Resize.h"

typedef void(^ButtonReplacementBlock)(void);

@interface THViewController () <UINavigationControllerDelegate, THCameraDelegateProtocol, UIScrollViewDelegate>

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
    
    NSNumber *thenImageHeight = [NSNumber numberWithFloat:self.thenImage.size.height];
    NSNumber *thenImageWidth = [NSNumber numberWithFloat:self.thenImage.size.width];
    
    NSNumber *nowImageHeight = [NSNumber numberWithFloat:self.nowImage.size.height];
    NSNumber *nowImageWidth = [NSNumber numberWithFloat:self.nowImage.size.width];
    
    _metrics = @{@"cameraViewTop":@64, @"cameraViewBottom":@0, @"toolbarHeight":@44, @"cameraViewBottomAnimated":@460, @"thenImageHeight":thenImageHeight, @"thenImageWidth":thenImageWidth,@"nowImageHeight":nowImageHeight,@"nowImageWidth":nowImageWidth};
 
    return _metrics;
    
}

- (UIImageView *)nowImageView {
    
    if (self.nowImage)
    {
        [_nowImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_nowImageView setImage:self.nowImage];
    }
    
    return _nowImageView;
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
    id _topScrollView = self.thenScrollView;
    id _bottomScrollView = self.nowScrollView;
    
    if (self.thenOnLeftOrTop)
    {
        _topScrollView = self.thenScrollView;
        _bottomScrollView = self.nowScrollView;
    }
    else
    {
        _bottomScrollView = self.thenScrollView;
        _topScrollView = self.nowScrollView;
    }
    
    _topBottomViewsDictionary = NSDictionaryOfVariableBindings(_topScrollView, _bottomScrollView, _toolbar, _topLayoutGuide, _cameraView);
    
    
    
    return _topBottomViewsDictionary;
}

-(NSDictionary *)leftRightViewsDictionary{
    
    id _leftScrollView = self.thenScrollView;
    id _rightScrollView = self.nowScrollView;
    id _cameraView = self.cameraContainerView;
    
    if (self.thenOnLeftOrTop)
    {
        
        _leftScrollView = self.thenScrollView;
        _rightScrollView = self.nowScrollView;
        
    }
    else
    {
        _rightScrollView = self.thenScrollView;
        _leftScrollView = self.nowScrollView;
    }
    
    _leftRightViewsDictionary = NSDictionaryOfVariableBindings(_leftScrollView, _rightScrollView,_cameraView,_toolbar);
    
    return _leftRightViewsDictionary;
}

-(NSDictionary *)subviewsDictionary
{
    if (!_subviewsDictionary)
    {
        _subviewsDictionary = NSDictionaryOfVariableBindings(_thenImageView, _nowImageView, _thenScrollView, _nowScrollView, _thenLabel, _nowLabel);
    }
    
    return _subviewsDictionary;
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.horizontalSplit = NO;
    self.thenOnLeftOrTop = YES;
    self.editMode = NO;
    self.thenImage = [UIImage imageNamed:@"funnyBabyPNG"];
    [self layoutEditingPanel];
}

- (void)layoutEditingPanel{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
    self.editMode = YES;
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

    self.nowScrollView = [[UIScrollView alloc] init];
    self.thenScrollView = [[UIScrollView alloc] init];
    
    self.nowScrollView.delegate = self;
    self.thenScrollView.delegate = self;
    
    CGFloat widthDivisor = 160.0;
    CGFloat heightDivisor = 320.0;
    
    CGFloat thenMinZoomScale = MAX(widthDivisor/self.thenImage.size.width,heightDivisor/self.thenImage.size.height);

    self.thenScrollView.maximumZoomScale = 4;
    self.thenScrollView.minimumZoomScale = thenMinZoomScale;
    
    
    self.nowScrollView.showsHorizontalScrollIndicator = NO;
    self.nowScrollView.showsVerticalScrollIndicator = NO;
    self.thenScrollView.showsHorizontalScrollIndicator = NO;
    self.thenScrollView.showsVerticalScrollIndicator = NO;
    
    self.nowScrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nowScrollView.layer.borderWidth = 3;
    
    self.thenScrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.thenScrollView.layer.borderWidth = 3;

    self.cameraContainerView = [[UIView alloc] init];
    
    self.thenImageView = [[UIImageView alloc]  init];
    self.nowImageView = [[UIImageView alloc]  init];
    
    self.toolbar = [[UIToolbar alloc] init];
//    self.pictureAddition = [[THPictureAddition alloc] init];
    
    self.nowLabel = [[UILabel alloc] init];
    self.thenLabel = [[UILabel alloc] init];

    [self.view addSubview:self.nowScrollView];
    [self.view addSubview:self.thenScrollView];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.cameraContainerView];

    //[self.nowView addSubview:self.nowButton];
    //[self.thenView addSubview:self.thenButton];
    [self.view addSubview:self.thenScrollView];
    [self.view addSubview:self.nowScrollView];
    
    [self.thenScrollView addSubview:self.thenImageView];
    [self.nowScrollView addSubview:self.nowImageView];
    
    [self.toolbar setItems:self.baseToolbarItems]; //technically not a property...
}

-(void)viewDidLayoutSubviews
{
    
}

- (void)setupCamera
{
    if (self.cameraVC)
    {
        [self.cameraVC removeFromParentViewController];
    }
    
    self.cameraVC = [[THCamera2ViewController alloc] init];
    
    [self addChildViewController:self.cameraVC];
    [self.cameraContainerView addSubview:self.cameraVC.view];
    self.cameraContainerView.frame = self.view.bounds;
    self.cameraVC.view.frame = self.cameraContainerView.bounds;
    self.cameraVC.delegate = self;
}

-(void)setupEditView
{
    self.nowScrollView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.thenScrollView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    self.cameraContainerView.hidden = YES;
    
    //FIXIT: Should i keep this line? self.thenImageView.alpha =1.0;
    [self layoutThenAndNowScrollViews];
    [self layoutBaseNavbar];
    
}



- (void)setupInitialStateOfImageViews
{
    self.thenImage = [UIImage imageNamed:@"funnyBabyPNG"];
    [self.thenImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.thenImageView setImage:self.thenImage];
    
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
    
    [self.nowScrollView addSubview:self.nowLabel];
    [self.thenScrollView addSubview:self.thenLabel];
    
    [self.nowScrollView bringSubviewToFront:self.nowLabel];
    [self.thenScrollView bringSubviewToFront:self.thenLabel];
    
    UIColor *textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIFont *font = [UIFont systemFontOfSize:20.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attr = @{NSForegroundColorAttributeName:textColor, NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    NSString *textForAttributedText = @"Then";
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:textForAttributedText
                                           attributes:attr];
    
    CGSize thetextSize = [textForAttributedText sizeWithAttributes:attr];
    
    self.thenLabel.attributedText = attributedText;
    
    //self.thenTextImageView.backgroundColor = [UIColor orangeColor];
    //self.nowTextImageView.backgroundColor = [UIColor whiteColor];

    [self layoutTextLabels];
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
        self.nowImageView.image = self.nowImage;
        
        CGFloat widthDivisor = 160.0;
        CGFloat heightDivisor = 320.0;
        
        CGFloat nowMinZoomScale = MAX(widthDivisor/self.nowImage.size.width,heightDivisor/self.nowImage.size.height);
        self.nowScrollView.maximumZoomScale = 4;
        self.nowScrollView.minimumZoomScale = nowMinZoomScale;
        
        [self layoutThenAndNowScrollViews];
    }
    
    [self resignCamera];
}

#pragma mark - TextOverlayDelegate
- (void)setTextOverlayToImages
{
    //    [self.thenImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.thenImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Then"] forState:UIControlStateNormal];
    
    //    [self.nowImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.nowImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Now"] forState:UIControlStateNormal];
    
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView == self.thenScrollView)
    {
        return self.thenImageView;
    };
    
    return self.nowImageView;
}

@end
