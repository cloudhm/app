//
//  ShareViewController.h
//  Mode
//
//  Created by YedaoDEV on 15/6/8.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareViewController;
@protocol ShareViewControllerDelegate <NSObject>
@optional
-(void)shareViewController:(ShareViewController*)shareViewController shareNineModeGoodsToOthers:(NSArray*)nineGoods andTextContent:(NSString*)textContent;

@end
@interface ShareViewController : UIViewController
@property (strong, nonatomic) NSArray *nineGoods;
@property (weak, nonatomic) id <ShareViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end
