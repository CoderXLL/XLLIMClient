//
//  SJWaterLayout.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SJWaterLayoutDelegate <NSObject>

@required

- (CGFloat)waterLayout:(UICollectionViewLayout *)waterLayout itemWidth:(CGFloat)itemWidth indexPath:(NSIndexPath *)indexPath;

@optional
/**
 *  行间距
 */
- (CGFloat)rowMarginInWaterflowLayout:(UICollectionViewLayout*)layout;
/**
 *  列间距
 */
- (CGFloat)columnMarginInWaterflowLayout:(UICollectionViewLayout*)layout;
/**
 *  列数
 */
- (NSInteger)columnCountInWaterflowLayout:(UICollectionViewLayout*)layout;
/**
 *  collectionView内边距
 */
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(UICollectionViewLayout*)layout;


@end

@interface SJWaterLayout : UICollectionViewLayout

@property (nonatomic,weak) id<SJWaterLayoutDelegate> delegate;

@end
