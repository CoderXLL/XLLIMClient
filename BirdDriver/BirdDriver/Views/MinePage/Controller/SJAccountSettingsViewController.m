//
//  SJAccountSettingsViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//
// 修改用户信息

#import "SJAccountSettingsViewController.h"
#import "SJChangeHobbiesViewController.h"
#import "SJPhotosController.h"
#import "SJPhotoComponents.h"
#import "JAUserPresenter.h"
#import "JAFileUploadPresenter.h"
#import "SJPhotoModel.h"
#import "SJBrowserController.h"

@interface SJAccountSettingsViewController ()<UITextFieldDelegate, SJPhotoProtocol>

@property (nonatomic, copy) NSString *currentHeadUrl;
@property (nonatomic, strong) NSMutableArray *myArr;


@end

@implementation SJAccountSettingsViewController

-(void)updateUserInfo{
    //头像
    [self.porImageView sd_setImageWithURL:SPLocalInfo.userModel.avatarUrl.mj_url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    //昵称
    self.nameTextField.text = [SPLocalInfo.userModel getShowNickName];

    //个人签名
    if (SPLocalInfo.userModel.personalSign.length > 0) {
        self.describeTextField.text = SPLocalInfo.userModel.personalSign;
    } else {
        self.describeTextField.text = @"";
    }
    //性别0是女，1是男
    if ([SPLocalInfo.userModel.sex isEqualToString:@"1"]) {//男
        self.genderManBtn.selected = YES;
        self.genderWomanBtn.selected = NO;
        self.porImageView.layer.borderColor = [UIColor colorWithHexString:@"6EEBEE" alpha:1].CGColor;
    } else {//女
        self.genderManBtn.selected = NO;
        self.genderWomanBtn.selected = YES;
        self.porImageView.layer.borderColor = [UIColor colorWithHexString:@"F9739B" alpha:1].CGColor;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.myArr = [[SPLocalInfo.userModel.hobbies componentsSeparatedByString:@","] mutableCopy];
    if (self.isChange) {
        if (self.hobbys.length > 0) {
            self.myArr = [[self.hobbys componentsSeparatedByString:@","] mutableCopy];
        } else {
            self.myArr = [NSMutableArray array];
        }
    } else {
        self.hobbys = SPLocalInfo.userModel.hobbies;
    }
    [self hobbyTagListViewRefresh];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (IBAction)changePhoto:(id)sender {
    
    [self headModifyAction];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUserInfo];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"个人信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem.tintColor = RGBCOLOR(255, 187, 4);
    
    self.porImageView.layer.masksToBounds = YES;
//    [self.porBtn addTarget:self action:@selector(headModifyAction) forControlEvents:UIControlEventTouchUpInside];
    self.porImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.porImageView.imageView.layer.cornerRadius = 28.0;
    self.porImageView.imageView.clipsToBounds = YES;
    [self.genderManBtn addTarget:self action:@selector(genderChangesManAction) forControlEvents:UIControlEventTouchUpInside];
    [self.genderWomanBtn addTarget:self action:@selector(genderChangesWomanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.interestBtn addTarget:self action:@selector(interestModifyAction) forControlEvents:UIControlEventTouchUpInside];
    self.nameTextField.delegate = self;
    self.nameTextField.tag = 1;
    self.describeTextField.delegate = self;
    self.describeTextField.tag = 2;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hobbyTagListViewRefresh];
    });
    self.hobbyTagListView.signalTagColor=[UIColor clearColor];
    self.hobbyTagListView.deleteHide = YES;
    self.hobbyTagListView.canTouch = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}


