//
//  JAForumPresenter.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAPresenter.h"
#import "JABBSModel.h"
#import "JARouteListModel.h"
#import "JARouteDetailModel.h"
#import "JAAddCollectionModel.h"
#import "JAInterestListModel.h"
#import "JAPostCommentModel.h"
#import "JAPostChildCommentModel.h"

@interface JAForumPresenter : JAPresenter

#pragma mark - 增
/**
 添加收藏（感兴趣）
 
 @param detailId 详情id
 @param retBlock 回执
 */
+ (void)postAddDetailCollection:(NSInteger)detailId
                         Result:(void (^_Nonnull) (JAAddCollectionModel * _Nullable model))retBlock;

/**
 添加或修改帖子（新接口）

 @param Id 帖子ID 传0为添加， 传Id为修改
 @param status 帖子进行状态：1：提交审核（草稿），2：审核中
 @param labels 帖子相关标签
 @param title 帖子标题
 @param content 帖子正文
 @param retBlock 回执
 */
+ (void)postAddOrUpdatePort:(NSInteger)Id
                     status:(JAPostsRunStatus)status
                     labels:(NSString *)labels
                      title:(NSString *)title
                    content:(NSString *)content
                     Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock;

/**
 添加帖子或路线评论

 @param detailId 帖子或路线Id
 @param content 评论内容
 @param imagesAddress 评论插图，以,隔开
 @param score 评分
 @param retBlock 回执
 */
+ (void)postAddComment:(NSInteger)detailId
               content:(NSString *)content
         imagesAddress:(NSString *)imagesAddress
                 score:(NSInteger)score
                Result:(void (^_Nonnull) (JAPostCommentItemModel * _Nullable model))retBlock;

/**
 添加子评论

 @param detailId 帖子Id
 @param superCommentId 父评论Id
 @param content 评论内容
 @param imagesAddress 评论插图
 @param score 评分
 @param retBlock 回执
 */
+ (void)postAddChildComment:(NSInteger)detailId
             superCommentId:(NSInteger)superCommentId
                    content:(NSString *)content
              imagesAddress:(NSString *)imagesAddress
                      score:(NSInteger)score
                     Result:(void (^_Nonnull) (JACommentVOModel * _Nullable model))retBlock;

/**
 添加回复

 @param detailId 帖子Id
 @param superCommentId 父评论Id
 @param replyUserId 被回复者Id
 @param content 评论内容
 @param imagesAddress 评论插图
 @param score 评分
 @param retBlock 回执
 */
+ (void)postAddReply:(NSInteger)detailId
      superCommentId:(NSInteger)superCommentId
         replyUserId:(NSInteger)replyUserId
             content:(NSString *)content
       imagesAddress:(NSString *)imagesAddress
               score:(NSInteger)score
              Result:(void (^_Nonnull) (JACommentVOModel * _Nullable model))retBlock;






#pragma mark - 删
/**
 取消收藏（感兴趣）
 
 @param Id 收藏Id
 @param retBlock 回执
 */
+ (void)postDeleteDetailCollection:(NSInteger)Id
                            Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock;


/**
 删除帖子或路线

 @param Id 帖子或路线Id
 @param retBlock 回执
 */
+ (void)postDeletePostById:(NSInteger)Id
                    Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock;

/**
 删除评论

 @param Id 评论Id
 @param retBlock 回执
 */
+ (void)postDeleteComment:(NSInteger)Id
                   Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock;


#pragma mark - 改

/**
 投诉评论接口

 @param commentId 评论Id
 @param blackTypes 投诉类型集合
 @param blackReason 投诉原因（选填）
 @param retBlock 回执
 */
+ (void)postComplainComment:(NSInteger)commentId
                 blackTypes:(NSString *)blackTypes
                blackReason:(NSString *)blackReason
                     Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock;


#pragma mark - 查
/**
 获取路线列表

 @param labels 标签名
 @param isPaging 是否分页
 @param currentPage 当前页
 @param limit pageSize
 @param retBlock 回执
 */
+ (void)postQueryRouteListByLabels:(NSString *)labels
                          isPaging:(BOOL)isPaging
                   withCurrentPage:(NSInteger)currentPage
                         withLimit:(NSInteger)limit
                              sort:(NSString *)sort
                            Result:(void (^_Nonnull)(JARouteListModel * _Nullable model))retBlock;


/**
 获取路线详情

 @param Id 路线Id
 @param retBlock 回执
 */
+ (void)postQueryRouteDetail:(NSInteger)Id
                      Result:(void (^_Nonnull) (JARouteDetailModel * _Nullable model))retBlock;

/**
 获取路线感兴趣的人列表
 
 @param detailId 路线Id
 @param retBlock 回执
 */
+ (void)postQueryRouteCollectionPage:(NSInteger)detailId
                            isPaging:(BOOL)isPaging
                     withCurrentPage:(NSInteger)currentPage
                           withLimit:(NSInteger)limit
                             OrderBy:(NSString *)orderBy
                                Sort:(NSString *)sort
                              Result:(void (^_Nonnull) (JAInterestListModel * _Nullable model))retBlock;

/**
 查询我的收藏路线列表

 @param isPaging 是否分页
 @param currentPage 当前页
 @param limit pageSize
 @param orderBy 按照那个字段排序 非必传
 @param sort 排序规则：降序：" desc"，升序" asc" 非必传
 @param retBlock 回执
 */
+ (void)postQueryMyCollectionRoutePage:(BOOL)isPaging
                       withCurrentPage:(NSInteger)currentPage
                             withLimit:(NSInteger)limit
                               OrderBy:(NSString *)orderBy
                                  Sort:(NSString *)sort
                                Result:(void (^_Nonnull) (JARouteListModel * _Nullable model))retBlock;

/**
 获取帖子的评论列表

 @param isPaging 是否分页
 @param currentPage 当前页
 @param limit pageSize
 @param detailId 帖子Id
 @param orderBy 按照哪那个字段排序
 @param sort 排序规则：降序：" desc"，升序" asc"
 @param retBlock 回执
 */
+ (void)postQueryCommentPage:(BOOL)isPaging
             withCurrentPage:(NSInteger)currentPage
                   withLimit:(NSInteger)limit
                    detailId:(NSInteger)detailId
                     OrderBy:(NSString *)orderBy
                        Sort:(NSString *)sort
                      Result:(void (^_Nonnull) (JAPostCommentModel * _Nullable model))retBlock;

/**
 获取评论详情列表

 @param isPaging 是否分页
 @param currentPage 当前页
 @param limit pageSize
 @param commentId 评论Id
 @param orderBy 按照哪那个字段排序
 @param sort  排序规则：降序：" desc"，升序" asc"
 @param retBlock 回执
 */
+ (void)postQueryCommentDetailPage:(BOOL)isPaging
                   withCurrentPage:(NSInteger)currentPage
                         withLimit:(NSInteger)limit
                         commentId:(NSInteger)commentId
                           OrderBy:(NSString *)orderBy
                              Sort:(NSString *)sort
                            Result:(void (^_Nonnull) (JAPostChildCommentModel * _Nullable model))retBlock;


@end
