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
    NSArray* array = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray* listArr = [NSMutableArray array];
    for (NSDictionary* dic in array) {
        ModeSysList* modeSysList = [[ModeSysList alloc]init];
        modeSysList.name = [dic objectForKey:@"name"];
        modeSysList.picLink = [dic objectForKey:@"picLink"];
        modeSysList.menutype = [dic objectForKey:@"type"];
        [listArr addObject:modeSysList];
    }
    BOOL res = [ModeDatabase replaceIntoTable:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andInsertContent:listArr];
    if (res) {
        NSLog(@"初始化数据库成功");
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"menu_utime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } else {
        NSLog(@"插入数据失败");
    }
}
@end
