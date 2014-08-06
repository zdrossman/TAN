//
//  THDraggableImageView.m
//  TAN
//
//  Created by Zachary Drossman on 8/1/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THDraggableImageView.h"

@interface THDraggableImageView ()

@property (strong, nonatomic) UIImageView *imageView;

@end


@implementation THDraggableImageView

-(id)init
{
    self = [super init];
    if (self)
    {
        [self addSubview:self.imageView];
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.imageView.image = nil;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self loadImageView];
        
    }
    return self;
}


- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithImage:self.image];
    }
    
    return _imageView;
}
/*
 // Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setImage:(UIImage *)image
{
    _image = image;
    [self refresh];
}

-(void)setTextSize:(CGFloat)textSize
{
    _textSize = textSize;
    [self refresh];
}

-(void)setImageText:(NSString *)imageText
{
    _imageText = imageText;
    [self refresh];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)refresh {
    self.imageView.image = self.image;
    self.imageView.backgroundColor = [UIColor yellowColor];
    self.imageView.frame = self.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

-(UIImage *)applyOverlayToImage:(UIImage *)image withPostion:(CGPoint)postion withTextSize:(CGFloat)textSize withText:(NSString *)text{
    
    NSString *textToDraw = text;
    UIColor *textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIFont *font = [UIFont systemFontOfSize:textSize];
    
    // Compute rect to draw the text inside
    CGSize imageSize = image.size;
    
    
    NSDictionary *attr = @{NSForegroundColorAttributeName: textColor, NSFontAttributeName: font};
    CGSize thetextSize = [textToDraw sizeWithAttributes:attr];
    
    
    CGRect textRect = CGRectMake(imageSize.width - thetextSize.width -postion.x, imageSize.height - thetextSize.height - postion.y, thetextSize.width, thetextSize.height);
    
    
    
    
    // Create the image
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0f);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [textToDraw drawInRect:CGRectIntegral(textRect) withAttributes:attr];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return resultImage;
    
    
    
}


@end
