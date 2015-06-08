//
//  PassbookTableViewCell.m
//  Mode
//
//  Created by YedaoDEV on 15/6/2.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "PassbookTableViewCell.h"

@implementation PassbookTableViewCell

- (void)awakeFromNib {
    self.hourLabel.layer.borderWidth = 1.5f;
    self.hourLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.minuteLabel.layer.borderWidth = 1.5f;
    self.minuteLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.secondLabel.layer.borderWidth = 1.5f;
    self.secondLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.hourLabel.text = [self.timeDic objectForKey:@"hour"];
    self.minuteLabel.text = [self.timeDic objectForKey:@"minute"];
    self.secondLabel.text = [self.timeDic objectForKey:@"second"];
    self.main_img.backgroundColor = [UIColor greenColor];
    self.brand_img.backgroundColor = [UIColor grayColor];
    
    
    
    
    
    
}
-(void)drawRect:(CGRect)rect{
    
}
@end
