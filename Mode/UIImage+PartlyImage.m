//
//  UIImage+PartlyImage.m
//  OhterImageView
//
//  Created by huangmin on 15/6/14.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "UIImage+PartlyImage.h"
#define SCALE (1.0/5.0)
@implementation UIImage (PartlyImage)
+(UIImage*)getSubImageByImage:(UIImage*)image{
    NSLog(@"%@",NSStringFromCGSize(image.size));
    float scale = image.size.width/image.size.height;
    CGRect rect = CGRectZero;
    if (scale >=  SCALE) {
        rect = CGRectMake((image.size.width - image.size.height* SCALE)/2, 0.f, image.size.height*SCALE, image.size.height);
    } else {
        rect = CGRectMake(0, (image.size.height - image.size.width/SCALE)/2, image.size.width, image.size.width/SCALE);
    }
    CGImageRef subImage = CGImageCreateWithImageInRect(image.CGImage,rect);
    UIImage* newImage = [UIImage imageWithCGImage:subImage];
    CGImageRelease(subImage);
    return newImage;
}
@end
