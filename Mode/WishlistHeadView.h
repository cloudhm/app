//
//  WishlistHeadView.h
//  Mode
//
//  Created by YedaoDEV on 15/6/3.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileInfo.h"

@class WishlistHeadView;
@protocol WishlistHeadViewDelegate <NSObject>
@optional
-(void)wishlistHeadView:(WishlistHeadView*)wishlistHeadView didClickGoToCashListWith:(NSString*)cash;

@end


@interface WishlistHeadView : UIView
@property(weak,nonatomic)IBOutlet UILabel* following;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UILabel *invitations;
@property (weak, nonatomic) IBOutlet UILabel *cash;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) ProfileInfo *profileInfo;
@property (weak, nonatomic) id <WishlistHeadViewDelegate> delegate;
@end
