//
//  SJNoviceGuideStep3Controller.m
//  BirdDriver
//
//  Created by Soul on 2018/8/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoviceGuideStep3Controller.h"
#import "SJNoviceHobbiesCell.h"
#import "SJNoviceHobbiesHeader.h"
#import "SJNoviceHobbiesFooter.h"
#import "SJNoviceHobbiesLayout.h"

#import "JAMessagePresenter.h"
#import "JAUserPresenter.h"

@interface SJNoviceGuideStep3Controller ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cv_hobbies;

@property (strong, atomic)  NSMutableArray    *hobbiesArr;
@property (strong, atomic)  NSArray           *itemArr;

@end

@implementation SJNoviceGuideStep3Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = SP_WHITE_COLOR;
    self.title = @"设置个人爱好";
    
    self.hobbiesArr = [NSMutableArray arrayWithArray:@[]];
    [self.cv_hobbies registerNib:[UINib nibWithNibName:@"SJNoviceHobbiesCell" bundle:nil]
      forCellWithReuseIdentifier:@"SJNoviceHobbiesCell"];
    [self.cv_hobbies registerNib:[UINib nibWithNibName:@"SJNoviceHobbiesHeader" bundle:nil]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:@"SJNoviceHobbiesHeader"];
    [self.cv_hobbies registerNib:[UINib nibWithNibName:@"SJNoviceHobbiesFooter" bundle:nil]
      forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
             withReuseIdentifier:@"SJNoviceHobbiesFooter"];
    
    SJNoviceHobbiesLayout *layout = [[SJNoviceHobbiesLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0.5f;
    layout.minimumInteritemSpacing = 1.0f;
    layout.sectionInset = UIEdgeInsetsMake(0,10,10,10);
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 50.0f);
    layout.footerReferenceSize = CGSizeMake(kScreenWidth, 70.0f);
    
    if (@available(iOS 10.0, *)) {
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    } else {
        // Fallback on earlier versions
        layout.estimatedItemSize = CGSizeMake(120.0f, 50.0f);
    }
    self.cv_hobbies.collectionViewLayout = layout;

    [self updateInfo];
}

- (void)getHobbysDicticty{
    WEAKSELF
    [JAMessagePresenter postDataDictionary:@"hobbyTags"
                                    Result:^(NSMutableArray * _Nullable array) {
                                        if (array.count) {
                                            [[NSUserDefaults standardUserDefaults] setObject:array
                                                                                      forKey:@"hobbyTag"];
                                            weakSelf.itemArr = [NSMutableArray arrayWithArray:array];
                                        }
                                    }];
}

- (void)updateInfo{
    [self getHobbysDicticty];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"hobbyTag"];
    self.itemArr = arr?arr:@[];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cv_hobbies reloadSections:[NSIndexSet indexSetWithIndex:1]];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)finishNovice:(id)sender {
    NSString *string = [self.hobbiesArr componentsJoinedByString:@","];
    [JAUserPresenter postUpdateUserHobby:string
                                  Result:^(JAResponseModel * _Nullable model) {
                                      if (model.success) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              [SPLocalInfoModel shareInstance].hasBeenLogin = YES;
                                              [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_loginSuccess object:nil];
                                              [self dismissViewControllerAnimated:YES
                                                                       completion:nil];
                                          });
                                      }else{
                                          [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                                          [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                                      }
                                  }];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        SJNoviceHobbiesHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                               withReuseIdentifier:@"SJNoviceHobbiesHeader"
                                                                                      forIndexPath:indexPath];
    
        if (indexPath.section) {
            [headerView.v_line setHidden:NO];
            headerView.lbl_title.text = @"请选择";
        }else{
            [headerView.v_line setHidden:YES];
            headerView.lbl_title.text = @"个人爱好";
        }
        
        return headerView;
    }else if(kind == UICollectionElementKindSectionFooter){
        //Footer
        SJNoviceHobbiesFooter *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                               withReuseIdentifier:@"SJNoviceHobbiesFooter"
                                                                                      forIndexPath:indexPath];
        if(indexPath.section == 1){
            [footerView setHidden:YES];
        }
        
        return footerView;
    }else{
          return [UICollectionReusableView new];
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJNoviceHobbiesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJNoviceHobbiesCell"
                                                                          forIndexPath:indexPath];
    
    SJNoviceHobbiesModel *model = [SJNoviceHobbiesModel new];
    if (indexPath.section == 0) {
        model.canBeDeleted = YES;
        model.title = self.hobbiesArr[indexPath.row];
    }else{
        model.canBeDeleted = NO;
        model.title = self.itemArr[indexPath.row];
    }
    
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //取消选中
        [self.hobbiesArr removeObjectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        });
    }else if (indexPath.section == 1) {
        //选中某条
        NSString *hobbyStr = self.itemArr[indexPath.row];
        if ([self.hobbiesArr containsObject:hobbyStr]) {
            [SVProgressHUD showInfoWithStatus:@"您已经有此标签~"];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }else{
            if (self.hobbiesArr.count >=5) {
                [SVProgressHUD showInfoWithStatus:@"最多可选择5个标签"];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }else{
                [self.hobbiesArr addObject:hobbyStr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                });
            }
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hobbiesArr?self.hobbiesArr.count:0;
    }else if (section == 1){
        return self.itemArr?self.itemArr.count:5;
    }
    return 0;
}

@end

