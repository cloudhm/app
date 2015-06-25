//
//  BrandCollectionViewCell.h
//  Mode
//
//  Created by huangmin on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "CustomCollectionViewCell.h"

#import "ModeSysList.h"
//@class BrandCollectionViewCell;
//@protocol BrandCollectionViewCellDelegate <NSObject>
//
//@optional
//-(void)brandCollectionViewCell:(BrandCollectionViewCell*)brandCollectionViewCell didSelectedWithParams:(NSDictionary*)params;
//
//@end
@interface BrandCollectionViewCell : CustomCollectionViewCell
@property (strong, nonatomic) ModeSysList *brand;
//@property (weak, nonatomic) id <BrandCollectionViewCellDelegate> delegate;
@end
