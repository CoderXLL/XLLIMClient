//
//  SJHotActivityController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/6/1.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJHotActivityController.h"
#import "SJBuildActivityController.h"
//#import "SJDetailController.h"
#import "SJFootprintDetailsController.h"
#import "SJBackButton.h"
#import "SJMyCollectionCell.h"
#import "SJNoDataFootView.h"
#import "JABbsPresenter.h"
#import "SJLoginController.h"

@interface SJHotNavgationBar ()

@property (nonatomic, weak) SJBackButton *backBtn;
@property (nonatomic, weak) UIButton *rightBtn;

@end

@implementation SJHotNavgationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupBase];
    }
    return self;
}

- (void)setupBase
{
    self.layer.shadowColor = SJ_TITLE_COLOR.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 8;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, kScreenWidth, kNavBarHeight));
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    SJBackButton *backBtn = [SJBackButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self
                action:@selector(backBtnClick)
      forControlEvents:UIControlEventTouchUpInside];
    backBtn.imageStr = @"Set_back";
    [self addSubview:backBtn];
    self.backBtn = backBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self
                 action:@selector(rightBtnClick)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    self.rightBtn = rightBtn;
}

- (void)backBtnClick
{
    if (self.clickBlock) {
        self.clickBlock(YES);
    }
}

- (void)rightBtnClick
{
    if (self.clickBlock) {
        self.clickBlock(NO);
    }
}

#pragma mark - setter
- (void)setTitleName:(NSString *)titleName
{
    _titleName = [titleName copy];
    self.backBtn.titleStr = titleName;
    [self setNeedsLayout];
}

- (void)setNavgationBarStyle:(SJHotNavgationBarStyle)navgationBarStyle
{
    _navgationBarStyle = navgationBarStyle;
    switch (navgationBarStyle) {
        case SJHotNavgationBarStyleHotActivity:
        {
            [self.rightBtn setTitle:@"发起足迹" forState:UIControlStateNormal];
            [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"2B3248" alpha:1.0] forState:UIControlStateNormal];
            [self.rightBtn setImage:[UIImage imageNamed:@"hotActivity_navBtn"] forState:UIControlStateNormal];
            self.rightBtn.titleLabel.font = SPFont(15.0);
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"hotActivity_navBg"] forState:UIControlStateNormal];
        }
            break;
        case SJHotNavgationBarStyleMessage:
        {
            [self.rightBtn setImage:[UIImage imageNamed:@"messageRead"] forState:UIControlStateNormal];
        }
            break;
        case SJHotNavgationBarStyleNone:
        {
            self.rightBtn.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize backSize = self.backBtn.size;
    CGFloat height = iPhoneX ? 20 : 10;
    self.backBtn.frame = CGRectMake(15, (kNavBarHeight-backSize.height)/2.0+height, backSize.width, backSize.height);
    self.rightBtn.frame = CGRectMake(self.width - 100, (kNavBarHeight-30)/2.0+height, 100, 30);
}

@end

@interface SJHotActivityController () <SJMyCollectionCellDelegate>

@property (nonatomic, weak) SJHotNavgationBar *navigationBar;
@property (nonatomic, strong) SJNoDataFootView *noDataView;
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation SJHotActivityController
static NSString *const SJCurrentPage = @"SJCurrentPage";
static NSString *const SJCurrentData = @"SJCurrentData";
static NSString *const SJFooterHiden = @"SJFooterHiden";

#pragma mark - lazy loading
- (NSMutableDictionary *)dataDict {
    if (_dataDict == nil) {
        _dataDict = [NSMutableDictionary dictionary];
        [_dataDict setValue:@"1" forKey:SJCurrentPage];
        [_dataDict setValue:[NSMutableArray array] forKey:SJCurrentData];
        [_dataDict setValue:@"0" forKey:SJFooterHiden];
    }
    return _dataDict;
}

- (SJNoDataFootView *)noDataView {
    if (_noDataView == nil) {
        _noDataView = [SJNoDataFootView createCellWithXib];
        _noDataView.backgroundColor = JMY_BG_COLOR;
        _noDataView.exceptionStyle = SJExceptionStyleNoData;
    }
    return _noDataView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupNavgationBar];
    [self addRefreshView];
    [self getHotActivityList];
}

