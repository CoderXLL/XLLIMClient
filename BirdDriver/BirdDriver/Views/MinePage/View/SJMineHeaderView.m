//
//  SJMineHeaderView.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJMineHeaderView.h"
#import "SJMineHeaderCell.h"
#import "JAMessagePresenter.h"

@implementation SJHeaderItemModel

@end


@interface SJMineHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *mineBgView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headTopCons;

@end

@implementation SJMineHeaderView
static NSString *const ID = @"SJMineHeaderCell";

#pragma mark - lazy loading
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
        SJHeaderItemModel *postModel = [[SJHeaderItemModel alloc] init];
        postModel.titleStr = @"帖子";
        postModel.iconStr = @"mine_post";
        
        SJHeaderItemModel *pictureModel = [[SJHeaderItemModel alloc] init];
        pictureModel.titleStr = @"图册";
        pictureModel.iconStr = @"mine_atlas";
        
        SJHeaderItemModel *collectionModel = [[SJHeaderItemModel alloc] init];
        collectionModel.titleStr = @"收藏";
        collectionModel.iconStr = @"mine_collect";
        
        SJHeaderItemModel *messageModel = [[SJHeaderItemModel alloc] init];
        messageModel.titleStr = @"消息";
        messageModel.iconStr = @"mine_message";
        [_dataArray addObjectsFromArray:@[postModel, pictureModel, collectionModel, messageModel]];
        
        
    }
    return _dataArray;
}

+ (instancetype)createCellWithXib{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SJMineHeaderView" owner:nil options:nil] objectAtIndex:0];
}

- (void)getMessageNotReadCountWithGroup:(dispatch_group_t)group{
    dispatch_group_enter(group);
    [JAMessagePresenter postNotReadMessageCount:MessageTypeAll
                                         Result:^(JAResponseModel * _Nullable model) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 dispatch_group_leave(group);
                                                 if (model.success)
                                                 {
                                                     self.messageLabel.text = [NSString stringWithFormat:@"%zd", model.notReadMsgCount];
                                                 } else {
                                     
                                                     if (![model.responseStatus.code isEqualToString:@"9995"]) {
                                                         [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                                                     [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                                                     }
                                                 }
                                                     });
                                         }];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headTopCons.constant = kNavBarHeight+5;
    [self getMessageNotReadCountWithGroup:dispatch_group_create()];
    [self.collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    self.mineBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [self.mineBgView addGestureRecognizer:tapGesture];
    self.portraitImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)tapGestureClick
{
    [SJStatisticEventTool umengEvent:Nsj_Event_LR
                               NsjId:@"10010200"
                             NsjName:@"点击图形验证码"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBgView:)])
    {
        [self.delegate didClickBgView:self];
    }
}

- (IBAction)protraitImageClick:(id)sender {
    //点击头像
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPortraitImageView)])
    {
        [self.delegate didClickPortraitImageView];
    }
}

#pragma mark - delegate, dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat itemW = 113-kSJMargin*2-25;
    CGFloat margin = (kScreenWidth-itemW*self.dataArray.count)/8.0;
    return margin*2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat itemW = 113-kSJMargin*2-25;
    CGFloat margin = (kScreenWidth-itemW*self.dataArray.count)/8.0;
    return UIEdgeInsetsMake(kSJMargin, margin, kSJMargin, margin);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemH = 113 - kSJMargin*2;
    return CGSizeMake(itemH-25, itemH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJMineHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.itemModel = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJHeaderItemModel *itemModel = self.dataArray[indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItemModel:)])
    {
        [self.delegate didSelectedItemModel:itemModel];
    }
}

@end
