//
//  ModeDatabase.m
//  Mode
//
//  Created by huangmin on 15/6/14.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeDatabase.h"
#import "ModeGood.h"
@implementation ModeDatabase
//清空表内容 sql语句
+(NSString*)deleteTableWithTableName:(NSString*)tableName{
    return [NSString stringWithFormat:@"delete from %@",tableName];
}
//创建表命令
+(NSString*)createTableStrWithTableName:(NSString*)tableName andTableElements:(NSArray*)elements{
    NSString* sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@",tableName];
    for (int i = 0; i<elements.count; i++) {
        if (i == 0) {
            sqlStr = [NSString stringWithFormat:@"%@(%@ primary key,",sqlStr,elements[i]];
        } else if (i == elements.count-1){
            sqlStr = [NSString stringWithFormat:@"%@%@)",sqlStr,elements[i]];
        } else {
            sqlStr = [NSString stringWithFormat:@"%@%@,",sqlStr,elements[i]];
        }
    }
    return sqlStr;
}
//插入表内容 sql语句
+(NSString*)insertTableStrWithTableName:(NSString*)tableName andTableElements:(NSArray*)elements{
    NSString* sqlStr = [NSString stringWithFormat:@"insert into %@",tableName];
    for (int i = 0 ; i<elements.count; i++) {
        if (i == 0) {
            sqlStr = [NSString stringWithFormat:@"%@(%@,",sqlStr,elements[i]];
        } else if (i == elements.count-1){
            sqlStr = [NSString stringWithFormat:@"%@%@)",sqlStr,elements[i]];
        } else {
            sqlStr = [NSString stringWithFormat:@"%@%@,",sqlStr,elements[i]];
        }
    }
    for (int i =0 ; i< elements.count; i++) {
        if (i == 0) {
            sqlStr = [NSString stringWithFormat:@"%@ values(%@,",sqlStr,@"?"];
        } else if (i == elements.count-1){
            sqlStr = [NSString stringWithFormat:@"%@%@)",sqlStr,@"?"];
        } else {
            sqlStr = [NSString stringWithFormat:@"%@%@,",sqlStr,@"?"];
        }
    }
    return sqlStr;
}



//把网络请求回来的秀场数据 存入数据库
+(void)saveGetNewDatabaseIntoTableName:(NSString*)tableName andTableElements:(NSArray*)elements WithObj:(id)obj{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSString* sqlStr = [self deleteTableWithTableName:tableName];
        BOOL result = [db executeUpdate:sqlStr];//只是为了清空原先加载的16张图片数据模型
        if (result) {
            NSLog(@"成功删除");
        } else {
            NSLog(@"该表不存在或未删除");
        }
        sqlStr = [self createTableStrWithTableName:tableName andTableElements:elements];
        result = [db executeUpdate:sqlStr];
        if (result) {
            NSLog(@"创建likenope表成功");
            for (ModeGood* modeGood in obj) {
                sqlStr = [self insertTableStrWithTableName:tableName andTableElements:elements];
                BOOL res = [db executeUpdate:sqlStr, modeGood.goods_id,modeGood.brand_name,modeGood.brand_img_link,modeGood.img_link,modeGood.has_coupon];
                if (res == NO) {
                    NSLog(@"插入数据失败");
                }
            }
        } else {
            NSLog(@"创建数据表失败");
            [db close];
        }
    } else {
        NSLog(@"数据库打开失败");
        [db close];
    }
}



@end
