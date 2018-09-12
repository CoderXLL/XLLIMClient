//
//  JABbsPresenter.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/28.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAPresenter.h"
#import "JABBSModel.h"
#import "JACommentListModel.h"
#import "JAChildCommentListModel.h"
#import "JANewCommentModel.h"
#import "JAHomeRecGroupModel.h"
#import "JADiscRecGroupModel.h"
#import "JATimeLineListModel.h"
#import "JAAtlasListModel.h"
#import "JAPhotoListModel.h"
#import "JADiscRecLabelModel.h"
#import "JANewAtlasModel.h"
#import "SJTeamListModel.h"
#import "JAAddPraiseModel.h"
#import "JAIsReportedModel.h"
#import "JAAddCollectionModel.h"
#import "JAUserListModel.h"
#import "JAUpdatePraiseModel.h"
#import "SJScoreModel.h"

typedef NS_ENUM(NSInteger, JADetailsType){
    JADetailsTypePost       = 1,    //帖子
    JADetailsTypeActivity   = 2,    //活动
    JADetailsTypeComment    = 3,    //评论
};

typedef NS_ENUM(NSInteger, JACommentType) {
    
    JACommentTypeNormal = 0, //评论帖子或活动或评论
    JACommentTypeReply  = 1, //回复评论的回复
};

@interface JABbsPresenter : JAPresenter

#pragma mark - 查

/**
 查询所有标签

 @param isPaging 是否分页
 @param Limit pageSize
 @param retBlock 回执
 */
+ (void)postQueryLabelsListIsPaging:(BOOL)isPaging
                              Limit:(NSInteger)Limit
                             Result:(void (^_Nonnull)(JADiscRecLabelModel * _Nullable model))retBlock;


/**
 查询首页的标签+对应的话题

 @param labelCount 首页标签数量
 @param labelActsCount 每个标签对应的话题数量
 @param retBlock 标签+话题组成的结构体
 */
+ (void)postQueryHomeRecActivity:(NSInteger)labelCount
              withLabelActsCount:(NSInteger)labelActsCount
                          Result:(void (^_Nonnull)(JAHomeRecGroupModel * _Nullable model))retBlock;


/**
 根据标签模糊查询活动或帖子

 @param labelName 标签名字
 @param queryType 1.帖子  2.活动
 @param isPaging 是否分页
 @param currentPage 当前页
 @param limit pageSize
 @param retBlock 响应回执
 */
+ (void)postQueryDetailsByLabels:(NSString *)labelName
                       queryType:(JADetailsType)queryType
                        isPaging:(BOOL)isPaging
                 withCurrentPage:(NSInteger)currentPage
                       withLimit:(NSInteger)limit
                          Result:(void (^_Nonnull)(JADiscRecGroupModel * _Nullable model))retBlock;

/**
 发现页面根据标签查询对应的话题+帖子

 @param labelId 标签的id(暂时不加验证，可填0)
 @param lableName 标签名称(查询依据，必填项)
 @param labelActsCount 标签对应的查询话题数量
 @param isPaging 是否分页，不分页以下参数无用
 @param currentPage 当前页面
 @param limit 每页条数
 @param retBlock 话题+帖子组成的结构体
 */
+ (void)postQueryDiscoveryActivity:(NSInteger)labelId
                     withLabelName:(NSString *_Nonnull)lableName
                withlabelActsCount:(NSInteger)labelActsCount
                          isPaging:(BOOL)isPaging
                   withCurrentPage:(NSInteger)currentPage
                         withLimit:(NSInteger)limit
                            Result:(void (^_Nonnull)(JADiscRecGroupModel * _Nullable model))retBlock;

/**
 查询所有标签(分页)
 
 @param orderBy 按照哪那个字段排序（可空）
 @param isPaging 是否分页
 @param currentPage 当前页数
 @param limit 每页条数
 @param retBlock 发现页标签查询返回
 */
+ (void)postQueryLabelsList:(NSString * _Nullable)orderBy
                   IsPaging:(BOOL)isPaging
            WithCurrentPage:(NSInteger)currentPage
                  WithLimit:(NSInteger)limit
                     Result:(void (^_Nonnull)(JADiscRecLabelModel * _Nullable model))retBlock;

