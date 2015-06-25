//
//  WishlistTableSectionHeaderView.m
//  Mode
//
//  Created by YedaoDEV on 15/6/24.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "WishlistTableSectionHeaderView.h"
#import "UIColor+HexString.h"
@interface WishlistTableSectionHeaderView()

@property (weak, nonatomic) UILabel* headerTitle;

@end
@implementation WishlistTableSectionHeaderView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    WishlistTableSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[WishlistTableSectionHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont fontWithName:@"STHeitiK-Light" size:16];
        label.textColor = [UIColor colorWithHexString:@"#1b1b1b"];
        [self.contentView addSubview:label];
        self.headerTitle = label;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat labelX = 15.f;
    CGFloat labelY = 0.f;
    CGFloat labelW = self.frame.size.width - 15.f;
    CGFloat labelH = self.frame.size.height;
    self.headerTitle.frame = CGRectMake(labelX, labelY, labelW, labelH);
}
-(void)setHeaderString:(NSString *)headerString{
    _headerString = headerString;
    self.headerTitle.text = headerString;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