- (IBAction)porImageViewClick:(id)sender {
    
        if (kStringIsEmpty(SPLocalInfo.userModel.avatarUrl)) {
    
            [SJPhotoComponents requestPhotoAuthorizationWithCompletionHandler:^(BOOL isAllowed) {
                if (isAllowed) {
                    SJPhotosController *photoVC = [[SJPhotosController alloc] init];
                    photoVC.titleName = @"全部";
                    photoVC.maximumLimit = 1;
                    photoVC.isHead = YES;
                    photoVC.delegate = self;
                    [self.navigationController pushViewController:photoVC animated:YES];
                }
            }];
        } else {
            SJBrowserController *browserVC = [[SJBrowserController alloc] init];
            browserVC.fetchPhotoResults = [@[SPLocalInfo.userModel.avatarUrl] mutableCopy];
            browserVC.noEdit = YES;
            [self.navigationController pushViewController:browserVC animated:YES];
        }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 保存
-(void)saveAction{
    //性别0是女，1是男
    NSString *sex = SPLocalInfo.userModel.sex;
    if (self.genderManBtn.isSelected) {
        sex = @"1";
    } else {
        sex = @"0";
    }
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"昵称不为空"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    [JAUserPresenter postUpdateUserInfo:SPLocalInfo.userModel.Id
                          WithAvatarUrl:self.currentHeadUrl
                           WithNickname:self.nameTextField.text
                            WithAddress:nil
                              WithEmail:nil
                                WithSex:sex
                       WithPersonalSign:self.describeTextField.text
                                 WithQq:nil
                             WithWechat:nil
                            WithHobbies:self.hobbys
                                 Result:^(JAResponseModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(model.success){
                [SVProgressHUD showSuccessWithStatus:@"修改用户信息成功"];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                [JAUserPresenter postQueryUserInfo:^(JAUserModel * _Nullable model) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
        });
    }];
    return;
}

#pragma mark - 头像修改
-(void)headModifyAction{
    [SJPhotoComponents requestPhotoAuthorizationWithCompletionHandler:^(BOOL isAllowed) {
        if (isAllowed) {
            SJPhotosController *photoVC = [[SJPhotosController alloc] init];
            photoVC.titleName = @"全部";
            photoVC.maximumLimit = 1;
            photoVC.isHead = YES;
            photoVC.delegate = self;
            [self.navigationController pushViewController:photoVC animated:YES];
        }
    }];
}

#pragma mark - 性别男修改
-(void)genderChangesManAction{
    self.genderManBtn.selected = YES;
    self.genderWomanBtn.selected = NO;
    self.porImageView.layer.borderColor = [UIColor colorWithHexString:@"6EEBEE" alpha:1].CGColor;
}
#pragma mark - 性别女修改
-(void)genderChangesWomanAction{
    self.genderManBtn.selected = NO;
    self.genderWomanBtn.selected = YES;
    self.porImageView.layer.borderColor = [UIColor colorWithHexString:@"F9739B" alpha:1].CGColor;
}
#pragma mark - 个人爱好修改
-(void)interestModifyAction{
    SJChangeHobbiesViewController *changeHobbiesVC = [[SJChangeHobbiesViewController alloc] init];
    changeHobbiesVC.titleName = @"修改个人爱好";
    changeHobbiesVC.hobbys = [self.myArr mutableCopy];
    [self.navigationController pushViewController:changeHobbiesVC animated:YES];
}

-(void)hobbyTagListViewRefresh{
    self.hobbyTagListView.signalTagColor=[UIColor clearColor];
    self.hobbyTagListView.deleteHide = YES;
    self.hobbyTagListView.canTouch = YES;
    
    NSMutableArray *hobbies = [NSMutableArray arrayWithCapacity:self.myArr.count];
    for (NSString *hobby in self.myArr) {
        [hobbies addObject:[hobby stringByReplacingOccurrencesOfString:@"#" withString:@""]];
    }
    self.hobbyTagListView.signalTagTextColor = [UIColor colorWithHexString:@"8A898A" alpha:1];
    [self.hobbyTagListView setTagWithTagArray:hobbies];
    self.hobbyHeight.constant = MAX(60, self.hobbyTagListView.frame.size.height + 25);
}

#pragma mark - SJPhotoProtocol
- (void)photoController:(SJPhotosController *)photoVC didSelectedPhotos:(NSArray<SJPhotoModel *> *)photos
{
    void(^uploadSuccessBlock)(NSString *) = ^(NSString *newUrl) {
        
            self.currentHeadUrl = newUrl;
            [self.porImageView sd_setImageWithURL:newUrl.mj_url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_portrait"]];
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
    };
    SJPhotoModel *photoModel = photos.firstObject;
    NSData *imageData = UIImageJPEGRepresentation(photoModel.resultImage, 0.8);
    [SVProgressHUD show];
    [JAFileUploadPresenter uploadFile:nil fileData:imageData fileDataKey:@"file" progress:nil success:^(id dataObject) {
        
        uploadSuccessBlock(dataObject[@"url"]);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}


/**
 *  当 text field 文本内容改变时 会调用此方法
 */
-(void)textViewEditChanged:(NSNotification *)notification{
    // 拿到文本改变的 text field
    UITextField *textField = (UITextField *)notification.object;
    // 需要限制的长度
    NSUInteger maxLength = 0;
    if (textField.tag == 1) { // 昵称限制长度
        maxLength = 12;
    }
    if (textField.tag == 2) { // 个性签名限制长度
        maxLength = 20;
    }
    if (maxLength == 0) return;
    
    // text field 的内容
    NSString *contentText = textField.text;
    
    // 获取高亮内容的范围
    UITextRange *selectedRange = [textField markedTextRange];
    // 这行代码 可以认为是 获取高亮内容的长度
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    // 没有高亮内容时,对已输入的文字进行操作
    if (markedTextLength == 0) {
        // 如果 text field 的内容长度大于我们限制的内容长度
        if (contentText.length > maxLength) {
            // 截取从前面开始maxLength长度的字符串
            //            textField.text = [contentText substringToIndex:maxLength];
            // 此方法用于在字符串的一个range范围内，返回此range范围内完整的字符串的range
            NSRange rangeRange = [contentText rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
            textField.text = [contentText substringWithRange:rangeRange];
        }
    }
    
}

@end
