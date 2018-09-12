//
//  JAAtlasListModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/6/4.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

typedef NS_ENUM(NSInteger, JAAtlasStatus){
    JAAtlasStatusOpen           = 1,    //完全开放
    JAAtlasStatusOnlyFriend     = 2,    //只对关注者开放
    JAAtlasStatusOnlyMyself     = 3,    //只对自己开放
};

@class JAAtlasModel;

@interface JAAtlasListModel : JAResponseModel

@property (nonatomic, strong) NSArray<JAAtlasModel *> *atlasList;

@end

typedef NS_ENUM(NSInteger, SJMyPictureShowType) {
    
    SJMyPictureShowTypeNormal, //正常展示
    SJMyPictureShowTypeEdit    //编辑模式
};

@interface JAAtlasModel : JAResponseModel

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *atlasName;

@property (nonatomic, assign) BOOL isDeleted;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) long long lastUpdateTime;

@property (nonatomic, assign) JAAtlasStatus atlasStatus;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, copy) NSString *coverImage;

@property (nonatomic, assign) NSInteger atlasUserId;

#pragma mark - 自定义属性
@property (nonatomic, assign) SJMyPictureShowType showType;
@property (nonatomic, assign, getter=selected) BOOL isSelected;

@end