- (void)addRefreshView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.dataDict setValue:@"1" forKey:SJCurrentPage];
        NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
        [dataArray removeAllObjects];
        [self getHotActivityList];
    }];
    self.listView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
        [self.dataDict setValue:[NSString stringWithFormat:@"%zd", [currentPage integerValue]+1] forKey:SJCurrentPage];
        [self getHotActivityList];
    }];
    self.listView.mj_footer = footer;
}

- (void)getHotActivityList {
    [SVProgressHUD show];
    NSString *currentPage = [self.dataDict valueForKey:SJCurrentPage];
    [JABbsPresenter postQueryDetailsByLabels:self.labelModel.labelName queryType:JADetailsTypeActivity isPaging:YES withCurrentPage:[currentPage integerValue] withLimit:10 Result:^(JADiscRecGroupModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                
                NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                [dataArray addObjectsFromArray:model.detailsPO.activitysList];
                self.listView.mj_footer.hidden = (model.detailsPO.activitysList.count < 10);
                self.listView.mj_header.hidden = kArrayIsEmpty(dataArray);
                [self.listView reloadData];
                if (kArrayIsEmpty(dataArray)) {
                    
                    [self.view insertSubview:self.noDataView aboveSubview:self.listView];
                } else {
                    if (self.noDataView.superview) {
                        [self.noDataView removeFromSuperview];
                    }
                }
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            [self endRefreshView];
        });
    }];
}

- (void)endRefreshView {
    [self.listView.mj_header endRefreshing];
    [self.listView.mj_footer endRefreshing];
}

- (void)setupNavgationBar {
    SJHotNavgationBar *navigationBar = [[SJHotNavgationBar alloc] init];
    navigationBar.titleName = self.titleName;
    navigationBar.navgationBarStyle = SJHotNavgationBarStyleHotActivity;
    navigationBar.backgroundColor = [UIColor whiteColor];
    navigationBar.clickBlock = ^(BOOL isBack) {
        
        if (isBack) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            if ([self alertAction])
            {
                SJBuildActivityController *buildVC = [[SJBuildActivityController alloc] init];
                buildVC.titleName = @"发起足迹";
                buildVC.buildSuccessBlock = ^{
                    
                    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
                    [dataArray removeAllObjects];
                    [self getHotActivityList];
                };
                [self.navigationController pushViewController:buildVC animated:YES];
            }
            
        }
    };
    [self.view addSubview:navigationBar];
    self.navigationBar = navigationBar;
}


#pragma mark - 判断登录弹窗
-(BOOL)alertAction {
    if (![SPLocalInfoModel shareInstance].hasBeenLogin)
    {
        SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认" handler:^(id content) {
            [self loginAction];
        }];
        SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
        }];
        SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否登录" message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel,cancelModel]];
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

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    if (kArrayIsEmpty(dataArray)) {
        return 0.0001;
    }
    return 15.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SJMyCollectionCell *cell = [SJMyCollectionCell xibCell:tableView];
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAActivityModel *activityModel = dataArray[indexPath.row];
    cell.activityModel = activityModel;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Web版足迹详情
    //    SJDetailController *detailVC = [[SJDetailController alloc] init];
    //    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    //    JAActivityModel *activityModel = dataArray[indexPath.row];
    //    detailVC.titleName = activityModel.detailsName;
    //    NSString *postDetail = [NSString stringWithFormat:@"%@/activityDetail?id=%zd", JA_SERVER_WEB, activityModel.ID];
    //    detailVC.detailStr = postDetail;
    //    [self.navigationController pushViewController:detailVC animated:YES];
    
    //原生版足迹详情
    SJFootprintDetailsController *detailVC = [[SJFootprintDetailsController alloc] init];
    detailVC.tableViewStyle = UITableViewStylePlain;
    NSMutableArray *dataArray = [self.dataDict valueForKey:SJCurrentData];
    JAActivityModel *activityModel = dataArray[indexPath.row];
    
    //活动id
    detailVC.activityId = activityModel.ID;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.navigationBar.frame = CGRectMake(0, 0, self.view.width, kNavBarHeight);
    self.listView.frame = CGRectMake(0, kNavBarHeight, self.view.width, self.view.height - kNavBarHeight);
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
