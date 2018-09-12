//
//  SJDiscoveryController.m
//  BirdDriver
//
//  Created by Soul on 2018/5/16.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJDiscoveryController.h"
#import "SJBuildNoteController.h"
#import "SJHotActivityController.h"
#import "SJLoginController.h"
#import "SJDetailController.h"
#import "SJNoteDetailController.h"
#import "SJRouteListController.h"
#import "SJSegmentView.h"
#import "SJNoDataFootView.h"
#import "SJWaterCollectionViewCell.h"
#import "SJBaseWaterCollectionCell.h"
#import "SJWaterTextCell.h"
#import "SJDiscoveryHeaderCollectionReusableView.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "UIImage+ColorsImage.h"
#import "SJSearchViewController.h"
#import "JABbsPresenter.h"

@interface SJDiscoveryController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, SJWaterCollectionCellDelegate>
{
    NSInteger _currentIndex;
}

@property (nonatomic, strong, nonnull) UIView *titleView;
@property (nonatomic, strong, nonnull) SJSegmentView *sliderSegmentView;
@property (strong, nonatomic) UICollectionView *mainCollectionView;
@property (nonatomic, strong) NSMutableDictionary *dataDict;
//标签集合
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) SJNoDataFootView *noNetView;

@end

@implementation SJDiscoveryController
static NSString *const SJCurrentPage = @"SJCurrentPage";
static NSString *const SJHeaderData = @"SJHeaderData";
static NSString *const SJCurrentData = @"SJCurrentData";
static NSString *const SJFooterHiden = @"SJFooterHiden";
static NSString *const footerID = @"SJNoDataFootView";

#pragma mark - lazy loading
- (SJNoDataFootView *)noNetView
{
    if (_noNetView == nil)
    {
        _noNetView = [SJNoDataFootView createCellWithXib];
        _noNetView.exceptionStyle = SJExceptionStyleNoNet;
        _noNetView.backgroundColor = [UIColor whiteColor];
        _noNetView.buttonView.customButtonClickBlock = ^(UIButton *button) {
            
            if (!kArrayIsEmpty(self.tags)) {
                NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", self->_currentIndex]];
                [currentDict setValue:@"1" forKey:SJCurrentPage];
                NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
                [dataArray removeAllObjects];
                [currentDict setValue:@"0" forKey:SJFooterHiden];
                JABbsLabelModel *labelModel = [self.tags objectAtIndex:self->_currentIndex];
                [self requestTagNote:labelModel];
            } else {
                [self getAllTagList];
            }
        };
    }
    return _noNetView;
}


- (NSMutableDictionary *)dataDict
{
    if (_dataDict == nil)
    {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}


- (NSMutableArray *)tags
{
    if (_tags == nil)
    {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kNavBarHeight+40)+5)];
        //鸟巢title
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"鸟巢";
        titleLabel.textColor = [UIColor colorWithHexString:@"121212" alpha:1.0];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.0f];
        [_titleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat statusBarH = iPhoneX?44:20;
            make.top.equalTo(self->_titleView).with.offset((kNavBarHeight-statusBarH-18)*0.5+statusBarH);
            make.centerX.equalTo(self->_titleView).with.offset(0);
        }];
        
        //发帖按钮
        UIButton *postingBtn = [[UIButton alloc] init];
        [postingBtn setImage:[UIImage imageNamed: @"discovery_posting_new"] forState:UIControlStateNormal];
        [postingBtn addTarget:self action:@selector(postMessageAction) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:postingBtn];
        [postingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(titleLabel.mas_top);
            make.centerY.equalTo(titleLabel.mas_centerY);
            make.right.equalTo(self->_titleView).with.offset(-15);
        }];
        //滑动标签
        [_titleView addSubview:self.sliderSegmentView];
    }
    return _titleView;
}

