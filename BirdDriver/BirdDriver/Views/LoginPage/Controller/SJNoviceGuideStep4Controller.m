//
//  SJNoviceGuideStep4Controller.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/9/1.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoviceGuideStep4Controller.h"
#import "GBTagListView.h"
#import "SJHobbyTextFieldView.h"
#import "SJAccountSettingsViewController.h"
#import "JAMessagePresenter.h"
#import "NSString+XHLStringSize.h"
#import "SJGradientButton.h"
#import "JAUserPresenter.h"


@interface SJNoviceGuideStep4Controller ()

@property (nonatomic, strong) NSMutableArray *hobbys;//爱好

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) GBTagListView *selectItems;
@property (nonatomic,strong) GBTagListView *hobbyTag;
@property (nonatomic,strong) NSMutableArray *itemArr;
@property (nonatomic,strong) NSMutableArray *myArr;
@property(nonatomic, assign)BOOL isChange;

@property (nonatomic, strong, nonnull) UIView *headerView;
@property (nonatomic, strong, nonnull) UIView *selectView;
@property (nonatomic, strong, nonnull) SJHobbyTextFieldView *hobbyTextFieldView;
@property (nonatomic, strong) SJGradientButton *gradientBtn;

@end

@implementation SJNoviceGuideStep4Controller

-(void)getHobbysDicticty{
    [JAMessagePresenter postDataDictionary:@"hobbyTags"
                                    Result:^(NSMutableArray * _Nullable array) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:array.count];
                                            for (NSString *item in array) {
                                                [myArray addObject:[item stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                                            }
                                            self.itemArr = [myArray copy];
                                            [self.selectItems setTagWithTagArray:self.itemArr];
                                           
                                            self.selectView.frame = CGRectMake(0, self.headerView.frame.size.height + 10, kScreenWidth, self.selectItems.frame.origin.y + self.selectItems.frame.size.height + 20);
  self.gradientBtn.frame = CGRectMake(80, self.selectView.frame.origin.y + self.selectView.frame.size.height + 10, kScreenWidth-160, 44);
                                          self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, self.gradientBtn.frame.origin.y+self.gradientBtn.height+20);
                                        });
                                    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)updateInfo{
    self.myArr = [self.hobbys mutableCopy];
    [self getHobbysDicticty];
    [self  createView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myArr = [NSMutableArray array];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置个人爱好";
    [self updateInfo];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Set_back"] style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    
}

//没时间找内存泄漏，先在这里移除
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createView{
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavBarHeight)];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainScrollView];
    
    [mainScrollView addSubview:self.headerView];
    [mainScrollView addSubview:self.selectView];
    [mainScrollView addSubview:self.gradientBtn];
    self.mainScrollView = mainScrollView;
    
    //    [mainScrollView addSubview:self.hobbyTextFieldView];
    
    //    mainScrollView.contentSize = CGSizeMake(kScreenWidth, self.hobbyTextFieldView.frame.origin.y + self.hobbyTextFieldView.frame.size.height);
    mainScrollView.contentSize = CGSizeMake(kScreenWidth, self.gradientBtn.frame.origin.y+self.gradientBtn.height+20);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (SJGradientButton *)gradientBtn
{
    if (!_gradientBtn)
    {
        _gradientBtn = [SJGradientButton gradientButton];
        _gradientBtn.frame = CGRectMake(80, self.selectView.frame.origin.y + self.selectView.frame.size.height + 10, kScreenWidth-160, 44);
        _gradientBtn.titleStr = @"完成";
        _gradientBtn.enabled = NO;
        [_gradientBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gradientBtn;
}

#pragma mark - event
- (void)finishBtnClick
{
    NSString *string = [self.myArr componentsJoinedByString:@","];
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

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 30, kScreenWidth - 30, 15)];
        titleLabel.text=@"个人爱好";
        titleLabel.textAlignment=NSTextAlignmentLeft;
        titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [_headerView addSubview:titleLabel];
        
        [self refresh];
        
        UILabel *describeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, self.hobbyTag.frame.origin.y + self.hobbyTag.frame.size.height + 10, kScreenWidth - 30, 15)];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:@"*最多可设置5个兴趣爱好"];
        NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"*"].location, [[noteStr string] rangeOfString:@"*"].length);
        [noteStr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(@"FF0000") range:redRange];
        [describeLabel setAttributedText:noteStr];
        describeLabel.textAlignment=NSTextAlignmentLeft;
        describeLabel.font=[UIFont systemFontOfSize:11];
        [_headerView addSubview:describeLabel];
        
        _headerView.frame = CGRectMake(0, 0, kScreenWidth, describeLabel.frame.origin.y + describeLabel.frame.size.height + 20);
    }
    return _headerView;
}

