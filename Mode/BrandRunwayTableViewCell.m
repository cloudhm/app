//
//  BrandRunwayTableViewCell.m
//  Mode
//
//  Created by YedaoDEV on 15/6/5.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "BrandRunwayTableViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"
@implementation BrandRunwayTableViewCell

- (void)awakeFromNib {
    NSLog(@"..");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.runway_img sd_setImageWithURL:[NSURL URLWithString:self.brandRunway.pic_link] placeholderImage:nil];
}
@end
