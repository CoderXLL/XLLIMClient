//
//  SJAttributesCell.h
//  BirdDriver
//
//  Created by liuzhangyong on 2018/7/13.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"
@class SJBuildNoteModel, SJPhotoModel;

@protocol SJAttributesCellDelegate <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)newHeight atIndexPath:(NSIndexPath *)indexPath;

@end

@interface SJAttributesCell : SPBaseCell

@property (nonatomic, strong) SJBuildNoteModel *buildNoteModel;
- (void)insertPhotoModel:(SJPhotoModel *)photoModel;
@property (nonatomic, copy) void(^addBlock)(void);
@property (nonatomic, copy) void(^reloadBlock)(void);

@property (nonatomic, weak) id <SJAttributesCellDelegate> delegate;

@end
