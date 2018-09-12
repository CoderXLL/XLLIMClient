//
//  SJBuildNoteModel.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseModel.h"
#import "JABbsLabelModel.h"

@interface SJBuildNoteModel : SPBaseModel

/**
 帖子标题
 */
@property (nonatomic, copy) NSString *note_title;

/**
 帖子内容
 */
@property (nonatomic, copy) NSString *note_content;

/**
 帖子内容
 */
@property (nonatomic, copy) NSAttributedString *note_attributedText;

/**
 图片模型, 可能是SJPhotoModel, 可能是url
 */
@property (nonatomic, strong) NSMutableArray *photos;

/**
 标签集合
 */
@property (nonatomic, strong) NSMutableArray <JABbsLabelModel *>*tags;
/**
 选择的标签
 */
@property (nonatomic, strong) JABbsLabelModel *selectedTagModel;

@property (nonatomic, assign) CGFloat attributedHeight;
@property (nonatomic, assign) CGFloat tagCellHeight;
@property (nonatomic, assign) BOOL isNeedReload;

@end
