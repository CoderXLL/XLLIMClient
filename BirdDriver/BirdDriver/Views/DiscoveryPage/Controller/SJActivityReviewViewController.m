//
//  SJActivityReviewViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/7/18.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJActivityReviewViewController.h"
#import "SJBrowserController.h"
#import "SJStartReviewTableViewCell.h"
#import "SJTReviewContentableViewCell.h"
#import "JABbsPresenter.h"

#import "SJReviewSelPicCollectionViewCell.h"
#import "SJPhotosController.h"
#import "SJPhotoModel.h"
#import "SJPhotoComponents.h"
#import "SJBrowserController.h"
#import "JAFileUploadPresenter.h"
#import "SJScoreModel.h"

@interface SJActivityReviewViewController ()<UITableViewDelegate, UITableViewDataSource ,UICollectionViewDelegate, UICollectionViewDataSource,SJPhotoProtocol>

@property(nonatomic,retain)UITableView *mainTableView;
@property(nonatomic,retain)NSMutableArray *picList;
@property(nonatomic,assign)NSInteger starCount;
@property(nonatomic,copy)NSString *content;

@property(nonatomic,retain)SJScoreModel *scoreModel;

@property(nonatomic,retain)SJStartReviewTableViewCell *starCell;


@end

@implementation SJActivityReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [self.view addSubview:self.mainTableView];
    self.scoreModel = [SJScoreModel model];
}

