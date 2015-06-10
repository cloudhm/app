//
//  WishlistInfo.h
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ModeWishlist : NSObject
@property (nonatomic,copy) NSString* wishlist_id;
@property (nonatomic,copy) NSString* comments;
@property (nonatomic,copy) NSString* img_link;
@property (nonatomic,copy) NSString* ctime;
-(CGFloat)getCommentHeightByLabelWidth:(CGFloat)width;
@end
