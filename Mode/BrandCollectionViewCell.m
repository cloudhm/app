//
//  BrandCollectionViewCell.m
//  Mode
//
//  Created by huangmin on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "BrandCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@implementation BrandCollectionViewCell
-(void)setBrand:(ModeSysList *)brand{
    _brand=brand;
    [self layoutSubviews];
}
-(void)layoutSubviews{
    [super layoutSubviews];
//        self.name.text = self.brand.name;
    [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.brand.picLink] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:[self.brand.picLink lastPathComponent] toDisk:YES];
    }];
//    if (![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.brand.pic_link lastPathComponent]]) {
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        [manager downloadImageWithURL:[NSURL URLWithString:self.brand.pic_link] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            nil;
//        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            
//            [[SDImageCache sharedImageCache] storeImage:image forKey:[self.brand.pic_link lastPathComponent] toDisk:YES];
//            [self.button setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.brand.pic_link lastPathComponent]] forState:UIControlStateNormal];
//            
//        }];
//    } else {
//        [self.button setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.brand.pic_link lastPathComponent]] forState:UIControlStateNormal];
//        
//    }

}
-(void)click:(UIButton*)btn{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"bvcToLvc" object:nil userInfo:@{@"mode":@"brand",@"category":self.brand.name}];
}
@end
