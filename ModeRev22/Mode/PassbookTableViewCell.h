//
//  PassbookTableViewCell.h
//  Mode
//
//  Created by YedaoDEV on 15/6/2.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassbookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bg_img;
@property (weak, nonatomic) IBOutlet UIImageView *main_img;
@property (weak, nonatomic) IBOutlet UIImageView *brand_img;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (nonatomic, strong) NSDictionary* timeDic;
@end
