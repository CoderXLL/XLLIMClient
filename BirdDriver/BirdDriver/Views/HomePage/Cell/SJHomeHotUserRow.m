//
//  SJHomeHotUserRow.m
//  BirdDriver
//
//  Created by Soul on 2018/5/18.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJHomeHotUserRow.h"
#import "SJHomeHotUserCell.h"
#import "SJNoDataFootView.h"
#import "JAUserAccount.h"
#import "JABBSModel.h"

@interface SJHomeHotUserRow()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cv_users;
@property (nonatomic, strong) SJNoDataFootView *noDataView;

@end

@implementation SJHomeHotUserRow

#pragma mark - lazy loading
- (SJNoDataFootView *)noDataView
{
    if (_noDataView == nil)
    {
        _noDataView = [SJNoDataFootView createCellWithXib];
        _noDataView.backgroundColor = JMY_BG_COLOR;
        _noDataView.exceptionStyle = SJExceptionStyleNoData;
    }
    return _noDataView;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        [self.cv_users registerNib:[UINib nibWithNibName:NSStringFromClass([SJHomeHotUserCell class]
                                                                         )
                                                bundle:[NSBundle mainBundle]]
      forCellWithReuseIdentifier:NSStringFromClass([SJHomeHotUserCell class])];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.cv_users registerNib:[UINib nibWithNibName:NSStringFromClass([SJHomeHotUserCell class]
                                                                     )
                                            bundle:[NSBundle mainBundle]]
  forCellWithReuseIdentifier:NSStringFromClass([SJHomeHotUserCell class])];
    
    self.cv_users.dataSource = self;
    self.cv_users.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHotUserList:(NSArray<JAUserAccount *> *)hotUserList {
    _hotUserList = hotUserList;
    if (kArrayIsEmpty(hotUserList)) {
        if (!self.noDataView.superview) {
            [self insertSubview:self.noDataView aboveSubview:self.cv_users];
        }
    } else {
        if (self.noDataView.superview) {
            [self.noDataView removeFromSuperview];
        }
    }
    [self.cv_users reloadData];
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJHomeHotUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SJHomeHotUserCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [SJHomeHotUserCell new];
    }
    id model = self.hotUserList[indexPath.item];
    cell.model = model;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotUserList.count;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *image = [UIImage imageNamed:@"profile_bg"];
    CGFloat width = image.size.width;
    CGFloat tempWidth = (collectionView.width-2*kSJMargin-2*10)/3.0;
    CGSize size = CGSizeMake(MAX(width, tempWidth), self.frame.size.height);
    return size;
}

//这个是两行cell之间的间距（左右行cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 15.0f;
//}


//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);//分别为上、左、下、右
}

////两个cell之间的间距（上下行的cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return kLine_HeightT_1_PPI;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.hotUserList[indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedAccountModel:)])
    {
        [self.delegate didSelectedAccountModel:model];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.noDataView.frame = CGRectMake(0, 0, self.width, self.height);
}

@end
