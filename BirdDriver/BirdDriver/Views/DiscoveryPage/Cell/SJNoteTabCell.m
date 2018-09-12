//
//  SJNoteTabCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteTabCell.h"
#import "GBTagListView.h"
#import "SJBuildNoteModel.h"

@interface SJNoteTabCell ()

@property (weak, nonatomic) IBOutlet GBTagListView *tagView;

@end

@implementation SJNoteTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tagView.canTouch = YES;
    self.tagView.deleteHide = YES;
    self.tagView.signalTagColor = [UIColor whiteColor];
    self.tagView.didselectItemBlock = ^(NSArray *arr, NSInteger index) {
        
        for (JABbsLabelModel *tagModel in self.tabs) {
            NSInteger currentIndex = [self.tabs indexOfObject:tagModel];
            if (currentIndex == index) {
                tagModel.isSelected = !tagModel.isSelected;
            } else {
                tagModel.isSelected = NO;
            }
        }
        JABbsLabelModel *myTagModel = self.tabs[index];
//        myTagModel.isSelected = !myTagModel.isSelected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChoosedTag:)])
        {
            [self.delegate didChoosedTag:myTagModel];
        }
    };
}

/**
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isEqual:self.tagView] && [keyPath isEqualToString:@"frame"])
    {
        self.tagViewHeightCons.constant = self.tagView.height;
        if (self.heightBlock)
        {
            self.heightBlock(self.tagView.height+kSJMargin);
        }
    }
}
 */

#pragma mark - setter
- (void)setTabs:(NSMutableArray *)tabs
{
    _tabs = tabs;
    NSMutableArray *tabStrs = [NSMutableArray arrayWithCapacity:tabs.count];
    for (JABbsLabelModel *tagModel in tabs) {
        [tabStrs addObject:[tagModel.labelName stringByReplacingOccurrencesOfString:@"#" withString:@""]];
    }
    self.tagView.width = kScreenWidth;
    [self.tagView setTagWithTagArray:[tabStrs copy]];
}

@end
