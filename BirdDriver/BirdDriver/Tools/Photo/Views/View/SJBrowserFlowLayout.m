//
//  SJBrowserFlowLayout.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBrowserFlowLayout.h"
#import "SJPhotoComponents.h"

@implementation SJBrowserFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.itemSize = self.collectionView.size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width/2.0;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *attributes = [NSMutableArray arrayWithCapacity:count];
    
    __block CGFloat min = CGFLOAT_MAX;
    __block NSUInteger minIdx;
    for (NSInteger i = 0; i < count; i++)
    {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        if (ABS(centerX-attribute.center.x) < min)
        {
            min = ABS(centerX-attribute.center.x);
            minIdx = i;
        }
        [attributes addObject:attribute];
    }
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (minIdx - 1 == idx)
        {
            obj.center = CGPointMake(obj.center.x-SJBrowserMargin*0.5, obj.center.y);
        }
        if (minIdx + 1 == idx)
        {
            obj.center = CGPointMake(obj.center.x+SJBrowserMargin*0.5, obj.center.y);
        }
    }];
    return attributes;
}

@end
