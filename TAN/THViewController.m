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
    
    UIBarButtonItem *stickerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1169-star-toolbar"] style:UIBarButtonItemStylePlain target:self action:@selector(stickerTapped)];
    

    
    return _baseToolbarItems = @[switchSubviewsButton, self.spacerBBI, textOverlay, self.spacerBBI, polaroidFrameButton, self.spacerBBI, stickerButton];
}

-(NSArray *)stickerToolbarItems {

    if (!_stickerToolbarItems)
    {
    
        NSMutableArray *toolbarArray = [[NSMutableArray alloc] init];
        
        [toolbarArray addObject:self.returnButton];
        
        _stickerToolbarItems = toolbarArray;
    }

    return _stickerToolbarItems;
}



-(NSArray *)textToolbarItems {
    

    
    if (!_textToolbarItems)
    {
        NSMutableArray *toolbarArray = [[NSMutableArray alloc] init];
        
        [toolbarArray addObject:self.returnButton];
        
        UIBarButtonItem *typefaceBBI = [[UIBarButtonItem alloc] initWithTitle:@"Typeface" style:UIBarButtonItemStylePlain target:self action:@selector(typefaceButtonTapped)];
        
        UIBarButtonItem *textColorBBI = [[UIBarButtonItem alloc] initWithTitle:@"TextColor" style:UIBarButtonItemStylePlain target:self action:@selector(layoutSecondaryToolbar)];
        
        [toolbarArray addObjectsFromArray:@[self.spacerBBI, typefaceBBI, self.spacerBBI, textColorBBI, self.spacerBBI]];
        
        _textToolbarItems = toolbarArray;
    }
    
    
    return _textToolbarItems;
    
}

- (UIBarButtonItem *)returnButton {
    if (!_returnButton)
    {
    _returnButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"433-x"] style:UIBarButtonItemStylePlain target:self action:@selector(returnTapped)];
    }
    return _returnButton;
}

