//
//  SJCollectionNoteController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJCollectionNoteController.h"
#import "SJNoteDetailController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "SJWaterCollectionViewCell.h"
#import "SJBaseWaterCollectionCell.h"
#import "SJNoDataFootView.h"
#import "JAActivityListModel.h"
#import "JABbsPresenter.h"
#import "SJDetailController.h"
 

@interface SJCollectionNoteController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, SJWaterCollectionCellDelegate>

@property(strong, nonnull)UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
@property (nonatomic, strong) SJNoDataFootView *noDataView;

@end

@implementation SJCollectionNoteController
static NSString *const ID = @"SJWaterCollectionViewCell";
static NSString *const SJCurrentPage = @"SJCurrentPage";
static NSString *const SJCurrentData = @"SJCurrentData";
static NSString *const SJFooterHiden = @"SJFooterHiden";

#pragma mark - lazy loading
-(UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView)
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.minimumColumnSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = JMY_BG_COLOR;
        [_mainCollectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"SJWaterTextCell" bundle:nil] forCellWithReuseIdentifier:@"SJWaterTextCell"];
        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, 0, iPhoneX?34:0, 0);
    }
    return _mainCollectionView;
}

- (NSMutableDictionary *)dataDict
{
    if (_dataDict == nil)
    {
        _dataDict = [NSMutableDictionary dictionary];
        [_dataDict setValue:@"1" forKey:SJCurrentPage];
        [_dataDict setValue:@"0" forKey:SJFooterHiden];
        [_dataDict setValue:[NSMutableArray array] forKey:SJCurrentData];
    }
    return _dataDict;
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainCollectionView];
    
    [self addRefreshView];
    [self getPostsLists];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotePraise:) name:kNotify_notePraise object:nil];
}

- (void)updateNotePraise:(NSNotification *)notification
{
    BOOL isPraise = [notification.object integerValue];
    NSInteger detailId = [[notification.userInfo valueForKey:@"detailsId"] integerValue];
     NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.ID = %d", detailId];
    NSArray *filterArray = [dataArray filteredArrayUsingPredicate:predicate];
    if (!kArrayIsEmpty(filterArray)) {
        
        JAPostsModel *postModel = filterArray.firstObject;
        NSNumber *praisesIdNum = [notification.userInfo valueForKey:@"praisesId"];
        if ([praisesIdNum isEqual:[NSNull null]])
        {
            postModel.praisesId = nil;
        } else {
            postModel.praisesId = praisesIdNum;
        }
        if (isPraise) {
            
            postModel.praises += 1;
        } else {
            postModel.praises -= 1;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[dataArray indexOfObject:postModel] inSection:0];
        [self.mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)addRefreshView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.dataDict setValue:@"1" forKey:SJCurrentPage];
        NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
        [dataArray removeAllObjects];
        [self getPostsLists];
        
    }];
    self.mainCollectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
        [self.dataDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue] + 1] forKey:SJCurrentPage];
        [self getPostsLists];
    }];
    footer.hidden = YES;
    self.mainCollectionView.mj_footer = footer;
}

- (void)getPostsLists
{
    [SVProgressHUD show];
    NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
    [JABbsPresenter postQueryCollectionDetails:SPLocalInfo.userModel.Id
                                     queryType:JADetailsTypePost
                                      IsPaging:YES
                               WithCurrentPage:[currentPage integerValue]
                                     WithLimit:10
                                        Result:^(JARecommendDetailSpolistModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success)
            {
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                [dataArray addObjectsFromArray:model.detailsPO.postsList];
                [self.mainCollectionView reloadData];
                self.mainCollectionView.mj_header.hidden = kArrayIsEmpty(dataArray);
                if (kArrayIsEmpty(dataArray)) {
                    self.noDataView.describeLabel.text = @"空空如也";
                    [self.view insertSubview:self.noDataView aboveSubview:self.mainCollectionView];
                } else {
                    if (self.noDataView.superview) {
                        [self.noDataView removeFromSuperview];
                    }
                }
            } else {
                self.noDataView.describeLabel.text = model.responseStatus.message;
                [self.view insertSubview:self.noDataView aboveSubview:self.mainCollectionView];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            self.mainCollectionView.mj_footer.hidden = (model.detailsPO.postsList.count < 10);
            [self endRefreshView];
        });
    }];
}

