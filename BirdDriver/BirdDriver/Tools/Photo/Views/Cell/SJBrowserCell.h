//
//  SJBrowserCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SJBrowserCell;

@protocol SJBrowserCellDelegate <NSObject>

- (void)didDeleteBrowserCell:(SJBrowserCell *)cell;

@end

@interface SJBrowserCell : UICollectionViewCell

@property (nonatomic, strong) id model;
@property (nonatomic, assign) CGFloat zoomScale;

@property (nonatomic, weak) id <SJBrowserCellDelegate>delegate;

@end
