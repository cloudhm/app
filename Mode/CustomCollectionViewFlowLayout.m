//
//  BrandCollectionViewFlowLayout.m
//  Mode
//
//  Created by YedaoDEV on 15/5/25.
//  Copyright (c) 2015年 YedaoDEV. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"

@implementation CustomCollectionViewFlowLayout
- (CGSize)collectionViewContentSize{
    NSInteger num = [self.collectionView numberOfItemsInSection:0];
//    NSInteger pages = num/6==0?1:(num%6==0?num/6:(num/6+1));
    NSInteger pages = num%2 == 0 ? num/2 :(num/2+1);
    return CGSizeMake(self.collectionView.bounds.size.width,self.collectionView.bounds.size.height /3 * pages);
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        float toppadding = 0.f;
        float leftpadding = 20.f;
        float rightpadding = 20.f;
        float bottompadding = 0.f;
        self.minimumLineSpacing = 0.f;
        self.minimumInteritemSpacing = 10.f;
        self.itemSize = CGSizeMake((frame.size.width-self.minimumInteritemSpacing - leftpadding - rightpadding)/2, (frame.size.height - 2*self.minimumLineSpacing - toppadding -bottompadding)/3);
        self.sectionInset = UIEdgeInsetsMake(toppadding, leftpadding, bottompadding, rightpadding);//上左下右
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;//边界修改时是否重新计算布局
}
@end
