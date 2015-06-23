//
//  ModeSysList.h
//  Mode
//
//  Created by YedaoDEV on 15/6/4.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModeSysList : NSObject<NSCoding>
@property (nonatomic,copy) NSString* name;
@property (nonatomic,copy) NSString* picLink;
@property (nonatomic,copy) NSString* tagId;
@property (copy, nonatomic) NSString *amount;

@end
