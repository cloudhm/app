//
//  ModeDatabase.h
//  Mode
//
//  Created by huangmin on 15/6/14.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

typedef void (^MyCallback)(id obj);
@interface ModeDatabase : NSObject
+(void)saveGetNewDatabaseIntoTableName:(NSString*)tableName andTableElements:(NSArray*)elements andObj:(id)obj;

+(void)saveSystemListDatabaseIntoTableName:(NSString*)tableName andTableElements:(NSArray*)elements andObject:(id)obj andKeyWord:(NSString*)keyword;

+(NSArray*)readDatabaseFromTableName:(NSString*)tableName andSelectConditionKey:(NSString*)conditionKey andSelectConditionValue:(NSString*)conditionValue;

+(BOOL)deleteTableWithName:(NSString*)tableName;
+(void)replaceIntoTable:(NSString*)tableName andTableElements:(NSArray*)elements andInsertContent:(id)obj;
@end
