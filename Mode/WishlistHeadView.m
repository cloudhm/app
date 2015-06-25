//
//  WishlistHeadView.m
//  Mode
//
//  Created by YedaoDEV on 15/6/3.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WishlistHeadView.h"
#import "Common.h"
#import "UIImage+PartlyImage.h"
@implementation WishlistHeadView
-(void)awakeFromNib{
    self.backgroundView.clipsToBounds = YES;
    self.iconImageView.layer.borderWidth = 1.f;
    self.iconImageView.layer.cornerRadius = 29.f;
    self.iconImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.iconImageView.image = [UIImage imageNamed:@"headPortrait.png"];
    UIScrollView* sv = [[UIScrollView alloc]init];
    sv.showsHorizontalScrollIndicator = NO;
    sv.bounces = YES;
    self.scrollView = sv;
    [self addSubview:sv];
}
-(void)setProfileInfo:(ProfileInfo *)profileInfo{
    _profileInfo = profileInfo;
    [self layoutSubviews];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.likes.text = [NSString stringWithFormat:@"%d",self.profileInfo.likes.integerValue];
    self.cash.text = [NSString stringWithFormat:@"%.2f",self.profileInfo.usd.doubleValue];

    self.name.text = self.profileInfo.nickname;

    if (self.profileInfo.likes.integerValue == 0) {
        self.scrollView.alpha = 0.f;
        self.scrollView.frame = CGRectZero;
    } else {
        self.scrollView.alpha = 1.f;
        self.scrollView.frame = CGRectMake(0, 125, KScreenWidth, 60);
        self.scrollView.contentSize = CGSizeMake(self.likes.text.integerValue/4 ==0 ? 0 : self.likes.text.integerValue*KScreenWidth/4, 0);
    }
    self.backgroundView.frame = CGRectMake(0, 0, KScreenWidth, 125);
    self.backgroundView.image = [UIImage getSubImageByImage:[UIImage imageNamed:@"box.png"] andImageViewFrame:self.backgroundView.frame];
}
-(IBAction)gotoCashList:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(wishlistHeadView:didClickGoToCashListWith:)]) {
        [self.delegate wishlistHeadView:self didClickGoToCashListWith:self.cash.text];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
