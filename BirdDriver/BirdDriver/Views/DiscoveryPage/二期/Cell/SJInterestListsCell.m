//
//  SJInterestListsCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJInterestListsCell.h"
#import "SJInterestListsTagCell.h"
#import "JABBSModel.h"

@interface SJInterestListsCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;

@end

@implementation SJInterestListsCell
static NSString *const ID = @"SJInterestListsTagCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    
    self.headView.layer.borderWidth = 2.0;
}

- (void)setPosModel:(JAUserAccountPosList *)posModel
{
    _posModel = posModel;
    self.nameLabel.text = posModel.nickName;
    [self.headView sd_setImageWithURL:posModel.photoSrc.mj_url placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.descriptionLabel.text = posModel.personalSign;
    if (posModel.sex == 0) { //女
        
        self.headView.layer.borderColor = [UIColor colorWithHexString:@"F9739B" alpha:1].CGColor;
    } else { //男
        self.headView.layer.borderColor = [UIColor colorWithHexString:@"6EEBEE" alpha:1].CGColor;
    }
    [self.collectionView reloadData];
}

#pragma mark - dataSource,delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.posModel.labelsList.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, collectionView.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJInterestListsTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.label = self.posModel.labelsList[indexPath.item];
    return cell;
}

@end
