//
//  ModeTransactionsAPI.h
//  Mode
//
//  Created by YedaoDEV on 15/6/18.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
//用户交易的历史
typedef void (^MyCallback)(id obj);
@interface ModeTransactionsAPI : NSObject
+(void)requestTransactionsAndCallback:(MyCallback)callback;
@end
