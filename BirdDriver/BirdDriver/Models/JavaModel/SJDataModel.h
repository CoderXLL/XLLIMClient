//
//  SJDataModel.h
//  BirdDriver
//
//  Created by 宋明月 on 2018/6/14.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JAData;
@class JADataM;

@interface SJDataModel : JAResponseModel

@property (nonatomic, strong) JAData *data;

@end



@interface JAData : NSObject


@property (nonatomic, assign) NSInteger endRow;

@property (nonatomic, assign) NSInteger firstPage;

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, assign) BOOL hasPreviousPage;

@property (nonatomic, assign) BOOL isFirstPage;

@property (nonatomic, assign) BOOL isLastPage;

@property (nonatomic, assign) NSInteger lastPage;

@property (nonatomic, strong) NSArray<JADataM *> *list;

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


@interface JADataM : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, assign) long long lastUpdateTime;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *dictionaryTypeName;

@property (nonatomic, copy) NSString *dictionaryTypeId;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign) BOOL isSelected;





@end
