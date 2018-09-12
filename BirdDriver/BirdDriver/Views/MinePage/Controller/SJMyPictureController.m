//
//  SJMyPictureController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  我的图册

#import "SJMyPictureController.h"
#import "SJPicturesController.h"
#import "SJCollectionView.h"
#import "SJMyPictureCell.h"
#import "SJAddPictureCell.h"
#import "SJAlertView.h"
#import "SJNoDataFootView.h"
#import "SJMyPicturePresenter.h"
#import "JABbsPresenter.h"
#import "JAAtlasListModel.h"

@interface SJMyPictureController () <SJCollectionViewDelegate, SJCollectionViewDataSource, UICollectionViewDelegateFlowLayout, SJMyPictureDelegate>

@property (nonatomic, strong) UIButton *rightBtn;
//是否为编辑模式
@property (nonatomic, assign, getter=editStyle) BOOL isEditStyle;

@property (nonatomic, strong) SJMyPicturePresenter *picturePresenter;
@property (nonatomic, strong) JAAtlasModel *dragingModel;

@property (nonatomic, strong) SJCollectionView *collectionView;
@property (nonatomic, strong) SJNoDataFootView *noDataView;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation SJMyPictureController
static NSString *const ID = @"SJMyPictureCell";
static NSString *const SJCurrentPage = @"SJCurrentPage";
static NSString *const SJCurrentData = @"SJCurrentData";
static NSString *const SJFooterHiden = @"SJFooterHiden";

#pragma mark - lazy loading
- (NSMutableDictionary *)dataDict
{
    if (_dataDict == nil)
    {
        _dataDict = [NSMutableDictionary dictionary];
        [_dataDict setValue:@"1" forKey:SJCurrentPage];
        [_dataDict setValue:[NSMutableArray array] forKey:SJCurrentData];
        [_dataDict setValue:@"0" forKey:SJFooterHiden];
    }
    return _dataDict;
}

- (SJMyPicturePresenter *)picturePresenter
{
    if (_picturePresenter == nil)
    {
        _picturePresenter = [[SJMyPicturePresenter alloc] init];
        _picturePresenter.delegate = self;
    }
    return _picturePresenter;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.picturePresenter getPicturesWithPage:1 userId:self.userId];
    [self setupSubviews];
    [self addRefreshView];
}

- (void)addRefreshView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataDict setValue:@"1" forKey:SJCurrentPage];
        [self.dataDict setValue:[NSMutableArray array] forKey:SJCurrentData];
        [self.picturePresenter getPicturesWithPage:1 userId:self.userId];
        
    }];
    UIScrollView *scrollView = (UIScrollView *)self.collectionView;
    scrollView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
        [self.dataDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue] + 1] forKey:SJCurrentPage];
        [self.picturePresenter getPicturesWithPage:[currentPage integerValue]+1 userId:self.userId];
    }];
    scrollView.mj_footer = footer;
}


