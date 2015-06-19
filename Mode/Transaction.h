//
//  Transaction.h
//  Mode
//
//  Created by YedaoDEV on 15/6/18.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject
@property (strong, nonatomic) NSNumber *transactionId;//long int
@property (strong, nonatomic) NSNumber *userId;//long int
@property (strong, nonatomic) NSString *amount;//source:double->string
@property (strong, nonatomic) NSNumber *formerAmount;//double
@property (strong, nonatomic) NSString *unit;//currency type
@property (strong, nonatomic) NSString *ctimeStr;//source：long int-string
@property (strong, nonatomic) NSNumber *utime;//int
@property (strong, nonatomic) NSNumber *status;//int
@property (strong, nonatomic) NSString *sn;
@property (strong, nonatomic) NSString *comment;// null
@end
