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
#import <QuartzCore/QuartzCore.h>
//#import "UIImage+Resize.h"

typedef void(^ButtonReplacementBlock)(void);

@interface THViewController ()

#pragma mark - Object Properties
@property (strong, nonatomic) THDraggableImageView *draggableThenImageView;
@property (strong, nonatomic) THDraggableImageView *draggableNowImageView;
@property (strong, nonatomic) THCamera2ViewController *cameraVC;
@property (strong, nonatomic) UIView *cameraContainerView;
@property (strong, nonatomic) UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) NSArray *toolbarButtonsArray;
@property (strong, nonatomic) UIImage *thenImage;
@property (strong, nonatomic) UIImage *nowImage;

#pragma mark - LayoutConstraint Properties
@property (strong, nonatomic) NSDictionary *viewsDictionary;
@property (strong, nonatomic) NSArray *horizontalToolbarConstraints;
@property (strong, nonatomic) NSArray *verticalToolbarConstraints;
@property (strong, nonatomic) NSArray *verticalCameraConstraints;
@property (strong, nonatomic) NSArray *horizontalCameraConstraints;
@property (strong, nonatomic) NSArray *horizontalDTIVConstraints;
@property (strong, nonatomic) NSArray *horizontalDNIVConstraints;
@property (strong, nonatomic) NSArray *verticalIVConstraints;
@property (strong, nonatomic) NSDictionary *metrics;

#pragma mark - Other Properties
@property (nonatomic) BOOL takingPhoto;
@property (nonatomic) BOOL originalOrder;
@end

@implementation THViewController

-(NSArray *)toolbarButtonsArray
{
    UIBarButtonItem *alignmentButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1074-grid-2"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *textOverlay = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"1174-choose-font-toolbar"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    _toolbarButtonsArray = @[alignmentButton, textOverlay];
    
    return _toolbarButtonsArray;
}

-(NSDictionary *)metrics{
 
    if (!_metrics)
    {
        _metrics = @{};
    }
    
    return _metrics;
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.takingPhoto = NO;
    self.originalOrder = YES;
    [self baseInit];
    [self setupPhotos];
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

//    UIImage *funnyBaby = [UIImage imageNamed:@"funnyBabyPNG"];
//    self.nowImageView = [[UIImageView alloc] initWithImage:funnyBaby];
//    [self.view addSubview:self.nowImageView];
//    self.nowImageView.frame = CGRectMake(0,264,funnyBaby.size.width/2,funnyBaby.size.height/2);
//    UIImage *funnyBabyWithText = [self applyOverlayToImage:funnyBaby Position:CGPointMake(250, 300) TextSize:20.0 Text:@"BABY"];
//    
//    
//    self.nowImageView.image = funnyBabyWithText;
//    [self.view bringSubviewToFront:self.nowImageView];
//    self.nowImageView.layer.backgroundColor = [UIColor blueColor].CGColor;
    
    [self addChildViewController:self.cameraVC];
    [self.cameraContainerView addSubview:self.cameraVC.view];
    self.cameraContainerView.frame = self.view.bounds;
    self.cameraVC.view.frame = self.cameraContainerView.bounds;
    self.cameraVC.delegate = self;
    
    [self.toolbar setItems:self.toolbarButtonsArray];
    
    self.draggableNowImageView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.draggableThenImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    
}

-(void)setupPhotos
{
    self.cameraContainerView.hidden = YES;
    self.draggableNowImageView.hidden = NO;
    self.toolbar.alpha = 1;
    self.toolbar.hidden = NO;
    
    self.draggableNowImageView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.draggableThenImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    
    [self removeAllConstraints];
    
    self.verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_topImageView(==230)][_bottomImageView(==_topImageView)]" options:0 metrics:nil views:self.viewsDictionary];
    
    self.horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topImageView]|" options:0 metrics:nil views:self.viewsDictionary];
    
    self.horizontalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.viewsDictionary];
    

    
    [self.view addConstraints:self.verticalIVConstraints];
    [self.view addConstraints:self.horizontalDNIVConstraints];
    [self.view addConstraints:self.horizontalDTIVConstraints];
    
    [self generateStandardToolBarConstraints];
    
    [self.view layoutIfNeeded];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStylePlain target:self action:@selector(slideToolbarDownWithCompletionBlock:)];
    
    UIBarButtonItem *testButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Test2" style:UIBarButtonItemStylePlain target:self action:@selector(replaceToolbarWithButtons:)];
    
    UIBarButtonItem *testButton3 = [[UIBarButtonItem alloc] initWithTitle:@"Test3" style:UIBarButtonItemStylePlain target:self action:@selector(thenAndNowswitch)];
    
    UIBarButtonItem *testButton4 = [[UIBarButtonItem alloc] initWithTitle:@"test4" style:UIBarButtonItemStylePlain target:self action:@selector(reverseThenAndNowSwitch)];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)],testButton2, testButton3, testButton4];
}

