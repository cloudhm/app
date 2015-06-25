//
//  Passbook.h
//  Mode
//
//  Created by YedaoDEV on 15/6/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Passbook : NSObject
@property (strong, nonatomic) NSNumber *passbookId;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSNumber *eventId;
@property (strong, nonatomic) NSNumber *ctime;
@property (strong, nonatomic) NSNumber *utime;
@property (strong, nonatomic) NSNumber *expires;
#warning 332-344  缺点击跳转url链接
@end
