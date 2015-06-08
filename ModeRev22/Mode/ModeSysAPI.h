//
//  ModeSys.h
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

//系统网络请求
#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"
typedef void (^MyCallback)(id obj);
@interface ModeSysAPI : NSObject
+(void)requestBrandListAndCallback:(MyCallback)callback;
+(void)requestOccasionListAndCallback:(MyCallback)callback;
+(void)requestStyleListAndCallback:(MyCallback)callback;
@end
