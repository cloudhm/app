//
//  OrderTableViewCell.m
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    //cell中的右视图   由于数据内容是根据后端提供的数据变化，因此另外做一个类
    self.orderCellInnerView = [[OrderCellInnerView alloc]init];
    [self.contentView addSubview:self.orderCellInnerView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.orderCellInnerView.modeOrder = self.modeOrder;
#warning colorView如果要加边框  就在后面用layer来写
    self.colorView.colorStr = [NSString stringWithFormat:@"#%d",arc4random()%999999];
#warning hold
//    self.frame = CGRectMake(CGFloat x, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
}

@end