/**
 用户查询自己的帖子和活动

 @param userId 用户ID
 @param queryType 详情类型 1.帖子 2.活动
 @param status  查看用户指定状态的帖子
 @param isPaging 是否分页
 @param currentPage 当前请求页
 @param limit pageSize
 @param retBlock 请求回执
 */
+ (void)postQueryDetailsByUser:(NSInteger)userId
                     queryType:(JADetailsType)queryType
                        status:(NSInteger)status
                      IsPaging:(BOOL)isPaging
               WithCurrentPage:(NSInteger)currentPage
                     WithLimit:(NSInteger)limit
                        Result:(void (^_Nonnull)(JARecommendDetailSpolistModel *_Nullable model))retBlock;

/**
 根据用户查找收藏的帖子或活动
 
 @param userId 被查询的用户id
 @param queryType 1.帖子 2.活动
 @param isPaging 是否分页
 @param currentPage 当前页数
 @param limit 每页条数
 @param retBlock 查询结果回调
 */
+ (void)postQueryCollectionDetails:(NSInteger)userId
                         queryType:(JADetailsType)queryType
                          IsPaging:(BOOL)isPaging
                   WithCurrentPage:(NSInteger)currentPage
                         WithLimit:(NSInteger)limit
                            Result:(void (^_Nonnull)(JARecommendDetailSpolistModel * _Nullable model))retBlock;

/**
 查询用户图册集
 
 @param userId 相册用户id
 @param isPaging 是否分页
 @param currentPage 当前页数
 @param limit 每页条数
 @param retBlock 查询结果回调
 */
+ (void)postQueryUserAtlas:(NSInteger)userId
                  IsPaging:(BOOL)isPaging
           WithCurrentPage:(NSInteger)currentPage
                 WithLimit:(NSInteger)limit
                    Result:(void (^_Nonnull)(JAAtlasListModel * _Nullable model))retBlock;

/**
 查询相册中的图片集合
 
 @param atlasId 图册id
 @param isPaging 是否分页
 @param currentPage 当前页
 @param limit 每页条数
 @param retBlock 查询结果回调
 */
+ (void)postQueryPicsList:(NSInteger)atlasId
                 IsPaging:(BOOL)isPaging
          WithCurrentPage:(NSInteger)currentPage
                WithLimit:(NSInteger)limit
                   Result:(void (^_Nonnull)(JAPhotoListModel * _Nullable model))retBlock;

/**
 查询用户时光轴
 
 @param userId 用户id
 @param retBlock 查询结果回调
 */
+ (void)postQueryTimeAxis:(NSInteger)userId
                   Result:(void (^_Nonnull)(JATimeLineListModel * _Nullable model))retBlock;

/**
 查询用户时光轴(分页)
 
 @param userId 被查询的用户id
 @param isPaging 是否分页
 @param currentPage 当前页数
 @param limit 每页条数
 @param retBlock 查询结果回调
 */
+ (void)postQueryTimeAxis:(NSInteger)userId
                 IsPaging:(BOOL)isPaging
          WithCurrentPage:(NSInteger)currentPage
                WithLimit:(NSInteger)limit
                   Result:(void (^_Nonnull)(JATimeLineListModel * _Nullable model))retBlock;

/**
 查询帖子详情

 @param detailId 帖子Id
 @param retBlock 查询结果回调
 */
+ (void)postQueryDetails:(NSInteger)detailId
                  Result:(void (^_Nonnull)(JABBSModel * _Nullable model))retBlock;

/**
 查询全部组员

 @param detailId 帖子/活动相关id
 @param retBlock 查询结果回调
 */
+(void)postTeamUsers:(NSInteger)detailId
              Result:(void (^_Nonnull)(SJTeamListModel * _Nullable model))retBlock;

/**
 查询评论

 @param detailId 帖子或活动ID
 @param isPaging 是否分页
 @param currentPage 当前页
 @param limit pageSize
 @param sort 降序：" desc"，升序" asc"
 @param retBlock 查询结果回执
 */
