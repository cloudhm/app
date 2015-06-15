//
// ChoosePersonView.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ChooseClothesView.h"

#import "ModeGood.h"
#import "SDWebImageManager.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIColor+HexString.h"
#import "UIImage+PartlyImage.h"
@interface ChooseClothesView ()
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic,strong) UIImageView *brandImageView;

@end

@implementation ChooseClothesView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       modeGood:(ModeGood *)modeGood
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];//MDCSwipeToChooseView的初始化方法
    if (self) {
        self.layer.borderWidth = 1.5f;//加边框
        self.layer.borderColor = [UIColor colorWithHexString:@"#4c4c4c" withAlpha:.5f].CGColor;//设置边框颜色
        _modeGood = modeGood;
        [self constructInformationView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.bounds;
    frame.origin.x = 30.f;
    frame.origin.y = 15.f;
    frame.size.width -= 60.f;
    frame.size.height -= 60.f;
    self.imageView.frame = frame;
    self.imageView.backgroundColor = [UIColor grayColor];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.modeGood.img_link] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.imageView.image = [UIImage getSubImageByImage:image andImageViewFrame:self.imageView.frame];
        [[SDImageCache sharedImageCache]storeImage:image forKey:[self.modeGood.img_link lastPathComponent] toDisk:YES];
    }];
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadImageWithURL:[NSURL URLWithString:self.modeGood.img_link] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        [[SDImageCache sharedImageCache]storeImage:image forKey:[self.modeGood.img_link lastPathComponent] toDisk:YES];
//        self.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.modeGood.img_link lastPathComponent]];
//    }];
}
#pragma mark - Internal Methods
/**
 *  下方信息栏初始化
 */
- (void)constructInformationView {
    CGFloat bottomHeight = 45.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                        UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_informationView];
    
    [self constructBrandImg];
    [self constructNameLabel];

}
-(void)constructBrandImg{//商标图片
    CGFloat leftPadding = 15.f;
    CGFloat topPadding = 5.f;
    CGRect frame = CGRectMake(leftPadding, topPadding, 25.f, 25.f);
    _brandImageView = [[UIImageView alloc]initWithFrame:frame];
    _brandImageView.layer.cornerRadius = CGRectGetWidth(frame)/2;
    _brandImageView.layer.masksToBounds = YES;
    _brandImageView.layer.borderWidth = 1.f;
    _brandImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:self.modeGood.brand_img_link] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.brandImageView.image = [UIImage getSubImageByImage:image andImageViewFrame:self.brandImageView.frame];
        [[SDImageCache sharedImageCache]storeImage:image forKey:[self.modeGood.brand_img_link lastPathComponent] toDisk:YES];
    }];
//    if (![[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[self.modeGood.brand_img_link lastPathComponent]]) {
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        [manager downloadImageWithURL:[NSURL URLWithString:self.modeGood.brand_img_link] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            NSLog(@"%ld/%ld",receivedSize,expectedSize);
//        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            [[SDImageCache sharedImageCache]storeImage:image forKey:[self.modeGood.brand_img_link lastPathComponent] toDisk:YES];
//            self.brandImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.modeGood.brand_img_link lastPathComponent]];
//        }];
//    } else {
//        self.brandImageView.image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:[self.modeGood.brand_img_link lastPathComponent]];
//    }
    
    [_informationView addSubview:_brandImageView];
}
- (void)constructNameLabel {//商标名称
    CGFloat leftPadding = 45.f;
    CGFloat topPadding = 13.f;
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              CGRectGetWidth(self.bounds)-leftPadding,
                              18);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.text = [_modeGood.brand_name uppercaseString];
    [_informationView addSubview:_nameLabel];
}


@end
