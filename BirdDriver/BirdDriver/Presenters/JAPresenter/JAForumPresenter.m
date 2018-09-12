//
//  JAForumPresenter.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/27.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAForumPresenter.h"

@implementation JAForumPresenter

//获取路线列表
+ (void)postQueryRouteListByLabels:(NSString *)labels
                          isPaging:(BOOL)isPaging
                   withCurrentPage:(NSInteger)currentPage
                         withLimit:(NSInteger)limit
                              sort:(NSString *)sort
                            Result:(void (^_Nonnull)(JARouteListModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_forum_queryRouteList
                    Parameters:@{
                                 @"labels": labels,
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit),
                                 @"sort":sort,
                                 @"orderBy":@"weight"
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JARouteListModel *model = [JARouteListModel mj_objectWithKeyValues:data];
                           LogD(@"获取路线列表成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取路线列表失败:%@",errModel);
                           JARouteListModel *model = [JARouteListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//获取路线详情
+ (void)postQueryRouteDetail:(NSInteger)Id Result:(void (^)(JARouteDetailModel * _Nullable))retBlock
{
    [JAHTTPManager postRequest:kURL_forum_queryRouteDetail
                    Parameters:@{
                                 @"id": @(Id)                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JARouteDetailModel *model = [JARouteDetailModel mj_objectWithKeyValues:data];
                           LogD(@"获取路线详情成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取路线详情失败:%@",errModel);
                           JARouteDetailModel *model = [JARouteDetailModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//添加收藏（感兴趣）
+ (void)postAddDetailCollection:(NSInteger)detailId
                         Result:(void (^_Nonnull) (JAAddCollectionModel * _Nullable model))retBlock;
{
    [JAHTTPManager postRequest:kURL_forum_addDetailCollection
                    Parameters:@{
                                 @"detailId": @(detailId)                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAAddCollectionModel *model = [JAAddCollectionModel mj_objectWithKeyValues:data];
                           LogD(@"添加收藏（感兴趣）成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加收藏（感兴趣）失败:%@",errModel);
                           JAAddCollectionModel *model = [JAAddCollectionModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//取消收藏（感兴趣）
+ (void)postDeleteDetailCollection:(NSInteger)Id
                            Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_forum_deleteDetailCollection
                    Parameters:@{
                                 @"id": @(Id)                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"取消收藏（感兴趣）成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"取消收藏（感兴趣）失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

//获取路线感兴趣的人列表
+ (void)postQueryRouteCollectionPage:(NSInteger)detailId
                            isPaging:(BOOL)isPaging
                     withCurrentPage:(NSInteger)currentPage
                           withLimit:(NSInteger)limit
                             OrderBy:(NSString *)orderBy
                                Sort:(NSString *)sort
                              Result:(void (^_Nonnull) (JAInterestListModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"isPaging":@(isPaging),
                                                                                @"currentPage":@(currentPage),
                                                                                @"limit":@(limit),
                                                                                @"detailId": @(detailId)                                    }];
    if (!kStringIsEmpty(orderBy)) {
        [dict setValue:orderBy forKey:@"orderBy"];
    }
    if (!kStringIsEmpty(sort)) {
        [dict setValue:sort forKey:@"sort"];
    }
    [JAHTTPManager postRequest:kURL_forum_routeCollectionPage
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           
                           JAInterestListModel *model = [JAInterestListModel mj_objectWithKeyValues:data];
                           LogD(@"获取路线感兴趣人成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取路线感兴趣人失败:%@",errModel);
                           JAInterestListModel *model = [JAInterestListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//获取我的收藏路线列表
+ (void)postQueryMyCollectionRoutePage:(BOOL)isPaging
                       withCurrentPage:(NSInteger)currentPage
                             withLimit:(NSInteger)limit
                               OrderBy:(NSString *)orderBy
                                  Sort:(NSString *)sort
                                Result:(void (^_Nonnull) (JARouteListModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"isPaging":@(isPaging),
                                                                                @"currentPage":@(currentPage),
                                                                                @"limit":@(limit)                }];
    if (!kStringIsEmpty(orderBy)) {
        [dict setValue:orderBy forKey:@"orderBy"];
    }
    if (!kStringIsEmpty(sort)) {
        [dict setValue:sort forKey:@"sort"];
    }
    [JAHTTPManager postRequest:kURL_forum_myCollectionRoutePage
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           
                           JARouteListModel *model = [JARouteListModel mj_objectWithKeyValues:data];
                           LogD(@"获取我的收藏路线成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取我的收藏路线失败:%@",errModel);
                           JARouteListModel *model = [JARouteListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//添加或修改帖子
+ (void)postAddOrUpdatePort:(NSInteger)Id
                     status:(JAPostsRunStatus)status
                     labels:(NSString *)labels
                      title:(NSString *)title
                    content:(NSString *)content
                     Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_forum_addOrUpdatePort
                    Parameters:@{
                                 @"id":@(Id),
                                 @"status":@(status),
                                 @"labels":labels,
                                 @"title":title,
                                 @"content":content
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"添加或修改帖子成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加或修改帖子失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

//删除帖子或路线
+ (void)postDeletePostById:(NSInteger)Id
                    Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_forum_deleteById
                    Parameters:@{
                                 @"id":@(Id)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"删除帖子或路线成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"删除帖子或路线失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postAddComment:(NSInteger)detailId
               content:(NSString *)content
         imagesAddress:(NSString *)imagesAddress
                 score:(NSInteger)score
                Result:(void (^_Nonnull) (JAPostCommentItemModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"detailId":@(detailId),
                                                                                @"content":content
                                                                                }];
    if (!kStringIsEmpty(imagesAddress)) {
        
        [dict setValue:imagesAddress forKey:@"imagesAddress"];
    }
    if (score>0) {
        [dict setValue:@(score) forKey:@"score"];
    }
    [JAHTTPManager postRequest:kURL_forum_addComment
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           
                           JAPostCommentItemModel *model = [JAPostCommentItemModel mj_objectWithKeyValues:data];
                           LogD(@"添加帖子或路线评论成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加帖子或路线评论失败:%@",errModel);
                           JAPostCommentItemModel *model = [JAPostCommentItemModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//获取帖子的评论列表
+ (void)postQueryCommentPage:(BOOL)isPaging
             withCurrentPage:(NSInteger)currentPage
                   withLimit:(NSInteger)limit
                    detailId:(NSInteger)detailId
                     OrderBy:(NSString *)orderBy
                        Sort:(NSString *)sort
                      Result:(void (^_Nonnull) (JAPostCommentModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"isPaging":@(isPaging),
                                                                                @"currentPage":@(currentPage),
                                                                                @"limit":@(limit),
                                                                                @"detailId":@(detailId)                                    }];
    if (!kStringIsEmpty(orderBy)) {
        [dict setValue:orderBy forKey:@"orderBy"];
    }
    if (!kStringIsEmpty(sort)) {
        [dict setValue:sort forKey:@"sort"];
    }
    [JAHTTPManager postRequest:kURL_forum_queryCommentPage
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           
                           JAPostCommentModel *model = [JAPostCommentModel mj_objectWithKeyValues:data];
                           LogD(@"获取帖子评论列表成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取帖子评论列表失败:%@",errModel);
                           JAPostCommentModel *model = [JAPostCommentModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//添加子评论
+ (void)postAddChildComment:(NSInteger)detailId
             superCommentId:(NSInteger)superCommentId
                    content:(NSString *)content
              imagesAddress:(NSString *)imagesAddress
                      score:(NSInteger)score
                     Result:(void (^_Nonnull) (JACommentVOModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"detailId":@(detailId),
                                                                                @"superCommentId":@(superCommentId),                                     @"content":content                                    }];
    if (!kStringIsEmpty(imagesAddress)) {
        
        [dict setValue:imagesAddress forKey:@"imagesAddress"];
    }
    if (score>0) {
        [dict setValue:@(score) forKey:@"score"];
    }
    [JAHTTPManager postRequest:kURL_forum_addChildComment
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           
                           JACommentVOModel *model = [JACommentVOModel mj_objectWithKeyValues:data];
                           LogD(@"添加子评论成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加子评论失败:%@",errModel);
                           JACommentVOModel *model = [JACommentVOModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//获取评论详情分页列表
+ (void)postQueryCommentDetailPage:(BOOL)isPaging
                   withCurrentPage:(NSInteger)currentPage
                         withLimit:(NSInteger)limit
                         commentId:(NSInteger)commentId
                           OrderBy:(NSString *)orderBy
                              Sort:(NSString *)sort
                            Result:(void (^_Nonnull) (JAPostChildCommentModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"isPaging":@(isPaging),
                                                                                @"currentPage":@(currentPage),
                                                                                @"limit":@(limit),
                                                                                @"commentId":@(commentId)                                      }];
    if (!kStringIsEmpty(orderBy)) {
        [dict setValue:orderBy forKey:@"orderBy"];
    }
    if (!kStringIsEmpty(sort)) {
        [dict setValue:sort forKey:@"sort"];
    }
    [JAHTTPManager postRequest:kURL_forum_queryCommentDetailPage
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           
                           JAPostChildCommentModel *model = [JAPostChildCommentModel mj_objectWithKeyValues:data];
                           LogD(@"获取评论详情列表成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取评论详情列表失败:%@",errModel);
                           JAPostChildCommentModel *model = [JAPostChildCommentModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//添加回复
+ (void)postAddReply:(NSInteger)detailId
      superCommentId:(NSInteger)superCommentId
         replyUserId:(NSInteger)replyUserId
             content:(NSString *)content
       imagesAddress:(NSString *)imagesAddress
               score:(NSInteger)score
              Result:(void (^_Nonnull) (JACommentVOModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"detailId":@(detailId),
                                                                                @"superCommentId":@(superCommentId),
                                                                                @"replyUserId":@(replyUserId),                                      @"content":content                                    }];
    if (!kStringIsEmpty(imagesAddress)) {
        
        [dict setValue:imagesAddress forKey:@"imagesAddress"];
    }
    if (score>0) {
        [dict setValue:@(score) forKey:@"score"];
    }
    [JAHTTPManager postRequest:kURL_forum_addReply
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           
                           JACommentVOModel *model = [JACommentVOModel mj_objectWithKeyValues:data];
                           LogD(@"添加回复成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加回复失败:%@",errModel);
                           JACommentVOModel *model = [JACommentVOModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

//删除评论
+ (void)postDeleteComment:(NSInteger)Id
                   Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_forum_deleteComment
                    Parameters:@{
                                 @"id":@(Id)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"删除评论成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"删除评论失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

//投诉评论选填
+ (void)postComplainComment:(NSInteger)commentId
                 blackTypes:(NSString *)blackTypes
                blackReason:(NSString *)blackReason
                     Result:(void (^_Nonnull) (JAResponseModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"commentId":@(commentId),
                                                                                @"blackTypes":blackTypes                                   }];
    if (!kStringIsEmpty(blackReason)) {
        [dict setValue:blackReason forKey:@"blackReason"];
    }
    [JAHTTPManager postRequest:kURL_forum_complainComment
                    Parameters:dict                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"投诉评论成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"投诉评论失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

@end
