//
//  BrandRunwayTableViewCell.h
//  Mode
//
//  Created by YedaoDEV on 15/6/5.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModeBrandRunway.h"
@interface BrandRunwayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *runway_img;
@property (strong, nonatomic) ModeBrandRunway *brandRunway;
@end
