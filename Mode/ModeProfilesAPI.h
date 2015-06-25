//
//  ModeProfilesAPI.h
//  Mode
//
//  Created by YedaoDEV on 15/6/18.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
//用户的明细信息
typedef void (^MyCallback)(id obj);
@interface ModeProfilesAPI : NSObject
+(void)requestProfilesAndCallback:(MyCallback)callback;
+(void)requestEnchashmentWithParams:(NSDictionary*)params andCallback:(MyCallback)callback;//用户提现
@end
