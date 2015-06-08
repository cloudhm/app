//
//  BrandRunwayTableViewController.h
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandInfo.h"

//品牌详情介绍表视图控制器
@interface BrandRunwayTableViewController : UITableViewController
@property (copy, nonatomic) NSString *brandName;

@property (strong, nonatomic) BrandInfo *brandInfo;

@end
