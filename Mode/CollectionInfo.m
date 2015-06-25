//
//  CollectionInfo.m
//  Mode
//
//  Created by YedaoDEV on 15/6/25.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "CollectionInfo.h"

@implementation CollectionInfo
-(CGFloat)getCommentHeightByLabelWidth:(CGFloat)width{
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15],NSForegroundColorAttributeName:[UIColor blackColor]};
    CGRect rect = [self.comments boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size.height+15.f;
}
@end
