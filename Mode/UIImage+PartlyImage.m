//
//  UIImage+PartlyImage.m
//  OhterImageView
//
//  Created by huangmin on 15/6/14.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "UIImage+PartlyImage.h"
#define DEFAULT_FRAME CGRectMake(0,0,300,400)
@implementation UIImage (PartlyImage)
+(UIImage*)getSubImageByImage:(UIImage*)image{
    return [self getSubImageByImage:image andImageViewFrame:DEFAULT_FRAME];
}
+(UIImage*)getSubImageByImage:(UIImage *)image andImageViewFrame:(CGRect)imageViewFrame{
    float defaultScale = imageViewFrame.size.width/imageViewFrame.size.height;
    float scale = image.size.width/image.size.height;
    CGRect rect = CGRectZero;
    if (scale >=  defaultScale) {
        rect = CGRectMake((image.size.width - image.size.height* defaultScale)/2, 0.f, image.size.height*defaultScale, image.size.height);
    } else {
        rect = CGRectMake(0, (image.size.height - image.size.width/defaultScale)/2, image.size.width, image.size.width/defaultScale);
    }
    CGImageRef subImage = CGImageCreateWithImageInRect(image.CGImage,rect);
    UIImage* newImage = [UIImage imageWithCGImage:subImage];
    CGImageRelease(subImage);
    return newImage;
}
@end
