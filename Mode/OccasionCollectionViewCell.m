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
    
    self.name.text = [self.occasion.name uppercaseString];
    
    [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.occasion.picLink] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:[self.occasion.picLink lastPathComponent] toDisk:YES];
    }];

}

-(void)click:(UIButton*)btn{
    if (self.occasion) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ovcToLvc" object:nil userInfo:@{@"source":@"occasion",@"name":self.occasion.name}];
    }
//    if ([self.delegate respondsToSelector:@selector(occasionCollectionViewCell:didSelectedWithParams:)]) {
//        [self.delegate occasionCollectionViewCell:self didSelectedWithParams:@{@"source":@"occasion",@"name":self.occasion.name}];
//    }
    
}

@end
