//
//  THPictureAddition.m
//  TAN
//
//  Created by Heidi Anne Kaiulani Hansen on 8/8/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import "THPictureAddition.h"
#import "THViewController.h"



// add bowtie to view
// show result with two polaroids in one screen
// refactor combine images method so it is reuseable and different image features can be added before saving combined image
// change text to have black border

// when textOverlayButton is pressed again should remove the text.  can do more extensible version of text once it's working.
//reset image to previous image, have a boolean with tap method based on the boolean
// also take then image and now image, add polaroids to them, show them on new view combined.


@implementation THPictureAddition

#pragma mark - CoreGraphics
- (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage secondImagePlacement:(CGPoint) xy
{
    UIImage *image = nil;
    
    CGSize newImageSize;
    
    //Default placement, second image immediately to the right of first image
    if(xy.x >= firstImage.size.width){
        newImageSize = CGSizeMake(firstImage.size.width + secondImage.size.width, MAX(firstImage.size.height, secondImage.size.height));
    } else {
        newImageSize = CGSizeMake(firstImage.size.width, firstImage.size.width);
    }
    
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(newImageSize);
    }
    
    [firstImage drawAtPoint:CGPointMake(0, 0)];
    [secondImage drawAtPoint:CGPointMake(xy.x, xy.y)];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage
{
    return [self imageByCombiningImage:firstImage withImage:secondImage secondImagePlacement:CGPointMake(firstImage.size.width, 0)];
}


-(UIImage *)resizeImage:(UIImage *)image ForPolaroidFrame:(CGRect)rect
{
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width - 36, rect.size.height - 92));
    [image drawInRect: CGRectMake(0, 0, rect.size.width - 36, rect.size.height - 92)];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect cropRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    
    UIImage *resizedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return resizedImage;
}

-(UIImage *)applyTextOverlayToImage:(UIImage *)image Position:(CGPoint)position TextSize:(CGFloat)textSize Text:(NSString *)text
{
    UIColor *textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIFont *font = [UIFont systemFontOfSize:textSize];
    NSDictionary *attr = @{NSForegroundColorAttributeName:textColor, NSFontAttributeName:font};
    
    CGSize thetextSize = [text sizeWithAttributes:attr];
    
    // Compute rect to draw the text inside
    CGSize imageSize = image.size;
    
    CGRect textRect = CGRectMake(position.x, position.y, thetextSize.width, thetextSize.height);
    
    // Create the image
    UIGraphicsBeginImageContextWithOptions(imageSize , NO , 0.0f);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [text drawInRect:CGRectIntegral(textRect) withAttributes:attr];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

@end
