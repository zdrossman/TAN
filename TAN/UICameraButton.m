//
//  UICameraButton.m
//  cameraButton
//
//  Created by Heidi Anne Kaiulani Hansen on 8/3/14.
//  Copyright (c) 2014 Heidi Hansen. All rights reserved.
//

#import "UICameraButton.h"

@implementation UICameraButton

//adjust the init so the rect can be changed
// refactor the code inside the init? break into smaller methods

- (id)init
{
    return [[UICameraButton alloc] initWithX:126 Y:415 Width:70 Height:70];
}

-(instancetype)initWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)circleWidth Height:(CGFloat)circleHeight
{
    CGRect rectVar = CGRectMake(x, y, circleWidth, circleHeight);
    self = [super initWithFrame:rectVar];
    
    if (self) {
        self.cameraFrame = rectVar;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraButtonTapped:)];
        
        self.backgroundColor = [UIColor blueColor];
        self.layer.borderWidth = 6;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.opacity = 0.5;
        self.layer.cornerRadius = self.cameraFrame.size.width / 2;
        [self addGestureRecognizer:tap];
        
        //sets inner circle frame
        CGFloat borderDim = self.layer.borderWidth;
        CGRect circFrame = CGRectMake((0 + borderDim), (0 + borderDim), (self.cameraFrame.size.width - (borderDim *2)), (self.cameraFrame.size.height - (borderDim *2)));
        
        //creates inner circle
        UIView *innerCircle = [[UIView alloc]init];
        innerCircle.frame = circFrame;
        innerCircle.backgroundColor = [UIColor whiteColor];
        innerCircle.layer.cornerRadius = circFrame.size.width / 2;
        innerCircle.layer.borderColor = [UIColor blackColor].CGColor;
        innerCircle.layer.borderWidth = 2;
        [innerCircle addGestureRecognizer:tap];
        [self addSubview:innerCircle];
    }
    return self;
}


-(void)cameraButtonTapped:(id)sender
{
    [self.delegate takePhotoTapped:sender];
}

@end










////
////  UICameraButton.m
////  cameraButton
////
////  Created by Heidi Anne Kaiulani Hansen on 8/3/14.
////  Copyright (c) 2014 Heidi Hansen. All rights reserved.
////
//
//#import "UICameraButton.h"
//
//@interface UICameraButton ()
//
//@property (nonatomic) CGRect cameraFrame;
//
//@end
//
//@implementation UICameraButton
//
////try to make background of button transparent
////adjust the init so the rect can be changed
//// refactor the code inside the init?
////
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if ((self = [super initWithCoder:aDecoder])) {
//        
//        [self baseInitWithWidth:self.circleWidth andHeight:self.circleHeight];
//        
//    }
//    return self;
//}
//
//-(void)awakeFromNib
//{
//    [self baseInitWithWidth:self.circleWidth andHeight:self.circleHeight];
//}
//
////created custom init instead of initWithFrame because
//-(void)baseInitWithWidth:(CGFloat)circleWidth andHeight:(CGFloat)circleHeight
//{
//    CGRect rectVar = CGRectMake(0, 0, circleWidth, circleHeight);
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraButtonTapped:)];
//        
//        self.cameraFrame = rectVar;
//
//        self.backgroundColor = [UIColor blueColor];
//        self.layer.borderWidth = 6;
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.layer.opacity = 0.5;
//        self.layer.cornerRadius = self.cameraFrame.size.width / 2;
//        [self addGestureRecognizer:tap];
//        
//        //sets inner circle frame
//        CGFloat borderDim = self.layer.borderWidth;
//        CGRect circFrame = CGRectMake((0 + borderDim), (0 + borderDim), (self.cameraFrame.size.width - (borderDim *2)), (self.cameraFrame.size.height - (borderDim *2)));
//        
//        
//        //creates inner circle
//        UIView *innerCircle = [[UIView alloc]init];
//        innerCircle.frame = circFrame;
//        innerCircle.backgroundColor = [UIColor whiteColor];
//        innerCircle.layer.cornerRadius = circFrame.size.width / 2;
//        innerCircle.layer.borderColor = [UIColor blackColor].CGColor;
//        innerCircle.layer.borderWidth = 2;
//        [innerCircle addGestureRecognizer:tap];
//        [self addSubview:innerCircle];
//   
//}
//
//-(IBAction)cameraButtonTapped:(id)sender
//{
//    NSLog(@"Camera Button Tapped");
//}
//
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
//}
//*/
//
//@end
