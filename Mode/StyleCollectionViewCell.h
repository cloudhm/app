//
//  StyleCollectionViewCell.h
//  Mode
//
//  Created by huangmin on 15/5/28.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "CustomCollectionViewCell.h"

#import "ModeSysList.h"
//@class StyleCollectionViewCell;
//@protocol StyleCollectionViewCellDelegate <NSObject>
//
//@optional
//-(void)styleCollectionViewCell:(StyleCollectionViewCell*)styleCollectionViewCell didSelectedWithParams:(NSDictionary*)params;
//
//@end
@interface StyleCollectionViewCell : CustomCollectionViewCell
@property (nonatomic,strong) ModeSysList* mstyle;
//@property (weak, nonatomic) id <StyleCollectionViewCellDelegate> delegate;
@end
