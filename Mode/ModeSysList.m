//
//  ModeSysList.m
//  Mode
//
//  Created by YedaoDEV on 15/6/4.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeSysList.h"

@implementation ModeSysList
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.picLink forKey:@"picLink"];
    [aCoder encodeObject:self.tagId forKey:@"tagId"];
    [aCoder encodeObject:self.amount forKey:@"amount"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.picLink = [aDecoder decodeObjectForKey:@"picLink"];
        self.tagId = [aDecoder decodeObjectForKey:@"tagId"];
        self.amount = [aDecoder decodeObjectForKey:@"amount"];
    }
    return self;
}
@end
