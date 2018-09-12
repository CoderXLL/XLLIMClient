//
//  SJSearchViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSearchViewController.h"
#import "SJFootprintDetailsController.h"
#import "LLSearchView.h"
#import "SJSearchHeaderView.h"
#import "SJLabelTableViewCell.h"
#import "SJActivityListTableViewCell.h"
#import "SJMyNoteCell.h"
#import "SJSearchNoDataView.h"
#import "JABbsPresenter.h"
#import "SJSearchMoreActivityController.h"
#import "SJSearchTipsView.h"
#import "SJDetailController.h"
#import "SJNoteDetailController.h"
#import "SJSearckUserTableViewCell.h"
#import "SJOtherInfoPageController.h"
#import "SJMoreUserViewController.h"


@interface SJSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) LLSearchView *searchView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) SJSearchNoDataView *noDataView;
@property (nonatomic, strong) NSMutableArray *hotSearchArray;
@property (nonatomic, strong) NSMutableArray *historySearchArray;
@property (nonatomic, strong)NSMutableArray *searchArray;

@property (nonatomic, strong) SJSearchTipsView *tipsView;

@property(nonatomic, assign)NSInteger page;

@end

@implementation SJSearchViewController




- (NSMutableArray *)hotSearchArray{
    if (!_hotSearchArray) {
       _hotSearchArray = [NSMutableArray array];
    }
    return _hotSearchArray;
}

- (NSMutableArray *)historySearchArray{
    if (!_historySearchArray) {
        _historySearchArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"HistorySearch"] mutableCopy];
        if (!_historySearchArray) {
            _historySearchArray = [NSMutableArray array];
        }
    }
    return _historySearchArray;
}

#pragma mark - 搜索历史
- (LLSearchView *)searchView{
    if (!_searchView) {
        self.searchView = [[LLSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) hotArray:self.hotSearchArray historyArray:self.historySearchArray];
        __weak SJSearchViewController *weakSelf = self;
        _searchView.tapAction = ^(NSString *str) {
            [weakSelf pushToSearchResultWithSearchStr:str];
        };
    }
    return _searchView;
}

-(void)getHotSearchArrayAction{
    [JABbsPresenter postQueryLabelsListIsPaging:YES Limit:15 Result:^(JADiscRecLabelModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success && [model.labelList count] > 0) {
                for (JABbsLabelModel *labelModel in model.labelList) {
                    [self.hotSearchArray addObject:labelModel.labelName];
                }
            } else {
                self.hotSearchArray = [NSMutableArray array];
            }
            [self.view addSubview:self.searchView];
        });
    }];
}

- (void)beginRefreshing {
    self.page = 1;
     [self pushToSearchResultWithSearchStr:self.searchTextField.text];
}

- (void)lodingMore {
    self.page ++;
    [self getSearchPosts:self.searchTextField.text];
}

#pragma mark - 搜索结果mainTableView
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = HEXCOLOR(@"FFFFFF");
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJLabelTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJLabelTableViewCell"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJSearckUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJSearckUserTableViewCell"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJActivityListTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJActivityListTableViewCell"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJMyNoteCell" bundle:nil] forCellReuseIdentifier:@"SJMyNoteCell"];
        _mainTableView.separatorStyle = UITableViewCellEditingStyleNone;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self beginRefreshing];
        }];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self lodingMore];
        }];
    }
    return _mainTableView;
}

-(SJSearchNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [SJSearchNoDataView createCellWithXib];
        _noDataView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight);
        [_noDataView.labelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreenWidth - 30));
        }];
        _noDataView.labelView.signalTagColor=[UIColor clearColor];
        _noDataView.labelView.deleteHide = YES;
        _noDataView.labelView.canTouch = YES;
        [_noDataView.labelView setTagWithTagArray:self.hotSearchArray];
        [_noDataView.labelView setDidselectItemBlock:^(NSArray *arr, NSInteger index) {
             [self pushToSearchResultWithSearchStr:[self.hotSearchArray objectAtIndex:index]];
        }];
    }
    _noDataView.describeLabel.text = [NSString stringWithFormat:@"对不起！\n 暂时还没有 \" %@ \" 的相关内容。",self.searchTextField.text];
    return _noDataView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarButtonItem];
    
    self.searchArray = [NSMutableArray array];
    NSMutableDictionary *labelDic = [NSMutableDictionary dictionary];
    [labelDic setObject:@"标签" forKey:@"title"];
    [labelDic setObject:[NSMutableArray array] forKey:@"array"];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    [userDic setObject:@"相关用户" forKey:@"title"];
    [userDic setObject:[NSMutableArray array] forKey:@"array"];
    NSMutableDictionary *activityDic = [NSMutableDictionary dictionary];
    [activityDic setObject:@"热门足迹项" forKey:@"title"];
    [activityDic setObject:[NSMutableArray array] forKey:@"array"];
    NSMutableDictionary *postsDic = [NSMutableDictionary dictionary];
    [postsDic setObject:@"相关帖子" forKey:@"title"];
    [postsDic setObject:[NSMutableArray array] forKey:@"array"];
    
    [self.searchArray addObject:labelDic];
    [self.searchArray addObject:userDic];
    [self.searchArray addObject:activityDic];
    [self.searchArray addObject:postsDic];
    
    [self getHotSearchArrayAction];
    self.page = 1;
}


