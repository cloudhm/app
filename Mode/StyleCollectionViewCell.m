//
//  StyleCollectionViewCell.m
//  Mode
//
//  Created by huangmin on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "StyleCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "UIButton+WebCache.h"
@implementation StyleCollectionViewCell
-(void)setMstyle:(ModeSysList *)mstyle{
    _mstyle=mstyle;
    [self layoutSubviews];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.name.text = [self.mstyle.name uppercaseString];
    [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.mstyle.picLink] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:[self.mstyle.picLink lastPathComponent] toDisk:YES];
    }];
//    if (![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.mstyle.pic_link lastPathComponent]]) {
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        [manager downloadImageWithURL:[NSURL URLWithString:self.mstyle.pic_link] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            nil;
//        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            [[SDImageCache sharedImageCache] storeImage:image forKey:[self.mstyle.pic_link lastPathComponent] toDisk:YES];
//            [self.button setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.mstyle.pic_link lastPathComponent]] forState:UIControlStateNormal];
//            
//        }];
//    } else {
//        [self.button setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.mstyle.pic_link lastPathComponent]] forState:UIControlStateNormal];
//    }
}
-(void)click:(UIButton*)btn{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"svcToLvc" object:nil userInfo:@{@"mode":@"style",@"category":self.mstyle.name,@"category":self.mstyle.name}];
}

@end
