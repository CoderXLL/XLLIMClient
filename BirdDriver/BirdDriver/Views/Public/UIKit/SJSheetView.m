//
//  SJSheetView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSheetView.h"
#import "SJLineView.h"
#import "SJSheetCell.h"

@interface SJSheetView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UIButton *coverBtn;
@property (nonatomic, weak) UIView *actionView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) SJLineView *sepLine;
@property (nonatomic, weak) UIButton *cancelBtn;

@property (nonatomic, copy) void(^clickBlock)(SJSheetViewActionType);
@property (nonatomic, strong) NSArray <SJSheetModel *>*sheetModels;

@end

@implementation SJSheetModel

@end

@implementation SJSheetView
static NSString *const ID = @"SJSheetCell";

+ (instancetype)sheetViewWithSheetModels:(NSArray <SJSheetModel *>*)sheetModels ClickBlock:(void(^)(SJSheetViewActionType))clickBlock
{
    SJSheetView *sheetView = [[SJSheetView alloc] init];
    sheetView.clickBlock =  clickBlock;
    sheetView.sheetModels = sheetModels;
    return sheetView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coverBtn.backgroundColor = [UIColor blackColor];
    coverBtn.alpha = 0.6;
    [coverBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:coverBtn];
    self.coverBtn = coverBtn;
    
    UIView *actionView = [[UIView alloc] init];
    actionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:actionView];
    self.actionView = actionView;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor colorWithHexString:@"F8F8F8" alpha:1.0];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    [collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [self.actionView addSubview:collectionView];
    self.collectionView = collectionView;
    
    SJLineView *sepLine = [[SJLineView alloc] init];
    sepLine.backgroundColor = [UIColor colorWithHexString:@"ECECEC" alpha:1.0];
    [self.actionView addSubview:sepLine];
    self.sepLine = sepLine;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"BDBDBD" alpha:1.0] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = SPFont(15.0);
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
}

#pragma mark - delegate, datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sheetModels.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 34;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 17, 5, 17);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = 65.f;
    return CGSizeMake(itemWidth, itemWidth+20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJSheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    SJSheetModel *sheetModel = self.sheetModels[indexPath.item];
    cell.sheetModel = sheetModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismiss];
    SJSheetModel *sheetModel = self.sheetModels[indexPath.item];
    if (self.clickBlock) {
        self.clickBlock(sheetModel.actionType);
    }
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.frame = keyWindow.bounds;
    self.actionView.transform = CGAffineTransformTranslate(self.actionView.transform, 0, CGRectGetMaxY(self.actionView.frame));
    self.coverBtn.alpha = 0.0;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:.25f animations:^{
        self.coverBtn.alpha = 0.6;
        self.actionView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25f animations:^{
        self.coverBtn.alpha = 0;
        self.actionView.y+=self.actionView.height;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverBtn.frame = self.bounds;
    self.actionView.frame = CGRectMake(0, self.height-165, self.width, 165);
    self.cancelBtn.frame = CGRectMake(0, self.actionView.height-50, self.actionView.width, 50);
    self.sepLine.frame = CGRectMake(0, self.cancelBtn.y-1, self.actionView.width, 1);
    self.collectionView.frame = CGRectMake(0, 0, self.actionView.width, self.sepLine.y-1);
}

@end