- (void)setBarButtonItem {
    [self.navigationItem setHidesBackButton:YES];
    // 创建搜索框
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth*4/5, 30)];
    titleView.backgroundColor = HEXCOLOR(@"F8F8F8");
    titleView.layer.cornerRadius = 4;
    titleView.layer.masksToBounds = YES;
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(titleView.frame) - 50, 30)];
    self.searchTextField.placeholder = @"搜索鸟斯基内容";
    self.searchTextField.delegate = self;
    self.searchTextField.font = [UIFont systemFontOfSize:14];
    self.searchTextField.textColor = SJ_TITLE_COLOR;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    [titleView addSubview:self.searchTextField];
    [self.searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(titleView.frame) - 40, 0, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"search_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchBtn];
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

-(void)searchAction{
    if (self.searchTextField.text.length > 0) {
        [self pushToSearchResultWithSearchStr:self.searchTextField.text];
    }
}

- (void)pushToSearchResultWithSearchStr:(NSString *)str {
    self.searchTextField.text = str;
    [self setHistoryArrWithStr:str];
    [self getSearchLabels:str];
    [self getSearchUser:str];
    [self getSearchActivity:str];
    [self getSearchPosts:str];
    [self.searchTextField resignFirstResponder];
}



#pragma mark - 存储历史
- (void)setHistoryArrWithStr:(NSString *)str {
    for (int i = 0; i < self.historySearchArray.count; i++) {
        if ([self.historySearchArray[i] isEqualToString:str]) {
            [self.historySearchArray removeObjectAtIndex:i];
            break;
        }
    }
    [self.historySearchArray insertObject:str atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.historySearchArray forKey:@"HistorySearch"];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if (theTextField.text == nil || [theTextField.text length] <= 0) {
        [self.mainTableView removeFromSuperview];
        [self.noDataView removeFromSuperview];
        [self.tipsView removeFromSuperview];
        [self.view addSubview:self.searchView];
    } else {
        [self getTiptString:theTextField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self pushToSearchResultWithSearchStr:textField.text];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self searchAction];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SJLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJLabelTableViewCell" forIndexPath:indexPath];
        cell.pictureImageView.layer.masksToBounds = YES;
        NSMutableDictionary *labelDic = [self.searchArray objectAtIndex:indexPath.section];
        JABbsLabelModel *labelModel = [[labelDic objectForKey:@"array"] firstObject];
        cell.titleLabel.text = labelModel.labelName;
        [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:labelModel.imagesAddress] placeholderImage:[UIImage imageNamed:@"default_picture"]];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;

        return cell;
    }  else if (indexPath.section == 1){
        SJSearckUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJSearckUserTableViewCell" forIndexPath:indexPath];
        NSMutableDictionary *userDic = [self.searchArray objectAtIndex:indexPath.section];
        NSArray *userArray = [userDic objectForKey:@"array"];
        JAUserAccount *model = [userArray objectAtIndex:indexPath.row];
        [cell setUserInfo:model];
        return cell;
    } else if (indexPath.section == 2){
        SJActivityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJActivityListTableViewCell" forIndexPath:indexPath];
        NSMutableDictionary *activityDic = [self.searchArray objectAtIndex:indexPath.section];
        NSArray *activityArray = [activityDic objectForKey:@"array"];
        JAActivityModel *model = [activityArray objectAtIndex:indexPath.row];
        [cell setActivityInfoAction:model];
        return cell;
    } else if (indexPath.section == 3){
        SJMyNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJMyNoteCell" forIndexPath:indexPath];
        NSMutableDictionary *postsDic = [self.searchArray objectAtIndex:indexPath.section];
        NSArray *postsArray = [postsDic objectForKey:@"array"];
        JAPostsModel *model = [postsArray objectAtIndex:indexPath.row];
        cell.postsModel = model;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }  else if (indexPath.section == 1){
        NSMutableDictionary *userDic = [self.searchArray objectAtIndex:indexPath.section];
        NSArray *userArray = [userDic objectForKey:@"array"];
        JAUserAccount *model = [userArray objectAtIndex:indexPath.row];
        
        SJOtherInfoPageController *anotherPageVC = [[SJOtherInfoPageController alloc] init];
        anotherPageVC.userId = model.Id;
        anotherPageVC.titleName = @"";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:anotherPageVC
                                                   sender:nil];
        });
    } else if (indexPath.section == 2){
        NSMutableDictionary *activityDic = [self.searchArray objectAtIndex:indexPath.section];
        NSArray *activityArray = [activityDic objectForKey:@"array"];
        JAActivityModel *model = [activityArray objectAtIndex:indexPath.row];
        SJFootprintDetailsController *detailVC = [[SJFootprintDetailsController alloc] init];
        detailVC.titleName = model.detailsName;
        detailVC.activityId = model.ID;
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController showViewController:detailVC
                                               sender:nil];
    });
    } else if (indexPath.section == 3){
        NSMutableDictionary *postsDic = [self.searchArray objectAtIndex:indexPath.section];
        NSArray *postsArray = [postsDic objectForKey:@"array"];
        JAPostsModel *model = [postsArray objectAtIndex:indexPath.row];
        
        SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
        detailVC.noteId = model.ID;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController showViewController:detailVC
                                                   sender:nil];
        });
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableDictionary *dic = [self.searchArray objectAtIndex:section];
    NSMutableArray *array = [dic objectForKey:@"array"];
    return [array count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSMutableDictionary *labelDic = [self.searchArray firstObject];
        NSMutableArray *labelArray = [labelDic objectForKey:@"array"];
        if ([labelArray count] > 0) {
            return 140;
        }
        return 0;
    }else if (indexPath.section == 1){
        NSMutableDictionary *userDic = [self.searchArray objectAtIndex:1];
        NSMutableArray *userArray = [userDic objectForKey:@"array"];
        if ([userArray count] > 0) {
            return 70;
        }
        return 0;
    }
    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.searchArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    NSMutableDictionary *dic = [self.searchArray objectAtIndex:section];
    NSMutableArray *array = [dic objectForKey:@"array"];
    if ([array count] > 0) {
        return 30;
    } else {
        return 0.01;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SJSearchHeaderView *headerView = [SJSearchHeaderView createCellWithXib];
    headerView.moreBtn.hidden = YES;
    headerView.titleLabel.hidden = YES;
    if (section == 1) {
        [headerView.moreBtn addTarget:self action:@selector(moreUserAction) forControlEvents:UIControlEventTouchUpInside];
        headerView.moreBtn.hidden = NO;
        headerView.titleLabel.hidden = NO;
        NSMutableDictionary *dic = [self.searchArray objectAtIndex:section];
        NSMutableArray *array = [dic objectForKey:@"array"];
        if ([array count] > 0) {
            headerView.titleLabel.text = @"相关用户";
            if ([array count] == 3) {
                headerView.moreBtn.hidden = NO;
            } else {
                headerView.moreBtn.hidden = YES;
            }
        } else {
            headerView.titleLabel.text = @"";
            headerView.moreBtn.hidden = YES;
        }
    }else if (section == 2) {
        [headerView.moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        headerView.moreBtn.hidden = NO;
        headerView.titleLabel.hidden = NO;
        NSMutableDictionary *dic = [self.searchArray objectAtIndex:section];
        NSMutableArray *array = [dic objectForKey:@"array"];
        if ([array count] > 0) {
            headerView.titleLabel.text = @"热门足迹项";
            if ([array count] == 3) {
                headerView.moreBtn.hidden = NO;
            } else {
                headerView.moreBtn.hidden = YES;
            }
        } else {
            headerView.titleLabel.text = @"";
            headerView.moreBtn.hidden = YES;
        }
    } else if (section == 3){
        headerView.titleLabel.hidden = NO;
        NSMutableDictionary *dic = [self.searchArray objectAtIndex:section];
        NSMutableArray *array = [dic objectForKey:@"array"];
        if ([array count] > 0) {
            headerView.titleLabel.text = @"相关帖子";
        } else {
            headerView.titleLabel.text = @"";
        }
    }
    return headerView;
}

#pragma mark - 更多活动
-(void)moreAction{
    SJSearchMoreActivityController *moreVC = [[SJSearchMoreActivityController alloc] init];
    moreVC.titleName = @"更多足迹";
    moreVC.searchString = self.searchTextField.text;
    [self.navigationController pushViewController:moreVC animated:YES];
}
#pragma mark - 更多用户
-(void)moreUserAction{
    SJMoreUserViewController *moreVC = [[SJMoreUserViewController alloc] init];
    moreVC.titleName = @"更多用户";
    moreVC.searchString = self.searchTextField.text;
    [self.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark - 搜索标签
-(void)getSearchLabels:(NSString *)string{
    [JABbsPresenter postFuzzySearchLabels:string IsPaging:NO WithCurrentPage:1 WithLimit:10 Result:^(JADiscRecLabelModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dic = [self.searchArray objectAtIndex:0];
            if (model.success && [model.labelList count] > 0) {
                NSMutableArray *labelArray = [NSMutableArray array];
                [labelArray addObject:[model.labelList firstObject]];
                [dic setObject:labelArray forKey:@"array"];
            } else {
                [dic setObject:[NSMutableArray array] forKey:@"array"];
            }
            [self.searchArray replaceObjectAtIndex:0 withObject:dic];
            [self searchReault];
        });
    }];
}

#pragma mark - 搜索相关活动
-(void)getSearchActivity:(NSString *)string{
    [JABbsPresenter postFuzzySearchDetials:string WithQueryType:2 IsPaging:YES WithCurrentPage:1 WithLimit:3 Result:^(JADiscRecGroupModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dic = [self.searchArray objectAtIndex:2];
            if (model.success && [model.detailsPO.activitysList count] > 0) {
                [dic setObject:model.detailsPO.activitysList forKey:@"array"];
            } else {
                [dic setObject:[NSMutableArray array] forKey:@"array"];
            }
            [self.searchArray replaceObjectAtIndex:2 withObject:dic];
            [self searchReault];
        });
    }];
}

