//
//  ConsigneeNameViewController.h
//  Mode
//
//  Created by YedaoDEV on 15/6/23.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConsigneeNameViewController;
@protocol ConsigneeNameViewControllerDelegate <NSObject>

@optional
-(void)consigneeNameViewController:(ConsigneeNameViewController*)consigneeNameViewController comfirmInputConsigneeName:(NSString*)consigneeName;
-(void)dismissconsigneeNameViewController:(ConsigneeNameViewController *)consigneeNameViewContorller;
@end
@interface ConsigneeNameViewController : UIViewController
@property (weak, nonatomic) id <ConsigneeNameViewControllerDelegate> delegate;
@end
