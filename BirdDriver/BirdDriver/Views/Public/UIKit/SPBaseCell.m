//
//  SJBaseCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SPBaseCell.h"

@implementation SPBaseCell

//纯代码快速创建cell
+ (instancetype)cell:(UITableView *)tableView
{
    NSString *ID = NSStringFromClass(self.class);
    SPBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        [tableView registerClass:self forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}

//xib快速创建cell
+ (instancetype)xibCell:(UITableView *)tableView
{
    NSString *ID = NSStringFromClass(self.class);
    SPBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    return cell;
}

//快速创建空白cell
+ (instancetype)blankCell:(UITableView *)tableView
{
    static NSString *const ID = @"SPBlankCell";
    SPBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[SPBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"我是空白cell";
    return cell;
}

@end

