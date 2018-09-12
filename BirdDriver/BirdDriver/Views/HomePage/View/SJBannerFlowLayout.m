//
//  SJBannerFlowLayout.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBannerFlowLayout.h"

@implementation SJBannerFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = kLine_HeightT_1_PPI;
    self.minimumLineSpacing = 15;
    CGFloat width = kScreenWidth *260.0f/375;
    self.itemSize = CGSizeMake(width, self.collectionView.height);
    self.sectionInset = UIEdgeInsetsMake(kLine_HeightT_1_PPI, 15, kLine_HeightT_1_PPI, 15);
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat width = kScreenWidth *260.0f/375;
    CGFloat pageSpacing = width+kSJMargin; // width + space
    float currentOffset = self.collectionView.contentOffset.x;
    float targetOffset = proposedContentOffset.x;
    
    float newTargetOffset = 0;
    if (targetOffset > currentOffset) {
        newTargetOffset = ceilf(currentOffset / pageSpacing) * pageSpacing;
    } else {
        newTargetOffset = floorf(currentOffset / pageSpacing) * pageSpacing;
    }
    if (newTargetOffset < 0) {
        newTargetOffset = 0;
    } else if (newTargetOffset > self.collectionView.contentSize.width) {
        newTargetOffset = self.collectionView.contentSize.width;
    }
    proposedContentOffset.x = currentOffset;
    return CGPointMake(newTargetOffset, proposedContentOffset.y);
}

@end
