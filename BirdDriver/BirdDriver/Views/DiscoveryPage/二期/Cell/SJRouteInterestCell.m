//
//  SJRouteInterestCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteInterestCell.h"
#import "SJRouteInterestCollectionCell.h"
#import "JARouteListModel.h"

@interface SJRouteInterestCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UILabel *descLabel;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation SJRouteInterestCell
static NSString *const ID = @"SJRouteInterestCollectionCell";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.font = [UIFont boldSystemFontOfSize:14.0];
    descLabel.textColor = [UIColor colorWithHexString:@"2B3248" alpha:1];
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
}

#pragma mark - delegate, dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemModel.collectionUserList.count+1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 10, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.height, collectionView.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJRouteInterestCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.isMore = (indexPath.item == self.itemModel.collectionUserList.count);
    if (indexPath.item < self.itemModel.collectionUserList.count) {
        cell.posModel = self.itemModel.collectionUserList[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(routeInterestCell:didClickAccount:)])
    {
        JAUserAccountPosList *posModel = nil;
        if (indexPath.item < self.itemModel.collectionUserList.count) {
            posModel = self.itemModel.collectionUserList[indexPath.item];
        }
        [self.delegate routeInterestCell:self didClickAccount:posModel];
    }
}

#pragma mark - setter
- (void)setItemModel:(JARouteListItemModel *)itemModel
{
    _itemModel = itemModel;
    self.descLabel.text = [NSString stringWithFormat:@"%zd人感兴趣", itemModel.collection];
    [self.collectionView reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.descLabel.frame = CGRectMake(kSJMargin+2, 0, self.contentView.width-kSJMargin*2-2, 54);
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.descLabel.frame), self.contentView.width, self.contentView.height-10-self.descLabel.height);
}

@end