- (SJSegmentView *)sliderSegmentView{
    if (!_sliderSegmentView) {
        
        _sliderSegmentView = [[SJSegmentView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, 40)];
        __weak typeof(self)weakSelf = self;
        _sliderSegmentView.titleChooseReturn = ^(int x) {

            self->_currentIndex = x;
            NSMutableDictionary *currentDict = [weakSelf.dataDict valueForKey:[NSString stringWithFormat:@"%d",x]];
             LogD(@"%p", currentDict);
            NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
            if (kArrayIsEmpty(dataArray)) {
                JABbsLabelModel *labelModel = weakSelf.tags[x];
                [weakSelf requestTagNote:labelModel];
                
                //埋点发现页推荐标签
                NSString *nsjId = [NSString stringWithFormat:@"400103%02d",x+1];
                NSString *nsjDes = [NSString stringWithFormat:@"点击发现推荐标签%@",labelModel.labelName];
                [SJStatisticEventTool umengEvent:Nsj_Event_Discovery
                                           NsjId:nsjId
                                         NsjName:nsjDes];
                
            } else {
                [weakSelf.mainCollectionView reloadData];
                //多此一举？
                [weakSelf.mainCollectionView setContentOffset:CGPointZero];
            }
        };
    }
    return _sliderSegmentView;
}

-(UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.minimumColumnSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.headerHeight = 90;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (kNavBarHeight+40)+5, kScreenWidth, kScreenHeight - ((kNavBarHeight+40)+5) - kTabBarHeight) collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = HEXCOLOR(@"F5F5F5");
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"SJWaterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SJWaterCollectionViewCell"];
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"SJWaterTextCell" bundle:nil] forCellWithReuseIdentifier:@"SJWaterTextCell"];
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"SJDiscoveryHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:@"SJDiscoveryHeaderCollectionReusableView"];
        [_mainCollectionView registerNib:[UINib nibWithNibName:footerID bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter withReuseIdentifier:footerID];
        if (@available(iOS 11.0, *)) {
            _mainCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _mainCollectionView.contentInset = UIEdgeInsetsMake(0, 0, iPhoneX?34:0, 0);
    }
    return _mainCollectionView;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(homeJump:)
                                                     name:kNotify_homeJump
                                                   object:nil];
    }
    return self;
}

- (void)homeJump:(NSNotification *)notification
{
    NSString *jumpIndex = notification.object;
    if ([self isViewLoaded])
    {
        [self.sliderSegmentView clickButtonWithIndex:jumpIndex];
    } else {
        self->_currentIndex = jumpIndex.integerValue;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.mainCollectionView];
    [self addRefreshView];
    //获取所有标签
    [self getAllTagList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotePraise:)
                                                 name:kNotify_notePraise
                                               object:nil];
}

- (void)updateNotePraise:(NSNotification *)notification
{
    BOOL isPraise = [notification.object integerValue];
    NSInteger detailId = [[notification.userInfo valueForKey:@"detailsId"] integerValue];
    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", _currentIndex]];
    NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
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
        
        NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", self->_currentIndex]];
        [currentDict setValue:@"1" forKey:SJCurrentPage];
        [currentDict setValue:@"1" forKey:SJFooterHiden];
        NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
        [dataArray removeAllObjects];
        if (!kArrayIsEmpty(self.tags)) {
            JABbsLabelModel *labelModel = [self.tags objectAtIndex:self->_currentIndex];
            [self requestTagNote:labelModel];
        } else {
            [self.mainCollectionView.mj_header endRefreshing];
        }
    }];
    self.mainCollectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", self->_currentIndex]];
        NSString *currentPage = [currentDict valueForKey:SJCurrentPage];
        [currentDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue] + 1] forKey:SJCurrentPage];
        JABbsLabelModel *labelModel = [self.tags objectAtIndex:self->_currentIndex];
        [self requestTagNote:labelModel];
    }];
    self.mainCollectionView.mj_footer = footer;
}

