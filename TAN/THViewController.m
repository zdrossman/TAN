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

//#import "UIImage+Resize.h"

typedef void(^ButtonReplacementBlock)(void);

@interface THViewController () <UINavigationControllerDelegate, THCameraDelegateProtocol, BASSquareCropperDelegate>


@end

@implementation THViewController
-(NSArray *)toolbarButtonsArray
{
    UIBarButtonItem *horizontalSplitButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1074-grid-2"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *alignmentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1074-grid-2"] style:UIBarButtonItemStylePlain target:self action:@selector(choosePosition)];
    
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
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.takingPhoto = NO;
    self.originalOrder = YES;
    self.currentPosition =YES;
    [self baseInit];
    [self setupPhotos];
    [self setupInitialStateOfImageViews];
}

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

- (void)cameraInit
{
    self.cameraVC = [[THCamera2ViewController alloc] init];
    
    [self addChildViewController:self.cameraVC];
    [self.cameraContainerView addSubview:self.cameraVC.view];
    self.cameraContainerView.frame = self.view.bounds;
    self.cameraVC.view.frame = self.cameraContainerView.bounds;
    self.cameraVC.delegate = self;
}

- (void)baseInit
{
    self.nowView = [[UIView alloc] init];
    self.thenView = [[UIView alloc] init];
    self.cameraContainerView = [[UIView alloc] init];
    
    self.thenImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nowImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toolbar = [[UIToolbar alloc] init];
    self.pictureAddition = [[THPictureAddition alloc] init];

    [self.view addSubview:self.cameraContainerView];
    [self.view addSubview:self.nowView];
    [self.view addSubview:self.thenView];
    [self.view addSubview:self.toolbar];
    
    [self.nowView addSubview:self.nowImageView];
    [self.thenView addSubview:self.thenImageView];

    [self.toolbar setItems:self.toolbarButtonsArray];
}


-(void)setupSubviewAutolayout
{
        //TODO: STEVE
}

-(void)setupPhotos
{
    
    if (self.nowImage)
    {
        [self.nowImageView.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.nowImageView setImage:self.nowImage forState:UIControlStateNormal];
        [self.nowImageView addTarget:self
                              action:@selector(setupCropper)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    self.cameraContainerView.hidden = YES;
    self.nowView.hidden = NO;
    self.toolbar.alpha = 1;
    self.toolbar.hidden = NO;
    self.currentPosition = YES;
    [self setVerticalSplit];
    
//    self.nowImageView.layer.backgroundColor = [UIColor redColor].CGColor;
//    self.thenImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;

    //FIXIT: Should i keep this line? self.thenImageView.alpha =1.0;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *testButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Test2" style:UIBarButtonItemStylePlain target:self action:@selector(replaceToolbarWithButtons:)];
    
    UIBarButtonItem *testButton4 = [[UIBarButtonItem alloc] initWithTitle:@"Animate" style:UIBarButtonItemStylePlain target:self action:@selector(performAnimation)];

    UIBarButtonItem *testButton5 = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStylePlain target:self action:@selector(choosePosition)];
    
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)],testButton2, testButton4,testButton5];
    
    [self cameraInit];

}

-(void)choosePosition{
    
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

- (void)setHorizontalSplit
{
    [self removeAllConstraints];
    self.verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_topImageView(==230)][_bottomImageView(==_topImageView)]" options:0 metrics:nil views:self.viewsDictionary];
    
    self.horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topImageView]|" options:0 metrics:nil views:self.viewsDictionary];
    
    self.horizontalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.viewsDictionary];
    
    [self.view addConstraints:self.verticalIVConstraints];
    [self.view addConstraints:self.horizontalDNIVConstraints];
    [self.view addConstraints:self.horizontalDTIVConstraints];
    
    [self generateStandardToolbarConstraints];
    
    [self.view layoutIfNeeded];

}


- (void)setVerticalSplit
{
        [self removeAllConstraints];
        
        self.horizontalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_leftImageView(==160)][_rightImageView(==_leftImageView)]" options:0 metrics:nil views:self.leftRightViewsDictionary];
        self.verticalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_leftImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
        self.verticalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_rightImageView]-(44)-|" options:0 metrics:nil views:self.leftRightViewsDictionary];
        
        [self.view addConstraints:self.horizontalIVConstraints];
        [self.view addConstraints:self.verticalDNIVConstraints];
        [self.view addConstraints:self.verticalDTIVConstraints];
        
        [self generateStandardToolbarConstraints];
        
        [self.view layoutIfNeeded];
    
}



-(void)generateStandardToolbarConstraints{
    
    self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==44)]|" options:0 metrics:nil views:self.viewsDictionary];
    
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
    
    [self.view addConstraints:self.horizontalToolbarConstraints];
    [self.view addConstraints:self.verticalToolbarConstraints];
    
}

