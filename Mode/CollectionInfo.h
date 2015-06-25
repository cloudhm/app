//
//  CollectionInfo.h
//  Mode
//
//  Created by YedaoDEV on 15/6/25.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CollectionInfo : NSObject
@property (strong, nonatomic) NSNumber *collectionId;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *ctimeStr;
@property (strong, nonatomic) NSNumber *utime;
@property (strong, nonatomic) NSString *comments;//null
@property (strong, nonatomic) NSString *defaultThumb;//null
@property (strong, nonatomic) NSString *defaultImage;//null
@property (strong, nonatomic) NSArray *collectionItems;
-(CGFloat)getCommentHeightByLabelWidth:(CGFloat)width;
@end
