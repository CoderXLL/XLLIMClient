//
//  SJNoteInputCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"

@class  SJBuildNoteModel;

@interface SJNoteInputCell : SPBaseCell

@property (nonatomic, copy) void(^reloadBlock)(void);
@property (nonatomic, strong) SJBuildNoteModel *noteModel;

@property (weak, nonatomic) IBOutlet UITextView *inputView;

@end
