//
//  SJSystemMessageListModel.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/23.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"


@class JAPageInfo;
@class JASystemModel;

@interface SJSystemMessageListModel : JAResponseModel

@property (nonatomic, strong) JAPageInfo *data;

@end


@interface JAPageInfo : NSObject


@property (nonatomic, assign) NSInteger endRow;

@property (nonatomic, assign) NSInteger firstPage;

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, assign) BOOL hasPreviousPage;

@property (nonatomic, assign) BOOL isFirstPage;

@property (nonatomic, assign) BOOL isLastPage;

@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, strong) NSArray<JASystemModel *> *list;

@property (nonatomic, assign) NSInteger navigateFirstPage;

@property (nonatomic, assign) NSInteger navigateLastPage;

@property (nonatomic, assign) NSInteger navigatePages;

@property (nonatomic, strong) NSArray<NSNumber *> *navigatepageNums;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger prePage;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger startRow;

@property (nonatomic, assign) NSInteger total;


@end


@interface JASystemModel : SPBaseModel

@property(nonatomic,copy)NSString *createTime;//创建时间
@property (nonatomic, copy) NSString * h5Link;//H5链接
@property (nonatomic, assign) NSInteger ID;//编号
@property (nonatomic, copy) NSString * imagesAddress;//图片
@property (nonatomic, assign) BOOL isDeleted;//是否删除
@property (nonatomic, assign) BOOL isRead;//是否已读
@property (nonatomic, copy) NSString * lastUpdateTime;//更新时间
@property (nonatomic, copy) NSString * messageContent;//消息内容
@property (nonatomic, copy) NSString * messageTitle;//消息标题
@property (nonatomic, assign) NSInteger messageType;//消息类型 1纯文字 2链接图文
@property (nonatomic, copy) NSString * messageValidTime;//消息有效时间

- (instancetype)initWithMessageId:(NSInteger)MessageId
                       createTime:(NSString *)createTime
                           h5Link:(NSString *)h5Link
                    imagesAddress:(NSString *)imagesAddress
                        isDeleted:(NSString *)isDeleted
                           isRead:(NSString *)isRead
                   lastUpdateTime:(NSString *)lastUpdateTime
                   messageContent:(NSString *)messageContent
                     messageTitle:(NSString *)messageTitle
                      messageType:(NSInteger)messageType
                 messageValidTime:(NSString *)messageValidTime;

@end

