//
//  ModeUtils.m
//  Mode
//
//  Created by YedaoDEV on 15/6/4.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeUtils.h"
#import <FMDB.h>
@implementation ModeUtils
+(void)initDatabase{
    NSString* plistPath = [[NSBundle mainBundle]pathForResource:@"init" ofType:@"plist"];
    NSArray* array = [NSArray arrayWithContentsOfFile:plistPath];
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* path = [documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS list_home (event_id primary key,type,name,pic_link,amount)"];
        BOOL res = NO;
        if (result) {
            for (NSDictionary* dic in array) {
                NSNumber* event_id = [dic objectForKey:@"event_id"];
                NSString* style_type = [dic objectForKey:@"type"];
                NSString* name = [dic objectForKey:@"name"];
                NSString* pic_link = [dic objectForKey:@"pic_link"];
                NSNumber* amount = [dic objectForKey:@"amount"];
                res = [db executeUpdate:@"replace into list_home(event_id,type,name,pic_link,amount) values(?,?,?,?,?)",event_id,style_type,name,pic_link,amount];
                if (res == NO) {
                    NSLog(@"插入数据失败");
                }
            }
            
            if (res == YES) {
                NSLog(@"初始化数据库成功");
                [[NSUserDefaults standardUserDefaults]setObject:@"000000" forKey:@"brandlist_utime"];
                [[NSUserDefaults standardUserDefaults]setObject:@"000000" forKey:@"occasionlist_utime"];
                [[NSUserDefaults standardUserDefaults]setObject:@"000000" forKey:@"stylelist_utime"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        [db close];
    } else {
        [db close];
        NSLog(@"数据库打开失败");
    }
}
@end
