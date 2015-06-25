//
//  WishlistTableViewCell.h
//  Mode
//
//  Created by YedaoDEV on 15/6/3.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollectionInfo.h"

@interface WishlistTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *iconIV;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *defaultImages;

@property (weak, nonatomic) IBOutlet UILabel *ctimeLabel;
@property (strong, nonatomic) UILabel *commentLabel;


@property (strong, nonatomic) CollectionInfo *collectionInfo;

@end
