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
-(void)setModeWishlist:(ModeWishlist *)modeWishlist{
    _modeWishlist = modeWishlist;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.commentLabel.text = self.modeWishlist.comments;
    float commentLabelW = (CGRectGetWidth(self.bounds)-60.f-10.f);
    float commentLabelH = [self.modeWishlist getCommentHeightByLabelWidth:commentLabelW];
    NSLog(@"commentLabelH:%f",commentLabelH);
    self.commentLabel.frame = CGRectMake(60.f, 10.f, commentLabelW, commentLabelH);
    
    self.iconIV.frame =CGRectMake(15.f, 10.f, 35.f, 35.f);
    self.iconIV.layer.cornerRadius = self.iconIV.bounds.size.width/2;
    self.iconIV.layer.borderWidth = 1.5f;
    self.iconIV.layer.borderColor = [UIColor blackColor].CGColor;
    self.iconIV.layer.masksToBounds = YES;
    
    [self.shareIV sd_setImageWithURL:[NSURL URLWithString:self.modeWishlist.img_link] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache]storeImage:image forKey:[self.modeWishlist.img_link lastPathComponent] toDisk:YES];
    }];
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:self.modeWishlist.img_link]];
    self.ctimeLabel.text = self.modeWishlist.ctime;
}
@end
