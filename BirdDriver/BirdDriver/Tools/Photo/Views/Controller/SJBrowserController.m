//
//  SJBrowserController.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.

#import "SJBrowserController.h"
#import "JAPhotoListModel.h"
#import "SJPhotoComponents.h"
#import "SJPhotoNavigationBar.h"
#import "SJBackButton.h"
#import "SJBrowserCell.h"
#import "SJCollectionView.h"
#import "SJBrowserFlowLayout.h"
#import "JABbsPresenter.h"

@interface SJBrowserController ()<UICollectionViewDataSource, SJCollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, SJBrowserCellDelegate>
{
    BOOL _isBarHidden;
}

@property (nonatomic, weak) SJCollectionView *collectionView;
@property (nonatomic, weak) SJPhotoNavigationBar *navigationBar;

@end

@implementation SJBrowserController
static NSString *ID = @"SJBrowserCell";


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
#pragma clang diagnostic pop
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
#pragma clang diagnostic pop
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
    [self createNavigationBar];
    
    if (@available(iOS 11.0, *)) {
        
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    //对collectionView添加单击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick:)];
    [self.collectionView addGestureRecognizer:tapGesture];
}

- (void)createNavigationBar
{
    SJPhotoNavigationBar *navigationBar = [[SJPhotoNavigationBar alloc] init];
    
    WEAKSELF
    navigationBar.popBlock = ^{
        
        if ([self.fetchPhotoResults.firstObject isKindOfClass:[JAPhotoModel class]])
        {
            for (JAPhotoModel *pictureModel in self.fetchPhotoResults) {
                pictureModel.showType = SJMyPictureShowTypeNormal;
            }
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:navigationBar];
    self.navigationBar = navigationBar;
}

- (void)createSubviews
{
    SJBrowserFlowLayout *flowLayout = [[SJBrowserFlowLayout alloc] init];
    SJCollectionView *collectionView = [[SJCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor blackColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor blackColor];
    
    [collectionView registerClass:NSClassFromString(ID) forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - EVENT
- (void)tapGestureClick:(UITapGestureRecognizer *)tapGesture
{
    _isBarHidden = !_isBarHidden;
    self.navigationBar.hidden = _isBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
    
    CGPoint touchPoint = [tapGesture locationOfTouch:0 inView:tapGesture.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];
    
    if ([self.fetchPhotoResults.firstObject isKindOfClass:[JAPhotoModel class]])
    {
        JAPhotoModel *pictureModel = self.fetchPhotoResults[indexPath.item];
        if (pictureModel.showType == SJMyPictureShowTypeEdit)
        {
            pictureModel.showType = SJMyPictureShowTypeNormal;
            pictureModel.isSelected = NO;
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
}

#pragma mark - 状态栏设置
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

- (BOOL)prefersStatusBarHidden
{
    return _isBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchPhotoResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SJBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

#pragma mark - SJCollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(SJBrowserCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.model = self.fetchPhotoResults[indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(SJBrowserCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.zoomScale = 1;
}

- (void)collectionView:(SJCollectionView *)collectionView didLongPressed:(SJBrowserCell *)cell
{
    if (self.noEdit) {
        return;
    }
    if ([cell.model isKindOfClass:[JAPhotoModel class]])
    {
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
        JAPhotoModel *pictureModel = cell.model;
        pictureModel.showType = SJMyPictureShowTypeEdit;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

#pragma mark - SJBrowserCellDelegate
- (void)didDeleteBrowserCell:(SJBrowserCell *)cell
{
    id model = cell.model;
    if ([model isKindOfClass:[JAPhotoModel class]]) {
        
        JAPhotoModel *pictureModel = (JAPhotoModel *)model;
        [JABbsPresenter postUpdatePictures:self.lasID isDeleted:YES WithPicIds:[NSString stringWithFormat:@"%zd", pictureModel.ID] Result:^(JAResponseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (model.success) {
                    
                    NSInteger index = [self.fetchPhotoResults indexOfObject:pictureModel];
                    [self.fetchPhotoResults removeObjectAtIndex:index];
                    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
                    if (self.deleteBlock) {
                        self.deleteBlock(pictureModel);
                    }
                    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    if (kArrayIsEmpty(self.fetchPhotoResults)) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:@"删除出错"];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    }
}

#pragma mark - UIGestureRecognizerDelegate
//解决单击手势和双击手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.navigationBar.frame = CGRectMake(0, 0, self.view.width, kNavBarHeight);
    self.collectionView.frame = self.view.bounds;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