- (SJStartReviewTableViewCell *)starCell {
    if (!_starCell) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
        _starCell = [self.mainTableView cellForRowAtIndexPath:indexpath];
    }
    return _starCell;
}
//提交
- (void)submitComments{
    self.starCount = [[self.starCell.v_count.text substringToIndex:self.starCell.v_count.text.length - 1] integerValue];
    if (!self.returnCommentModel && self.starCount == 0) {
        [SVProgressHUD showInfoWithStatus:@"请先评分！"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    void(^getImgBlock)(NSArray *) = ^(NSArray *imgs) {
        self.scoreModel.score = self.starCount;
        self.scoreModel.commentType = 0;
        self.scoreModel.detailsId = self.activityId;
        self.scoreModel.evaluate = self.content;
        self.scoreModel.imagesAddressList = imgs;
        if (self.returnCommentModel) {
           self.scoreModel.score = 10;
           self.scoreModel.commentType = 0;
            if (self.parentCommentId > 0 ) {
                self.scoreModel.parentCommentId =[NSString stringWithFormat:@"%ld", (long)self.parentCommentId];
                self.scoreModel.commentType = 1;
            } else {
                self.scoreModel.parentCommentId =[NSString stringWithFormat:@"%ld", (long)self.returnCommentModel.ID];
            }
            self.scoreModel.relpyUserId = [NSString stringWithFormat:@"%ld", (long)self.returnCommentModel.commentUserId];
            self.scoreModel.scoreUserId = [NSString stringWithFormat:@"%ld", (long)SPLocalInfo.userModel.Id];
        }
        [JABbsPresenter postAddScore:self.authorId scorePO:self.scoreModel
                              Result:^(JAResponseModel * _Nullable model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(model.success){
                    [SVProgressHUD showSuccessWithStatus:@"点评成功"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                    [SVProgressHUD dismissWithDelay:1];
                }
            });
        }];
    };
    [SVProgressHUD showWithStatus:@"上传中"];
    if (!kArrayIsEmpty(self.picList)) {
        [self uploadImgWithAttachments:self.picList AndBlock:getImgBlock];
    } else {
        getImgBlock(nil);
    }
}

- (void)uploadImgWithAttachments:(NSArray <SJPhotoModel *>*)attachments AndBlock:(void(^)(NSArray *))block
{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *imgs = [NSMutableArray array];
    for (SJPhotoModel *attachment in attachments) {
        dispatch_group_enter(group);
        if (attachment.resultImage) {
            NSData *imageData = UIImageJPEGRepresentation(attachment.resultImage, 0.8);
            [JAFileUploadPresenter uploadFile:nil
                                     fileData:imageData
                                  fileDataKey:@"file"
                                     progress:nil
                                      success:^(id dataObject) {
                                          [imgs addObject:[dataObject valueForKey:@"url"]];
                                          attachment.localIdentifier = [dataObject valueForKey:@"url"];
                                          dispatch_group_leave(group);
                                      } failure:^(NSError *error) {
                                          dispatch_group_leave(group);
                                          [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                          [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                                      }];
        } else {
            dispatch_group_leave(group);
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (block) {
            block(imgs);
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mainTableView
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = HEXCOLOR(@"FFFFFF");
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJStartReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"SJStartReviewTableViewCell"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"SJTReviewContentableViewCell" bundle:nil] forCellReuseIdentifier:@"SJTReviewContentableViewCell"];
        _mainTableView.separatorStyle = UITableViewCellEditingStyleNone;
    }
    return _mainTableView;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SJStartReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJStartReviewTableViewCell" forIndexPath:indexPath];
         cell.whiteView.hidden = YES;
        if(self.returnCommentModel){
            cell.whiteView.hidden = NO;
        }
        return cell;
    } else {
        SJTReviewContentableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJTReviewContentableViewCell" forIndexPath:indexPath];
        cell.pictureCollectionView.delegate = self;
        cell.pictureCollectionView.dataSource = self;
        [cell.pictureCollectionView registerNib:[UINib nibWithNibName:@"SJReviewSelPicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SJReviewSelPicCollectionViewCell"];
        [cell.pictureCollectionView reloadData];
        cell.sureBtn.customBtnTitle = @"提交";
        cell.sureBtn.customBtnEnable = YES;
        cell.sureBtn.customBtnGradientColors = @[HEXCOLOR(@"303850"),HEXCOLOR(@"6E7EAF")];
        cell.sureBtn.customBtnTitleColor = HEXCOLOR(@"FFBB04");
        cell.sureBtn.cornerRadius = 22.0f;
        [cell.sureBtn customButtonClick:^(UIButton *button) {
            if (cell.contectView.text.length < 1) {
                [SVProgressHUD showInfoWithStatus:@"评论不能为空"];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                return;
            }
            self.content = cell.contectView.text;
            //提交
            [self submitComments];
        }];
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
       return 80;
    }
    return 500;
}

//选择图片
- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SJReviewSelPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SJReviewSelPicCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [SJReviewSelPicCollectionViewCell new];
    }
    cell.detBtn.hidden = NO;
    if (indexPath.row == [self.picList count]) {
        [cell.pictureImageView setImage:[UIImage imageNamed:@"review_pic"]];
        cell.detBtn.hidden = YES;
    } else {
        SJPhotoModel *photoModel = [self.picList objectAtIndex:indexPath.row];
        cell.pictureImageView.image = photoModel.thumbnailImage;
        [cell setPic:photoModel];
        cell.deletepicBlock = ^(SJPhotoModel *model) {
            [self.picList removeObject:model];
            [collectionView reloadData];
        };
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.picList.count + 1;
}

//定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(82, 82);
    return size;
}

//这个是两行cell之间的间距（左右行cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 15.0f;
//}


//定义每个Section的四边间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);//分别为上、左、下、右
}

////两个cell之间的间距（上下行的cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return kLine_HeightT_1_PPI;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.picList count]) {
        [SJPhotoComponents requestPhotoAuthorizationWithCompletionHandler:^(BOOL isAllowed) {
            if (isAllowed){
                SJPhotosController *photoVC = [[SJPhotosController alloc] init];
                photoVC.selectedAssets = [self.picList mutableCopy];
                photoVC.maximumLimit = 9;
                photoVC.delegate = self;
                [self.navigationController pushViewController:photoVC animated:YES];
            }
        }];
    } else {
        SJBrowserController *browserVC = [[SJBrowserController alloc] init];
        browserVC.fetchPhotoResults = self.picList;
        browserVC.currentIndex = indexPath.item;
        browserVC.noEdit = YES;
        [self.navigationController pushViewController:browserVC animated:YES];
    }
}

#pragma mark - SJPhotoProtocol
- (void)photoController:(SJPhotosController *)photoVC didSelectedPhotos:(NSArray<SJPhotoModel *> *)photos {
    self.picList = [photos mutableCopy];
    [self.mainTableView reloadData];
}


@end
