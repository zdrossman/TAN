//
//  THCameraDelegateProtocol.h
//  TAN
//
//  Created by Zachary Drossman on 8/3/14.
//  Copyright (c) 2014 Zach Drossman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THCameraDelegateProtocol <NSObject>

-(void)didTakePhoto:(UIImage *)image;

@end