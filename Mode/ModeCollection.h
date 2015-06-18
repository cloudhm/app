//
//  WishlistInfo.h
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ModeCollection : NSObject
@property (nonatomic,strong) NSString* defaultThumb;
@property (nonatomic,strong) NSNumber* userId;
@property (nonatomic,strong) NSNumber* utime;
@property (nonatomic,strong) NSString* ctime;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) NSString *defaultImage;
@property (strong, nonatomic) NSNumber *collectionId;
-(CGFloat)getCommentHeightByLabelWidth:(CGFloat)width;
@end
