//
//  SJAttributedHeaderView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/7.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJPhotoModel, SJBuildNoteModel;
@interface SJAttributedHeaderView : UIView

+ (instancetype)createCellWithXib;

- (void)insertPhotoModel:(SJPhotoModel *)photoModel;

@property (nonatomic, copy) void(^addBlock)(void);
@property (nonatomic, copy) void(^heightBlock)(CGFloat);
@property (nonatomic, strong) SJBuildNoteModel *noteModel;

@end