- (void)getAllTagList
{
    [SVProgressHUD show];

    [JABbsPresenter postQueryLabelsList:nil
                               IsPaging:YES
                        WithCurrentPage:1
                              WithLimit:10
                                 Result:^(JADiscRecLabelModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success)
            {
                self.tags = [model.labelList mutableCopy];
                NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:self.tags.count];
                for (JABbsLabelModel *labelModel in self.tags) {
                    NSString *labelN = [labelModel.labelName stringByReplacingOccurrencesOfString:@"#" withString:@""];
                    [titleArr addObject:labelN];
                }
                [self.sliderSegmentView setTitleArray:titleArr
                                            titleFont:14.0
                                           titleColor:HEXCOLOR(@"BDBDBD")
                                   titleSelectedColor:HEXCOLOR(@"2C344A")
                                            withStyle:SJSegmentStyleSlider];
                //根据标签，创建字典
                [self buildDataDict];
                if (!kArrayIsEmpty(self.tags)) {
                    //这里有点击了，就不需要再请求一遍了
//                    JABbsLabelModel *labelModel = self.tags[self->_currentIndex];
                    [self.sliderSegmentView clickButtonWithIndex:[NSString stringWithFormat:@"%zd", self->_currentIndex]];
//                    [self requestTagNote:labelModel];
                }
            } else {
                if (!self.noNetView.superview) {
                    [self.view insertSubview:self.noNetView aboveSubview:self.mainCollectionView];
                }
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

- (void)buildDataDict
{
    for (JABbsLabelModel *labelModel in self.tags) {
        
        NSInteger index = [self.tags indexOfObject:labelModel];
        NSMutableDictionary* dataDictM = [NSMutableDictionary dictionary];
        // 默认是第1页
        [dataDictM setValue:@"1" forKey:SJCurrentPage];
        // 默认隐藏
        [dataDictM setValue:@"1" forKey:SJFooterHiden];
        // 默认无数据
        [dataDictM setValue:[NSMutableArray array] forKey:SJCurrentData];
        // 透视图数据
        [dataDictM setValue:labelModel forKey:SJHeaderData];
        [self.dataDict setValue:dataDictM forKey:[NSString stringWithFormat:@"%zd", index]];
    }
}

- (void)requestTagNote:(JABbsLabelModel *)labelModel
{
    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", _currentIndex]];
    NSString *footerHiden = [currentDict valueForKey:SJFooterHiden];
    self.mainCollectionView.mj_footer.hidden = [footerHiden isEqualToString:@"1"];
    NSString *currentPage = [currentDict valueForKey:SJCurrentPage];
    [JABbsPresenter postQueryDiscoveryActivity:labelModel.ID
                                 withLabelName:labelModel.labelName
                            withlabelActsCount:1
                                      isPaging:YES
                               withCurrentPage:[currentPage integerValue]
                                     withLimit:10
                                        Result:^(JADiscRecGroupModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success) {
                
                if (self.noNetView.superview) {
                    [self.noNetView removeFromSuperview];
                }
                NSMutableArray *currentData = [currentDict valueForKey:SJCurrentData];
                //防止边下拉刷新，边点击出现bug
                if ([currentPage isEqualToString:@"1"]) {
                    [currentData removeAllObjects];
                }
                [currentData addObjectsFromArray:model.detailsPO.postsList];
                self.mainCollectionView.mj_footer.hidden = (model.detailsPO.postsList.count < 10);
                [currentDict setValue:[NSString stringWithFormat:@"%d", (model.detailsPO.postsList.count < 10)] forKey:SJFooterHiden];
                [self.mainCollectionView reloadData];
                [self.mainCollectionView.mj_footer endRefreshing];
                [self.mainCollectionView.mj_header endRefreshing];
            } else {
                if (!self.noNetView.superview) {
                    [self.view insertSubview:self.noNetView aboveSubview:self.mainCollectionView];
                }
            }
        });
    }];
}

