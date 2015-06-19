//
//  ModeGood.h
//  Mode
//
//  Created by YedaoDEV on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

//商品接口
#import <Foundation/Foundation.h>
typedef void (^MyCallback)(id obj);
@interface ModeGoodAPI : NSObject

//设置商品测试反馈
+(void)setGoodsFeedbackWithParams:(NSDictionary*)params andCallback:(MyCallback)callback;
////获取商品的基本信息
//+(void)requestGoodInfoWithGoodID:(NSString*)goodID andCallback:(MyCallback)callback;
@end
