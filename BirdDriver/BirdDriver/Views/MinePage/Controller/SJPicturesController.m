//
//  SJPicturesController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJPicturesController.h"
#import "SJBrowserController.h"
#import "SJPhotosController.h"
#import "SJPhotoComponents.h"
#import "SJPhotoCell.h"
#import "SJAddPictureCell.h"
#import "SJNoDataFootView.h"
#import "SJCollectionView.h"
#import "JAAtlasListModel.h"
#import "SJPhotoModel.h"
#import "JABbsPresenter.h"
#import "JAFileUploadPresenter.h"
#import "MJRefresh.h"

@interface SJPicturesController () <SJCollectionViewDelegate, SJCollectionViewDataSource, UICollectionViewDelegateFlowLayout, SJPhotoProtocol>

@property (nonatomic, assign, getter=editStyle) BOOL isEditStyle;
@property (nonatomic, weak) SJCollectionView *collectionView;
@property (nonatomic, strong) SJNoDataFootView *noDataView;

@property (nonatomic, strong) JAPhotoModel *dragingModel;

@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation SJPicturesController
static NSString *const ID = @"SJPhotoCell";
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

- (SJNoDataFootView *)noDataView
{
    if (_noDataView == nil)
    {
        _noDataView = [SJNoDataFootView createCellWithXib];
        _noDataView.exceptionStyle = SJExceptionStyleNoData;
        _noDataView.backgroundColor = JMY_BG_COLOR;
    }
    return _noDataView;
}

#pragma mark - setter
- (void)setLasModel:(JAAtlasModel *)lasModel
{
    _lasModel = lasModel;
    self.titleName = lasModel.atlasName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    SJCollectionView *collectionView = [[SJCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = JMY_BG_COLOR;
    collectionView.showsVerticalScrollIndicator = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:NSClassFromString(ID) forCellWithReuseIdentifier:ID];
    [collectionView registerNib:[UINib nibWithNibName:@"SJAddPictureCell" bundle:nil] forCellWithReuseIdentifier:@"SJAddPictureCell"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    if (self.canAddPhoto) {
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.size = CGSizeMake(70, 30);
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor colorWithHexString:@"FFBB04" alpha:1] forState:UIControlStateNormal];
        editBtn.titleLabel.font = SPFont(15.0);
        [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    }
    
    [self getPhotoLists];
    [self addRefreshView];
}

- (void)addRefreshView
{
    UIScrollView *scrollView = (UIScrollView *)self.collectionView;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataDict setValue:@"1" forKey:SJCurrentPage];
        [self.dataDict setValue:[NSMutableArray array] forKey:SJCurrentData];
        [self getPhotoLists];
        
    }];
    scrollView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
        [self.dataDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue] + 1] forKey:SJCurrentPage];
        [self getPhotoLists];
    }];
    scrollView.mj_footer = footer;
}

- (void)getPhotoLists
{
    [SVProgressHUD show];
    NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
    [JABbsPresenter postQueryPicsList:self.lasModel.ID IsPaging:YES WithCurrentPage:[currentPage integerValue] WithLimit:20 Result:^(JAPhotoListModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success)
            {
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                for (JAPhotoModel *pictureModel in model.pictureList) {
                    pictureModel.showType = self.editStyle?SJMyPictureShowTypeEdit:SJMyPictureShowTypeNormal;
                }
                [dataArray addObjectsFromArray:model.pictureList];
                NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
                if ([currentPage isEqualToString:@"1"]) {
                    JAPhotoModel *tempModel = [[JAPhotoModel alloc] init];
                    [dataArray insertObject:tempModel atIndex:0];
                }
                self.collectionView.mj_footer.hidden = model.pictureList.count < 20;
                self.collectionView.mj_header.hidden = kArrayIsEmpty(dataArray);
                [self.collectionView reloadData];
                if (dataArray.count>1) {
                    JAPhotoModel *pictureModel = dataArray[1];
                    if (self.updateCoverBlock) {
                        self.updateCoverBlock(self.lasModel.ID, pictureModel.address);
                    }
                }
                if (kArrayIsEmpty(dataArray)) {
                    
                    [self.view insertSubview:self.noDataView aboveSubview:self.collectionView];
                } else {
                    
                    if (self.noDataView.superview) {
                        [self.noDataView removeFromSuperview];
                    }
                }
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        });
    }];
}

