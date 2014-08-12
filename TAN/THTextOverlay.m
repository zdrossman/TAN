//
//  THTextOverlay.m
//  TAN
//
//  Created by Zachary Drossman on 8/11/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THTextOverlay.h"

@implementation THTextOverlay

-(instancetype)init
{
    return [self initWithImageText:@"DEFAULT TEXT" Font:[UIFont systemFontOfSize:20] FontSize:20 TextAlignment:NSTextAlignmentLeft ForViewFrameToDrawIn:CGRectMake(0,0,100,100)];
}

-(instancetype)initWithImageText:(NSString *)imageText Font:(UIFont *)font FontSize:(CGFloat)textSize TextAlignment:(NSTextAlignment)textAlignment ForViewFrameToDrawIn:(CGRect)viewFrameToDrawIn
{
    self = [super init];
    if (self) {
        _imageText = imageText;
        _font = font;
        _textSize = textSize;
        _viewFrameToDrawIn = viewFrameToDrawIn;
        _textAlignment = textAlignment;
    }
    return self;
}

-(UIImage *)imageFromText
{
    UIColor *textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIFont *font = [UIFont systemFontOfSize:self.textSize];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

    paragraphStyle.alignment = NSTextAlignmentRight;
    
    NSDictionary *attr = @{NSForegroundColorAttributeName:textColor, NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize thetextSize = [self.imageText sizeWithAttributes:attr];
    
    // Compute rect to draw the text inside
    CGSize viewSize = self.viewFrameToDrawIn.size;
    
    CGRect textRect = CGRectMake(self.viewFrameToDrawIn.origin.x, self.viewFrameToDrawIn.origin.y, thetextSize.width, thetextSize.height);
    
    // Create the image
    UIGraphicsBeginImageContextWithOptions(textRect.size , NO , 0.0f);
    CGContextClearRect(UIGraphicsGetCurrentContext(), textRect);
    [self.imageText drawInRect:textRect withAttributes:attr];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
    
}

@end
