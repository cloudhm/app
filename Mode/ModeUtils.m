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
    NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSNumber* utime = [dictionary objectForKey:@"utime"];
    NSArray* occasionArr = [self parserAndGetBy:[dictionary objectForKey:OCCASION]];
    NSArray* brandArr = [self parserAndGetBy:[dictionary objectForKey:BRAND]];
    NSArray* mstyle = [self parserAndGetBy:[dictionary objectForKey:STYLE]];
    NSData* occData = [NSKeyedArchiver archivedDataWithRootObject:occasionArr];
    NSString* occStr = [occData base64EncodedStringWithOptions:0];
    NSLog(@"%@",occStr);
    NSData* brandData = [NSKeyedArchiver archivedDataWithRootObject:brandArr];
    NSString* brandStr = [brandData base64EncodedStringWithOptions:0];
    NSData* styleData = [NSKeyedArchiver archivedDataWithRootObject:mstyle];
    NSString* styleStr = [styleData base64EncodedStringWithOptions:0];
    
    BOOL res = [ModeDatabase replaceIntoTable:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andInsertContent:@[utime,occStr,brandStr,styleStr]];
    if (res) {
        NSLog(@"初始化数据库成功");
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"menu_utime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
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
