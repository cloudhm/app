//
//  ModeUtils.m
//  Mode
//
//  Created by YedaoDEV on 15/6/4.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeUtils.h"
#import <FMDB.h>
#import "ModeDatabase.h"
#import "PrefixHeaderDatabase.pch"
#import "JsonParser.h"
#import "ModeSysList.h"
@implementation ModeUtils
+(void)initDatabase{
    
    NSString* plistPath = [[NSBundle mainBundle]pathForResource:@"init" ofType:@"plist"];
    NSDictionary* dictionary = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    BOOL res = [ModeDatabase replaceIntoTable:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andInsertContent:jsonStr];
    if (res) {
        NSLog(@"初始化数据库成功");
//        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"menu_utime"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
    } else {
        NSLog(@"插入数据失败");
    }
}
+(NSArray*)parserAndGetBy:(NSArray*)array{
    NSMutableArray* arr = [NSMutableArray array];
    for (NSDictionary* dic in array) {
        ModeSysList* modeSysList = [[ModeSysList alloc]init];
        modeSysList.name = [dic objectForKey:@"name"];
        modeSysList.picLink = [dic objectForKey:@"picLink"];
        [arr addObject:modeSysList];
    }
    return arr;
}
@end
