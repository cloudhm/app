//
//  JVDrawerTableViewCell.m
//  JVFloatingDrawer
//
//  Created by Julian Villella on 2015-01-15.
//  Copyright (c) 2015 JVillella. All rights reserved.
//

#import "JVLeftDrawerTableViewCell.h"

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
    UIColor *tintColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.7];
    if(highlight) {
        tintColor = [UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1];
    }
    
    self.titleLabel.textColor = tintColor;
    self.iconImageView.tintColor = tintColor;
}

#pragma mark - Accessors

#pragma Title

- (NSString *)titleText {
    return self.titleLabel.text;
}

- (void)setTitleText:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma Icon

- (UIImage *)iconImage {
    return self.iconImageView.image;
}

- (void)setIconImage:(UIImage *)icon {
    self.iconImageView.image = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end
