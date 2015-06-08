//
//  ShareView.h
//  Mode
//
//  Created by YedaoDEV on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareView;
@protocol ShareViewDelegate <NSObject>
@optional
-(void)shareView:(ShareView*)shareView shareNineModeGoodsToOthers:(NSArray*)nineGoods andTextContent:(NSString*)textContent;

@end
@interface ShareView : UIView
@property (strong, nonatomic) NSArray *nineGoods;
@property (weak, nonatomic) id <ShareViewDelegate> delegate;
@end