- (void)endRefreshView
{
    [self.mainCollectionView.mj_header endRefreshing];
    [self.mainCollectionView.mj_footer endRefreshing];
}


#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    return dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    SJWaterCollectionViewCell *cell = (SJWaterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAPostsModel *postModel = [dataArray objectAtIndex:indexPath.row];
    SJBaseWaterCollectionCell *cell = [SJBaseWaterCollectionCell cellForPostsModel:postModel collectionView:collectionView indexPath:indexPath Delegate:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAPostsModel *postsModel = [dataArray objectAtIndex:indexPath.row];
//    SJDetailController *detailVC = [[SJDetailController alloc] init];
//    NSString *postDetail = [NSString stringWithFormat:@"%@/postingDetail?id=%ld", JA_SERVER_WEB, postsModel.ID];
//    detailVC.detailStr = postDetail;
//    detailVC.titleName = @"帖子详情";
    SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
    detailVC.noteId = postsModel.ID;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAPostsModel *postsModel = [dataArray objectAtIndex:indexPath.item];
    CGFloat cellWidth = (collectionView.width - 2 * 10)/2.0-10;
    if (!CGSizeEqualToSize(postsModel.imageSize, CGSizeZero)) {
        
        CGFloat titleHeight = [postsModel.detailsName boundingRectWithSize:CGSizeMake(cellWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0]} context:nil].size.height;
        CGFloat imageH = cellWidth * postsModel.imageSize.height*1.0 / postsModel.imageSize.width;
        //        return CGSizeMake(cellWidth, imageH + titleHeight+20+10);
        return CGSizeMake(cellWidth, imageH+titleHeight+60+6);
    } else if (kArrayIsEmpty(postsModel.imagesAddressList)) {
//        CGFloat titleHeight = [postsModel.detailsName boundingRectWithSize:CGSizeMake(cellWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(12.0)} context:nil].size.height;
//        return CGSizeMake(cellWidth, titleHeight+60+6);
        return CGSizeMake(cellWidth, postsModel.waterTextHeight);
    }
    return CGSizeMake(cellWidth, cellWidth*1.2);
}

#pragma mark - SJWaterCollectionCellDelegate
- (void)didSetupImageSize:(JAPostsModel *)postModel
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    NSInteger itemIndex = [dataArray indexOfObject:postModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:0];
    [self.mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)didClickLikeBtn:(JAPostsModel *)postModel
{
    if (postModel.praisesId) {
        
        //取消点赞，成功后，将praisesId置空
        [SVProgressHUD show];
        [JABbsPresenter postUpdatePraiseType:JADetailsTypePost detailsId:postModel.ID praiseId:postModel.praisesId.integerValue isDeleted:NO Result:^(JAUpdatePraiseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (model.success) {
                    
                    [SVProgressHUD dismiss];
                    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[dataArray indexOfObject:postModel] inSection:0];
                    postModel.praisesId = nil;
//                    postModel.praises -= 1;
                    [self.mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                    //发送取消点赞通知
                    NSDictionary *info = @{
                                           @"detailsId":@(postModel.ID),
                                           @"praisesId":[NSNull null]
                                           };
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_notePraise object:@(NO) userInfo:info];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    } else {
        //点赞
        [SVProgressHUD show];
        [JABbsPresenter postAddPraise:JADetailsTypePost WithDetailsId:postModel.ID Result:^(JAAddPraiseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    
                    [SVProgressHUD dismiss];
                    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[dataArray indexOfObject:postModel] inSection:0];
                    postModel.praisesId = @(model.praisesRelationId);
//                    postModel.praises += 1;
                    [self.mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                    //发送点赞通知
                    NSDictionary *info = @{
                                           @"detailsId":@(postModel.ID),
                                           @"praisesId":@(model.praisesRelationId)
                                           };
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_notePraise object:@(YES) userInfo:info];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.noDataView.frame = CGRectMake(0, (self.view.height-200)*0.5-64, self.view.width, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
