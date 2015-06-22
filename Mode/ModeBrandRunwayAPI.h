//
//  ModeBrandRunwayAPI.h
//  Mode
//
//  Created by YedaoDEV on 15/6/5.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MyCallback)(id obj);
@interface ModeBrandRunwayAPI : NSObject
//获取品牌信息
+(void)requestBrandInfoByBrandId:(NSNumber*)brandId andCallback:(MyCallback)callback;
@end
