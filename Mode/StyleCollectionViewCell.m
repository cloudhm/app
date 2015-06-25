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
#import "SDWebImageManager.h"
@implementation StyleCollectionViewCell
-(void)setMstyle:(ModeSysList *)mstyle{
    _mstyle=mstyle;
    [self layoutSubviews];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.name.text = [self.mstyle.name uppercaseString];
    [self.button sd_setBackgroundImageWithURL:[NSURL URLWithString:self.mstyle.picLink] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        if(!error) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:[self.mstyle.picLink lastPathComponent] toDisk:YES];
        }
        NSLog(@"%ld,%@",cacheType,error);
        

    }];

}
-(void)click:(UIButton*)btn{
    if (self.mstyle) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"svcToLvc" object:nil userInfo:@{@"source":@"style",@"name":self.mstyle.name}];
    }
    
//    if ([self.delegate respondsToSelector:@selector(styleCollectionViewCell:didSelectedWithParams:)]) {
//        [self.delegate styleCollectionViewCell:self didSelectedWithParams:@{@"source":@"style",@"name":self.mstyle.name}];
//    }
    
}


@end
