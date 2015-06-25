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

    [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.brand.picLink] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:[self.brand.picLink lastPathComponent] toDisk:YES];
    }];


}
-(void)click:(UIButton*)btn{
    if (self.brand) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"bvcToLvc" object:nil userInfo:@{@"source":@"brand",@"name":self.brand.name}];
    }
//    if ([self.delegate respondsToSelector:@selector(brandCollectionViewCell:didSelectedWithParams:)]) {
//        [self.delegate brandCollectionViewCell:self didSelectedWithParams:@{@"source":@"brand",@"name":self.brand.name}];
//    }
    
}

@end
