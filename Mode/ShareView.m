//
//  ShareView.m
//  Mode
//
//  Created by YedaoDEV on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ShareView.h"
#import "ModeGood.h"
#import "SDWebImage/SDWebImageManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface ShareView()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *shareImageViews;
@property (weak, nonatomic) IBOutlet UITextView *shareTextContent;



@end
@implementation ShareView


-(void)layoutSubviews{
    [super layoutSubviews];

    for (int i = 0; i<self.shareImageViews.count; i++) {
        ModeGood* modeGood = self.nineGoods[i];
        UIImageView*iv=self.shareImageViews[i];
        iv.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[modeGood.img_link lastPathComponent]];
//        [iv sd_setImageWithURL:[NSURL URLWithString:modeGood.img_link] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [[SDImageCache sharedImageCache]storeImage:image forKey:[modeGood.img_link lastPathComponent] toDisk:YES];
//        }];
        
        
//        if (![[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[modeGood.img_link lastPathComponent]]) {
//            [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:modeGood.img_link] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                NSLog(@"%d//%d",(int)receivedSize,(int)expectedSize);
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                [[SDImageCache sharedImageCache]storeImage:image forKey:[modeGood.img_link lastPathComponent] toDisk:YES];
//                iv.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[modeGood.img_link lastPathComponent]];
//            }];
//        } else {
//            iv.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[modeGood.img_link lastPathComponent]];
//        }
        
    }
}
- (IBAction)sendShareAndPostNotification:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shareView:shareNineModeGoodsToOthers:andTextContent:)]) {
        [self.delegate shareView:self shareNineModeGoodsToOthers:self.nineGoods andTextContent:self.shareTextContent.text];
    }
}

@end
