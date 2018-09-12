//
//  JARequestPath.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/21.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#ifndef JARequestPath_h
#define JARequestPath_h

#define JA_SERVER_HOST      [[NSBundle mainBundle] infoDictionary][@"ServerHost"]       //服务器地址
#define JA_SERVER_HOST_V2   [[NSBundle mainBundle] infoDictionary][@"ServerHostv2"]     //v2地址
#define JA_SERVER_WEB       [[NSBundle mainBundle] infoDictionary][@"ServerWeb"]        //h5请求地址
#define JA_SERVER_Program   [[NSBundle mainBundle] infoDictionary][@"ServerProgram"]    //小程序类型
#define JA_SERVER_VER       [[NSBundle mainBundle] infoDictionary][@"ServerVersion"]    //Target标示，0表示主包/1马甲
#define JA_TIME_OUT         10.0f                                                       //请求超时时间

// ======================= 对应https://t-m.niaosiji.com/swagger-ui.html整理接口 =======================
#pragma mark - userAccountController : 用户相关操作
static NSString * const kURL_user_getToken          =   @"/imagescode/gettokennum";     //获取图形验证码token
static NSString * const kURL_users_login            =   @"/userAccount/login";                  //登录
static NSString * const kURL_users_logOut           =   @"/userAccount/loginOut";               //退出
static NSString * const kURL_users_wxlogin          =   @"/userAccount/getWeiXinLoginInfo";   //微信登录
static NSString * const kURL_users_wxModifyUserInfo =   @"/userAccount/weiXinModifyUserInfo";  //微信登录绑定手机号
static NSString * const kURL_users_weiXinChangeTiePhone = @"/weiXinController/weiXinChangeTiePhone";  //微信登录换绑手机号
static NSString * const kURL_users_userInfo         =   @"/userAccount/queryCurrentUserInfo";   //获取用户信息
static NSString * const kURL_users_queryHotUser     =   @"/userAccount/queryHotUserList";       //查询热门用户列表
static NSString * const kURL_users_otherUserInfo    =   @"/userAccount/queryOtherUsersInfo";    //获取其他用户信息
static NSString * const kURL_users_attentionUser    =   @"/userAccount/attentionUser";          //关注用户
static NSString * const kURL_users_cancelAtteninUser=   @"/userAccount/cancelAttentionUser";    //取消关注
static NSString * const kURL_users_queryFans        =   @"/userAccount/queryFansList";      //查询粉丝列表
static NSString * const kURL_users_queryAttentions  =   @"/userAccount/queryAttentionList"; //查询关注列表
static NSString * const kURL_users_authName         =   @"/userAccount/userAuthentication";     //实名认证
static NSString * const kURL_users_bindPhone        =   @"/userAccount/updateUserMobilePhone";  //绑手机
static NSString * const kURL_users_bindWeChat       =   @"/weiXinController/bindWeChat";    //绑微信
static NSString * const kURL_users_unbindWeChat     =   @"/weiXinController/unBindWeiXin";  //解绑微信
static NSString * const kURL_users_oldPhoneCheck    =   @"/userAccount/oldPhoneNumberCheck";    //修改手机号之前校验输入的旧号码是否正确
static NSString * const kURL_users_updateHeadImg    =   @"/userAccount/updateUserHeadPortrait"; //修改用户头像
static NSString * const kURL_users_updateHobby      =   @"/userAccount/updateUserHobby";        //修改用户爱好
static NSString * const kURL_users_updateUserInfo   =   @"/userAccount/updateUserInfoById";     //修改用户信息
static NSString * const kURL_users_feedBack         =   @"/feedBack/addFeedBack";               //添加用户反馈
static NSString * const kURL_users_userInteraction  =   @"/userAccount/userInteraction/defriend";           //拉黑
static NSString * const kURL_users_isBlacklist      =   @"/userAccount/userInteraction/isBlacklist";        //是否拉黑
static NSString * const kURL_users_cancelDefriend   =   @"/userAccount/userInteraction/cancelDefriend";     //取消拉黑
static NSString * const kURL_share_shareActivity    =   @"/activityTask/shareActivity";                     //分享后任务

