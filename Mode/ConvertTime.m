//
//  ConvertTime.m
//  CountDown
//
//  Created by YedaoDEV on 15/6/5.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ConvertTime.h"

@implementation ConvertTime
+(NSInteger)convertTimeByTimeInterval:(NSNumber*)timeNum{
    NSTimeInterval currentTimeSince1970 = [[NSDate date]timeIntervalSince1970];
    return timeNum.integerValue - (NSInteger)currentTimeSince1970;
}
//由于需要取模余  全部换算成整数
+(NSDictionary*)convertLastTimeByTimeInterval:(NSNumber*)timeNum{
    NSInteger lastTime = [self convertTimeByTimeInterval:timeNum];
    if (lastTime<=0) {//如果时间倒计时结束，返回0显示
        lastTime=0;
    }
    NSString* timeHour = [NSString stringWithFormat:@"%02ld",lastTime/3600];
    NSString* timeMinute = [NSString stringWithFormat:@"%02ld",lastTime%3600/60];
    NSString* timeSecond = [NSString stringWithFormat:@"%02ld",lastTime%60];
    
    return @{@"hour":timeHour,@"minute":timeMinute,@"second":timeSecond};
}
@end
