//
//  ModeSys.h
//  Mode
//
//  Created by YedaoDEV on 15/5/26.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

//获取系统主页网络请求
#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"
typedef void (^MyCallback)(id obj);
@interface ModeSysAPI : NSObject

+(void)requestMenuListAndCallback:(MyCallback)callback;

@end