#pragma mark - 搜索相关帖子
-(void)getSearchPosts:(NSString *)string{
    [JABbsPresenter postFuzzySearchDetials:string WithQueryType:1 IsPaging:YES WithCurrentPage:self.page WithLimit:10 Result:^(JADiscRecGroupModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            NSMutableDictionary *dic = [self.searchArray objectAtIndex:3];
            NSMutableArray *array = [[dic objectForKey:@"array"] mutableCopy];
            if (self.page == 1) {
                if (model.success && [model.detailsPO.postsList count] > 0) {
                    array = [model.detailsPO.postsList mutableCopy];
                } else {
                    array = [NSMutableArray array];
                }
            } else {
                [array addObjectsFromArray:model.detailsPO.postsList];
            }
            [dic setObject:array forKey:@"array"];
            if ([model.detailsPO.postsList count] < 10) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.searchArray replaceObjectAtIndex:3 withObject:dic];
            [self searchReault];
        });
    }];
}

-(void)searchReault{
    [self.searchView removeFromSuperview];
    [self.historySearchArray removeAllObjects];
    [self.view addSubview:self.mainTableView];
    
    NSMutableDictionary *labelDic = [self.searchArray objectAtIndex:0];
    NSMutableDictionary *userDic = [self.searchArray objectAtIndex:1];
    NSMutableDictionary *activitysDic = [self.searchArray objectAtIndex:2];
    NSMutableDictionary *postsDicic = [self.searchArray objectAtIndex:3];
    if ([[labelDic objectForKey:@"array"] count] == 0 && [[userDic objectForKey:@"array"] count] == 0 && [[activitysDic objectForKey:@"array"] count] == 0 && [[postsDicic objectForKey:@"array"] count] == 0) {
        [self.mainTableView removeFromSuperview];
        [self.historySearchArray removeAllObjects];
        [self.view addSubview:self.noDataView];
    }
    [self.mainTableView reloadData];
}

