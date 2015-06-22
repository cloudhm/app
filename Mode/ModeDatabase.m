//
//  ModeDatabase.m
//  Mode
//
//  Created by huangmin on 15/6/14.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeDatabase.h"
#import "ModeGood.h"
#import "ModeSysList.h"
#import "PrefixHeaderDatabase.pch"
//#import "ModeGood.h"
#import "GoodItem.h"
@implementation ModeDatabase
//清空表内容 sql语句
+(NSString*)deleteTableStrWithTableName:(NSString*)tableName{
    return [self deletaTableStrWithTableName:tableName andConditionKey:nil andConditionValue:nil];
}
+(NSString*)deletaTableStrWithTableName:(NSString*)tableName andConditionKey:(NSString*)conditionKey andConditionValue:(NSString*)conditionValue{
    if (conditionKey==nil||conditionValue==nil) {
        return [NSString stringWithFormat:@"delete from %@",tableName];
    } else {
        return [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName,conditionKey,conditionValue];
    }
    
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
//替换表内容 sql语句 多了一列type for home_list
+(NSString*)replaceTableStrWithTableName:(NSString*)tableName andTableElements:(NSArray*)elements{
    NSString* sqlStr = [NSString stringWithFormat:@"replace into %@",tableName];
//    if ([tableName isEqualToString:HOME_LIST_TABLENAME]) {
//        for (int i = 0 ; i<=elements.count; i++) {
//            if (i == 0) {
//                sqlStr = [NSString stringWithFormat:@"%@(%@,",sqlStr,elements[i]];
//            } else if (i == elements.count){
//                sqlStr = [NSString stringWithFormat:@"%@%@)",sqlStr,@"type"];
//            } else {
//                sqlStr = [NSString stringWithFormat:@"%@%@,",sqlStr,elements[i]];
//            }
//        }
//        for (int i =0 ; i<= elements.count; i++) {
//            if (i == 0) {
//                sqlStr = [NSString stringWithFormat:@"%@ values(%@,",sqlStr,@"?"];
//            } else if (i == elements.count){
//                sqlStr = [NSString stringWithFormat:@"%@%@)",sqlStr,@"?"];
//            } else {
//                sqlStr = [NSString stringWithFormat:@"%@%@,",sqlStr,@"?"];
//            }
//        }
//    } else {
        for (int i = 0 ; i<elements.count; i++) {
            if (i == 0) {
                sqlStr = [NSString stringWithFormat:@"%@(%@,",sqlStr,elements[i]];
            } else if (i == elements.count-1){
                sqlStr = [NSString stringWithFormat:@"%@%@)",sqlStr,elements[i]];
            } else {
                sqlStr = [NSString stringWithFormat:@"%@%@,",sqlStr,elements[i]];
            }
        }
        for (int i =0 ; i<elements.count; i++) {
            if (i == 0) {
                sqlStr = [NSString stringWithFormat:@"%@ values(%@,",sqlStr,@"?"];
            } else if (i == elements.count-1){
                sqlStr = [NSString stringWithFormat:@"%@%@)",sqlStr,@"?"];
            } else {
                sqlStr = [NSString stringWithFormat:@"%@%@,",sqlStr,@"?"];
            }
        }
//    }
    
    return sqlStr;
}
//查询语句
+(NSString*)selectTableStrWithTableName:(NSString*)tableName{
    return [NSString stringWithFormat:@"select * from %@",tableName];
}
+(NSString*)selectTableStrWithTableName:(NSString*)tableName andSelectConditionKey:(NSString*)conditionKey andSelectConditionValue:(NSString*)conditionValue{
    if (conditionKey==nil||conditionValue==nil) {
        return [self selectTableStrWithTableName:tableName];
    }
    return [NSString stringWithFormat:@"select * from %@ where %@ = '%@' ",tableName,conditionKey,conditionValue];
}
+(BOOL)deleteTableWithName:(NSString*)tableName andConditionKey:(NSString*)conditionKey andConditionValue:(NSString*)conditionValue{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    NSString* sqlStr = [self deleteTableStrWithTableName:tableName];
    if ([db open]) {
        BOOL res = [db executeUpdate:sqlStr];
        if (res) {
            NSLog(@"成功清空数据");
            return YES;
        } else {
            NSLog(@"未成功清空数据");
        }
    } else {
        NSLog(@"数据库未打开");
    }
    [db close];
    return NO;
}
//把网络请求回来的秀场数据 存入数据库
+(void)saveGetNewDatabaseIntoTableName:(NSString*)tableName andTableElements:(NSArray*)elements andObj:(id)obj{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSString* sqlStr = [self deleteTableStrWithTableName:tableName];//只是为了清空原先加载的16张图片数据模型
        BOOL result = [db executeUpdate:sqlStr];
        if (result) {
            NSLog(@"成功删除");
        } else {
            NSLog(@"该表不存在或未删除");
        }
        sqlStr = [self createTableStrWithTableName:tableName andTableElements:elements];
        result = [db executeUpdate:sqlStr];
        if (result) {
            NSLog(@"创建likenope表成功");
            for (GoodItem* goodItem in obj) {
                sqlStr = [self insertTableStrWithTableName:tableName andTableElements:elements];
                BOOL res = [db executeUpdate:sqlStr,
                            goodItem.itemId,
                            goodItem.moreProperty,
                            goodItem.saletime,
                            goodItem.sku,
                            goodItem.utime,
                            goodItem.color,
                            goodItem.ctime,
                            goodItem.goodSize,
                            goodItem.expires,
                            goodItem.itemName,
                            goodItem.merchantId,
                            goodItem.defaultImage,
                            goodItem.goodPrice,
                            goodItem.style,
                            goodItem.defaultThumb,
                            goodItem.productLink,
                            goodItem.goodTitle,
                            goodItem.brandId,
                            goodItem.occasion,
                            goodItem.status,
                            goodItem.goodDescription,
                            goodItem.hasCoupon,
                            goodItem.hasSelected];
                if (res == YES) {
                    NSLog(@"插入成功");
                } else {
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
//主页面的数据本地化存储
+(void)saveSystemListDatabaseIntoTableName:(NSString*)tableName andTableElements:(NSArray*)elements andObject:(id)obj andKeyWord:(NSString*)keyword{
    NSString* documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSString* sqlStr = [self createTableStrWithTableName:tableName andTableElements:elements];
        BOOL result = [db executeUpdate:sqlStr];
        if (result) {
            for (ModeSysList* occasion in obj) {
                sqlStr = [self replaceTableStrWithTableName:tableName andTableElements:elements];
                BOOL res = [db executeUpdate:sqlStr, occasion.name, occasion.picLink,keyword];
                if (res == YES) {
                    NSLog(@"插入或替换成功");
                } else {
                    NSLog(@"插入或替换失败");
                    
                }
            }
        }
        [db close];
    } else {
        [db close];
        NSLog(@"数据库打开失败");
    }
    
}


+(NSArray*)readDatabaseFromTableName:(NSString*)tableName andSelectConditionKey:(NSString*)conditionKey andSelectConditionValue:(NSString*)conditionValue {
    NSMutableArray* fetchedDatabase = [NSMutableArray array];
    //从本地数据库读取内容
    NSString* documentPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if ([db open] == NO) {
        NSLog(@"打开失败");
        [db close];
        return fetchedDatabase;
    }
    NSString* sqlStr = [self selectTableStrWithTableName:tableName andSelectConditionKey:conditionKey andSelectConditionValue:conditionValue];
    NSLog(@"%@",sqlStr);
    FMResultSet* set = [db executeQuery:sqlStr];
    //查询数据
    if ([tableName isEqualToString:HOME_LIST_TABLENAME]) {
        while ([set next]) {
            ModeSysList* mstyle = [[ModeSysList alloc]init];
            mstyle.name = [set stringForColumn:@"name"];
            mstyle.picLink = [set stringForColumn:@"picLink"];
//            mstyle.eventId = [set stringForColumn:@"eventId"];
//            mstyle.amount = [set stringForColumn:@"amount"];
            [fetchedDatabase addObject:mstyle];
        }
    }
    if ([tableName isEqualToString:LIKENOPE_TABLENAME]) {
        while ([set next]) {
            GoodItem* goodItem = [[GoodItem alloc]init];
            goodItem.moreProperty = [set stringForColumn:@"moreProperty"];
            goodItem.saletime = [set objectForColumnName:@"saletime"];
            goodItem.sku = [set stringForColumn:@"sku"];
            goodItem.utime = [set objectForColumnName:@"utime"];
            goodItem.color = [set stringForColumn:@"color"];
            goodItem.itemId = [set objectForColumnName:@"itemId"];
            goodItem.ctime = [set stringForColumn:@"ctime"];
            goodItem.goodSize = [set stringForColumn:@"goodSize"];
            goodItem.expires = [set objectForColumnName:@"expires"];
            goodItem.itemName = [set stringForColumn:@"itemName"];
            goodItem.merchantId = [set objectForColumnName:@"merchantId"];
            goodItem.defaultImage = [set stringForColumn:@"defaultImage"];
            goodItem.goodPrice = [set objectForColumnName:@"goodPrice"];
            goodItem.style = [set stringForColumn:@"style"];
            goodItem.defaultThumb = [set stringForColumn:@"defaultThumb"];
            goodItem.productLink = [set stringForColumn:@"productLink"];
            goodItem.goodTitle = [set stringForColumn:@"goodTitle"];
            goodItem.brandId = [set objectForColumnName:@"brandId"];
            goodItem.occasion = [set stringForColumn:@"occasion"];
            goodItem.status = [set objectForColumnName:@"status"];
            goodItem.goodDescription = [set stringForColumn:@"goodDescription"];
            goodItem.hasCoupon = [set stringForColumn:@"hasCoupon"];
            goodItem.hasSelected = [set objectForColumnName:@"hasSelected"];
//            modeGood.goods_id = [set stringForColumn:@"goods_id"];
//            modeGood.brand_name = [set stringForColumn:@"brand_name"];
//            modeGood.brand_img_link = [set stringForColumn:@"brand_img_link"];
//            modeGood.img_link = [set stringForColumn:@"img_link"];
//            modeGood.has_coupon = [set stringForColumn:@"has_coupon"];
            [fetchedDatabase addObject:goodItem];
        }
    }
    if ([tableName isEqualToString:WISHLIST_TABLENAME]) {
        while ([set next]) {
            GoodItem* goodItem = [[GoodItem alloc]init];
            goodItem.moreProperty = [set stringForColumn:@"moreProperty"];
            goodItem.saletime = [set objectForColumnName:@"saletime"];
            goodItem.sku = [set stringForColumn:@"sku"];
            goodItem.utime = [set objectForColumnName:@"utime"];
            goodItem.color = [set stringForColumn:@"color"];
            goodItem.itemId = [set objectForColumnName:@"itemId"];
            goodItem.ctime = [set stringForColumn:@"ctime"];
            goodItem.goodSize = [set stringForColumn:@"goodSize"];
            goodItem.expires = [set objectForColumnName:@"expires"];
            goodItem.itemName = [set stringForColumn:@"itemName"];
            goodItem.merchantId = [set objectForColumnName:@"merchantId"];
            goodItem.defaultImage = [set stringForColumn:@"defaultImage"];
            goodItem.goodPrice = [set objectForColumnName:@"goodPrice"];
            goodItem.style = [set stringForColumn:@"style"];
            goodItem.defaultThumb = [set stringForColumn:@"defaultThumb"];
            goodItem.productLink = [set stringForColumn:@"productLink"];
            goodItem.goodTitle = [set stringForColumn:@"goodTitle"];
            goodItem.brandId = [set objectForColumnName:@"brandId"];
            goodItem.occasion = [set stringForColumn:@"occasion"];
            goodItem.status = [set objectForColumnName:@"status"];
            goodItem.goodDescription = [set stringForColumn:@"goodDescription"];
            goodItem.hasCoupon = [set stringForColumn:@"hasCoupon"];
            goodItem.hasSelected = [set objectForColumnName:@"hasSelected"];
//            modeGood.brand_img_link = [set stringForColumn:@"brand_img_link"];
//            modeGood.brand_name = [set stringForColumn:@"brand_name"];
//            modeGood.goods_id = [set stringForColumn:@"goods_id"];
//            modeGood.img_link = [set stringForColumn:@"img_link"];
//            modeGood.has_coupon = [set stringForColumn:@"has_coupon"];
            [fetchedDatabase addObject:goodItem];
        }
    }
    [db close];
   return fetchedDatabase;
}
+(BOOL)replaceIntoTable:(NSString*)tableName andTableElements:(NSArray*)elements andInsertContent:(id)obj{
    NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString*path=[documentPath stringByAppendingPathComponent:@"my.sqlite"];
    FMDatabase* db = [FMDatabase databaseWithPath:path];
    if ([db open]) {
        NSString* sqlStr = [self createTableStrWithTableName:tableName andTableElements:elements];
        BOOL res = [db executeUpdate:sqlStr];
        if (res) {
            NSLog(@"创建或打开wishlist成功");
            sqlStr = [self replaceTableStrWithTableName:tableName andTableElements:elements];
            if (![obj isKindOfClass:[NSArray class]]) {//单条数据插入
                
                if ([tableName isEqualToString:WISHLIST_TABLENAME]) {
                    GoodItem* goodItem = (GoodItem*)obj;
                    BOOL flag = [db executeUpdate:sqlStr,
                                 goodItem.itemId,
                                 goodItem.moreProperty,
                                 goodItem.saletime,
                                 goodItem.sku,
                                 goodItem.utime,
                                 goodItem.color,
                                 goodItem.ctime,
                                 goodItem.goodSize,
                                 goodItem.expires,
                                 goodItem.itemName,
                                 goodItem.merchantId,
                                 goodItem.defaultImage,
                                 goodItem.goodPrice,
                                 goodItem.style,
                                 goodItem.defaultThumb,
                                 goodItem.productLink,
                                 goodItem.goodTitle,
                                 goodItem.brandId,
                                 goodItem.occasion,
                                 goodItem.status,
                                 goodItem.goodDescription,
                                 goodItem.hasCoupon,
                                 goodItem.hasSelected];
                    res = flag&&res;
                }
                if ([tableName isEqualToString:HOME_LIST_TABLENAME]) {
                    ModeSysList* modeSysList = (ModeSysList*)obj;
                    BOOL flag = [db executeUpdate:sqlStr,modeSysList.name,modeSysList.picLink,modeSysList.menutype];
                    res = flag&&res;
                }
                
            } else {//多条数据插入
                if ([tableName isEqualToString:WISHLIST_TABLENAME]) {
                    for (GoodItem* goodItem in obj) {
                        BOOL flag = [db executeUpdate:sqlStr,goodItem.itemId,
                                     goodItem.moreProperty,
                                     goodItem.saletime,
                                     goodItem.sku,
                                     goodItem.utime,
                                     goodItem.color,
                                     goodItem.ctime,
                                     goodItem.goodSize,
                                     goodItem.expires,
                                     goodItem.itemName,
                                     goodItem.merchantId,
                                     goodItem.defaultImage,
                                     goodItem.goodPrice,
                                     goodItem.style,
                                     goodItem.defaultThumb,
                                     goodItem.productLink,
                                     goodItem.goodTitle,
                                     goodItem.brandId,
                                     goodItem.occasion,
                                     goodItem.status,
                                     goodItem.goodDescription,
                                     goodItem.hasCoupon,
                                     goodItem.hasSelected];
                        if (!flag) {
                            NSLog(@"数组插入失败");
                            res = flag&&res;
                        }
                    }
                    
                }
                if ([tableName isEqualToString:HOME_LIST_TABLENAME]) {
                    for (ModeSysList* modeSysList in obj) {
                        BOOL flag = [db executeUpdate:sqlStr,modeSysList.name,modeSysList.picLink,modeSysList.menutype];
                        if (!flag) {
                            NSLog(@"数组插入失败");
                            res = flag&&res;
                        }
                    }
                }
            }
            if (res) {
                NSLog(@"插入成功");
                return  YES;
            } else {
                NSLog(@"插入失败");
            }
        } else {
            NSLog(@"创建失败");
        }
    } else {
        NSLog(@"打开数据库失败");
    }
    
    
    
    [db close];

    return NO;
}
@end
