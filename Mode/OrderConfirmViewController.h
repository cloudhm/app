//
//  OrderConfirmViewController.h
//  Mode
//
//  Created by YedaoDEV on 15/6/8.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//


//订单确定框  用户在跳转至webView页面购买东西  返回填写内容提交给服务器
#import <UIKit/UIKit.h>
@class OrderConfirmViewController,UIActivityIndicatorView;
@protocol OrderConfirmViewControllerDelegate <NSObject>

@optional
-(void)orderConfirmViewController:(OrderConfirmViewController*)orderConfirmViewController editFinishWithName:(NSString*)name andZipCode:(NSString*)zipcode beginAnimation:(UIActivityIndicatorView*)activityView;
-(void) dismissOrderConfirmViewController:(OrderConfirmViewController*)orderConfirmViewController;

@end
@interface OrderConfirmViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) id <OrderConfirmViewControllerDelegate> delegate;
@end
