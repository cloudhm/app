//
//  ModePassbookAPI.h
//  Mode
//
//  Created by YedaoDEV on 15/6/22.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MyCallback)(id obj);
@interface ModePassbookAPI : NSObject
+(void)requestPassbookListAndCallback:(MyCallback)callback;
@end
