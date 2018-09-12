//
//  SJHomeFinancialRow.m
//  BirdDriver
//
//  Created by Soul on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJHomeFinancialRow.h"
#import "SJHomeFinancialCell.h"
#import "JABannerListModel.h"

@interface SJHomeFinancialRow()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cv_financial;

@end


@implementation SJHomeFinancialRow
static NSString *const ID = @"SJHomeFinancialCell";

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        [self.cv_financial registerNib:[UINib nibWithNibName:ID bundle:nil]
            forCellWithReuseIdentifier:ID];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.cv_financial registerNib:[UINib nibWithNibName:NSStringFromClass([SJHomeFinancialCell class]
                                                                           )
                                                  bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:NSStringFromClass([SJHomeFinancialCell class])];
    
    self.cv_financial.backgroundColor = SP_CLEAR_COLOR;
    self.cv_financial.dataSource = self;
    self.cv_financial.delegate = self;
    self.cv_financial.showsVerticalScrollIndicator = NO;
    self.cv_financial.showsHorizontalScrollIndicator = NO;
    
    self.backgroundColor = SP_CLEAR_COLOR;
}

- (void)setSubBannerModel:(JABannerData *)subBannerModel
{
    _subBannerModel = subBannerModel;
    [self.cv_financial reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    SJHomeFinancialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    JABannerModel *bannerModel = self.subBannerModel.list[indexPath.item];
    cell.bannerModel = bannerModel;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { 
    return self.subBannerModel.list.count;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = kScreenWidth *165.0f/375;
    CGSize size = CGSizeMake(width, 60.0f);
    return size;
}

//这个是两行cell之间的间距（左右行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0f;
}

//两个cell之间的间距（上下行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kLine_HeightT_1_PPI;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     JABannerModel *bannerModel = self.subBannerModel.list[indexPath.item];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithBannerModel:)])
    {
        [self.delegate didSelectedWithBannerModel:bannerModel];
    }
    
    //埋点副Banner
    NSString *nsjId = [NSString stringWithFormat:@"300102%02d",(int)indexPath.row+1];
    NSString *nsjDes = [NSString stringWithFormat:@"点击副Banner%@",bannerModel.bannerName];
    [SJStatisticEventTool umengEvent:Nsj_Event_Home
                               NsjId:nsjId
                             NsjName:nsjDes];
}

@end