#pragma mark - 发帖
- (void)postMessageAction{
    //埋点发现页发帖
    NSString *nsjId = @"40010100";
    NSString *nsjDes = [NSString stringWithFormat:@"发现页发帖"];
    [SJStatisticEventTool umengEvent:Nsj_Event_Discovery
                               NsjId:nsjId
                             NsjName:nsjDes];
    
    if ([self alertAction])
    {
        if (kArrayIsEmpty(self.tags)) {
            [SVProgressHUD showErrorWithStatus:@"标签数量为空~"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            return;
        }
        SJBuildNoteController *buildNoteVC = [[SJBuildNoteController alloc] init];
        buildNoteVC.titleName = @"新建帖子";
        JABbsLabelModel *labelModel = self.tags[_currentIndex];
        buildNoteVC.defaultTagLabel = labelModel;
        [self.navigationController pushViewController:buildNoteVC animated:YES];
    }
}

#pragma mark - 判断登录弹窗
-(BOOL)alertAction {
    if (![SPLocalInfoModel shareInstance].hasBeenLogin)
    {
        SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认"
                                                               handler:^(id content) {
            [self loginAction];
        }];
        SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消"
                                                                handler:^(id content) {
        }];
        SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否登录"
                                                     message:@""
                                                        type:SJAlertShowTypeNormal
                                                 alertModels:@[alertModel,cancelModel]];
        [alertView showAlertView];
        return NO;
    }
    return YES;
}

#pragma mark - 登录
- (void)loginAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_Login_Request
                                                        object:nil];
}

