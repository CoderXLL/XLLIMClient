//
//  SJDetailNoteView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/8.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JABBSModel;

@protocol SJDetailNoteViewDelegate <NSObject>

- (void)didClickImageUrl:(NSString *)imageStr AllImageArr:(NSArray *)imageArr;

@end


@interface SJDetailNoteView : UIView

+ (instancetype)createCellWithXib;

@property (nonatomic, copy) void(^heightBlock)(CGFloat);
//点击头像
@property (nonatomic, copy) void(^userDetailBlock)(JABBSModel *);
@property (nonatomic, weak) id <SJDetailNoteViewDelegate> delegate;
@property (nonatomic, strong) JABBSModel *detailModel;

@end