- (void)removeAllConstraints
{
    [self.view removeConstraints:self.view.constraints];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;

    self.cameraContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cameraContainerView removeConstraints:self.cameraContainerView.constraints];

    self.thenImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.thenImageView removeConstraints:self.thenImageView.constraints];
    
    self.nowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nowImageView removeConstraints:self.nowImageView.constraints];

    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.toolbar removeConstraints:self.toolbar.constraints];
    
    self.cropperContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cropperContainerView removeConstraints:self.cropperContainerView.constraints];
}

-(NSArray *)verticalCameraConstraints
{
    
    if (!_verticalCameraConstraints)
    {
        _verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(cameraViewTop)-[_cameraView(==cameraViewBottom)]" options:0 metrics:self.metrics views:self.viewsDictionary];
    }
    
    return _verticalCameraConstraints;
}

-(NSArray *)horizontalCameraConstraints
{
    if (!_horizontalCameraConstraints)
    {
        _horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:self.metrics views:self.viewsDictionary];
    }

    return _horizontalCameraConstraints;

}


- (void)setupCameraAutolayout
{
    
//    self.nowImageView.layer.backgroundColor = [UIColor redColor].CGColor;
//    self.thenImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    self.cameraContainerView.hidden = NO;

    [self.view removeConstraints:self.verticalCameraConstraints];
    [self.view removeConstraints:self.horizontalCameraConstraints];

    [self.view addConstraints:self.horizontalCameraConstraints];
    [self.view addConstraints:self.verticalCameraConstraints];
    
    [self.view layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.view removeConstraints:self.horizontalCameraConstraints];
        [self.view removeConstraints:self.verticalCameraConstraints];
        
        self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:self.metrics views:self.viewsDictionary];
        
        self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(cameraViewTop)-[_cameraView(==cameraViewBottomAnimated)]" options:0 metrics:self.metrics views:self.viewsDictionary];
        
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
            self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
            
            self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_cameraView(==524)]" options:0 metrics:nil views:self.viewsDictionary];
            
            self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
            
            self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.viewsDictionary];
            
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
                
                if (self.horizontalDTIVConstraints)
                {
                    [self.view removeConstraints:self.horizontalDTIVConstraints];
                }
                
                if (self.verticalIVConstraints)
                {
                [self.view removeConstraints:self.verticalIVConstraints];
                }
                
                self.horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(25)-[_topImageView]-(142)-|" options:0 metrics:nil views:self.viewsDictionary];
                self.verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(400)-[_topImageView]-(15)-|" options:0 metrics:nil views:self.viewsDictionary];
                [self.view addConstraints:self.horizontalDTIVConstraints];
                [self.view addConstraints:self.verticalIVConstraints];
                
                [self.view layoutIfNeeded];
                
                [self.view bringSubviewToFront:self.thenImageView];
                self.thenImageView.alpha = 1;
                self.thenImageView.hidden = NO;
                self.thenImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                

            }];
    }];
   

    

    
    
    
    self.navigationItem.rightBarButtonItem = nil;
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setupPhotoAutoLayout)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(returnToPhotosFromCamera)];
    

}

-(void)returnToPhotosFromCamera
{
    [self resignCamera];
    
    //[self setupPhotos];
}

-(void)resignCamera{
    
    self.cameraContainerView.hidden = NO;
    
    [self.view removeConstraints:self.horizontalCameraConstraints];
    [self.view removeConstraints:self.verticalCameraConstraints];
    [self.view removeConstraints:self.horizontalToolbarConstraints];
    [self.view removeConstraints:self.verticalToolbarConstraints];
    
    self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
    self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(44)-[_cameraView(==524)]" options:0 metrics:nil views:self.viewsDictionary];
    
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
     self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.viewsDictionary];
    
    [self.view addConstraints:self.horizontalCameraConstraints];
    [self.view addConstraints:self.verticalCameraConstraints];
    [self.view addConstraints:self.verticalToolbarConstraints];
    [self.view addConstraints:self.horizontalToolbarConstraints];
    
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        NSLog(@"Animation called");
        [self removeAllConstraints];
    
        [self.toolbar setItems:self.toolbarButtonsArray animated:NO];
        
        self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
        
        self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(44)-[_cameraView(==480)]" options:0 metrics:nil views:self.viewsDictionary];
       
        [self generateStandardToolbarConstraints];
        [self.view addConstraints:self.horizontalCameraConstraints];
        [self.view addConstraints:self.verticalCameraConstraints];
        
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        self.nowView.hidden = YES;
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self.view removeConstraints:self.horizontalCameraConstraints];
            [self.view removeConstraints:self.verticalCameraConstraints];
            [self.view removeConstraints:self.horizontalToolbarConstraints];
            [self.view removeConstraints:self.verticalToolbarConstraints];
        
            self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
            
            self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(44)-[_cameraView(==0)]" options:0 metrics:nil views:self.viewsDictionary];
            
            [self generateStandardToolbarConstraints];
            
            [self.view addConstraints:self.horizontalCameraConstraints];
            [self.view addConstraints:self.verticalCameraConstraints];
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
         self.thenImageView.alpha =1.0;
            
        }];
    }];



    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setupPhotos)];
    
}


