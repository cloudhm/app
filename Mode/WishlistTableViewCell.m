//
//  WishlistTableViewCell.m
//  Mode
//
//  Created by YedaoDEV on 15/6/3.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WishlistTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIImage+PartlyImage.h"
#import "GoodItem.h"

@implementation WishlistTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!self.commentLabel) {
        self.commentLabel = [[UILabel alloc]init];
        self.commentLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        self.commentLabel.textColor = [UIColor blackColor];
        self.commentLabel.numberOfLines = 0;
        [self.contentView addSubview: self.commentLabel];
    }
    if (!self.iconIV) {
        self.iconIV = [[UIImageView alloc]init];
        
        [self.contentView addSubview: self.iconIV];
    }
    
}

-(void)setCollectionInfo:(CollectionInfo *)collectionInfo{
    _collectionInfo = collectionInfo;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)layoutSubviews{
    [super layoutSubviews];

    self.commentLabel.text = self.collectionInfo.comments;
    float commentLabelW = (CGRectGetWidth(self.bounds)-80.f-10.f);
    float commentLabelH = [self.collectionInfo getCommentHeightByLabelWidth:commentLabelW];

    self.commentLabel.frame = CGRectMake(80.f, 10.f, commentLabelW, commentLabelH);
    
    self.iconIV.frame =CGRectMake(15.f, 10.f, 50.f, 50.f);
    self.iconIV.layer.cornerRadius = self.iconIV.bounds.size.width/2;
    self.iconIV.layer.borderWidth = 1.5f;
    self.iconIV.layer.borderColor = [UIColor clearColor].CGColor;
    self.iconIV.layer.masksToBounds = YES;
    

//    [self.shareIV sd_setImageWithURL:[NSURL URLWithString:self.collectionInfo.defaultThumb] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.shareIV.image = [UIImage getSubImageByImage:image];
//        NSLog(@"%@",NSStringFromCGRect(self.shareIV.frame));
//        [[SDImageCache sharedImageCache]storeImage:image forKey:[self.collectionInfo.defaultThumb lastPathComponent] toDisk:YES];
//    }];
    for (int i = 0; i <self.defaultImages.count;i++) {
        UIImageView* imageView = self.defaultImages[i];
        GoodItem* goodItem = self.collectionInfo.collectionItems[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:goodItem.defaultThumb] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imageView.image = [UIImage getSubImageByImage:image andImageViewFrame:imageView.bounds];
            [[SDImageCache sharedImageCache]storeImage:image forKey:[goodItem.defaultThumb lastPathComponent] toDisk:YES];
        }];
    }

    self.iconIV.image = [UIImage imageNamed:@"headPortraitThumbnail.png"];
//    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:self.modeWishlist.img_link] placeholderImage:[UIImage imageNamed:@"headPortraitThumbnail.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.iconIV.image = [UIImage getSubImageByImage:image andImageViewFrame:self.iconIV.frame];
//        [[SDImageCache sharedImageCache]storeImage:image forKey:[self.modeWishlist.img_link lastPathComponent] toDisk:YES];
//    }];

    self.ctimeLabel.text = self.collectionInfo.ctimeStr;

}
@end
