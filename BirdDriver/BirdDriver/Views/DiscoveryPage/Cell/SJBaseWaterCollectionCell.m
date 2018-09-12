//
//  SJBaseWaterCollectionCell.m
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/31.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBaseWaterCollectionCell.h"
#import "JAActivityListModel.h"
#import "SJWaterCollectionViewCell.h"
#import "SJWaterTextCell.h"

@implementation SJBaseWaterCollectionCell

+ (instancetype)cellForPostsModel:(JAPostsModel *)postsModel collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath Delegate:(id<SJWaterCollectionCellDelegate>)delegate
{
    NSString *ID = [self reuseIdentifierForPostsModel:postsModel];
    SJBaseWaterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (cell == nil)
    {
        [collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    }
    cell.delegate = delegate;
    cell.postModel = postsModel;
    return cell;
}

+ (NSString *)reuseIdentifierForPostsModel:(JAPostsModel *)postsModel
{
    if (kArrayIsEmpty(postsModel.imagesAddressList)) {
        
        return @"SJWaterTextCell";
    }
    return @"SJWaterCollectionViewCell";
}

- (void)setPostModel:(JAPostsModel *)postModel
{
    _postModel = postModel;
}

@end