- (void)setupInitialStateOfImageViews
{
    if (!self.nowImage)
    {
        self.thenImage = [UIImage imageNamed:@"testImage"];
        //self.nowImage = [UIImage imageNamed:@"blossom.jpg"];
    }
    
    //    self.nowImageView.image = self.nowImage;
    
//    self.thenImageView.frame = CGRectMake(0,self.view.frame.origin.y + 64, self.view.frame.size.width, (self.view.frame.size.height - 64)/2);
    
    [self.thenImageView.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.thenImageView.clipsToBounds = YES;
    
//    self.thenImageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.nowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.thenImageView setImage:self.thenImage forState:UIControlStateNormal];
    [self.thenImageView addTarget:self action:@selector(setupCropper) forControlEvents:UIControlEventTouchUpInside];
}


- (void)replaceToolbarWithButtons:(ButtonReplacementBlock)buttonReplacementBlock
{
    [self slideToolbarDownWithCompletionBlock:^{
        [self.toolbar setItems:self.toolbarButtonsArray animated:NO];
        [self slideToolbarUpWithCompletionBlock:^{
            NSLog(@"Completed toolbar button update.");
        }];
    }];
}

-(void)slideToolbarDownWithCompletionBlock:(void (^)(void))completionBlock;
{
    
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
        
        [self generateStandardToolbarConstraints];
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        completionBlock();
    }];
}

-(NSDictionary *)viewsDictionary
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
    
    _viewsDictionary = NSDictionaryOfVariableBindings(_topImageView, _bottomImageView, _toolbar, _topLayoutGuide, _cameraView);
    
    
    return _viewsDictionary;
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
    
       _leftRightViewsDictionary = NSDictionaryOfVariableBindings(_leftImageView, _rightImageView,_cameraView);
    
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
        self.thenImageView.alpha = 0;
        
        
    } completion:^(BOOL finished) {
        if (finished)
        {
            
            
            self.thenImageView.transform = CGAffineTransformMakeTranslation(0, 0);
            self.thenImageView.transform = CGAffineTransformScale(self.thenImageView.transform, 1,1);
            
            [UIView animateWithDuration:0.2 animations:^{
                self.thenImageView.alpha = 1;
                
                
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
//        if (!self.nowImageView.image)
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
//            self.thenImageView.alpha = 0;
//            
//            
//        } completion:^(BOOL finished) {
//            if (finished)
//            {
//                
//                
//                self.thenImageView.transform = CGAffineTransformMakeTranslation(50, 800);
//                self.thenImageView.transform = CGAffineTransformScale(self.thenImageView.transform, 0.3,0.3);
//                self.thenImageView.layer.shadowOffset = CGSizeMake(7,7);
//                self.thenImageView.layer.shadowRadius = 5;
//                self.thenImageView.layer.shadowOpacity = 0.5;
//                
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.thenImageView.alpha = .5;
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
//        self.nowImageView.hidden = NO;
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
//            self.thenImageView.alpha = 0;
//            
//        } completion:^(BOOL finished) {
//            if (finished)
//            {
//                
//                
//                self.thenImageView.transform = CGAffineTransformMakeTranslation(0, 504);
//                self.thenImageView.transform = CGAffineTransformScale(self.thenImageView.transform, 1,1);
//                
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.thenImageView.alpha = 1;
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
    //self.nowImageView.hidden = !self.nowImageView.hidden;
}

-(void)didTakePhoto:(UIImage *)image
{
    self.nowImage = image;
    [self.toolbar setItems:self.toolbarButtonsArray animated:NO];
    [self setupPhotos];
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
            self.thenImageView.alpha = 0;
        
            [self.nowImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.nowImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Now"] forState:UIControlStateNormal];
            
            
        } completion:^(BOOL finished) {
            if (finished)
            {
                
                
                self.thenImageView.transform = CGAffineTransformMakeTranslation(0, 504);
                self.thenImageView.transform = CGAffineTransformScale(self.thenImageView.transform, 1,1);
                
                [self.nowImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.nowImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Now"] forState:UIControlStateNormal];

                
                [UIView animateWithDuration:0.2 animations:^{
                    self.thenImageView.alpha = 1;
                    
                    
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
    [self.thenImageView setImage:croppedImage forState:UIControlStateNormal];
    [cropper dismissViewControllerAnimated:NO completion:nil];
}

- (void)squareCropperDidCancelCropInCropper:(BASSquareCropperViewController *)cropper
{
    [cropper dismissViewControllerAnimated:NO completion:nil];
}

- (void)setTextOverlayToImages
{
    [self.thenImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.thenImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Then"] forState:UIControlStateNormal];

    [self.nowImageView setImage:[self.pictureAddition applyTextOverlayToImage:self.nowImage Position:CGPointMake(0,0) TextSize:200.0 Text:@"Now"] forState:UIControlStateNormal];

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

@end