-(UIBarButtonItem *)spacerBBI
{
    if (!_spacerBBI)
    {
        _spacerBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    
    return _spacerBBI;
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
    id _topContainerView;
    id _bottomContainerView;
    
    if (self.thenOnLeftOrTop)
    {
        _topContainerView = self.thenContainerView;
        _bottomContainerView = self.nowContainerView;
    }
    else
    {
        _bottomContainerView = self.thenContainerView;
        _topContainerView = self.nowContainerView;
    }
    
    _topBottomViewsDictionary = NSDictionaryOfVariableBindings(_topContainerView, _bottomContainerView, _toolbar, _topLayoutGuide, _cameraView);
    
    
    
    return _topBottomViewsDictionary;
}

-(NSDictionary *)leftRightViewsDictionary{
    
    id _leftContainerView;
    id _rightContainerView;
    id _cameraView = self.cameraContainerView;
    
    if (self.thenOnLeftOrTop)
    {
        
        _leftContainerView = self.thenContainerView;
        _rightContainerView = self.nowContainerView;
        
    }
    else
    {
        _rightContainerView = self.thenContainerView;
        _leftContainerView = self.nowContainerView;
    }
    
    _leftRightViewsDictionary = NSDictionaryOfVariableBindings(_leftContainerView, _rightContainerView,_cameraView,_toolbar);
    
    return _leftRightViewsDictionary;
}

-(NSDictionary *)subviewsDictionary
{
    
    if (!_subviewsDictionary) {
    _subviewsDictionary = NSDictionaryOfVariableBindings(_thenImageView, _nowImageView, _thenScrollView, _nowScrollView);
    }
    
    return _subviewsDictionary;
}

-(NSDictionary *)labelsDictionary
{
    if (!_labelsDictionary) {
        _labelsDictionary = NSDictionaryOfVariableBindings(_thenLabel, _nowLabel);
    }
    
    return _labelsDictionary;
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

    self.nowContainerView = [[UIView alloc] init];
    self.thenContainerView = [[UIView alloc] init];
    
    
    self.nowScrollView = [[UIScrollView alloc] init];
    self.thenScrollView = [[UIScrollView alloc] init];
    
    self.nowScrollView.delegate = self;
    self.thenScrollView.delegate = self;
    
    CGFloat widthDivisor = 160.0;
    CGFloat heightDivisor = 320.0;
    
    CGFloat thenMinZoomScale = MAX(widthDivisor/self.thenImage.size.width,heightDivisor/self.thenImage.size.height);

    self.thenScrollView.maximumZoomScale = 4;
    self.thenScrollView.minimumZoomScale = 0.2;
    
    self.nowScrollView.showsHorizontalScrollIndicator = NO;
    self.nowScrollView.showsVerticalScrollIndicator = NO;
    self.thenScrollView.showsHorizontalScrollIndicator = NO;
    self.thenScrollView.showsVerticalScrollIndicator = NO;
    
    self.nowContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.nowContainerView.layer.borderWidth = 3;
    
    self.thenContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.thenContainerView.layer.borderWidth = 3;

    self.cameraContainerView = [[UIView alloc] init];
    
    self.thenImageView = [[UIImageView alloc]  init];
    self.nowImageView = [[UIImageView alloc]  init];
    
    self.toolbar = [[UIToolbar alloc] init];
//    self.pictureAddition = [[THPictureAddition alloc] init];
    

    
    [self.view addSubview:self.thenContainerView];
    [self.view addSubview:self.nowContainerView];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.cameraContainerView];
    

    [self.thenContainerView addSubview:self.thenScrollView];
    [self.nowContainerView addSubview:self.nowScrollView];
    [self.thenScrollView addSubview:self.thenImageView];
    [self.nowScrollView addSubview:self.nowImageView];
    
    [self.thenScrollView setBackgroundColor:[UIColor blackColor]];
    [self.nowScrollView setBackgroundColor:[UIColor blackColor]];
    
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
    self.nowScrollView.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.thenScrollView.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.cameraContainerView.hidden = YES;
    
    //FIXIT: Should i keep this line? self.thenImageView.alpha =1.0;
    [self layoutThenAndNowContainerViews];
    [self layoutBaseNavbar];
    
}



- (void)setupInitialStateOfImageViews
{
    self.thenImage = [UIImage imageNamed:@"funnyBabyPNG"];
    [self.thenImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.thenImageView setImage:self.thenImage];
    
}


- (void)replaceToolbarWithButtons:(NSArray *)buttons
{
    [self animateLayoutToolbarOfHeightZeroAtBottomOfScreenWithCompletion:^{
        [self.toolbar setItems:buttons animated:NO];
        [self animateLayoutToolbarOfStandardHeightWithCompletion:^{
            NSLog(@"Completed toolbar button update.");
        }];
    }];
}


