//
//  SJBuildNoteModel.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/28.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBuildNoteModel.h"
#import "GBTagListView.h"

@implementation SJBuildNoteModel

- (instancetype)init
{
    if (self = [super init])
    {
        self.tags = [NSMutableArray array];
        self.photos = [NSMutableArray array];
    }
    return self;
}

- (CGFloat)attributedHeight
{
    if (_attributedHeight < 257.0) {
        
        return 257.0;
    }
    return _attributedHeight;
}

- (CGFloat)tagCellHeight
{
    NSMutableArray *tagArr = [NSMutableArray arrayWithCapacity:self.tags.count];
    for (JABbsLabelModel *labelModel in self.tags) {
        [tagArr addObject:labelModel.labelName];
    }
    CGFloat totalHeight = [GBTagListView calculateTagHeight:tagArr cellWidth:kScreenWidth];
    return totalHeight+10;
}

@end