#pragma mark - 搜索
-(void)searchAction{
    SJSearchViewController *searchVC = [[SJSearchViewController alloc] init];
    searchVC.titleName = @"";
    [self.navigationController pushViewController:searchVC animated:YES];
    
    //埋点搜索框
    NSString *nsjId = @"40010200";
    NSString *nsjDes = @"点击发现页搜索框";
    [SJStatisticEventTool umengEvent:Nsj_Event_Discovery
                               NsjId:nsjId
                             NsjName:nsjDes];
}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", _currentIndex]];
    NSString *footerHiden = [currentDict valueForKey:SJFooterHiden];
    collectionView.mj_footer.hidden = [footerHiden isEqualToString:@"1"];
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
       SJDiscoveryHeaderCollectionReusableView *reusableView  =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:@"SJDiscoveryHeaderCollectionReusableView"   forIndexPath:indexPath];
        NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", _currentIndex]];
        JABbsLabelModel *labelModel = [currentDict valueForKey:SJHeaderData];
        reusableView.labelModel = labelModel;
        reusableView.detailBlock = ^{
            
            SJRouteListController *routeListVC = [[SJRouteListController alloc] init];
            routeListVC.titleName = @"    ";
            JABbsLabelModel *labelModel = self.tags[self->_currentIndex];
            routeListVC.labelModel = labelModel;
            [self.navigationController pushViewController:routeListVC animated:YES];
            /**
                SJHotActivityController *hotActivityVC = [[SJHotActivityController alloc] init];
                hotActivityVC.titleName = @"热门足迹";
                JABbsLabelModel *labelModel = self.tags[self->_currentIndex];
                hotActivityVC.labelModel = labelModel;
                [self.navigationController pushViewController:hotActivityVC animated:YES];
             */
            
            //埋点发现页足迹列表
            NSString *nsjId = [NSString stringWithFormat:@"400104%02d",(int)_currentIndex+1];
            NSString *nsjDes = [NSString stringWithFormat:@"点击发现推荐足迹列表%@",labelModel.labelName];
            [SJStatisticEventTool umengEvent:Nsj_Event_Discovery
                                       NsjId:nsjId
                                     NsjName:nsjDes];
            
        };
        return reusableView;
    } else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        
        SJNoDataFootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter withReuseIdentifier:footerID forIndexPath:indexPath];
        footerView.exceptionStyle = SJExceptionStyleNoData;
        return footerView;
    }
    return nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", _currentIndex]];
    NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
    self.mainCollectionView.backgroundColor = kArrayIsEmpty(dataArray)?[UIColor whiteColor]:[UIColor colorWithHexString:@"F5F5F5" alpha:1];
    if (kArrayIsEmpty(dataArray)) {
        return kScreenHeight - ((kNavBarHeight+40)+5) - kTabBarHeight - kNavBarHeight;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", _currentIndex]];
     LogD(@"%p", currentDict);
    NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
     LogD(@"总共有%zd个数据", dataArray.count);
    return dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    SJWaterCollectionViewCell *cell = (SJWaterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SJWaterCollectionViewCell" forIndexPath:indexPath];
    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", _currentIndex]];
    NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
    if (indexPath.item < dataArray.count) {
         JAPostsModel *postModel = dataArray[indexPath.item];
        SJBaseWaterCollectionCell *cell = [SJBaseWaterCollectionCell cellForPostsModel:postModel
                                                                        collectionView:collectionView
                                                                             indexPath:indexPath Delegate:self];
        return cell;
    } else {
#ifdef DEBUG
        [SVProgressHUD showInfoWithStatus:@"这个是移动端bug，上线时不会出现这个提示"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
#endif
    }
    //闪退
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"SJWaterCollectionViewCell"
                                                     forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%ld", _currentIndex]];
    NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
    JAPostsModel *postsModel = dataArray[indexPath.item];
//    SJDetailController *detailVC = [[SJDetailController alloc] init];
//    NSString *postDetail = [NSString stringWithFormat:@"%@/postingDetail?id=%ld", JA_SERVER_WEB, postsModel.ID];
//    detailVC.detailStr = postDetail;
//    detailVC.titleName = @"帖子详情";
//    [self.navigationController pushViewController:detailVC animated:YES];
    SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
    detailVC.noteId = postsModel.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //埋点发现页帖子
    NSString *nsjId = [NSString stringWithFormat:@"400105%02d",(int)indexPath.row+1];
    NSString *nsjDes = [NSString stringWithFormat:@"点击发现页推荐帖子"];
    [SJStatisticEventTool umengEvent:Nsj_Event_Discovery
                               NsjId:nsjId
                             NsjName:nsjDes];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%ld", (long)_currentIndex]];
    NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
    JAPostsModel *postsModel = [dataArray objectAtIndex:indexPath.item];
    CGFloat cellWidth = (collectionView.width - 2 * 10)/2.0-10;
    if (!CGSizeEqualToSize(postsModel.imageSize, CGSizeZero)) {
        
        CGFloat titleHeight = [postsModel.detailsName boundingRectWithSize:CGSizeMake(cellWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0]} context:nil].size.height;
        CGFloat imageH = cellWidth * postsModel.imageSize.height*1.0 / postsModel.imageSize.width;
//        return CGSizeMake(cellWidth, imageH + titleHeight+20+10);
        return CGSizeMake(cellWidth, imageH+titleHeight+60+6);
    } else if (kArrayIsEmpty(postsModel.imagesAddressList)) {
        //纯文本部分
//        CGFloat titleHeight = [postsModel.detailsName boundingRectWithSize:CGSizeMake(cellWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(12.0)} context:nil].size.height;
//        return CGSizeMake(cellWidth, titleHeight+60+6);
        return CGSizeMake(cellWidth, postsModel.waterTextHeight);
    }
    return CGSizeMake(cellWidth, cellWidth*1.2);
}

#pragma mark - SJWaterCollectionCellDelegate
- (void)didSetupImageSize:(JAPostsModel *)postModel
{
    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", _currentIndex]];
    NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
    NSInteger itemIndex = [dataArray indexOfObject:postModel];
    LogD(@"~~~%@-%zd~~~", NSStringFromCGSize(postModel.imageSize), itemIndex);
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
                    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", self->_currentIndex]];
                    NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[dataArray indexOfObject:postModel] inSection:0];
                    postModel.praisesId = nil;
                    postModel.praises -= 1;
                    [self.mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                }
            });
        }];
    } else {
        //点赞
        [SVProgressHUD show];
        [JABbsPresenter postAddPraise:JADetailsTypePost
                        WithDetailsId:postModel.ID
                               Result:^(JAAddPraiseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    
                    [SVProgressHUD dismiss];
                    NSMutableDictionary *currentDict = [self.dataDict valueForKey:[NSString stringWithFormat:@"%zd", self->_currentIndex]];
                    NSMutableArray *dataArray = [currentDict valueForKey:SJCurrentData];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[dataArray indexOfObject:postModel] inSection:0];
                    postModel.praisesId = @(model.praisesRelationId);
                    postModel.praises += 1;
                    [self.mainCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                    
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
    self.noNetView.frame = CGRectMake(0, (kNavBarHeight+40)+5, self.view.width, self.view.height-((kNavBarHeight+40)+5));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