-(void)thenAndNowswitch{
    
    if (!self.originalOrder)
    {
        [self.view bringSubviewToFront:self.draggableThenImageView];
    }
    else
    {
        [self.view bringSubviewToFront:self.draggableNowImageView];
    }
    
    self.draggableNowImageView.layer.shadowOffset = CGSizeMake(0,0);
    self.draggableNowImageView.layer.shadowRadius = 25;
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
        NSLog(@"Animation for setupPhotos called");
        

        
//        self.draggableThenImageView.layer.shadowOffset = CGSizeMake(20,50);
//        self.draggableThenImageView.layer.shadowRadius = 50;
//        self.draggableThenImageView.layer.shadowOpacity = 1;
//        
        [self.view removeConstraints:self.horizontalDTIVConstraints];
        [self.view removeConstraints:self.verticalIVConstraints];
        [self.view removeConstraints:self.horizontalDNIVConstraints];
        
        self.horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topImageView(==290)]-(15)-|" options:0 metrics:nil views:self.viewsDictionary];
        self.horizontalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.viewsDictionary];
        self.verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(79)-[_topImageView(==200)]-(15)-[_bottomImageView(==230)]" options:0 metrics:nil views:self.viewsDictionary];
        

        
        [self.view addConstraints:self.horizontalDTIVConstraints];
        [self.view addConstraints:self.verticalIVConstraints];
        [self.view addConstraints:self.horizontalDNIVConstraints];
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
       
        [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            NSLog(@"Animation for setupPhotos called");
            [self removeAllConstraints];
            
            self.horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[_topImageView(==290)]-(15)-|" options:0 metrics:nil views:self.viewsDictionary];
            
            self.verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomImageView(==230)]-(15)-[_topImageView(==200)]" options:0 metrics:nil views:self.viewsDictionary];
            
            self.horizontalDNIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomImageView]|" options:0 metrics:nil views:self.viewsDictionary];
            
            
            [self generateStandardToolBarConstraints];
            [self.view addConstraints:self.horizontalDTIVConstraints];
            [self.view addConstraints:self.horizontalDNIVConstraints];
            [self.view addConstraints:self.verticalIVConstraints];
            
            [self.view layoutIfNeeded];
        
        } completion:^(BOOL finished) {
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            anim.fromValue = [NSNumber numberWithFloat:1.0];
            anim.toValue = [NSNumber numberWithFloat:0.0];
            anim.duration = 0.3;
            [self.draggableNowImageView.layer addAnimation:anim forKey:@"shadowOpacity"];
            self.draggableNowImageView.layer.shadowOpacity = 0.0;
            
              [UIView animateWithDuration:.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                  [self.view removeConstraints:self.horizontalDTIVConstraints];
                  [self.view removeConstraints:self.verticalIVConstraints];
                  
                  self.horizontalDTIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topImageView]|" options:0 metrics:nil views:self.viewsDictionary];
                  self.verticalIVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(64)-[_bottomImageView(==230)][_topImageView(==230)]" options:0 metrics:nil views:self.viewsDictionary];
                  
                  
                  self.draggableNowImageView.layer.shadowOffset = CGSizeMake(0,0);
//                  self.draggableNowImageView.layer.shadowRadius = 0;
//                  self.draggableNowImageView.layer.shadowOpacity = 0;

                  
                  [self.view addConstraints:self.horizontalDTIVConstraints];
                  [self.view addConstraints:self.verticalIVConstraints];
                
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
    [self.draggableNowImageView.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.draggableNowImageView.layer.shadowOpacity = 1.0;

    
    
}



-(void)generateStandardToolBarConstraints{
    
    self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==44)]|" options:0 metrics:nil views:self.viewsDictionary];
    
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
    
    [self.view addConstraints:self.horizontalToolbarConstraints];
    [self.view addConstraints:self.verticalToolbarConstraints];
    
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
//    self.cameraContainerView.backgroundColor = [UIColor greenColor];
//    self.cameraVC.view.backgroundColor = [UIColor orangeColor];
    self.cameraContainerView.hidden = NO;

    [self removeAllConstraints];
    
    NSDictionary *metrics = @{@"cameraViewTop":@64, @"cameraViewBottom":@0, @"toolbarHeight":@44, @"cameraViewBottomAnimated":@460};

    __block NSArray *horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:metrics views:self.viewsDictionary];
    
    __block NSArray *verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(cameraViewTop)-[_cameraView(==cameraViewBottom)]" options:0 metrics:metrics views:self.viewsDictionary];
    
    __block NSArray *horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:metrics views:self.viewsDictionary];
    
    __block NSArray *verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==toolbarHeight)]|" options:0 metrics:metrics views:self.viewsDictionary];
    
    [self.view addConstraints:horizontalCameraConstraints];
    [self.view addConstraints:verticalCameraConstraints];
    [self.view addConstraints:verticalToolbarConstraints];
    [self.view addConstraints:horizontalToolbarConstraints];
    
    [self.view layoutIfNeeded];
    
