//
//  CashTableViewCell.h
//  Mode
//
//  Created by YedaoDEV on 15/6/11.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CashView.h"
@interface CashTableViewCell : UITableViewCell
@property (copy, nonatomic) NSString *cashNumStr;
@property (strong, nonatomic) CashView *cashView;
@end