#pragma mark - event
- (void)editBtnClick
{
    if (!self.editStyle) {
        self.isEditStyle = YES;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.selected == YES"];
        NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
        NSArray *filterArray = [dataArray filteredArrayUsingPredicate:predicate];
        if (kArrayIsEmpty(filterArray)) {
            self.isEditStyle = NO;
        } else {
            [self deletePictures:filterArray];
        }
    }
}

- (void)uploadPictures
{
    [SJPhotoComponents requestPhotoAuthorizationWithCompletionHandler:^(BOOL isAllowed) {
        
        if (isAllowed)
        {
            SJPhotosController *photoVC = [[SJPhotosController alloc] init];
            photoVC.titleName = @"选择图片";
            photoVC.maximumLimit = 5;
            photoVC.delegate = self;
            [self.navigationController pushViewController:photoVC animated:YES];
        }
    }];
}

#pragma mark - SJPhotoProtocol
- (void)photoController:(SJPhotosController *)photoVC didSelectedPhotos:(NSArray<SJPhotoModel *> *)photos
{
    [SVProgressHUD show];
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:photos.count];
    for (SJPhotoModel *photoModel in photos) {
        
        dispatch_group_enter(group);
        NSData *imageData = UIImageJPEGRepresentation(photoModel.resultImage, 0.8);
        [JAFileUploadPresenter uploadFile:nil fileData:imageData fileDataKey:@"file" progress:nil success:^(id dataObject) {
            
            [imgArr addObject:dataObject[@"url"]];
            dispatch_group_leave(group);
        } failure:^(NSError *error) {
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self startAddPictures:imgArr];
    });
}

