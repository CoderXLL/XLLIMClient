//
//  SJSelectTabView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSelectTabView.h"
#import "SJSelectTabCell.h"
#import "JABbsLabelModel.h"

@interface SJSelectTabView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *tabCollectionView;

@end

@implementation SJSelectTabView
static NSString *const ID = @"SJSelectTabCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *tabCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        tabCollectionView.showsVerticalScrollIndicator = NO;
        tabCollectionView.showsHorizontalScrollIndicator = NO;
        tabCollectionView.backgroundColor = [UIColor whiteColor];
        tabCollectionView.delegate = self;
        tabCollectionView.dataSource = self;
        [tabCollectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
        [self addSubview:tabCollectionView];
        self.tabCollectionView = tabCollectionView;
        
//        self.tabCollectionView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setLabels:(NSArray<JABbsLabelModel *> *)labels
{
    _labels = labels;
    [self.tabCollectionView reloadData];
}

#pragma mark - delegate, dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.labels.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //5
    return 0.001;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JABbsLabelModel *labelModel = self.labels[indexPath.item];
    CGFloat nameWidth = [labelModel.labelName boundingRectWithSize:CGSizeMake(MAXFLOAT, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(12.0)} context:nil].size.width;
    return CGSizeMake(nameWidth + 15 /**+40*/, collectionView.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJSelectTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    JABbsLabelModel *labelModel = self.labels[indexPath.item];
    cell.labelModel = labelModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *indexNum = [NSNumber numberWithInteger:indexPath.item];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lalala" object:indexNum];
    for (NSInteger i = 0; i < self.labels.count; i++)
    {
        JABbsLabelModel *labelModel = self.labels[i];
        labelModel.isSelected = NO;
        if (indexPath.item == i)
        {
            labelModel.isSelected = YES;
        }
    }
    [collectionView reloadData];
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tabCollectionView.frame = self.bounds;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