-(void)getTiptString:(NSString *)string{
    [JABbsPresenter postFuzzySearchLabels:string IsPaging:NO WithCurrentPage:1 WithLimit:10 Result:^(JADiscRecLabelModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success && [model.labelList count] > 0) {
                [self.view addSubview:self.tipsView];
                self.tipsView.tipsArray = model.labelList;
            } else {
                [self.tipsView removeFromSuperview];
            }
        });
    }];
}


-(SJSearchTipsView *)tipsView{
    if (!_tipsView) {
        _tipsView = [[SJSearchTipsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight)];
        __weak typeof(self)weakSelf = self;
        _tipsView.searchBlock = ^(NSString *string) {
            [weakSelf pushToSearchResultWithSearchStr:string];
        };
    }
    return _tipsView;
}

#pragma mark - 搜索相关用户
-(void)getSearchUser:(NSString *)string{
    [JABbsPresenter postqueryUserByNickName:string IsPaging:YES WithCurrentPage:0 WithLimit:3 Result:^(JAUserListModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *dic = [self.searchArray objectAtIndex:1];
            if (model.success && [model.data.list count] > 0) {
                [dic setObject:model.data.list forKey:@"array"];
            } else {
                [dic setObject:[NSMutableArray array] forKey:@"array"];
            }
            [self.searchArray replaceObjectAtIndex:1 withObject:dic];
            [self searchReault];
        });
    }];
}



@end
