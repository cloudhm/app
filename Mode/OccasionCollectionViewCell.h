//
//  OccasionCollectionViewCell.h
//  Mode
//
//  Created by huangmin on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "ModeSysList.h"
//@class OccasionCollectionViewCell;
//@protocol OccasionCollectionViewCellDelegate <NSObject>
//
//@optional
//-(void)occasionCollectionViewCell:(OccasionCollectionViewCell*)occasionCollectionViewCell didSelectedWithParams:(NSDictionary*)params;
//
//@end


@interface OccasionCollectionViewCell : CustomCollectionViewCell
@property (nonatomic,strong) ModeSysList* occasion;
//@property (weak, nonatomic) id <OccasionCollectionViewCellDelegate> delegate;
@end