+ (void)postQueryCommentsList:(NSInteger)detailId
                     IsPaging:(BOOL)isPaging
              WithCurrentPage:(NSInteger)currentPage
                    WithLimit:(NSInteger)limit
                     WithSort:(NSString *)sort
                       Result:(void (^_Nonnull)(JACommentListModel * _Nullable model))retBlock;

/**
 查询相关回复及评论子集

 @param detailId 帖子或活动ID
 @param Id 评论Id
 @param commentUserId 帖子主体userId
 @param isPaging 是否分页
 @param currentPage 页码
 @param limit pageSize
 @param sort 排序 降序：" desc"，升序" asc"
 @param retBlock 回执
 */
+ (void)postQueryChildCommentsList:(NSInteger)detailId
                         Id:(NSInteger)Id
                     commentUserId:(NSInteger)commentUserId
                          IsPaging:(BOOL)isPaging
                   WithCurrentPage:(NSInteger)currentPage
                         WithLimit:(NSInteger)limit
                          WithSort:(NSString *)sort
                            Result:(void (^_Nonnull)(JAChildCommentListModel * _Nullable model))retBlock;



#pragma mark - 增

/**
 添加评论

 @param detailId 帖子或活动id
 @param posterId 帖子人ID
 @param commentId 评论的评论ID
 @param commentType 评论类型
 @param replyUserId 被回复人ID
 @param commentText 评论内容
 @param imagesAddress 评论插图，以，隔开
 @param retBlock 回执
 */
+ (void)postAddCommentWithDetailId:(NSInteger)detailId
                          posterId:(NSInteger)posterId
                         commentId:(NSInteger)commentId
                       commentType:(JACommentType)commentType
                       replyUserId:(NSInteger)replyUserId
                       commentText:(NSString *)commentText
                     imagesAddress:(NSString *)imagesAddress
                            Result:(void (^_Nonnull)(JANewCommentModel * _Nullable model))retBlock;


/**
 图册中批量增加图片

 @param lasId 图册ID
 @param userId 用户ID
 @param pictures 图片地址，用,分割
 @param retBlock 响应回执
 */
+ (void)postAddPicturesAtlasId:(NSInteger)lasId
                        userId:(NSInteger)userId
                      pictures:(NSString *)pictures
                        Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;


/**
 创建图册

 @param atlasName 图册名
 @param retBlock 回执
 */
+ (void)postBuildAtlas:(NSString *)atlasName
       WithAtlasStatus:(JAAtlasStatus)atlasStatus
         WithIsDeleted:(BOOL)isDeleted
                Result:(void (^_Nonnull)(JANewAtlasModel * _Nullable model))retBlock;

/**
 发布新的活动/帖子

 @param detailsType 发布类型：1帖子，2活动（必填）
 @param runStatus  1.草稿  2.审核中
 @param oldId  发布草稿id
 @param detailsLabels 帖子/活动相关标签，以英文逗号分隔（必填）
 @param detailsName 帖子/活动标题（必填）
 @param detailsText 帖子/活动正文，可存正文文件地址或是正文内容（可选）
 @param imagesAddress 帖子/活动图片地址，以英文逗号分隔（可选）
 @param describtion  帖子/活动简介内容（可选）
 @param retBlock 发布结果回调
 */
+ (void)postAddDetails:(NSInteger)detailsType
         WithRunStatus:(NSInteger)runStatus
             WithOldId:(NSString *)oldId
     WithDetailsLabels:(NSString *_Nonnull)detailsLabels
       WithDetailsName:(NSString *_Nonnull)detailsName
       WithDetailsText:(NSString *_Nullable)detailsText
     WithImagesAddress:(NSString *_Nullable)imagesAddress
       WithDescribtion:(NSString *_Nullable)describtion
                Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

///**
// 添加收藏
//
// @param detailsId 相关贴子/活动id
// @param retBlock 添加结果回调
// */
//+ (void)postAddCollection:(NSInteger)detailsId
//                   Result:(void (^_Nonnull)(JAAddCollectionModel * _Nullable model))retBlock;

/**
 添加收藏(新) 2018.07.27 焦飞翔
 
 @param detailsId 相关贴子/活动id
 @param retBlock 添加结果回调
 */
+ (void)postAddCollection:(NSInteger)detailsId
          WithDetailsType:(JADetailsType)detailsType
                   Result:(void (^_Nonnull)(JAAddCollectionModel * _Nullable model))retBlock;

