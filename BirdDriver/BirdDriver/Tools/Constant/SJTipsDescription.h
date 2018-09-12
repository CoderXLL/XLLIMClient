//
//  SJTipsDescription.h
//  BirdDriver
//
//  Created by Soul on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#ifndef SJTipsDescription_h
#define SJTipsDescription_h

#prama mark - Title
static NSString * const title_home_invitefriends    = @"邀请好友";
static NSString * const title_home_webtitle         = @"正在加载页面";
static NSString * const title_financial_subjectType_newBorrow = @" 新手放送 ";
static NSString * const title_financial_subjectType_activity = @" 活动热荐 ";

static NSString * const message_login_failt         = @"登录失败";
static NSString * const message_login_success       = @"登录成功";
static NSString * const message_login_expired       = @"您的登录已过期,请重新登录";
static NSString * const message_success             = @"操作成功";
static NSString * const message_fail                = @"操作失败";
static NSString * const message_nullData            = @"无数据";
static NSString * const message_committing          = @"正在提交";
static NSString * const message_verifield_paycharge = @"温馨提示: 投资前需要进行充值！";
static NSString * const message_verifield_success   = @"认证成功！";

#prama mark - Status
static NSString * const netstatus_unKnown       = @"未知网络";
static NSString * const netstatus_reachableWiFi = @"当前网络: wifi";
static NSString * const netstatus_reachableWWAN = @"当前网络: 蜂窝移动网络";
static NSString * const netstatus_notReachable  = @"无网络连接";

#prama mark - Error
static NSString * const Error_UnKnown   = @"未知错误";
static NSString * const Error_Default   = @"加载失败";
static NSString * const Error_NoNetwork = @"您的网络异常";

#prama mark - Message
static NSString * const message_unlogon         = @"您还未登录";
static NSString * const message_error_psw       = @"密码应为6-15位数字、字母组合";
static NSString * const message_error_phoneNum  = @"请输入正确手机号";
static NSString * const message_error_verificationCode          = @"验证码为4位数字";
static NSString * const message_error_balanceMoney_notEnough    = @"余额不足，请先充值！";
static NSString * const message_error_investCode= @"邀请码不符合规则";
static NSString * const message_error_realName  = @"请输入正确姓名";
static NSString * const message_error_cardId    = @"请输入正确身份证号";
static NSString * const message_error_secondpsw = @"两次密码不一致";
static NSString * const message_error_bankCard  = @"银行卡号不正确";
static NSString * const message_error_bankName  = @"请选择银行";
static NSString * const message_error_payPsw    = @"密码为6位数字";
static NSString * const message_error_investMoney = @"100元起投！";
static NSString * const message_error_unBankCard = @"您还未绑定银行卡";
static NSString * const message_error_unPayPsw  = @"您还未设置交易密码";
static NSString * const message_error_unIdentityUserInfo = @"您还未实名认证";
static NSString * const message_paycharge_success = @"充值成功";
static NSString * const message_paycharge_fali      = @"充值失败";
static NSString * const message_withdraw_success    = @"提现申请成功";
static NSString * const message_withdraw_fail       = @"提现申请失败";

#endif /* SJTipsDescription_h */
