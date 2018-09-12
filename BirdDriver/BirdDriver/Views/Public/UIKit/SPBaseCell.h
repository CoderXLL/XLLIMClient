//
//  SJBaseCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//  cell唯一基类

#import <UIKit/UIKit.h>

@interface SPBaseCell : UITableViewCell

/**
 纯代码快速创建cell
 
 @param tableView cell所属tableView容器
 @return cell实例
 */
+ (instancetype)cell:(UITableView *)tableView;

/**
 xib快速创建cell
 
 @param tableView cell所属tableView容器
 @return cell实例
 */
+ (instancetype)xibCell:(UITableView *)tableView;

/**
 快速创建一个空白cell

 @param tableView cell所属tableView容器
 @return cell实例
 */
+ (instancetype)blankCell:(UITableView *)tableView;

@end

