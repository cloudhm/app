//
//  Runway.h
//  Mode
//
//  Created by YedaoDEV on 15/6/19.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Runway : NSObject
@property (strong, nonatomic) NSNumber *runwayId;
@property (strong, nonatomic) NSString *runwayDescription;//source->description  null
@property (strong, nonatomic) NSNumber *userId;//long int
@property (strong, nonatomic) NSString *utime;
@property (strong, nonatomic) NSString *ctime;
@property (strong, nonatomic) NSNumber *status;//null
@property (strong, nonatomic) NSString *source;//null
@property (strong, nonatomic) NSString *runwayTitle;//source->title

@end
