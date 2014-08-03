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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        
        [self loadImageView];
        
    }
    return self;
}


- (void)loadImageView
{

    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.frame = self.bounds;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
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
}


@end