#pragma mark - appConfig : 获取配置接口
static NSString * const kURL_appConfig_getKey = @"/appConfig/getKey";   //获取小程序原始id
static NSString * const kURL_dataDictionary_queryByType   =   @"/dataDictionary/queryDataDictionaryByType"; //根据类型查询数据字典

#pragma mark - bbsController : BBS核心接口
static NSString * const kURL_bbs_labelList          =   @"/bbs/queryLabelsList";                //获取所有标签

static NSString * const kURL_bbs_homeRecDetail      =   @"/bbs/queryRecommendDetails";          //获取首页推荐标签活动
static NSString * const kURL_bbs_discoveryRec       =   @"/bbs/queryPostsRecommendDetails";     //获取发现页推荐活动
static NSString * const kURL_bbs_queryDetailByLabel =   @"/bbs/queryDetailsByLabels";           //根据标签模糊查询活动或帖子
static NSString * const kURL_bbs_queryLabelList     =   @"/bbs/queryLabelsList";                //查询所有的标签
static NSString * const kURL_bbs_queryUserDetail    =   @"/bbs/queryDetailsByUser";             //查询用户自己的帖子或活动
static NSString * const kURL_bbs_queryCommentsList  =   @"/bbs/queryCommentsList";              //查询评论
static NSString * const kURL_bbs_queryChildCommentsList = @"/bbs/queryChildCommentsList";       //查询相关回复及评论子集
static NSString * const kURL_bbs_queryCollectDetail =   @"/bbs/queryCollectionDetails";         //查询用户收藏的帖子或活动
static NSString * const kURL_bbs_queryDetails       =   @"/bbs/queryDetails";                   //获取用户信息
static NSString * const kURL_bbs_queryTimeLine      =   @"/bbs/queryTimeAxis";                  //获取用户时光轴
static NSString * const kURL_bbs_queryAtlasList     =   @"/bbs/queryAtlasList";                 //查询用户图册集
static NSString * const kURL_bbs_queryPicsList      =   @"/bbs/queryPicturesList";              //查询图册中的图片集合

static NSString * const kURL_search_fuzzySearchLabels   =   @"/bbs/fuzzySearchLabels";              //模糊搜索相关标签
static NSString * const kURL_search_fuzzySearchDetails  =   @"/bbs/fuzzySearchDetails";             //模糊搜索相关活动&&帖子
static NSString * const kURL_bbs_teamUsers              =   @"/bbs/queryCollectionsUsers";          //查询帖子或活动收藏用户组

static NSString * const kURL_userAccount_queryUserByNickName  =   @"/userAccount/queryUserByNickName";      //根据昵称查询用户

static NSString * const kURL_message_queryMessage   =   @"/userMessage/queryUserMessage";                   //查询用户消息
static NSString * const kURL_message_notReadMessageCount =   @"/userMessage/queryUserNotReadMessageCount";  //查询用户未读消息数量
static NSString * const kURL_message_readAllMessage =   @"/userMessage/readAllUserMessage";                 //一键已读用户消息
static NSString * const kURL_message_readMessaget   =   @"/userMessage/readUserMessage";                    //消息已读标记

static NSString * const kURL_systemMessage_querySystemMessage   =   @"/systemMessage/querySystemMessage";     //系统消息
static NSString * const kURL_userMessage_queryAttentionMessage   =   @"/userMessage/queryAttentionMessage";    //关注消息
static NSString * const kURL_userMessage_queryCommentOnMeMessage   =   @"/userMessage/queryCommentOnMeMessage"; //评论我的
static NSString * const kURL_userMessage_queryLikeMessage   =   @"/userMessage/queryLikeMessage";               //点赞消息


static NSString * const kURL_activityTask_hasRewarding =   @"/activityTask/hasRewarding";       //判断当前用户是否有可领取任务

static NSString * const kURL_bbs_report             =   @"/bbs/report";                         //举报
static NSString * const kURL_bbs_isReported         =   @"/bbs/isReported";                     //是否举报
static NSString * const kURL_bbs_addCommentBlock    =   @"/bbs/addCommentBlock";                //投诉评论

static NSString * const kURL_bbs_addLabel           =   @"/bbs/addLabel";                       //添加标签
static NSString * const kURL_bbs_addDetails         =   @"/bbs/addDetails";                     //添加帖子&&活动
static NSString * const KURL_bbs_buildAtlas         =   @"/bbs/buildAtlas";                     //创建图册
static NSString * const kURL_bbs_addPictures        =   @"/bbs/addPictures";                    //批量添加图片

