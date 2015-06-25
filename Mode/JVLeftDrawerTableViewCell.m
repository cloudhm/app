//
//  JVDrawerTableViewCell.m
//  JVFloatingDrawer
//
//  Created by Julian Villella on 2015-01-15.
//  Copyright (c) 2015 JVillella. All rights reserved.
//

#import "JVLeftDrawerTableViewCell.h"
#import "UIColor+HexString.h"
@interface JVLeftDrawerTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation JVLeftDrawerTableViewCell
//从storyboard中建立
- (void)awakeFromNib {
    //设置
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self highlightCell:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self highlightCell:highlighted];
}

- (void)highlightCell:(BOOL)highlight {
    self.backgroundColor = [UIColor colorWithHexString:@"#2a2d37"];
    UIImageView*iv=(UIImageView*)[self.contentView viewWithTag:1];
    iv.highlighted = NO;
    UIColor *tintColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.7];
    if(highlight) {
        tintColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
        self.backgroundColor = [UIColor colorWithHexString:@"#3b3f4d"];
        iv.highlighted = YES;
    }

}


@end