//    self.draggableThenImageView.hidden = YES;
//    self.draggableThenImageView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self removeAllConstraints];
        
        horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:metrics views:self.viewsDictionary];
        
        verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(cameraViewTop)-[_cameraView(==cameraViewBottomAnimated)]" options:0 metrics:metrics views:self.viewsDictionary];

        verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==toolbarHeight)]|" options:0 metrics:metrics views:self.viewsDictionary];
        
        horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:metrics views:self.viewsDictionary];
   
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
        
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            //TODO: Finish animation of camera downward / toolbar downward.
            [self removeAllConstraints];
            
            [self.toolbar setItems:nil animated:YES];
            horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
            
            verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(44)-[_cameraView(==524)]" options:0 metrics:nil views:self.viewsDictionary];
            
            horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
            
            verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.viewsDictionary];
            
            [self.view addConstraints:horizontalCameraConstraints];
            [self.view addConstraints:verticalCameraConstraints];
            [self.view addConstraints:horizontalToolbarConstraints];
            [self.view addConstraints:verticalToolbarConstraints];
            
            [self.view layoutIfNeeded];
            
            }completion:^(BOOL finished) {
                self.draggableNowImageView.hidden = YES;
            }];
    }];
   

    

    
    
    
    self.navigationItem.rightBarButtonItem = nil;
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setupPhotoAutoLayout)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(returnToPhotosFromCamera)];
    

}

-(void)returnToPhotosFromCamera
{
    [self resignCamera];
    [self setupPhotos];
}

-(void)resignCamera{
    
    self.draggableNowImageView.layer.backgroundColor = [UIColor redColor].CGColor;
    self.draggableThenImageView.layer.backgroundColor = [UIColor yellowColor].CGColor;
//    self.cameraContainerView.backgroundColor = [UIColor greenColor];
//    self.cameraVC.view.backgroundColor = [UIColor orangeColor];
    self.cameraContainerView.hidden = NO;
    
    [self removeAllConstraints];
    
    self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
    self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(44)-[_cameraView(==524)]" options:0 metrics:nil views:self.viewsDictionary];
    
    self.horizontalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_toolbar]|" options:0 metrics:nil views:self.viewsDictionary];
     self.verticalToolbarConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(==0)]|" options:0 metrics:nil views:self.viewsDictionary];
    
    [self.view addConstraints:self.horizontalCameraConstraints];
    [self.view addConstraints:self.verticalCameraConstraints];
    [self.view addConstraints:self.verticalToolbarConstraints];
    [self.view addConstraints:self.horizontalToolbarConstraints];
    
    [self.view layoutIfNeeded];
    
    self.draggableThenImageView.hidden = YES;
    self.draggableThenImageView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        NSLog(@"Animation called");
        [self removeAllConstraints];
    
        //[self.toolbar setItems:nil animated:YES];
        

        
        self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
        
        self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(44)-[_cameraView(==480)]" options:0 metrics:nil views:self.viewsDictionary];
        
       
        [self generateStandardToolBarConstraints];
        [self.view addConstraints:self.horizontalCameraConstraints];
        [self.view addConstraints:self.verticalCameraConstraints];
        

        
        [self.view layoutIfNeeded];
        
    }completion:^(BOOL finished) {
        self.draggableNowImageView.hidden = YES;
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [self removeAllConstraints];
            
        
            self.horizontalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cameraView]|" options:0 metrics:nil views:self.viewsDictionary];
            
            self.verticalCameraConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topLayoutGuide]-(44)-[_cameraView(==0)]" options:0 metrics:nil views:self.viewsDictionary];

            
            [self generateStandardToolBarConstraints];
            
            [self.view addConstraints:self.horizontalCameraConstraints];
            [self.view addConstraints:self.verticalCameraConstraints];
            
            [self.view layoutIfNeeded];
            
            //TODO: Add constraints for moving THENphoto to "preview"
            [self.view bringSubviewToFront:self.draggableThenImageView];
            self.draggableThenImageView.alpha = 0.5;
            self.draggableThenImageView.hidden = NO;
            
        } completion:^(BOOL finished) {
            
        }];
    }];



    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(setupPhotos)];
    
}


