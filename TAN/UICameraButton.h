//
//  UICameraButton.h
//  cameraButton
//
//  Created by Heidi Anne Kaiulani Hansen on 8/3/14.
//  Copyright (c) 2014 Heidi Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol THCameraButtonDelegate <NSObject>

-(void)takePhotoTapped:(id)sender;

@end

@interface UICameraButton : UIButton

@property (weak, nonatomic) id<THCameraButtonDelegate> delegate;

@property (nonatomic) CGFloat circleWidth;
@property (nonatomic) CGFloat circleHeight;

@end

//
//  UICameraButton.h
//  cameraButton
//
//  Created by Heidi Anne Kaiulani Hansen on 8/3/14.
//  Copyright (c) 2014 Heidi Hansen. All rights reserved.
//

//#import <UIKit/UIKit.h>
//

//
//@interface UICameraButton : UIButton
//
//@property (nonatomic) CGRect cameraFrame;
//
//-(instancetype)initWithX:(CGFloat)x Y:(CGFloat)y Width:(CGFloat)circleWidth Height:(CGFloat)circleHeight;
//
//@end
