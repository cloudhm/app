//
//  BrandRunwayTableViewController.h
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandInfo.h"

//品牌所有秀场 及品牌详情介绍
@interface BrandRunwayTableViewController : UITableViewController
@property (copy, nonatomic) NSString *brandName;
#warning 暂时没有数据源 
@property (strong, nonatomic) BrandInfo *brandInfo;

@end
