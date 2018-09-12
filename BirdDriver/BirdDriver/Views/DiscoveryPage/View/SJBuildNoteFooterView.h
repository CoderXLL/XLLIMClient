//
//  SJBuildNoteFooterView.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SJBuildNoteFooterViewDelegate <NSObject>

- (void)didClickFooterBtn;

@end

@interface SJBuildNoteFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<SJBuildNoteFooterViewDelegate> delegate;
@property (nonatomic, copy) NSString *titleStr;

@end
