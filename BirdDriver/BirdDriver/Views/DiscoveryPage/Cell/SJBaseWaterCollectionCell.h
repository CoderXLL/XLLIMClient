//
//  SJBaseWaterCollectionCell.h
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/31.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JAPostsModel;

@protocol SJWaterCollectionCellDelegate <NSObject>

- (void)didClickLikeBtn:(JAPostsModel *)postModel;
- (void)didSetupImageSize:(JAPostsModel *)postModel;

@end

@interface SJBaseWaterCollectionCell : UICollectionViewCell

+ (instancetype)cellForPostsModel:(JAPostsModel *)postsModel collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath Delegate:(id<SJWaterCollectionCellDelegate>)delegate;

@property (nonatomic, strong) JAPostsModel *postModel;
@property (nonatomic, weak) id<SJWaterCollectionCellDelegate>delegate;

@end
