//
//  SJCollectionView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SJCollectionView;

@protocol SJCollectionViewDelegate <UICollectionViewDelegate>

//回调长按的cell
- (void)collectionView:(SJCollectionView *)collectionView
        didLongPressed:(UICollectionViewCell *)cell;
//拖动完成回调
- (void)dragCellCollectionViewCellEndMoving:(SJCollectionView *)collectionView;
//开始拖动回调
- (void)dragCellCollectionViewCellBeginMoving:(SJCollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@required
- (void)collectionView:(SJCollectionView *)collectionView newDataSourceAfterMove:(NSArray *)newDataSource;

@end

@protocol SJCollectionViewDataSource <UICollectionViewDataSource>

@required
- (NSArray *)dataSourceOfCollectionView:(SJCollectionView *)collectionView;

@end

@interface SJCollectionView : UICollectionView

@property (nonatomic, weak) id <SJCollectionViewDelegate> delegate;
@property (nonatomic, weak) id <SJCollectionViewDataSource> dataSource;

@end