-(void)refresh{
    [_hobbyTag removeFromSuperview];
    GBTagListView *myItems=[[GBTagListView alloc]initWithFrame:CGRectMake(0,30 + 15 + 20, kScreenWidth, 0)];
    myItems.signalTagColor=[UIColor clearColor];
    myItems.deleteHide = NO;
    myItems.canTouch = YES;
    myItems.signalTagTextColor = [UIColor colorWithHexString:@"8A898A" alpha:1];
    [_headerView addSubview:myItems];
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:self.myArr.count];
    for (NSString *item in self.myArr) {
        [myArray addObject:[item stringByReplacingOccurrencesOfString:@"#" withString:@""]];
    }
    [myItems setTagWithTagArray:myArray];
    self.gradientBtn.enabled = !kArrayIsEmpty(self.myArr);
    [myItems setDidselectItemBlock:^(NSArray *arr, NSInteger index) {
        self.isChange = YES;
        LogD(@"%ld", (long)index);
        [self.myArr removeObjectAtIndex:index];
        [self refresh];
    }];
    _hobbyTag = myItems;
}

-(UIView *)selectView{
    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height + 10, kScreenWidth, 180)];
        _selectView.backgroundColor = [UIColor whiteColor];
        
        UILabel *selectTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, kScreenWidth - 30, 15)];
        selectTitleLabel.text=@"请选择";
        selectTitleLabel.textAlignment=NSTextAlignmentLeft;
        selectTitleLabel.font=[UIFont boldSystemFontOfSize:14];
        [_selectView addSubview:selectTitleLabel];
        
        
        GBTagListView *selectItems=[[GBTagListView alloc]initWithFrame:CGRectMake(0,30 + 15 + 20, kScreenWidth - 15, 0)];
        selectItems.signalTagColor=[UIColor clearColor];
        selectItems.deleteHide = YES;
        selectItems.canTouch = YES;
        selectItems.signalTagTextColor = [UIColor colorWithHexString:@"8A898A" alpha:1];
        [_selectView addSubview:selectItems];
        self.selectItems = selectItems;
        [selectItems setDidselectItemBlock:^(NSArray *arr, NSInteger index) {
            if (self.myArr.count < 5) {
                self.isChange = YES;
                NSString *name = [self.itemArr objectAtIndex:index];
                LogD(@"--------%@",name);
                if (self.myArr.count == 0) {
                    self.myArr = [NSMutableArray array];
                }
                if ([self.myArr containsObject:name]) {
                    
                    [SVProgressHUD showInfoWithStatus:@"您已经有此标签~"];
                    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                    return ;
                }
                [self.myArr addObject:name];
            } else {
                [SVProgressHUD showInfoWithStatus:@"最多可设置5个兴趣爱好"];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            }
            [self refresh];
        }];
    }
    return _selectView;
}

- (SJHobbyTextFieldView *)hobbyTextFieldView{
    if (!_hobbyTextFieldView) {
        _hobbyTextFieldView = [SJHobbyTextFieldView createCellWithXib];
        _hobbyTextFieldView.frame = CGRectMake(0, self.selectView.frame.origin.y + self.selectView.frame.size.height + 10, kScreenWidth, 150);
        [_hobbyTextFieldView.sureBtn addTarget:self action:@selector(addLabelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hobbyTextFieldView;
}

- (void)addLabelAction{
    [self.hobbyTextFieldView.labelTextField resignFirstResponder];
    
    if ([self.hobbyTextFieldView.labelTextField.text isAllSpace]) {
        
        self.hobbyTextFieldView.labelTextField.text = @"";
        [SVProgressHUD showInfoWithStatus:@"自定义标签不能为空"];
        [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        return;
    }
    if (self.hobbyTextFieldView.labelTextField.text.length < 5 && self.hobbyTextFieldView.labelTextField.text.length > 0) {
        if (self.myArr.count < 5) {
            self.isChange = YES;
            if ([self.myArr containsObject:self.hobbyTextFieldView.labelTextField.text]) {
                
                [SVProgressHUD showInfoWithStatus:@"您已经有此标签~"];
                [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
                return ;
            }
            [self.myArr addObject:self.hobbyTextFieldView.labelTextField.text];
        } else {
            LogD(@"最多可设置5个兴趣爱好");
        }
        self.hobbyTextFieldView.labelTextField.text  = @"";
        [self refresh];
    } else {
        LogD(@"请输入自定义标签，长度1-4个字");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --重写back按钮的返回事件方法
- (void)goBack{
    UIViewController *previousVC = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 2) <= 0 ? 0 : (self.navigationController.viewControllers.count -2)];
    if ([previousVC isKindOfClass:[SJAccountSettingsViewController class]]) {
        SJAccountSettingsViewController *vc = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 2)];
        NSString *string = [self.myArr componentsJoinedByString:@","];
        vc.hobbys = string;
        vc.isChange = self.isChange;
        [self.navigationController popToViewController:vc animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  当 text field 文本内容改变时 会调用此方法
 */
-(void)textViewEditChanged:(NSNotification *)notification{
    // 拿到文本改变的 text field
    UITextField *textField = (UITextField *)notification.object;
    // 需要限制的长度
    NSUInteger maxLength = 4;
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

