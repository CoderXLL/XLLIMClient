//
//  JAUserListModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/6/5.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"
#import "JAUserAccount.h"

@class JAUserListData;

@interface JAUserListModel : JAResponseModel

@property (nonatomic, strong) JAUserListData *data;

@end

@interface JAUserListData : NSObject

@property (nonatomic, assign) NSInteger startRow;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger navigateLastPage;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger navigateFirstPage;

@property (nonatomic, assign) NSInteger endRow;

@property (nonatomic, assign) BOOL hasPreviousPage;

@property (nonatomic, assign) NSInteger firstPage;

@property (nonatomic, assign) BOOL isFirstPage;

@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, assign) NSInteger prePage;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger navigatePages;

@property (nonatomic, strong) NSArray<JAUserAccount *> *list;

@property (nonatomic, assign) BOOL isLastPage;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, strong) NSArray<NSNumber *> *navigatepageNums;

@end




