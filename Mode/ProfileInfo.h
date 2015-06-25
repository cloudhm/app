//
//  ProfileInfo.h
//  Mode
//
//  Created by YedaoDEV on 15/6/18.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileInfo : NSObject
@property (strong, nonatomic) NSNumber *level;//int
@property (strong, nonatomic) NSNumber *profileId;//int
@property (strong, nonatomic) NSString *uuid;//@""
@property (strong, nonatomic) NSNumber *profilePoint;//point
@property (strong, nonatomic) NSNumber *utime;//int
@property (strong, nonatomic) NSNumber *userId;//long int
@property (strong, nonatomic) NSNumber *rmb;//double
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSNumber *ctime;//long int
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSNumber *wishes;//int
@property (strong, nonatomic) NSNumber *vip;//source -> isvip int
@property (strong, nonatomic) NSNumber *orders;//int
@property (strong, nonatomic) NSNumber *inviteBy;//int
@property (strong, nonatomic) NSString *inviteCode;    //null

@property (strong, nonatomic) NSString *nickname; //-----------------

@property (strong, nonatomic) NSString *countryCode;//          null
@property (strong, nonatomic) NSNumber *longitude;//double      null
@property (strong, nonatomic) NSNumber *latitude;//double       null
@property (strong, nonatomic) NSString *gender;//               null
@property (strong, nonatomic) NSNumber *likes;//int
@property (strong, nonatomic) NSNumber *shares;//int
@property (strong, nonatomic) NSNumber *usd;//double
@property (strong, nonatomic) NSString *avatar;//@""
@property (strong, nonatomic) NSString *fbToken;//@""

@property (strong, nonatomic) NSString *email;//----------------------






@end