static NSString * const kURL_bbs_addComment         =   @"/bbs/addComment";                     //添加评论
static NSString * const kURL_bbs_addCollection      =   @"/bbs/addCollection";                  //添加收藏
static NSString * const kURL_bbs_addPraise          =   @"/bbs/addPraise";                      //添加点赞
static NSString * const kURL_bbs_addScore           =   @"/bbs/addScore";                       //添加评分

static NSString * const kURL_bbs_updatePraise       =   @"/bbs/updatePraise";                   //删除点赞
static NSString * const kURL_bbs_updateCollection   =   @"/bbs/updateCollection";                                                           //编辑或删除收藏帖子/活动
static NSString * const kURL_bbs_updateDetails      =   @"/bbs/updateDetails";                  //编辑或删除帖子,活动
static NSString * const kURL_bbs_updatePics         =   @"/bbs/updatePictures";                 //图册中批量删除图片

static NSString * const kURL_bbs_updateTimeAxis     =   @"/bbs/updateTimeAxis";                 //删除时光轴
static NSString * const kURL_bbs_deleteComment      =   @"/bbs/deleteComment";                  //删除评论
static NSString * const kURL_bbs_updateAtlas        =   @"/bbs/updateAtlas";                    //修改图册相关信息
static NSString * const kURL_bbs_updateCoverImage   =   @"/bbs/updateCoverImage";               //更改图册封面
static NSString * const kURL_bbs_changeLocation     =   @"/bbs/changeLocation";                 //拖动图册，传入最新图册的id顺序集
static NSString * const kURL_bbs_changePicLocation  =   @"/bbs/changePicLocation";              //拖动图片，传入最新图片的id顺序集

#pragma mark - forum帖子，路线，评论相关核心接口
static NSString * const kURL_forum_queryRouteList = @"/forum/queryRouteList";         //获取路线列表
static NSString * const kURL_forum_queryRouteDetail = @"/forum/queryRouteDetail";    //获取路线详情
static NSString * const kURL_forum_addDetailCollection = @"/forum/addDetailCollection";  //添加收藏（感兴趣）
static NSString * const kURL_forum_deleteDetailCollection = @"/forum/deleteDetailCollection";  //消息收藏（感兴趣）
static NSString * const kURL_forum_routeCollectionPage = @"/forum/queryRouteCollectionPage";  //获取路线感兴趣人
static NSString * const kURL_forum_myCollectionRoutePage = @"/forum/queryMyCollectionRoutePage";  //获取路线收藏列表
static NSString * const kURL_forum_addOrUpdatePort = @"/forum/addOrUpdatePort";   //添加或修改帖子
static NSString * const kURL_forum_deleteById = @"/forum/deleteById";  //删除帖子或路线
static NSString * const kURL_forum_deleteComment = @"/forum/deleteComment";  //删除评论
static NSString * const kURL_forum_addComment = @"/forum/addComment";  //添加帖子或路线评论
static NSString * const kURL_forum_addChildComment = @"/forum/addChildComment";   //添加子评论
static NSString * const kURL_forum_addReply = @"/forum/addReply";  //添加回复
static NSString * const kURL_forum_queryCommentPage = @"/forum/queryCommentPage";  //获取帖子评论列表
static NSString * const kURL_forum_queryCommentDetailPage = @"/forum/queryCommentDetailPage";  //获取评论详情分页列表
static NSString * const kURL_forum_complainComment = @"/forum/complainCommnet";   //投诉评论

#pragma mark - smsController : 短信相关操作
static NSString * const kURL_sms_sendCode           =   @"/smsController/sendVerifyCode";       //短信发送

#pragma mark - BannerController : 轮播图相关操作
static NSString * const kURL_banner_queryByPlatform =  @"/banner/queryBannerByPlatform";

#pragma mark - smsController : 配置相关操作
static NSString * const kURL_common_appConfig       =   @"/appConfig/queryAppConfig";           //配置H5地址

//#pragma mark - pwdController : 密码相关

// ======================= 对应https://t-m.niaosiji.com/swagger-ui.html整理接口 =======================

#endif /* JARequestPath_h */
