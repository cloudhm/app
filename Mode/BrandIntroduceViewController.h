//
//  BrandIntroduceViewController.h
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandInfo.h"
@interface BrandIntroduceViewController : UIViewController
@property (copy, nonatomic) NSString *brandName;
@property (strong, nonatomic) BrandInfo *brandInfo;
@end
