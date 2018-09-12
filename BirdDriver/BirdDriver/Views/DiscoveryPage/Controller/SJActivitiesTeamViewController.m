//
//  SJActivitiesTeamViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJActivitiesTeamViewController.h"
#import "SJActivitiesTeamCollectionViewCell.h"
#import "JABbsPresenter.h"
#import "SJOtherInfoPageController.h"

@interface SJActivitiesTeamViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic,retain)UICollectionView *mainCollectionView;
@property(nonatomic, strong)UILabel *notLabel;

@property(nonatomic,retain)NSMutableArray *teamArray;

@end

@implementation SJActivitiesTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainCollectionView];
    [self.view addSubview:self.notLabel];
    [self getUsers];
}

-(UILabel *)notLabel{
    if (!_notLabel) {
        _notLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight)];
        _notLabel.text = @"没有组员";
        _notLabel.font = [UIFont systemFontOfSize:15];
        _notLabel.textColor = SJ_TITLE_COLOR;
        _notLabel.textAlignment = YES;
        _notLabel.hidden = YES;
    }
    return _notLabel;
}

-(void)getUsers{
    [JABbsPresenter postTeamUsers:self.activityId Result:^(SJTeamListModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.teamArray = [model.userAccountPOsList mutableCopy];
            if (self.teamArray.count == 0) {
                self.notLabel.hidden = NO;
            } else {
                self.notLabel.hidden = YES;
            }
            [self.mainCollectionView reloadData];
        });
    }];
}

-(UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake((kScreenWidth - 30)/4, (kScreenWidth - 30)/4 + 30);
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) collectionViewLayout:layout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        [_mainCollectionView registerNib:[UINib nibWithNibName:@"SJActivitiesTeamCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SJActivitiesTeamCollectionViewCell"];
    }
    return _mainCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath  {
    SJActivitiesTeamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJActivitiesTeamCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [SJActivitiesTeamCollectionViewCell new];
    }
    cell.porImageView.layer.masksToBounds = YES;
    
    JAUserData *users = [self.teamArray objectAtIndex:indexPath.row];
    [cell.porImageView sd_setImageWithURL:[NSURL URLWithString:users.photoSrc] placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    cell.nickName.text = users.nickName;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.teamArray count];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JAUserData *users = [self.teamArray objectAtIndex:indexPath.row];
    SJOtherInfoPageController *anotherPageVC = [[SJOtherInfoPageController alloc] init];
    anotherPageVC.userId = users.Id;
    anotherPageVC.titleName = @"";
    [self.navigationController pushViewController:anotherPageVC animated:YES];
}




@end
