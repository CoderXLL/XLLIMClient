//
//  SJBuildNoteController.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBuildNoteController.h"
#import "SJBuildNoteModel.h"
//#import "SJNoteInputCell.h"
#import "SJPhotosController.h"
#import "SJPhotoComponents.h"
//#import "SJChoosePhotoCell.h"
#import "SJAttributesCell.h"
#import "SJNoteTabCell.h"
#import "SJNoteDescCell.h"
#import "SJActivityCategoryCell.h"
#import "SJBuildNoteFooterView.h"
#import "SJAlertView.h"
#import "SJAttributedHeaderView.h"
#import "JABbsPresenter.h"
#import "SJPhotoModel.h"
#import "SJHtmlTransfer.h"
#import "SJAttachment.h"
#import "JAFileUploadPresenter.h"
#import "JAForumPresenter.h"

#import "SJBuildNoteTitleCell.h"
#import "SJNoteParagraphCell.h"
#import "SJNoteParagraphParase.h"

#define CellOfStatus self.expandFlag?2:1

@interface SJBuildNoteController () <SJBuildNoteFooterViewDelegate,SJNoteTabCellDelegate,SJPhotoProtocol, SJAttributesCellDelegate>
{
    NSInteger totalParaphId;
    UIBarButtonItem *edtiorBarItem;
}

//编辑内容模型
@property (nonatomic, strong) SJBuildNoteModel *buildNoteModel;
@property (nonatomic, assign, getter=expandFlag) BOOL isExpandFlag;
@property (nonatomic, weak) SJAttributedHeaderView *attributeHeaderView;

@end

@implementation SJBuildNoteController

static NSString *const footerID = @"SJBuildNoteFooterView";

- (void)viewDidLoad {
    
    self.tableViewStyle = UITableViewStyleGrouped;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setupTableHeaderView];
    [self getLabelLists];
}

- (void)setupTableHeaderView
{
    SJAttributedHeaderView *headerView = [SJAttributedHeaderView createCellWithXib];
    CGFloat headerH = 222+55+15+35+30+30;
    if (iPhoneX) {
        headerH += 54;
    }
    headerView.frame = CGRectMake(0, 0, self.view.width, headerH);
    headerView.noteModel = self.buildNoteModel;
    __weak typeof(self) weakSelf = self;
    headerView.heightBlock = ^(CGFloat height) {
        weakSelf.attributeHeaderView.height = height;
        [weakSelf.listView beginUpdates];
        [weakSelf.listView setTableHeaderView:weakSelf.attributeHeaderView];
        [weakSelf.listView endUpdates];
    };
    headerView.addBlock = ^{
      
        //吊起📷或者相册
        [SJPhotoComponents requestPhotoAuthorizationWithCompletionHandler:^(BOOL isAllowed) {
            if (isAllowed)
            {
                SJPhotosController *photoVC = [[SJPhotosController alloc] init];
                photoVC.titleName = @"全部";
                photoVC.maximumLimit = 9;
                photoVC.delegate = self;
                NSMutableArray *selectedArr = [NSMutableArray array];
                photoVC.selectedAssets = selectedArr;
                [self.navigationController pushViewController:photoVC animated:YES];
            }
        }];
    };
    self.attributeHeaderView = headerView;
    self.listView.tableHeaderView = headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:NO];
  
