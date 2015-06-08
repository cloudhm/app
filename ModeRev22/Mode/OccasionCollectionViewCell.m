//
//  OccasionCollectionViewCell.m
//  Mode
//
//  Created by huangmin on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "OccasionCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "UIButton+WebCache.h"
@implementation OccasionCollectionViewCell
-(void)setOccasion:(ModeSysList *)occasion{
    _occasion = occasion;
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.name.text = self.occasion.name;
    
    [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.occasion.pic_link] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:[self.occasion.pic_link lastPathComponent] toDisk:YES];
    }];
//    if (![[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.occasion.pic_link lastPathComponent]]) {
//        
//        
//        
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        [manager downloadImageWithURL:[NSURL URLWithString:self.occasion.pic_link] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            nil;
//        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            [[SDImageCache sharedImageCache] storeImage:image forKey:[self.occasion.pic_link lastPathComponent] toDisk:YES];
//            [self.button setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.occasion.pic_link lastPathComponent]] forState:UIControlStateNormal];
//            
//        }];
//    } else {
//        [self.button setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.occasion.pic_link lastPathComponent]] forState:UIControlStateNormal];
//        
//    }
}

-(void)click:(UIButton*)btn{

    if (self.occasion) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ovcToLvc" object:nil userInfo:@{@"mode":@"occasion",@"mode_val":self.occasion.event_id,@"category":self.occasion.name}];
    }
    
}

@end
