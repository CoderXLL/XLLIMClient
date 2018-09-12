//
//  SJChoosePhotoCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJChoosePhotoCell.h"
#import "SJNotePhotoCell.h"

@interface SJChoosePhotoCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation SJChoosePhotoCell
static NSString *const ID = @"SJNotePhotoCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - setter
- (void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = (collectionView.frame.size.width-5*3-15*2)/4.0;
    return CGSizeMake(itemW, itemW);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7.5, 15, 15, 15);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJNotePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (indexPath.item == self.photos.count)
    {
        cell.model = nil;
    } else {
        cell.model = self.photos[indexPath.item];
    }
    cell.removeBlock = ^(id model) {
        
        NSInteger index = [self.photos indexOfObject:model];
        [self.photos removeObject:model];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cell:actionStyle:)])
        {
            [self.delegate cell:self actionStyle:SJChoosePhotoCellStyleRemove];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:actionStyle:)])
    {
        [self.delegate cell:self actionStyle:SJChoosePhotoCellStyleChoose];
    }
}

@end
