//
//  THTextOverlay.h
//  TAN
//
//  Created by Zachary Drossman on 8/11/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THTextOverlay : UIView

@property (strong, nonatomic) NSString *imageText;
@property (nonatomic) CGFloat textSize;
@property (strong, nonatomic) UIFont *font;
@property (nonatomic) CGRect viewFrameToDrawIn;
@property (nonatomic) NSTextAlignment textAlignment;

-(instancetype)initWithImageText:(NSString *)imageText Font:(UIFont *)font FontSize:(CGFloat)textSize TextAlignment:(NSTextAlignment)textAlignment ForViewFrameToDrawIn:(CGRect)viewFrameToDrawIn;
-(UIImage *)imageFromText;

@end