/**
 举报帖子或活动

 @param detailsId 帖子或活动Id
 @param reason 举报原因
 @param retBlock 回执
 */
+ (void)postReport:(NSInteger)detailsId
            reason:(NSString *)reason
        reportType:(NSArray *)reportTypes
            Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 是否举报相关帖子或活动

 @param detailsId 帖子ID或活动Id
 @param retBlock 回执
 */
+ (void)postIsReported:(NSInteger)detailsId
                Result:(void (^_Nonnull)(JAIsReportedModel * _Nullable model))retBlock;


/**
 投诉评论

 @param commentId 评论id
 @param commentUserId 评论用户ID
 @param remark 投诉原因
 @param retBlock 回执
 */
+ (void)postAddCommentBlock:(NSInteger)commentId
              commentUserId:(NSInteger)commentUserId
                     remark:(NSString *)remark
                     Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 添加标签

 @param labelName 标签名称
 @param retBlock 添加结果回调
 */
+ (void)postAddLabel:(NSString *_Nonnull)labelName
                Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 添加点赞

 @param detailsId 相关贴子/活动id
 @param praisesType 点赞类型：1：帖子，2：活动，3：评论
 @param retBlock 添加结果回调
 */
+ (void)postAddPraise:(JADetailsType)praisesType
        WithDetailsId:(NSInteger)detailsId
               Result:(void (^_Nonnull)(JAAddPraiseModel * _Nullable model))retBlock;

/**
 添加评分

 @param posterId 发帖人id
 @param model 评分实体类
 @param retBlock 添加结果回调
 */

+ (void)postAddScore:(NSInteger)posterId
            scorePO:(SJScoreModel *)model
              Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

#pragma mark - 改

/**
 更改图册封面图

 @param atlasId 图册ID
 @param pictureId 图片ID
 @param retBlock 响应回执
 */
+ (void)postUpdateCorverImage:(NSInteger)atlasId
                    pictureId:(NSInteger)pictureId
                       Reuslt:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 拖动图册，传入最新图册的id顺序集

 @param atlasIds 拖动的ID
 @param index 拖动后的位置
 @param isPaging 是否分页
 @param currentPage 当前页
 @param limit pageSize
 @param retBlock 回执
 
 @descirption 这个接口传参分页参数要与获取图册列表接口一致
 */
+ (void)postChangeLocation:(NSInteger)atlasId
                     index:(NSInteger)index
                  IsPaging:(BOOL)isPaging
           WithCurrentPage:(NSInteger)currentPage
                 WithLimit:(NSInteger)limit
                    Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 拖动图册，传入最新片的id顺序集

 @param pictureId 图片id
 @param index 位置
 @param atlasId 所属图册ID
 @param isPaging 是否分页
 @param currentPage 当前页
 @param limit pageSize
 @param retBlock 回执
 
  @descirption 这个接口传参分页参数要与获取图片列表接口一致
 */
+ (void)postChangePicLocation:(NSInteger)pictureId
                        index:(NSInteger)index
                      atlasId:(NSInteger)atlasId
                     IsPaging:(BOOL)isPaging
              WithCurrentPage:(NSInteger)currentPage
                    WithLimit:(NSInteger)limit
                       Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;


/**
 修改相册信息(未测试)
 
 @param atlasId 图册id(必填)
 @param atlasName 图册名称
 @param atlasStatus 图册显示状态：1：完全开放，2：只对关注者开放，3：只对自己开放
 @param remark 备注说明
 @param retBlock 修改结果回调
 */
+ (void)postUpdateAtlas:(NSInteger)atlasId
          WithAtlasName:(NSString *_Nullable)atlasName
        WithAtlasStatus:(JAAtlasStatus)atlasStatus
           WithIsDelete:(BOOL)isDelete
             WithRemark:(NSString *_Nullable)remark
                 Result:(void (^_Nonnull)(JAResponseModel * _Nullable))retBlock;


/**
 删除点赞

 @param detailsType 类型
 @param detailsId 活动或帖子ID
 @param praiseId 相关ID
 @param isDeleted 是否删除
 @param retBlock 回执
 */
