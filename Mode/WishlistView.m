//
//  WishlistView.m
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WishlistView.h"
#import "SDWebImageManager.h"
#import "ModeGood.h"
#import "UIImageView+WebCache.h"
#import "UIImage+PartlyImage.h"
@interface WishlistView()
@property (nonatomic,weak) UIImageView* mainImageView;
@property (nonatomic,weak) UIImageView* couponImageView;
@property (nonatomic,weak) UIButton* delBtn;
@end
@implementation WishlistView
-(instancetype)initWithFrame:(CGRect)frame andModeGood:(ModeGood*)modeGood andWithoutBtn:(BOOL)withoutBtn{
    self = [super initWithFrame:frame];
    if (self) {
        _modeGood = modeGood;
        self.backgroundColor = [UIColor whiteColor];
        [self createImageView];
        [self createCouponView];
        if (!withoutBtn) {
            [self createDelBtn];
        }

        if (![_modeGood.has_coupon isEqualToString:@"true"]) {
            self.couponImageView.alpha = 0.f;
        } else {
            self.couponImageView.alpha = 1.f;
        }
        self.delBtn.enabled = NO;
        self.delBtn.alpha = 0.f;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.selected == YES) {
        self.delBtn.enabled = NO;//按钮不显示
        self.delBtn.alpha = 0.f;//按钮不显示
    } else {
        self.delBtn.enabled = NO;
        self.delBtn.alpha = 0.f;
    }
}
-(void)createImageView{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.origin.x+3.f, self.bounds.origin.y + 3.f, CGRectGetWidth(self.frame) -6.f, CGRectGetHeight(self.frame) - 3.f)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor whiteColor];
//    if ([[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[_modeGood.img_link lastPathComponent]]) {
//        imageView.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[_modeGood.img_link lastPathComponent]];
//    } else {
//        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:_modeGood.img_link] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            NSLog(@"%d//%d",(int)receivedSize,(int)expectedSize);
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            [[SDImageCache sharedImageCache]storeImage:image forKey:[_modeGood.img_link lastPathComponent] toDisk:YES];
//            imageView.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[_modeGood.img_link lastPathComponent]];
//        }];
//    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:_modeGood.img_link] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        imageView.image = [UIImage getSubImageByImage:image andImageViewFrame:imageView.frame];//根据横宽比切图
        [[SDImageCache sharedImageCache]storeImage:image forKey:[_modeGood.img_link lastPathComponent] toDisk:YES];
    }];
    
    
    [self addSubview:imageView];
    self.mainImageView = imageView;
}
-(void)createCouponView{
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5.f, 5.f, 20.f, 10.f)];
    imageView.image = [UIImage imageNamed:@"coupon_normal.png"];
    [self addSubview:imageView];
    self.couponImageView = imageView;
    [self bringSubviewToFront:self.couponImageView];
}
-(void)createDelBtn{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-30.f, 15.f, 20.f, 20.f)];
    [btn setImage:[UIImage imageNamed:@"Close button.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    self.delBtn = btn;
    [self bringSubviewToFront:self.delBtn];
}
-(void)click:(UIButton*)btn{
//发送通知给控制器，要求控制器来执行删除视图及更新数据库的操作
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeNopedGood" object:self userInfo:@{@"goods_id":self.modeGood.goods_id}];
}
//selected属性变更时，刷新本控件 和 刷新子视图
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
    [self layoutSubviews];
}

//selected变更时  刷新本控件的贝塞尔曲线边框
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    // Draw an indicator line if tab is selected
    if (self.selected == YES) {
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0.f, CGRectGetHeight(rect))];
        [bezierPath addLineToPoint:CGPointMake(0.f, 0.f)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0.f)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
        [bezierPath setLineWidth:2.f];
        [[UIColor greenColor] setStroke];
        [bezierPath stroke];
    }
}

@end
