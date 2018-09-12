//
//  JAConfigModel.h
//  BirdDriverAPI
//
//  Created by Soul on 2018/5/28.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "JAResponseModel.h"

@class JAAppConfig;


@interface JAConfigModel : JAResponseModel

@property (nonatomic, strong) JAAppConfig *appConfig;

@end

@interface JAAppConfig : NSObject

@property (nonatomic, copy) NSString *config;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *targetId;

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *note;

@property (nonatomic, assign) long long lastUpdateTime;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) long long createTime;

@end

@interface JAConfigUrlModel : NSObject

/**
 样例
 */
@property (nonatomic, copy) NSString *xxxxxUrl;

@property (nonatomic, copy) NSString *Protocols;

@property (nonatomic, copy) NSString *appStoreURL;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *Contract;

@property (nonatomic, copy) NSString *InvitUrl;

@property (nonatomic, copy) NSString *HomeSecurityUrl;

@property (nonatomic, copy) NSString *BidsUrl;

@property (nonatomic, copy) NSString *MessageDetail;

@property (nonatomic, copy) NSString *NewGift;

@property (nonatomic, copy) NSString *BidPurchaseRecord;

@property (nonatomic, assign) NSInteger ProjectTablesHidde;

@property (nonatomic, copy) NSString *ProjectInfo;

@property (nonatomic, copy) NSString *EncouragementRule;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *BidSecurityUrl;

@property (nonatomic, copy) NSString *details;

@property (nonatomic, assign) NSInteger isForceUp;

@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *AboutUs;

@property (nonatomic, copy) NSString *BuySuccess;

@property (nonatomic, assign) NSInteger InvestDetailViewHidden;

@property (nonatomic, copy) NSString *schemlURL;

@property (nonatomic, copy) NSString *ProjectImg;

@end

