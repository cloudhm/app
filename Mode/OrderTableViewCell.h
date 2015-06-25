//
//  OrderTableViewCell.h
//  Mode
//
//  Created by YedaoDEV on 15/6/6.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModeOrder.h"
#import "ColorView.h"
//OrderViewController中tableView的自定义xib cell
@interface OrderTableViewCell : UITableViewCell
@property (nonatomic, strong) ModeOrder *modeOrder;
@property (weak, nonatomic) IBOutlet UIImageView *main_img;
@property (weak, nonatomic) IBOutlet UITextView *titleView;
@property (weak, nonatomic) IBOutlet ColorView *colorView;
@end
