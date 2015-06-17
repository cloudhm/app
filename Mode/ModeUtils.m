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
//    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString* path = [documentPath stringByAppendingPathComponent:@"my.sqlite"];
//    FMDatabase* db = [FMDatabase databaseWithPath:path];
//    if ([db open]) {
//        for (int i = 0; i<array.count; i++) {
    NSMutableArray* listArr = [NSMutableArray array];
    for (NSDictionary* dic in array) {
        ModeSysList* modeSysList = [[ModeSysList alloc]init];
        modeSysList.eventId = [dic objectForKey:@"eventId"];
        modeSysList.name = [dic objectForKey:@"name"];
        modeSysList.picLink = [dic objectForKey:@"picLink"];
        modeSysList.amount = [dic objectForKey:@"amount"];
        modeSysList.menutype = [dic objectForKey:@"menutype"];
        [listArr addObject:modeSysList];
    }
    BOOL res = [ModeDatabase replaceIntoTable:HOME_LIST_TABLENAME andTableElements:HOME_LIST_ELEMENTS andInsertContent:listArr];
    if (res) {
        NSLog(@"初始化数据库成功");
        [[NSUserDefaults standardUserDefaults]setObject:@"000000" forKey:@"menu_utime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } else {
        NSLog(@"插入数据失败");
    }
//        }
        
//        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS list_home (eventId primary key,menutype,name,picLink,amount)"];
//        BOOL res = NO;
//        if (result) {
//            for (NSDictionary* dic in array) {
//                
//                NSString* eventId = [dic objectForKey:@"eventId"];
//                NSString* style_type = [dic objectForKey:@"type"];
//                NSString* name = [dic objectForKey:@"name"];
//                NSString* picLink = [dic objectForKey:@"picLink"];
//                NSString* amount = [dic objectForKey:@"amount"];
//                res = [db executeUpdate:@"replace into list_home(eventId,menutype,name,picLink,amount) values(?,?,?,?,?)",eventId,style_type,name,picLink,amount];
//                if (res == NO) {
//                    NSLog(@"插入数据失败");
//                }
//            }
//            
//            
//        }
//        [db close];
//    } else {
//        [db close];
//        NSLog(@"数据库打开失败");
//    }
}
@end
