//
//  JAAttentionsListModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/29.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"
#import "JAUserAccount.h"

@class JAAttentionData;

@interface JAAttentionsListModel : JAResponseModel

@property (nonatomic, strong) JAAttentionData *data;

@property (nonatomic, strong) NSArray<JAUserAccount *> *userList;

@end

@interface JAAttentionData : NSObject

@property (nonatomic, assign) NSInteger startRow;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger navigateLastPage;

@property (nonatomic, assign) NSInteger navigateFirstPage;

@property (nonatomic, assign) NSInteger endRow;

@property (nonatomic, assign) BOOL isFirstPage;

@property (nonatomic, assign) NSInteger prePage;

@property (nonatomic, assign) BOOL hasPreviousPage;

@property (nonatomic, assign) NSInteger firstPage;

@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger navigatePages;

@property (nonatomic, strong) NSArray<JAUserAccount *> *list;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) BOOL isLastPage;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, strong) NSArray<NSNumber *> *navigatepageNums;

@end

