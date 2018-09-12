//
//  SJChoosePhotoCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
@class SJChoosePhotoCell;

typedef NS_ENUM(NSInteger, SJChoosePhotoCellStyle) {
    
    SJChoosePhotoCellStyleChoose = 1000, //选择
    SJChoosePhotoCellStyleRemove         //移除
};

@protocol SJChoosePhotoCellDelegate <NSObject>

- (void)cell:(SJChoosePhotoCell *)cell actionStyle:(SJChoosePhotoCellStyle)style;

@end

@interface SJChoosePhotoCell : SPBaseCell

@property (nonatomic, weak) id <SJChoosePhotoCellDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *photos;

@end