- (void)resignCamera
{
    [self.toolbar setItems:self.baseToolbarItems animated:NO];
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

- (void)returnTapped {
    self.secondaryToolbar.hidden = YES;
    [self replaceToolbarWithButtons:self.baseToolbarItems];
}

- (void)stickerTapped {
    
    [self replaceToolbarWithButtons:self.stickerToolbarItems];
    
}

- (void)textOverlayTapped {
    
    [self replaceToolbarWithButtons:self.textToolbarItems];
    
    if (!self.secondaryToolbar)
    {
        
        self.secondaryToolbar = [[UIScrollView alloc] init];
        [self.view addSubview:self.secondaryToolbar];
    
        [self.secondaryToolbar setShowsHorizontalScrollIndicator:NO];
        [self.secondaryToolbar setShowsVerticalScrollIndicator:NO];
        
        self.contentViewForSecondaryToolbar = [[UIView alloc] init];
        [self.secondaryToolbar addSubview:self.contentViewForSecondaryToolbar];
        
        
        [self layoutSecondaryToolbar];
    }
    
    [self typefaceButtonTapped];

}

- (void)typefaceButtonTapped {
    
    [self showHideTANTextWithFont:nil];
    
    self.secondaryToolbar.backgroundColor = [UIColor whiteColor];
    self.secondaryToolbar.alpha = 0.85;
    [self.secondaryToolbar layoutIfNeeded];
    
}

- (void)animateTypefaceChange:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        self.nowLabel.alpha = 0;
        self.thenLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self showHideTANTextWithFont:sender];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.thenLabel.alpha = 1;
            self.nowLabel.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)showHideTANTextWithFont:(id)sender
{
        if (!self.nowLabel)
        {
        self.nowLabel = [[UILabel alloc] init];
        self.thenLabel = [[UILabel alloc] init];
        
        [self.nowContainerView addSubview:self.nowLabel];
        [self.nowContainerView addSubview:self.thenLabel];
        
        [self.nowContainerView bringSubviewToFront:self.nowLabel];
        [self.nowContainerView bringSubviewToFront:self.thenLabel];
            
        [self layoutTextLabels];

        }
    
        UIColor *textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        UIButton *senderButton = (UIButton *)sender;
    
        if (!self.labelsFont || senderButton)
        {
            self.labelsFont = [UIFont fontWithName:senderButton.titleLabel.text size:30.0];
        }
        else if (!senderButton && !self.labelsFont)
        {
            self.labelsFont = [UIFont fontWithName:@"Georgia-Bold" size:30.0];
        }
            
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *attr = @{NSForegroundColorAttributeName:textColor, NSFontAttributeName:self.labelsFont, NSParagraphStyleAttributeName:paragraphStyle};
        
        NSString *textForAttributedThenText = @"Then";
        NSString *textForAttributedNowText = @"Now";
        
        NSMutableAttributedString *attributedThenText =
        [[NSMutableAttributedString alloc] initWithString:textForAttributedThenText
                                               attributes:attr];
        
        NSMutableAttributedString *attributedNowText =
        [[NSMutableAttributedString alloc] initWithString:textForAttributedNowText
                                               attributes:attr];
        
        self.thenLabel.attributedText = attributedThenText;
        self.nowLabel.attributedText = attributedNowText;
    
    
//    }
//    else
//    {
//        [self.nowContainerView bringSubviewToFront:self.nowLabel];
//        [self.nowContainerView bringSubviewToFront:self.thenLabel];
//        
//        self.thenLabel.hidden = !self.thenLabel.hidden;
//        self.nowLabel.hidden = !self.nowLabel.hidden;
//    }

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
        self.nowScrollView.minimumZoomScale = 0.2;
        
        [self layoutThenAndNowContainerViews];
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

- (NSArray *)typefaceButtonArray
{
    
    if (!_typefaceButtonArray)
    {
        NSArray *typefaceArray = @[@"Georgia-Bold",@"Verdana",@
                                   "Papyrus", @"SnellRoundhand-Black", @"Zapfino"];
        NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < [typefaceArray count]; i++)
        {
            UIButton *typeFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIColor *textColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:1.0];
            NSString *fontName = (NSString *)typefaceArray[i];
            UIFont *font = [UIFont fontWithName:fontName size:20.0];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            
            paragraphStyle.alignment = NSTextAlignmentLeft;
            
            NSDictionary *attr = @{NSForegroundColorAttributeName:textColor, NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
            
            NSString *textForAttributedText = (NSString *)typefaceArray[i];
            
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:textForAttributedText
                                                   attributes:attr];
            
            [typeFaceButton setAttributedTitle:attributedText forState:UIControlStateNormal];
            [typeFaceButton addTarget:self action:@selector(animateTypefaceChange:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonArray addObject:typeFaceButton];
        }
        
        _typefaceButtonArray = [[NSArray alloc] initWithArray:buttonArray];
    }
    
    return _typefaceButtonArray;
}
@end