//    [IQKeyboardManager sharedManager].enable = NO;
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
//    [IQKeyboardManager sharedManager].enable = YES;
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)getLabelLists
{
    [SVProgressHUD show];
    [JABbsPresenter postQueryLabelsListIsPaging:NO
                                          Limit:10
                                         Result:^(JADiscRecLabelModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success) {
                
                for (JABbsLabelModel *labelModel in model.labelList) {
                    if ([labelModel.labelName isEqualToString:self.defaultTagLabel.labelName]) {
                        
                        labelModel.isSelected = YES;
                        break;
                    }
                }
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // 0    标题,正文
    // 2    标签
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CellOfStatus;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        SJActivityCategoryCell *cell = [SJActivityCategoryCell xibCell:tableView];
        cell.myTagModel = self.buildNoteModel.selectedTagModel;
        cell.isExpandStatus = self.expandFlag;
        cell.expandBlock = ^() {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            self.isExpandFlag = !self.expandFlag;
            [self.listView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    }
    SJNoteTabCell *cell = [SJNoteTabCell xibCell:tableView];
    cell.delegate = self;
    cell.tabs = self.buildNoteModel.tags;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 61.0;
    }
    return self.buildNoteModel.tagCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    headerView.backgroundColor = JMY_BG_COLOR;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SJBuildNoteFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    if (footerView == nil)
    {
        [tableView registerClass:NSClassFromString(footerID) forHeaderFooterViewReuseIdentifier:footerID];
        footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    }
    footerView.delegate = self;
    return footerView;
}

//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (scrollView == self.listView)
//    {
//        [[UIApplication sharedApplication].keyWindow endEditing:YES];
//    }
//}


#pragma mark - SJBuildNoteFooterViewDelegate
- (void)didClickFooterBtn
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (kStringIsEmpty(self.buildNoteModel.note_title)) {
        [SVProgressHUD showErrorWithStatus:@"请填写帖子标题"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    if (kStringIsEmpty(self.buildNoteModel.note_attributedText.string)) {
        [SVProgressHUD showErrorWithStatus:@"请填写帖子内容"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    if (kObjectIsEmpty(self.buildNoteModel.selectedTagModel)) {
        [SVProgressHUD showErrorWithStatus:@"请选择标签"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    
    void(^getImgBlock)(NSArray *) = ^(NSArray *imgs) {
        
        NSString *imgAddresses = [imgs componentsJoinedByString:@","];
        
        NSString *tempHtml = [SJHtmlTransfer xll_transferHtmlWithAttributedText:self.buildNoteModel.note_attributedText isPublish:YES];
        [JAForumPresenter postAddOrUpdatePort:kObjectIsEmpty(self.postsModel)?0:self.postsModel.ID status:JAPostsRunStatusAuditing labels:self.buildNoteModel.selectedTagModel.labelName title:self.buildNoteModel.note_title content:tempHtml Result:^(JAResponseModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                    if (self.buildSuccssBlock) {
                        self.buildSuccssBlock();
                    }
                    [super popToBack];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
        /**
        [JABbsPresenter postAddDetails:1 WithRunStatus:2 WithOldId:[NSString stringWithFormat:@"%zd", self.postsModel.ID] WithDetailsLabels:self.buildNoteModel.selectedTagModel.labelName WithDetailsName:self.buildNoteModel.note_title WithDetailsText:tempHtml WithImagesAddress:imgAddresses WithDescribtion:nil Result:^(JAResponseModel * _Nullable model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (model.success) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                    if (self.buildSuccssBlock) {
                        self.buildSuccssBlock();
                    }
                    [super popToBack];
                } else {
                    [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                }
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            });
        }];
         */
    };
    [SVProgressHUD showWithStatus:@"正在发布，请稍后..."];
    NSArray <SJAttachment *>*attachments = [SJHtmlTransfer getAttributedAttachment:self.buildNoteModel.note_attributedText];
    if (!kArrayIsEmpty(attachments))
    {
        [self uploadImgWithAttachments:attachments AndBlock:getImgBlock];
    } else {
        getImgBlock(nil);
    }
}

- (void)uploadImgWithAttachments:(NSArray <SJAttachment *>*)attachments AndBlock:(void(^)(NSArray *))block
{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *imgs = [NSMutableArray array];
    for (SJAttachment *attachment in attachments) {
        
        dispatch_group_enter(group);
        if (kStringIsEmpty(attachment.netPath)) {
            
            UIImage *originImage = [UIImage imageWithContentsOfFile:attachment.localPath];
            NSData *imageData = UIImageJPEGRepresentation(originImage, 0.8);
            [JAFileUploadPresenter uploadFile:nil
                                     fileData:imageData
                                  fileDataKey:@"file"
                                     progress:nil
                                      success:^(id dataObject) {
                [imgs addObject:[dataObject valueForKey:@"url"]];
                attachment.netPath = [dataObject valueForKey:@"url"];
                dispatch_group_leave(group);
            } failure:^(NSError *error) {
                dispatch_group_leave(group);
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }];
        } else {
            dispatch_group_leave(group);
            [imgs addObject:attachment.netPath];
        }
    }
        
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (block) {
            block(imgs);
        }
    });
}

#pragma mark - SJAttributesCellDelegate
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)newHeight atIndexPath:(NSIndexPath *)indexPath
{
    self.buildNoteModel.attributedHeight = newHeight;
}

#pragma mark - SJNoteTabCellDelegate
- (void)didChoosedTag:(JABbsLabelModel *)tagModel
{
    if (tagModel.isSelected) {
        self.buildNoteModel.selectedTagModel = tagModel;
    } else {
        self.buildNoteModel.selectedTagModel = nil;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.listView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)popToBack
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (!kStringIsEmpty(self.buildNoteModel.note_title) && !kStringIsEmpty(self.buildNoteModel.note_attributedText.string) && !kObjectIsEmpty(self.buildNoteModel.selectedTagModel)) {
        
            [self alertTipsWithIsUpdate:!kObjectIsEmpty(self.postsModel)];
    } else {
        [super popToBack];
    }
}

- (void)alertTipsWithIsUpdate:(BOOL)isUpdate
{
    SJAlertModel *saveModel = [[SJAlertModel alloc] initWithTitle:isUpdate?@"更新":@"保存" handler:^(id content) {
        
        void(^getImgBlock)(NSArray *) = ^(NSArray *imgs) {
            
            NSString *imgAddresses = [imgs componentsJoinedByString:@","];
            if (isUpdate) {
                //更新
                [self updateNoteWithImages:imgAddresses runStatus:JAPostsRunStatusDraft];
            } else {
                //新建
                [self createNoteWithImages:imgAddresses];
            }
        };
        [SVProgressHUD showWithStatus:isUpdate?@"正在更新帖子草稿，请稍后...":@"正在创建帖子草稿，请稍后..."];
        NSArray <SJAttachment *>*attachments = [SJHtmlTransfer getAttributedAttachment:self.buildNoteModel.note_attributedText];
        if (!kArrayIsEmpty(attachments))
        {
            [self uploadImgWithAttachments:attachments AndBlock:getImgBlock];
        } else {
            getImgBlock(nil);
        }
    }];
    SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消"
                                                            handler:^(id content) {
        [super popToBack];
    }];
    SJAlertView *alertView = [SJAlertView alertWithTitle:isUpdate?@"是否更新草稿帖子？":@"您编辑的帖子尚未完成，是否保存？" message:nil type:SJAlertShowTypeNormal alertModels:@[saveModel, cancelModel]];
    [alertView showAlertView];
}

- (void)updateNoteWithImages:(NSString *)images
                   runStatus:(JAPostsRunStatus)runStatus
{
    [JAForumPresenter postAddOrUpdatePort:self.postsModel.ID status:runStatus labels:self.buildNoteModel.selectedTagModel.labelName title:self.buildNoteModel.note_title content:[SJHtmlTransfer xll_transferHtmlWithAttributedText:self.buildNoteModel.note_attributedText isPublish:NO] Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success) {
                [SVProgressHUD showSuccessWithStatus:@"帖子草稿更新成功"];
                if (self.buildSuccssBlock) {
                    self.buildSuccssBlock();
                }
                [super popToBack];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

- (void)createNoteWithImages:(NSString *)images
{
    [JAForumPresenter postAddOrUpdatePort:self.postsModel.ID status:JAPostsRunStatusDraft labels:self.buildNoteModel.selectedTagModel.labelName title:self.buildNoteModel.note_title content:[SJHtmlTransfer xll_transferHtmlWithAttributedText:self.buildNoteModel.note_attributedText isPublish:NO] Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                [SVProgressHUD showSuccessWithStatus:@"帖子草稿保存成功"];
                if (self.buildSuccssBlock) {
                    self.buildSuccssBlock();
                }
                [super popToBack];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
    /**
    [JABbsPresenter postAddDetails:1
                     WithRunStatus:1
                         WithOldId:nil
                 WithDetailsLabels:self.buildNoteModel.selectedTagModel.labelName
                   WithDetailsName:self.buildNoteModel.note_title
                   WithDetailsText:[SJHtmlTransfer xll_transferHtmlWithAttributedText:self.buildNoteModel.note_attributedText isPublish:NO]
                 WithImagesAddress:images
                   WithDescribtion:nil
                            Result:^(JAResponseModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success) {
                [SVProgressHUD showSuccessWithStatus:@"帖子草稿保存成功"];
                if (self.buildSuccssBlock) {
                    self.buildSuccssBlock();
                }
                [super popToBack];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
     */
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

#pragma mark - 选图回调
- (void)photoController:(SJPhotosController *)photoVC
      didSelectedPhotos:(NSArray<SJPhotoModel *> *)photos
{
    if (!kArrayIsEmpty(photos))
    {
        for (SJPhotoModel *photoModel in photos) {
            [self.attributeHeaderView insertPhotoModel:photoModel];
        }
    }
}

#pragma mark - lazy loading
- (SJBuildNoteModel *)buildNoteModel
{
    if (_buildNoteModel == nil)
    {
        _buildNoteModel = [[SJBuildNoteModel alloc] init];
    }
    return _buildNoteModel;
}

#pragma mark - setter
- (void)setDefaultTagLabel:(JABbsLabelModel *)defaultTagLabel
{
    _defaultTagLabel = defaultTagLabel;
    defaultTagLabel.isSelected = YES;
    self.buildNoteModel.selectedTagModel = defaultTagLabel;
    [self.listView reloadData];
}

- (void)setPostsModel:(JAPostsModel *)postsModel
{
    _postsModel = postsModel;
    [SVProgressHUD show];
    [JABbsPresenter postQueryDetails:self.postsModel.ID
                              Result:^(JABBSModel * _Nullable model) {
                                  
                                  if (model.success) {
                                    self.buildNoteModel.note_attributedText = [SJHtmlTransfer transferAttributedTextWithHtml:model.detail.detailsText isFixed:YES];
                                  }
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      if (model.success) {
                                          
                                              self.buildNoteModel.isNeedReload = YES;
                                              self.buildNoteModel.note_title = model.detail.detailsName;
                                              JABbsLabelModel *selectedModel = [[JABbsLabelModel alloc] init];
                                              selectedModel.labelName = model.detail.detailsLabels;
                                              self.defaultTagLabel = selectedModel;
                                          self.attributeHeaderView.noteModel = self.buildNoteModel;
                                              [self.listView reloadData];
                                          [SVProgressHUD dismiss];
//                                          }];
                                      } else {
                                          [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                                          [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                                      }
                                  });
                              }];
}


@end
