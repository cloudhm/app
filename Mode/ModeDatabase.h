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
+(void)saveGetNewDatabaseIntoTableName:(NSString*)tableName andTableElements:(NSArray*)elements WithObj:(id)obj;
@end
