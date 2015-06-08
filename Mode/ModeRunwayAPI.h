//
//  RunwayAPI.h
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

//秀场接口
#import <Foundation/Foundation.h>
typedef void (^MyCallback)(id obj);
@interface ModeRunwayAPI : NSObject
//新建一组秀场
+(void)requestGetNewWithParams:(NSDictionary*)params andCallback:(MyCallback)callback;
@end
