//
//  SJBuildActivityController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBuildActivityController.h"
#import "SJPhotosController.h"
#import "SJActivityCategoryCell.h"
#import "SJActivityTicketCell.h"
#import "SJNoteTabCell.h"
#import "SJBuildNoteFooterView.h"
#import "SJBuildNoteModel.h"
#import "SJPhotoModel.h"
#import "SJPhotoComponents.h"
#import "JABbsPresenter.h"
#import "JAFileUploadPresenter.h"

#define rowCountOfSection (self.ticketFlag?2:1)

@interface SJBuildActivityController () <SJBuildNoteFooterViewDelegate, SJActivityTicketCellDelegate, SJPhotoProtocol, SJNoteTabCellDelegate>

@property (nonatomic, strong) SJBuildNoteModel *buildNoteModel;
@property (nonatomic, assign) BOOL ticketFlag;

@end

@implementation SJBuildActivityController
static NSString *const ID = @"SJBuildNoteFooterView";

#pragma mark - lazy loading
- (SJBuildNoteModel *)buildNoteModel
{
    if (_buildNoteModel == nil)
    {
        _buildNoteModel = [[SJBuildNoteModel alloc] init];
    }
    return _buildNoteModel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.listView registerClass:NSClassFromString(ID) forHeaderFooterViewReuseIdentifier:ID];
    [self getAllPostsList];
}

- (void)getAllPostsList
{
    [SVProgressHUD show];
    [JABbsPresenter postQueryLabelsListIsPaging:NO Limit:10 Result:^(JADiscRecLabelModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success) {
                
                [self.buildNoteModel.tags addObjectsFromArray:model.labelList];
                [self.listView reloadData];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return rowCountOfSection;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 61.0;
        }
        return self.buildNoteModel.tagCellHeight;
    }
    return 288.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 10.f;
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 162.f;
    }
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) return nil;
    SJBuildNoteFooterView *footerView = [[SJBuildNoteFooterView alloc] initWithReuseIdentifier:ID];
    footerView.titleStr = @"申请发起";
    footerView.delegate = self;
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            SJActivityCategoryCell *cell = [SJActivityCategoryCell xibCell:tableView];
            cell.isExpandStatus = self.ticketFlag;
            cell.expandBlock = ^(){
                
                self.ticketFlag = !self.ticketFlag;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            };
            cell.myTagModel = self.buildNoteModel.selectedTagModel;
            return cell;
        }
        SJNoteTabCell *cell = [SJNoteTabCell xibCell:tableView];
        cell.tabs = self.buildNoteModel.tags;
        cell.delegate = self;
        return cell;
    }
    SJActivityTicketCell *cell = [SJActivityTicketCell xibCell:tableView];
    cell.delegate = self;
    cell.reloadBlock = ^(){
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                 withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.buildModel = self.buildNoteModel;
    return cell;
}

#pragma mark - SJNoteTabCellDelegate
- (void)didChoosedTag:(JABbsLabelModel *)tagModel
{
    if (tagModel.isSelected) {
        self.buildNoteModel.selectedTagModel = tagModel;
    } else {
        self.buildNoteModel.selectedTagModel = nil;
    }
    [self.listView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - SJBuildNoteFooterViewDelegate
- (void)didClickFooterBtn
{
    void (^getImgBlock)(NSString *) = ^(NSString *imgUrl) {
        
        [JABbsPresenter postAddDetails:2
                         WithRunStatus:2
                             WithOldId:nil
                     WithDetailsLabels:self.buildNoteModel.selectedTagModel.labelName WithDetailsName:self.buildNoteModel.note_title
                       WithDetailsText:self.buildNoteModel.note_content
                     WithImagesAddress:imgUrl
                       WithDescribtion:nil
                                Result:^(JAResponseModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
                if (model.success)
                {
                    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                    if (self.buildSuccessBlock) {
                        self.buildSuccessBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus: model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
    };
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (kStringIsEmpty(self.buildNoteModel.note_title)) {
        [SVProgressHUD showInfoWithStatus:@"请填写活动标题"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    };
    if (kStringIsEmpty(self.buildNoteModel.note_content)) {
        [SVProgressHUD showInfoWithStatus:@"请填写活动内容"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    if (self.buildNoteModel.note_content.length < 50) {
        [SVProgressHUD showInfoWithStatus:@"活动内容最少输入50个字符"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    if (kObjectIsEmpty(self.buildNoteModel.selectedTagModel)) {
        [SVProgressHUD showInfoWithStatus:@"请选择标签"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    if (kArrayIsEmpty(self.buildNoteModel.photos)) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择图片"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"发布中"];
    if (!kArrayIsEmpty(self.buildNoteModel.photos))
    {
        SJPhotoModel *photoModel = self.buildNoteModel.photos.firstObject;
        NSData *imageData = UIImageJPEGRepresentation(photoModel.resultImage, 0.8);
        [JAFileUploadPresenter uploadFile:nil fileData:imageData fileDataKey:@"file" progress:nil success:^(id dataObject) {
            
            getImgBlock(dataObject[@"url"]);
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        }];
    } else {
        getImgBlock(nil);
    }
}

#pragma mark - SJActivityTicketCellDelegate
- (void)didClickAddPicture
{
    [SJPhotoComponents requestPhotoAuthorizationWithCompletionHandler:^(BOOL isAllowed) {
        
        if (isAllowed)
        {
            SJPhotosController *photoVC = [[SJPhotosController alloc] init];
            photoVC.selectedAssets = [self.buildNoteModel.photos mutableCopy];
            photoVC.maximumLimit = 1;
            photoVC.delegate = self;
            [self.navigationController pushViewController:photoVC animated:YES];
        }
    }];
}

#pragma mark - SJPhotoProtocol
- (void)photoController:(SJPhotosController *)photoVC didSelectedPhotos:(NSArray<SJPhotoModel *> *)photos
{
    self.buildNoteModel.photos = [photos mutableCopy];
    [self.listView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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
