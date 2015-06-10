//
//  WishlistInfo.m
//  Mode
//
//  Created by huangmin on 15/5/31.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "ModeWishlist.h"

@implementation ModeWishlist
-(CGFloat)getCommentHeightByLabelWidth:(CGFloat)width{
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15],NSForegroundColorAttributeName:[UIColor blackColor]};
    CGRect rect = [self.comments boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size.height+10.f;
}
@end
