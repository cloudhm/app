//
//  CollectionItem.h
//  Mode
//
//  Created by YedaoDEV on 15/6/18.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionItem : NSObject
@property (strong, nonatomic) NSNumber *flagId;//source:id int
@property (strong, nonatomic) NSNumber *collectionId;
@property (strong, nonatomic) NSNumber *itemId;
@property (strong, nonatomic) NSNumber *ctime;
@property (strong, nonatomic) NSNumber *utime;
@end