- (void)setupInitialStateOfImageViews
{
    if (!self.nowImage)
    {
        self.thenImage = [UIImage imageNamed:@"funnyBabyPNG"];
        self.nowImage = [UIImage imageNamed:@"blossom.jpg"];
    }
    
    //    self.draggableNowImageView.image = self.nowImage;
    
//    self.draggableThenImageView.frame = CGRectMake(0,self.view.frame.origin.y + 64, self.view.frame.size.width, (self.view.frame.size.height - 64)/2);
    
    self.draggableThenImageView.clipsToBounds = YES;
    
    self.draggableNowImageView.name = @"NOW";
    self.draggableThenImageView.name = @"THEN";
    
    self.draggableNowImageView.snapToFrame = AVMakeRectWithAspectRatioInsideRect(self.thenImage.size, self.draggableThenImageView.frame);
    
    self.draggableThenImageView.snapToFrame = AVMakeRectWithAspectRatioInsideRect(self.thenImage.size, self.draggableNowImageView.frame);
    
    self.draggableThenImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.draggableNowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.draggableThenImageView.image = self.thenImage;

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
        
        [self generateStandardToolBarConstraints];
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        completionBlock();
    }];
}

-(NSDictionary *)viewsDictionary
{
    id _cameraView = self.cameraContainerView;
    id _topLayoutGuide = self.topLayoutGuide;
    id _topImageView = self.draggableThenImageView;
    id _bottomImageView = self.draggableNowImageView;
    
    if (self.originalOrder)
    {
        _topImageView = self.draggableThenImageView;
        _bottomImageView = self.draggableNowImageView;
    }
    else
    {
        _bottomImageView = self.draggableThenImageView;
        _topImageView = self.draggableNowImageView;
    }
    
    _viewsDictionary = NSDictionaryOfVariableBindings(_topImageView, _bottomImageView, _toolbar, _topLayoutGuide, _cameraView);
    
    
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
            
            self.draggableNowImageView.image = [self.draggableNowImageView applyOverlayToImage:self.draggableNowImageView.image withposition:CGPointMake(0,0) withTextSize:200.0 withText:@"Now"];
            
            
        } completion:^(BOOL finished) {
            if (finished)
            {
                
                
                self.draggableThenImageView.transform = CGAffineTransformMakeTranslation(0, 504);
                self.draggableThenImageView.transform = CGAffineTransformScale(self.draggableThenImageView.transform, 1,1);
                
                self.draggableThenImageView.image = [self.draggableThenImageView applyOverlayToImage:self.thenImage withposition:CGPointMake(0,0) withTextSize:60.0 withText:@"Then"];
                
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

-(UIImage *)applyOverlayToImage:(UIImage *)image Position:(CGPoint)position TextSize:(CGFloat)textSize Text:(NSString *)text{
    
    UIColor *textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIFont *font = [UIFont systemFontOfSize:textSize];
    NSDictionary *attr = @{NSForegroundColorAttributeName: textColor, NSFontAttributeName: font};

    CGSize thetextSize = [text sizeWithAttributes:attr];

    // Compute rect to draw the text inside
    CGSize imageSize = image.size;
    
    CGRect textRect = CGRectMake(position.x, position.y, thetextSize.width, thetextSize.height);
    
    // Create the image
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0f);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [text drawInRect:CGRectIntegral(textRect) withAttributes:attr];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
    
    
    
}

@end
