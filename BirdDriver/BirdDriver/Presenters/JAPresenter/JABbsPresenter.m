//
//  JABbsPresenter.m
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/28.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JABbsPresenter.h"

@implementation JABbsPresenter

+ (void)postQueryLabelsListIsPaging:(BOOL)isPaging
                              Limit:(NSInteger)Limit
                             Result:(void (^_Nonnull)(JADiscRecLabelModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"isPaging":@(isPaging),
                                                                                @"limit":@(Limit)                            }];
    [JAHTTPManager postRequest:kURL_bbs_labelList
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           JADiscRecLabelModel *model = [JADiscRecLabelModel mj_objectWithKeyValues:data];
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           JADiscRecLabelModel *model = [JADiscRecLabelModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryHomeRecActivity:(NSInteger)labelCount
              withLabelActsCount:(NSInteger)labelActsCount
                          Result:(void (^)(JAHomeRecGroupModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_homeRecDetail
                    Parameters:@{
                                 @"labelCount":@(labelCount),
                                 @"labelActsCount":@(labelActsCount)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAHomeRecGroupModel *model = [JAHomeRecGroupModel mj_objectWithKeyValues:data];
                           LogD(@"首页推荐标签活动请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"首页推荐标签活动请求失败:%@",errModel);
                           JAHomeRecGroupModel *model = [JAHomeRecGroupModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryLabelsList:(NSString *)orderBy
                   IsPaging:(BOOL)isPaging
            WithCurrentPage:(NSInteger)currentPage
                  WithLimit:(NSInteger)limit
                     Result:(void (^)(JADiscRecLabelModel * _Nullable))retBlock{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"isPaging":@(isPaging),
                                                                                @"currentPage":@(currentPage),
                                                                                @"limit":@(limit)
                                                                                }];
    if (!kStringIsEmpty(orderBy)) {
        [dict setObject:orderBy forKey:@"orderBy"];
    }
    
    [JAHTTPManager postRequest:kURL_bbs_queryLabelList
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           
                           JADiscRecLabelModel *model = [JADiscRecLabelModel mj_objectWithKeyValues:data];
                           LogD(@"推荐标签请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"推荐标签请求失败:%@",errModel);
                           JADiscRecLabelModel *model = [JADiscRecLabelModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryDetailsByLabels:(NSString *)labelName
                       queryType:(JADetailsType)queryType
                        isPaging:(BOOL)isPaging
                 withCurrentPage:(NSInteger)currentPage
                       withLimit:(NSInteger)limit
                          Result:(void (^_Nonnull)(JADiscRecGroupModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_bbs_queryDetailByLabel
                    Parameters:@{
                                 @"labelName": labelName,
                                 @"queryType":@(queryType),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                        
                           JADiscRecGroupModel *model = [JADiscRecGroupModel mj_objectWithKeyValues:data];
                           LogD(@"根据标签查询标签活动请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"根据标签查询标签活动请求失败:%@",errModel);
                           JADiscRecGroupModel *model = [JADiscRecGroupModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}


+ (void)postQueryCommentsList:(NSInteger)detailId
                     IsPaging:(BOOL)isPaging
              WithCurrentPage:(NSInteger)currentPage
                    WithLimit:(NSInteger)limit
                     WithSort:(NSString *)sort
                       Result:(void (^_Nonnull)(JACommentListModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_bbs_queryCommentsList
                    Parameters:@{
                @"detailId":@(detailId),
                
                @"isPaging":@(isPaging),
                
                @"currentPage":@(currentPage),
                
                @"limit":@(limit),
                @"sort":sort,
                @"orderBy":@"create_time"
                } Success:^(NSData * _Nullable data) {

                    JACommentListModel *model = [JACommentListModel mj_objectWithKeyValues:data];
                    LogD(@"查询评论请求成功:%@",model);
                    retBlock(model);

                } Failure:^(JAResponseModel * _Nullable errModel) {
                    LogD(@"查询评论请求失败:%@",errModel);
                    JACommentListModel *model = [JACommentListModel new];
                    model.responseStatus = errModel.responseStatus;
                    model.success = errModel.success;
                    model.exception = errModel.exception;
                    retBlock(model);
                }];
}


+ (void)postQueryChildCommentsList:(NSInteger)detailId
                         Id:(NSInteger)Id
                     commentUserId:(NSInteger)commentUserId
                          IsPaging:(BOOL)isPaging
                   WithCurrentPage:(NSInteger)currentPage
                         WithLimit:(NSInteger)limit
                          WithSort:(NSString *)sort
                            Result:(void (^_Nonnull)(JAChildCommentListModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_bbs_queryChildCommentsList
                    Parameters:@{
                                 @"detailId":@(detailId),
                                 @"commentId":@(Id),
                                 @"commentUserId":@(commentUserId),
                                 @"isPaging":@(isPaging),
                                 
                                 @"currentPage":@(currentPage),
                                 
                                 @"limit":@(limit),
                                 @"sort":sort,
                                 @"orderBy":@"create_time"
                                 } Success:^(NSData * _Nullable data) {
                                     
                                     JAChildCommentListModel *model = [JAChildCommentListModel mj_objectWithKeyValues:data];
                                     LogD(@"查询评论子集请求成功:%@",model);
                                     retBlock(model);
                                     
                                 } Failure:^(JAResponseModel * _Nullable errModel) {
                                     LogD(@"查询评论子集请求失败:%@",errModel);
                                     JAChildCommentListModel *model = [JAChildCommentListModel new];
                                     model.responseStatus = errModel.responseStatus;
                                     model.success = errModel.success;
                                     model.exception = errModel.exception;
                                     retBlock(model);
                                 }];
}

+ (void)postQueryDiscoveryActivity:(NSInteger)labelId
                     withLabelName:(NSString *)lableName
                withlabelActsCount:(NSInteger)labelActsCount
                          isPaging:(BOOL)isPaging
                   withCurrentPage:(NSInteger)currentPage
                         withLimit:(NSInteger)limit
                            Result:(void (^)(JADiscRecGroupModel * _Nullable))retBlock{
    
    [JAHTTPManager postRequest:kURL_bbs_discoveryRec
                    Parameters:@{
                                 @"labelPO": @{
                                         @"labelName": lableName,
                                         @"id":@(labelId)
                                         },
                                 @"labelActsCount":@(labelActsCount),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JADiscRecGroupModel *model = [JADiscRecGroupModel mj_objectWithKeyValues:data];
                           LogD(@"发现页推荐标签活动请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"发现页推荐标签活动请求失败:%@",errModel);
                           JADiscRecGroupModel *model = [JADiscRecGroupModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}




+ (void)postQueryDetailsByUser:(NSInteger)userId
                     queryType:(JADetailsType)queryType
                        status:(NSInteger)status
                      IsPaging:(BOOL)isPaging
               WithCurrentPage:(NSInteger)currentPage
                     WithLimit:(NSInteger)limit
                        Result:(void (^)(JARecommendDetailSpolistModel *_Nullable))retBlock {
    [JAHTTPManager postRequest:kURL_bbs_queryUserDetail
                    Parameters:@{
                                 @"userId":@(userId),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit),
                                 @"queryType":@(queryType),
                                 @"status":@(status)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JARecommendDetailSpolistModel *model = [JARecommendDetailSpolistModel mj_objectWithKeyValues:data];
                           LogD(@"获取用户收藏列表请求成功:%@",model);
                           retBlock(model);
                       } Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取用户帖子或活动列表请求失败:%@", errModel);
                           JARecommendDetailSpolistModel *model= [JARecommendDetailSpolistModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryCollectionDetails:(NSInteger)userId
                         queryType:(JADetailsType)queryType
                          IsPaging:(BOOL)isPaging
                   WithCurrentPage:(NSInteger)currentPage
                         WithLimit:(NSInteger)limit
                            Result:(void (^)(JARecommendDetailSpolistModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_queryCollectDetail
                    Parameters:@{
                                 @"userId":@(userId),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit),
                                 @"queryType":@(queryType)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JARecommendDetailSpolistModel *model = [JARecommendDetailSpolistModel mj_objectWithKeyValues:data];
                           LogD(@"获取用户收藏列表请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取用户收藏列表请求失败:%@",errModel);
                           JARecommendDetailSpolistModel *model= [JARecommendDetailSpolistModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryUserAtlas:(NSInteger)userId
                  IsPaging:(BOOL)isPaging
           WithCurrentPage:(NSInteger)currentPage
                 WithLimit:(NSInteger)limit
                    Result:(void (^)(JAAtlasListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_queryAtlasList
                    Parameters:@{
                                 @"userId":@(userId),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAAtlasListModel *model = [JAAtlasListModel mj_objectWithKeyValues:data];
                           LogD(@"获取用户图册请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取用户图册请求失败:%@",errModel);
                           JAAtlasListModel *model= [JAAtlasListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryPicsList:(NSInteger)atlasId
                 IsPaging:(BOOL)isPaging
          WithCurrentPage:(NSInteger)currentPage
                WithLimit:(NSInteger)limit
                   Result:(void (^)(JAPhotoListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_queryPicsList
                    Parameters:@{
                                 @"atlasId":@(atlasId),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAPhotoListModel *model = [JAPhotoListModel mj_objectWithKeyValues:data];
                           LogD(@"获取图册中图片请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取图册中图片请求失败:%@",errModel);
                           JAPhotoListModel *model= [JAPhotoListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryTimeAxis:(NSInteger)userId
                   Result:(void (^)(JATimeLineListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_queryTimeLine
                    Parameters:@{
                                 @"userId":@(userId)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JATimeLineListModel *model = [JATimeLineListModel mj_objectWithKeyValues:data];
                           LogD(@"获取用户时光轴请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取用户时光轴请求失败:%@",errModel);
                           JATimeLineListModel *model= [JATimeLineListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryTimeAxis:(NSInteger)userId
                 IsPaging:(BOOL)isPaging
          WithCurrentPage:(NSInteger)currentPage
                WithLimit:(NSInteger)limit
                   Result:(void (^)(JATimeLineListModel * _Nullable))retBlock{
    
    [JAHTTPManager postRequest:kURL_bbs_queryTimeLine
                    Parameters:@{
                                 @"userId":@(userId),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JATimeLineListModel *model = [JATimeLineListModel mj_objectWithKeyValues:data];
                           LogD(@"获取用户时光轴请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取用户时光轴请求失败:%@",errModel);
                           JATimeLineListModel *model= [JATimeLineListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postQueryDetails:(NSInteger)detailId
                  Result:(void (^)(JABBSModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_queryDetails
                    Parameters:@{
                                 @"detailId":@(detailId)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JABBSModel *model = [JABBSModel mj_objectWithKeyValues:data];
                           LogD(@"帖子详情请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"帖子详情请求失败:%@",errModel);
                           JABBSModel *model = [JABBSModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+(void)postTeamUsers:(NSInteger)detailId
Result:(void (^)(SJTeamListModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_teamUsers
                    Parameters:@{
                                 @"detailId":@(detailId),
                                 @"isPaging":@(NO)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           SJTeamListModel *model = [SJTeamListModel mj_objectWithKeyValues:data];
                           LogD(@"全部组员请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"全部组员请求失败:%@",errModel);
                           SJTeamListModel *model = [SJTeamListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}


+ (void)postAddCommentWithDetailId:(NSInteger)detailId
                          posterId:(NSInteger)posterId
                         commentId:(NSInteger)commentId
                       commentType:(JACommentType)commentType
                       replyUserId:(NSInteger)replyUserId
                       commentText:(NSString *)commentText
                     imagesAddress:(NSString *)imagesAddress
                            Result:(void (^_Nonnull)(JANewCommentModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"commentType":@(commentType),
                                                                                @"commentId":@(commentId),
                                                                                @"relpyUserId":@(replyUserId),                                     @"detailsId":@(detailId),
                                    @"commentText":commentText
                                  }];
    if (!kStringIsEmpty(imagesAddress)) {
        [dict setValue:imagesAddress forKey:@"imagesAddress"];
    }
    [JAHTTPManager postRequest:kURL_bbs_addComment
                    Parameters:@{
                                 @"comment":dict,
                                 @"posterId":@(posterId)
                                 }                       Success:^(NSData * _Nullable data) {
        
        JANewCommentModel *model = [JANewCommentModel mj_objectWithKeyValues:data];
        LogD(@"评论成功:%@",model);
        retBlock(model);
    } Failure:^(JAResponseModel * _Nullable errModel) {
        
        JANewCommentModel *model = [JANewCommentModel new];
        model.responseStatus = errModel.responseStatus;
        model.success = errModel.success;
        model.exception = errModel.exception;
        LogD(@"评论失败:%@",errModel);
        retBlock(model);
    }];
}

+ (void)postAddPicturesAtlasId:(NSInteger)lasId
                        userId:(NSInteger)userId
                      pictures:(NSString *)pictures
                        Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"atlasId":@(lasId),
                                                                                @"userId":@(userId),
                                                                                @"picturesAddress":pictures
                                                                                }];
    [JAHTTPManager postRequest:kURL_bbs_addPictures
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"批量添加图片成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"批量添加图片失败:%@",errModel);
                           retBlock(errModel);
                       }];
    
}

+ (void)postBuildAtlas:(NSString *)atlasName
       WithAtlasStatus:(JAAtlasStatus)atlasStatus
         WithIsDeleted:(BOOL)isDeleted
                Result:(void (^_Nonnull)(JANewAtlasModel * _Nullable model))retBlock
{
    //必须参数
    NSMutableDictionary *atlasDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"atlasName": atlasName,                                                                                  @"isDeleted":@(isDeleted)                                                                                                 }];
    if (atlasStatus) {
        [atlasDict setObject:@(atlasStatus) forKey:@"atlasStatus"];
    }
    [JAHTTPManager postRequest:KURL_bbs_buildAtlas
                    Parameters:@{
                                 @"atlas":atlasDict
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JANewAtlasModel *model = [JANewAtlasModel mj_objectWithKeyValues:data];
                           LogD(@"创建图册成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           JANewAtlasModel *model = [JANewAtlasModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];

}

+ (void)postAddDetails:(NSInteger)detailsType
         WithRunStatus:(NSInteger)runStatus
                 WithOldId:(NSString *)oldId
     WithDetailsLabels:(NSString *)detailsLabels
       WithDetailsName:(NSString *)detailsName
       WithDetailsText:(NSString *)detailsText
     WithImagesAddress:(NSString *)imagesAddress
       WithDescribtion:(NSString *)describtion
                Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    //必须参数
    NSMutableDictionary *detailDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      @"detailsName": detailsName,
                                                                                      @"detailsType": @(detailsType),
                                                                                      @"detailsLabels":[NSString stringWithFormat:@"#%@#", detailsLabels],
                                                                                      @"runStatus":@(runStatus)
                                                                                      }];
    
    //可选参数
    if (!kStringIsEmpty(describtion)) {
        [detailDict setObject:describtion forKey:@"describtion"];
    }
    
    if (!kStringIsEmpty(detailsText)) {
        [detailDict setObject:detailsText forKey:@"detailsText"];
    }
    
    if (!kStringIsEmpty(imagesAddress)) {
        [detailDict setObject:imagesAddress forKey:@"imagesAddress"];
    }
    if (!kStringIsEmpty(oldId)) {
        [detailDict setObject:@(oldId.integerValue) forKey:@"id"];
    }
    
    [JAHTTPManager postRequest:kURL_bbs_addDetails
                    Parameters:@{
                                 @"detail":detailDict
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"发布帖子/活动请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"发布帖子/活动请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postAddCollection:(NSInteger)detailId
              detailsType:(JADetailsType)detailsType
                   Result:(void (^)(JAAddCollectionModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_addCollection
                    Parameters:@{
                                 @"collectionRelation":@{
                                         @"detailsId":@(detailId),
                                         @"detailsType":@(detailsType)
                                         }
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           LogD(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])
                           JAAddCollectionModel *model = [JAAddCollectionModel mj_objectWithKeyValues:data];
                           LogD(@"添加收藏请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加收藏请求失败:%@",errModel);
                           JAAddCollectionModel *model = [JAAddCollectionModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postAddCollection:(NSInteger)detailsId
          WithDetailsType:(JADetailsType)detailsType
                   Result:(void (^)(JAAddCollectionModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_addCollection
                    Parameters:@{
                                 @"collectionRelation":@{
                                         @"detailsType":@(detailsType),
                                         @"detailsId":@(detailsId)
                                         }
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAAddCollectionModel *model = [JAAddCollectionModel mj_objectWithKeyValues:data];
                           LogD(@"添加收藏请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加收藏请求失败:%@",errModel);
                           JAAddCollectionModel *model = [JAAddCollectionModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postReport:(NSInteger)detailsId
            reason:(NSString *)reason
        reportType:(NSArray *)reportTypes
            Result:(void (^)(JAResponseModel * _Nullable))retBlock
{
//    NSDictionary *dict = @{
//                           @"bbsId":@(detailsId),
//                           @"reason":reason,
//                           @"reportType":reportTypes
//                           };
//    LogD(@"%@", dict)
    [JAHTTPManager postRequest:kURL_bbs_report
                    Parameters:@{
                                 @"bbsId":@(detailsId),
                                 @"reason":reason,
                                 @"reportType":reportTypes
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"举报成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"举报失败:%@",errModel);
                           retBlock(errModel);
                       }];
}


+ (void)postIsReported:(NSInteger)detailsId
                Result:(void (^_Nonnull)(JAIsReportedModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_bbs_isReported
                    Parameters:@{
                                 @"bbsId":@(detailsId)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAIsReportedModel *model = [JAIsReportedModel mj_objectWithKeyValues:data];
                           LogD(@"查看是否举报请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"查看是否举报请求失败:%@",errModel);
                           JAIsReportedModel *model = [JAIsReportedModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postAddCommentBlock:(NSInteger)commentId
              commentUserId:(NSInteger)commentUserId
                     remark:(NSString *)remark
                     Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_bbs_addCommentBlock
                    Parameters:@{
                                 @"cid":@(commentId),
                                 @"uid":@(commentUserId),
                                 @"remark":remark
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"投诉评论成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"投诉评论失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postAddLabel:(NSString *)labelName
              Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_addLabel
                    Parameters:@{
                                 @"label":@{
                                         @"labelName":labelName
                                         }
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"添加标签请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加标签请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postAddPraise:(JADetailsType)praisesType
        WithDetailsId:(NSInteger)detailsId
               Result:(void (^_Nonnull)(JAAddPraiseModel * _Nullable model))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_addPraise
                    Parameters:@{
                                 @"praisesRelation":@{
                                         @"praisesType":@(praisesType),
                                         @"detailsId":@(detailsId)
                                         }
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAAddPraiseModel *model = [JAAddPraiseModel mj_objectWithKeyValues:data];
                           LogD(@"添加点赞请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加点赞请求失败:%@",errModel);
                           JAAddPraiseModel *model = [JAAddPraiseModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}


+ (void)postAddScore:(NSInteger)posterId
             scorePO:(SJScoreModel *)model
              Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    NSMutableDictionary *scoreDict = [NSMutableDictionary dictionaryWithDictionary:
                                      @{
                                        @"commentType":@(model.commentType),
                                        @"score":@(model.score),
                                        @"detailsId":@(model.detailsId),
                                        @"evaluate":model.evaluate
                                        }
                                      ];
    //图片地址可能为空
    if (!kArrayIsEmpty(model.imagesAddressList)) {
        [scoreDict addEntriesFromDictionary:@{
                                              @"imagesAddressList":model.imagesAddressList
                                              }];
    }
    
    if (!kStringIsEmpty(model.parentCommentId)) {
        [scoreDict setObject:@(model.parentCommentId.integerValue) forKey:@"parentCommentId"];
    }
    
    if (!kStringIsEmpty(model.relpyUserId)) {
        [scoreDict setObject:@(model.relpyUserId.integerValue) forKey:@"relpyUserId"];
    }
    
    if (!kStringIsEmpty(model.scoreUserId)) {
        [scoreDict setObject:@(model.scoreUserId.integerValue) forKey:@"scoreUserId"];
    }
    [JAHTTPManager postRequest:kURL_bbs_addScore
                    Parameters:@{
                                 @"scorePO":scoreDict,
                                 @"posterId":@(posterId),
                                 @"messageSecType":@(2)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"添加评分请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"添加评分请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}




+ (void)postUpdateCorverImage:(NSInteger)atlasId
                    pictureId:(NSInteger)pictureId
                       Reuslt:(void (^)(JAResponseModel * _Nullable))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"atlasId":@(atlasId)
                                                                                }];
    [dict setValue:pictureId==666666?nil:@(pictureId) forKey:@"pictureId"];
    [JAHTTPManager postRequest:kURL_bbs_updateCoverImage
                    Parameters:dict
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"更新封面图请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"更新封面图请求失败:%@",errModel);
                           retBlock(errModel);
                       }];

}

+ (void)postChangeLocation:(NSInteger)atlasId
                     index:(NSInteger)index
                  IsPaging:(BOOL)isPaging
           WithCurrentPage:(NSInteger)currentPage
                 WithLimit:(NSInteger)limit
                    Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_bbs_changeLocation
                    Parameters:@{
                                 @"atlasId":@(atlasId),
                                 @"index":@(index),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"图册顺序移动请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"图册顺序移动请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postChangePicLocation:(NSInteger)pictureId
                        index:(NSInteger)index
                      atlasId:(NSInteger)atlasId
                     IsPaging:(BOOL)isPaging
              WithCurrentPage:(NSInteger)currentPage
                    WithLimit:(NSInteger)limit
                       Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock
{
    [JAHTTPManager postRequest:kURL_bbs_changePicLocation
                    Parameters:@{
                                 @"atlasId":@(atlasId),
                                 @"pictureId":@(pictureId),
                                 @"index":@(index),
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"图片顺序移动请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"图片顺序移动请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postUpdateAtlas:(NSInteger)atlasId
          WithAtlasName:(NSString *)atlasName
        WithAtlasStatus:(JAAtlasStatus)atlasStatus
           WithIsDelete:(BOOL)isDelete
             WithRemark:(NSString *)remark
                 Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    NSMutableDictionary *atlasDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"id":@(atlasId), @"isDeleted":@(isDelete)                                                }];
    if (!kStringIsEmpty(atlasName)) {
        [atlasDict setObject:atlasName forKey:@"atlasDict"];
    }
    
    if (!kStringIsEmpty(remark)) {
        [atlasDict setObject:remark forKey:@"remark"];
    }
    
    if (atlasStatus) {
        [atlasDict setObject:@(atlasStatus) forKey:@"atlasStatus"];
    }
    
    [JAHTTPManager postRequest:kURL_bbs_updateAtlas
                    Parameters:@{
                                 @"atlas":atlasDict,
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"修改图册相关信息请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"修改图册相关信息请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postUpdatePraiseType:(JADetailsType)detailsType
                   detailsId:(NSInteger)detailsId
                    praiseId:(NSInteger)praiseId
                   isDeleted:(BOOL)isDeleted
                      Result:(void (^_Nonnull)(JAUpdatePraiseModel * _Nullable))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"detailsId":@(detailsId),
                                                                                @"praisesType":@(detailsType),
//                                                                                @"isDeleted":@(isDeleted),
                                                                                @"id": @(praiseId)                        }];
    [JAHTTPManager postRequest:kURL_bbs_updatePraise
                    Parameters:@{
                                 @"praisesRelation":dict
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAUpdatePraiseModel *model = [JAUpdatePraiseModel mj_objectWithKeyValues:data];
                           LogD(@"删除点赞成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"删除点赞失败:%@",errModel);
                           JAUpdatePraiseModel *model= [JAUpdatePraiseModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postUpdateCollection:(NSInteger)collectionId
                    detailId:(NSInteger)detailId
                   isDeleted:(BOOL)isDeleted
                      Result:(void (^)(JAResponseModel * _Nullable))retBlock
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"detailsId":@(detailId),
                                                                                @"id":@(collectionId),
                                                                                @"isDeleted":@(isDeleted)
                                                                                }];
    [JAHTTPManager postRequest:kURL_bbs_updateCollection
                    Parameters:@{
                                 @"collectionRelation":dict
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"编辑收藏帖子或活动请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"编辑收藏帖子或活动失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

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
{
    //必传参数
    NSMutableDictionary *detailDict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                    @"id": @(detailID),
                                                                    @"detailsName":detailsName,
                                                                    @"detailsLabels":[NSString stringWithFormat:@"#%@#", detailsLabels],
                                                                    @"detailsUserId":@(detailsUserId),
                                                                    @"detailsType":@(detailsType),
                                                                                      @"isDeleted":@(isDeleted),
                                                                    @"openStatus":@(1),
                                                                    
                                                                    @"runStatus":@(runStatus)
                                                                                      }];
    if (!kStringIsEmpty(detailText)) {
        [detailDict setValue:detailText forKey:@"detailsText"];
    }
    if (!kStringIsEmpty(imageAddresses)) {
        [detailDict setValue:imageAddresses forKey:@"imagesAddress"];
    }
    [JAHTTPManager postRequest:kURL_bbs_updateDetails
                    Parameters:@{
                                 @"detail":detailDict
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"编辑帖子或活动请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"编辑帖子或活动失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postUpdatePictures:(NSInteger)atlasId
                 isDeleted:(BOOL)isDeleted
                WithPicIds:(NSString *_Nonnull)pictureIds
                    Result:(void (^_Nonnull)(JAResponseModel * _Nullable model))retBlock {
    [JAHTTPManager postRequest:kURL_bbs_updatePics
                    Parameters:@{
                                 @"atlasId": @(atlasId),
                                 @"pictureIds":pictureIds,
                                 @"isDeleted":@(isDeleted)
                                 }
                       Success:^(NSData * _Nullable data) {
                           
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"删除图册中的图片请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"删除图册中的图片请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postUpdateTimeAxis:(NSInteger)timeAxisId
                    Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_updateTimeAxis
                    Parameters:@{
                                 @"timeAxis":@{
                                         @"id":@(timeAxisId)
                                         }
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"删除时光轴请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"删除时光轴请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postDeleteComment:(NSInteger)Id
                   Result:(void (^)(JAResponseModel * _Nullable))retBlock
{
    [JAHTTPManager postRequest:kURL_bbs_deleteComment
                    Parameters:@{
                                 @"id":@(Id)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"删除时光轴请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"删除时光轴请求失败:%@",errModel);
                           retBlock(errModel);
                       }];

}

+ (void)postTimeAxis:(NSInteger)timeAxisId
                    Result:(void (^)(JAResponseModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_bbs_updateTimeAxis
                    Parameters:@{
                                 @"timeAxis":@{
                                         @"id":@(timeAxisId)
                                         }
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAResponseModel *model = [JAResponseModel mj_objectWithKeyValues:data];
                           LogD(@"删除时光轴请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"删除时光轴请求失败:%@",errModel);
                           retBlock(errModel);
                       }];
}

+ (void)postFuzzySearchLabels:(NSString *)condition
                     IsPaging:(BOOL)isPaging
              WithCurrentPage:(NSInteger)currentPage
                    WithLimit:(NSInteger)limit
                       Result:(void (^)(JADiscRecLabelModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_search_fuzzySearchLabels
                    Parameters:@{
                                 @"condition":condition,
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JADiscRecLabelModel *model = [JADiscRecLabelModel mj_objectWithKeyValues:data];
                           LogD(@"获取搜索框标签推荐请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"获取搜索框标签推荐请求失败:%@",errModel);
                           JADiscRecLabelModel *model= [JADiscRecLabelModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

+ (void)postFuzzySearchDetials:(NSString *)condition
                 WithQueryType:(NSInteger)queryType
                      IsPaging:(BOOL)isPaging
               WithCurrentPage:(NSInteger)currentPage
                     WithLimit:(NSInteger)limit
                        Result:(void (^)(JADiscRecGroupModel * _Nullable))retBlock{
    [JAHTTPManager postRequest:kURL_search_fuzzySearchDetails
                    Parameters:@{
                                 @"condition":condition,
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit),
                                 @"queryType":@(queryType)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JADiscRecGroupModel *model = [JADiscRecGroupModel mj_objectWithKeyValues:data];
                           LogD(@"模糊搜索请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"模糊搜索框请求失败:%@",errModel);
                           JADiscRecGroupModel *model= [JADiscRecGroupModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}


+ (void)postqueryUserByNickName:(NSString *_Nonnull)nickName
                       IsPaging:(BOOL)isPaging
                WithCurrentPage:(NSInteger)currentPage
                      WithLimit:(NSInteger)limit
                         Result:(void (^_Nonnull)(JAUserListModel * _Nullable model))retBlock{
    [JAHTTPManager postRequest:kURL_userAccount_queryUserByNickName
                    Parameters:@{
                                 @"nickName":nickName,
                                 @"isPaging":@(isPaging),
                                 @"currentPage":@(currentPage),
                                 @"limit":@(limit)
                                 }
                       Success:^(NSData * _Nullable data) {
                           JAUserListModel *model = [JAUserListModel mj_objectWithKeyValues:data];
                           LogD(@"模糊搜索请求成功:%@",model);
                           retBlock(model);
                       }
                       Failure:^(JAResponseModel * _Nullable errModel) {
                           LogD(@"模糊搜索框请求失败:%@",errModel);
                           JAUserListModel *model= [JAUserListModel new];
                           model.responseStatus = errModel.responseStatus;
                           model.success = errModel.success;
                           model.exception = errModel.exception;
                           retBlock(model);
                       }];
}

@end