- (void)setupSubviews
{
    if (self.userId == SPLocalInfo.userModel.Id) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.size = CGSizeMake(80, 30);
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = SPFont(15.0);
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"FFBB04" alpha:1.0] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    SJCollectionView *collectionView = [[SJCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsVerticalScrollIndicator = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = NO;
    [collectionView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
    [collectionView registerNib:[UINib nibWithNibName:@"SJAddPictureCell" bundle:nil] forCellWithReuseIdentifier:@"SJAddPictureCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - event
- (void)rightBtnClick
{
    if (self.userId != SPLocalInfo.userModel.Id) return;
    if (!self.editStyle) {
        self.isEditStyle = YES;
    } else {
        NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.selected == YES"];
        NSArray *filterArray = [dataArray filteredArrayUsingPredicate:predicate];
        if (kArrayIsEmpty(filterArray)) {
            self.isEditStyle = NO;
        } else {
            [self.picturePresenter deletePictureWithAtlasList:filterArray];
        }
    }
}

#pragma mark - SJMyPictureDelegate
- (void)setPictureLists:(NSMutableArray<JAAtlasModel *> *)pictureLists
{
    self.collectionView.mj_footer.hidden = pictureLists.count < 10;
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    [dataArray addObjectsFromArray:pictureLists];
    NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
    if ([currentPage isEqualToString:@"1"]) {
        JAAtlasModel *lasModel = [[JAAtlasModel alloc] init];
        [dataArray insertObject:lasModel atIndex:0];
    }
//    if (kArrayIsEmpty(dataArray)) {
//
//        [self.collectionView removeFromSuperview];
//        [self.view addSubview:self.noDataView];
//    } else {
//        if (self.noDataView.superview) {
//            [self.noDataView removeFromSuperview];
//        }
//        if (!self.collectionView.superview) {
//            [self.view addSubview:self.collectionView];
//        }
//    }
    [self.collectionView reloadData];
}

- (void)didEndLoading
{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)didSucceedDelete:(NSArray<JAAtlasModel *> *)pictureLists
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    NSMutableArray <NSIndexPath *>*indexPaths = [NSMutableArray array];
    for (JAAtlasModel *lasModel in pictureLists) {
        NSInteger index = [dataArray indexOfObject:lasModel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [indexPaths addObject:indexPath];
     }
     [dataArray removeObjectsInArray:pictureLists];
     [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    if (kArrayIsEmpty(dataArray)) {
        self.isEditStyle = NO;
        [self.collectionView removeFromSuperview];
        [self.view addSubview:self.noDataView];
    }
}

- (void)didSucceedCreatePicture:(JAAtlasModel *)lasModel
{
    if (self.noDataView.superview) {
        [self.noDataView removeFromSuperview];
    }
    if (!self.collectionView.superview) {
        [self.view addSubview:self.collectionView];
    }
    
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    [dataArray addObject:lasModel];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:dataArray.count-1 inSection:0]]];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    return dataArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kSJMargin, kSJMargin, kSJMargin, kSJMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 12.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = (collectionView.width - kSJMargin * 2 - 2 * 12)/3.f;
    return CGSizeMake(itemW, itemW);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        
        SJAddPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJAddPictureCell" forIndexPath:indexPath];
        cell.descStr = @"新建图册";
        return cell;
    }
    SJMyPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAAtlasModel *lasModel = dataArray[indexPath.item];
    cell.lasModel = lasModel;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认创建" handler:^(id content) {
            
            if (kStringIsEmpty(content)) {
                [SVProgressHUD showInfoWithStatus:@"请输入相册名称"];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                return ;
            }
            [self.picturePresenter createPictureWithName:content];
        }];
        SJAlertView *alertView = [SJAlertView alertWithTitle:@"新建图册" message:@"请输入您的图册名称" type:SJAlertShowTypeInput alertModels:@[alertModel]];
        [alertView showAlertView];
    } else {
        NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
        JAAtlasModel *lasModel = dataArray[indexPath.item];
        if (self.editStyle)
        {
            lasModel.isSelected = !lasModel.selected;
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        } else {
            SJPicturesController *pictureVC = [[SJPicturesController alloc] init];
            NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
            JAAtlasModel *lasModel = dataArray[indexPath.item];
            pictureVC.canAddPhoto = (self.userId == SPLocalInfo.userModel.Id);
            pictureVC.lasModel = lasModel;
            pictureVC.updateCoverBlock = ^(NSInteger atlasId, NSString *newCover) {
              
                for (JAAtlasModel *lasModel in dataArray) {
                    
                    if (lasModel.ID == atlasId) {
                        lasModel.coverImage = newCover;
                        [collectionView reloadData];
                        break;
                    }
                }
            };
            [self.navigationController pushViewController:pictureVC animated:YES];
        }
    }
}

#pragma mark - SJCollectionViewDelegate
- (void)dragCellCollectionViewCellBeginMoving:(SJCollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAAtlasModel *lasModel = dataArray[indexPath.item];
    self.dragingModel = lasModel;
}

- (void)collectionView:(SJCollectionView *)collectionView newDataSourceAfterMove:(NSArray *)newDataSource
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:newDataSource];
}

- (void)dragCellCollectionViewCellEndMoving:(SJCollectionView *)collectionView
{
    NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    /**
    NSMutableArray *atlasIds = [NSMutableArray arrayWithCapacity:dataArray.count-1];
    for (JAAtlasModel *lasModel in dataArray) {
        NSInteger index = [dataArray indexOfObject:lasModel];
        if (index == 0) continue;
        [atlasIds addObject:@(lasModel.ID)];
    }
     */
    NSInteger index = [dataArray indexOfObject:self.dragingModel];
    [JABbsPresenter postChangeLocation:self.dragingModel.ID index:index IsPaging:YES WithCurrentPage:currentPage.integerValue WithLimit:10 Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!model.success) {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
}

#pragma mark - SJCollectionViewDataSource
- (NSArray *)dataSourceOfCollectionView:(SJCollectionView *)collectionView
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    return dataArray;
}

#pragma mark - setter
- (void)setIsEditStyle:(BOOL)isEditStyle
{
    _isEditStyle = isEditStyle;
    [self.rightBtn setTitle:isEditStyle?@"删除":@"编辑" forState:UIControlStateNormal];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    for (JAAtlasModel *lasModel in dataArray) {
        lasModel.showType = isEditStyle?SJMyPictureShowTypeEdit:SJMyPictureShowTypeNormal;
    }
    [self.collectionView reloadData];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    self.noDataView.frame = CGRectMake(0, (self.view.height - 200)*0.5, self.view.width, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