+ (void)postUpdatePraiseType:(JADetailsType)detailsType
                   detailsId:(NSInteger)detailsId
                    praiseId:(NSInteger)praiseId
                   isDeleted:(BOOL)isDeleted
                      Result:(void (^_Nonnull)(JAUpdatePraiseModel * _Nullable))retBlock;


/**
 删除或编辑收藏的帖子、活动

 @param collectionId 收藏Id
 @param detailId 帖子/活动Id
 @param isDeleted 是否删除
 @param retBlock 响应回执
 */
+ (void)postUpdateCollection:(NSInteger)collectionId
                    detailId:(NSInteger)detailId
                   isDeleted:(BOOL)isDeleted
                      Result:(void (^_Nonnull)(JAResponseModel * _Nullable))retBlock;

/**
 删除或编辑我的帖子、活动

 @param detailID ID
 @param detailsType 类型，1.帖子。 2.活动
 @param isDeleted 是否为删除
 @param retBlock 回执
 */
+ (void)postUpdateDetails:(NSInteger)detailID
                runStatus:(JAPostsRunStatus)runStatus
              detailsName:(NSString *)detailsName
            detailsLabels:(NSString *)detailsLabels
               detailText:(NSString *)detailText
           imageAddresses:(NSString *)imageAddresses
            detailsUserId:(NSInteger)detailsUserId
              detailsType:(JADetailsType)detailsType
                isDeleted:(BOOL)isDeleted
                   Result:(void (^_Nonnull)(JAResponseModel * _Nullable))retBlock;

#pragma mark - 删
/**
 图册中批量删除图片
 
 @param atlasId 图册Id
 @param pictureIds 图片id集，以逗号分隔
 @param retBlock 删除结果回调
 */
+ (void)postUpdatePictures:(NSInteger)atlasId
                 isDeleted:(BOOL)isDeleted
                WithPicIds:(NSString *_Nonnull)pictureIds
                    Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 删除时光轴
 
 @param timeAxisId 时光轴id
 @param retBlock 删除结果回调
 */
+ (void)postUpdateTimeAxis:(NSInteger)timeAxisId
                    Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

/**
 删除评论
 
 @param Id 评论id
 @param retBlock 回执
 */
+ (void)postDeleteComment:(NSInteger)Id
                   Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock;

#pragma mark - 搜索

/**
 模糊搜索相关标签

 @param condition 模糊搜索条件 e.g.关键词
 @param isPaging 是否分页
 @param currentPage 当前页数
 @param limit 每页条数
 @param retBlock 返回推荐的标签（搜索下拉框）
 */
+ (void)postFuzzySearchLabels:(NSString *_Nonnull)condition
                     IsPaging:(BOOL)isPaging
              WithCurrentPage:(NSInteger)currentPage
                    WithLimit:(NSInteger)limit
                       Result:(void (^_Nonnull)(JADiscRecLabelModel * _Nullable model))retBlock;

/**
 模糊搜索相关帖子或活动

 @param condition 模糊搜索条件 e.g.关键词
 @param queryType 查询类型：1：只查帖子，2：只查活动，3或不传则为都查
 @param isPaging 是否分页
 @param currentPage 当前页数
 @param limit 每页条数
 @param retBlock 返回推荐的活动/帖子
 */
+ (void)postFuzzySearchDetials:(NSString *_Nonnull)condition
                 WithQueryType:(NSInteger)queryType
                      IsPaging:(BOOL)isPaging
               WithCurrentPage:(NSInteger)currentPage
                     WithLimit:(NSInteger)limit
                        Result:(void (^_Nonnull)(JADiscRecGroupModel * _Nullable model))retBlock;


/**
 根据昵称查询用户
 
 @param nickName 模糊搜索条件 e.g.关键词
 @param isPaging 是否分页
 @param currentPage 当前页数
 @param limit 每页条数
 @param retBlock 返回推荐的活动/帖子
 */
+ (void)postqueryUserByNickName:(NSString *_Nonnull)nickName
                      IsPaging:(BOOL)isPaging
               WithCurrentPage:(NSInteger)currentPage
                     WithLimit:(NSInteger)limit
                        Result:(void (^_Nonnull)(JAUserListModel * _Nullable model))retBlock;

@end
