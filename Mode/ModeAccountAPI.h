//
//  ModeAccountAPI.h
//  Mode
//
//  Created by YedaoDEV on 15/6/4.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"
typedef void (^MyCallback)(id obj);
@interface ModeAccountAPI : NSObject
//用户邮箱注册
+(void)signupWithParams:(NSDictionary*)params andCallback:(MyCallback)callback;
@end