- (void)startAddPictures:(NSMutableArray *)imgArr
{
    NSString *imgStr = [imgArr componentsJoinedByString:@","];
    [JABbsPresenter postAddPicturesAtlasId:self.lasModel.ID userId:SPLocalInfo.userModel.Id pictures:imgStr Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success)
            {
#warning - XLL 屌丝接口，我只能再次请求，后期让接口优化
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                [dataArray removeAllObjects];
                [self.dataDict setValue:@"1" forKey:SJCurrentPage];
                [self getPhotoLists];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

- (void)deletePictures:(NSArray *)filterArray
{
    [SVProgressHUD show];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    NSMutableArray *ids = [NSMutableArray arrayWithCapacity:filterArray.count];
    for (JAPhotoModel *pictureModel in filterArray) {
        [ids addObject:[NSString stringWithFormat:@"%zd", pictureModel.ID]];
    }
    [JABbsPresenter postUpdatePictures:self.lasModel.ID isDeleted:YES WithPicIds:[ids componentsJoinedByString:@","] Result:^(JAResponseModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                
                NSMutableArray <NSIndexPath *>*indexPaths = [NSMutableArray array];
                for (JAPhotoModel *pictureModel in filterArray) {
                    NSInteger index = [dataArray indexOfObject:pictureModel];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                    [indexPaths addObject:indexPath];
                }
                [dataArray removeObjectsInArray:filterArray];
                [self.collectionView deleteItemsAtIndexPaths:indexPaths];
                if (kArrayIsEmpty(dataArray)) {
                    [self.view insertSubview:self.noDataView aboveSubview:self.collectionView];
                    self.isEditStyle = NO;
                }
                JAPhotoModel *firstModel = dataArray.count>1?dataArray[1]:nil;
                //接口，让我们告诉他应该展示哪张logo
                [JABbsPresenter postUpdateCorverImage:self.lasModel.ID pictureId:!kObjectIsEmpty(firstModel)?firstModel.ID:666666 Reuslt:^(JAResponseModel * _Nullable model) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        if (model.success) {
                            if (self.updateCoverBlock) {
                                self.updateCoverBlock(self.lasModel.ID, firstModel.address);
                            }
                        }
                    });
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

#pragma mark - UICollectionView..
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
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = (collectionView.width - kSJMargin * 2 - 3 * 5)/4.f;
    return CGSizeMake(itemW, itemW);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        SJAddPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJAddPictureCell" forIndexPath:indexPath];
        cell.descStr = @"添加图片";
        return cell;
    }
    SJPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAPhotoModel *photoModel = dataArray[indexPath.item];
    cell.pictureModel = photoModel;
    cell.photoCallBack = ^(id model) {
        
        if ([model isKindOfClass:[JAPhotoModel class]]) {
            
            JAPhotoModel *pictureModel = (JAPhotoModel *)model;
            pictureModel.isSelected = !pictureModel.selected;
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0)
    {
        [self uploadPictures];
        return;
    }
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAPhotoModel *pictureModel = dataArray[indexPath.item];
    if (pictureModel.showType == SJMyPictureShowTypeNormal)
    {
        //进入详情
        SJBrowserController *browserVC = [[SJBrowserController alloc] init];
        browserVC.fetchPhotoResults = [dataArray mutableCopy];
        browserVC.currentIndex = indexPath.item;
        browserVC.lasID = self.lasModel.ID;
        browserVC.noEdit = !self.canAddPhoto;
        browserVC.deleteBlock = ^(JAPhotoModel *pictureModel) {
            NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
            [dataArray removeObject:pictureModel];
            [self.collectionView reloadData];
            if (kArrayIsEmpty(dataArray)) {
                [self.view insertSubview:self.noDataView aboveSubview:self.collectionView];
                self.isEditStyle = NO;
            }
            
            JAPhotoModel *firstModel = !kArrayIsEmpty(dataArray)?dataArray.firstObject:nil;
            //接口，让我们告诉他应该展示哪张logo
            [JABbsPresenter postUpdateCorverImage:self.lasModel.ID pictureId:kObjectIsEmpty(firstModel)?666666:firstModel.ID Reuslt:^(JAResponseModel * _Nullable model) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (model.success) {
                        if (self.updateCoverBlock) {
                            self.updateCoverBlock(self.lasModel.ID, firstModel.address);
                        }
                    }
                });
            }];
        };
        [self.navigationController pushViewController:browserVC animated:YES];
    } else {
        //选择刷新
        pictureModel.isSelected = !pictureModel.selected;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

#pragma mark - SJCollectionViewDelegate
- (void)dragCellCollectionViewCellBeginMoving:(SJCollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAPhotoModel *pictureModel = dataArray[indexPath.item];
    self.dragingModel = pictureModel;
}

- (void)collectionView:(SJCollectionView *)collectionView newDataSourceAfterMove:(NSArray *)newDataSource
{
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:newDataSource];
}

- (void)dragCellCollectionViewCellEndMoving:(SJCollectionView *)collectionView
{
    NSInteger currentPage = [[self.dataDict valueForKey:SJCurrentPage] integerValue];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    /**
    NSMutableArray *pictureIds = [NSMutableArray arrayWithCapacity:dataArray.count-1];
    for (JAPhotoModel *pictureModel in dataArray) {
        NSInteger index = [dataArray indexOfObject:pictureModel];
        if (index == 0) continue;
        [pictureIds addObject:@(pictureModel.ID)];
    }
     */
    NSInteger index = [dataArray indexOfObject:self.dragingModel];
    [JABbsPresenter postChangePicLocation:self.dragingModel.ID index:index atlasId:self.lasModel.ID IsPaging:YES WithCurrentPage:currentPage WithLimit:20 Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                
                if (dataArray.count>1) {
                    JAPhotoModel *firstModel = dataArray[1];
                    if (self.updateCoverBlock) {
                        self.updateCoverBlock(self.lasModel.ID, firstModel.address);
                    }
                }
            } else {
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
//- (void)collectionView:(SJCollectionView *)collectionView didLongPressed:(UICollectionViewCell *)cell
//{
//    if (!self.canAddPhoto) return;
//    self.isEditStyle = !self.editStyle;
//    SJPhotoCell *photoCell = (SJPhotoCell *)cell;
//    if (photoCell.pictureModel.showType == SJMyPictureShowTypeEdit)
//    {
//        photoCell.pictureModel.isSelected = YES;
//    }
//    [collectionView reloadData];
//}

#pragma mark - setter
- (void)setIsEditStyle:(BOOL)isEditStyle
{
    _isEditStyle = isEditStyle;
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    for (JAPhotoModel *pictureModel in dataArray) {
        pictureModel.showType = isEditStyle?SJMyPictureShowTypeEdit:SJMyPictureShowTypeNormal;
    }
    UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
    [btn setTitle:isEditStyle?@"删除":@"编辑" forState:UIControlStateNormal];
    [self.collectionView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    self.noDataView.frame = CGRectMake(0, (self.view.height-200)*0.5, self.view.width, 200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
