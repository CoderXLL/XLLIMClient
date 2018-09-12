//
//  SJSelectLabelRow.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/29.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJSelectLabelRow.h"
#import "JAHomeRecGroupModel.h"
#import "JAActivityListModel.h"
#import "SJSelectMainView.h"

 

@interface SJSelectLabelRow()

@property (weak, nonatomic) IBOutlet SJSelectMainView *mainView;

@end

@implementation SJSelectLabelRow

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickNotification:)
                                                 name:kNotify_homeNoteDetail
                                               object:nil];
}

- (void)clickNotification:(NSNotification *)notification
{
    JAActivityModel *activityModel = notification.object;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedRowWithActivityModel:)])
    {
        [self.delegate didSelectedRowWithActivityModel:activityModel];
    }
}

- (void)setRecommendDetailsPOList:(NSArray<JARecommendDetailSpolistModel *> *)recommendDetailsPOList
{
    _recommendDetailsPOList = recommendDetailsPOList;
    self.mainView.recommendDetailsPOList = recommendDetailsPOList;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
