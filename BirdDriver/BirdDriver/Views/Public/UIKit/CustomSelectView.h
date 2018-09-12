//
//  CustomSelectView.h
//  GoldChildren
//
//  Created by 宋明月 on 2017/9/27.
//  Copyright © 2017年 宋明月. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSelectView : UIView

typedef void(^customSelectViewClickBlock)(NSInteger tag);

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) UIImageView *imgV;
@property (nonatomic,retain) UILabel *titleLb;

@property (nonatomic,copy) void(^customSelectViewClickBlock)(NSInteger tag);

- (void) customSelectViewClick:(customSelectViewClickBlock)block;
@end
