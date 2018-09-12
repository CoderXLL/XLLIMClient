//
//  LLSearchView.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import "LLSearchView.h"

@interface LLSearchView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UIView *searchHistoryView;
@property (nonatomic, strong) UIView *hotSearchView;

@end
@implementation LLSearchView

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr
{
    if (self = [super initWithFrame:frame]) {
        self.historyArray = historyArr;
        self.hotArray = hotArr;
        [self addSubview:self.searchHistoryView];
        [self addSubview:self.hotSearchView];
    }
    return self;
}

- (UIView *)hotSearchView {
    if (!_hotSearchView) {
        self.hotSearchView = [self setViewWithOriginY:CGRectGetHeight(_searchHistoryView.frame) title:@"热门搜索" textArr:self.hotArray];
    }
    return _hotSearchView;
}


- (UIView *)searchHistoryView {
    if (!_searchHistoryView) {
        if (_historyArray.count > 0) {
            self.searchHistoryView = [self setViewWithOriginY:0 title:@"最近搜索" textArr:self.historyArray];
        } else {
            self.searchHistoryView = [self setNoHistoryView];
        }
    }
    return _searchHistoryView;
}



- (UIView *)setViewWithOriginY:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr {
    UIView *view = [[UIView alloc] init];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 30 - 45, 30)];
    titleL.text = title;
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
    
    if ([title isEqualToString:@"最近搜索"]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth - 45, 10, 28, 30);
        [btn setImage:[UIImage imageNamed:@"search_delete"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    CGFloat y = 10 + 40;
    CGFloat letfWidth = 15;
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = textArr[i];
        CGFloat width = [self getWidthWithStr:text] + 30;
        if (letfWidth + width + 15 > kScreenWidth) {
            if (y >= 130 && [title isEqualToString:@"最近搜索"]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += 40;
            letfWidth = 15;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, 30)];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:12];
        label.text = text;
        label.layer.borderWidth = 0.5;
        label.layer.cornerRadius = 15;
        label.textAlignment = NSTextAlignmentCenter;
        if (i % 2 == 0 && [title isEqualToString:@"热门搜索"]) {
            label.layer.borderColor = HEXCOLOR(@"CCCCCC").CGColor;
            label.textColor = SJ_TITLE_COLOR;
        } else {
            label.textColor = SJ_TITLE_COLOR;
            label.layer.borderColor = HEXCOLOR(@"CCCCCC").CGColor;
        }
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [view addSubview:label];
        letfWidth += width + 10;
    }
    view.frame = CGRectMake(0, riginY, kScreenWidth, y + 40);
    return view;
}


- (UIView *)setNoHistoryView {
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 30, 30)];
    titleL.text = @"最近搜索";
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleL.frame) + 10, 100, 20)];
    notextL.text = @"无搜索历史";
    notextL.font = [UIFont systemFontOfSize:12];
    notextL.textColor = [UIColor blackColor];
    notextL.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:titleL];
    [historyView addSubview:notextL];
    return historyView;
}

- (void)tagDidCLick:(UITapGestureRecognizer *)tap {
    UILabel *label = (UILabel *)tap.view;
    if (self.tapAction) {
        self.tapAction(label.text);
    }
}

- (CGFloat)getWidthWithStr:(NSString *)text {
    CGFloat width = [text boundingRectWithSize:CGSizeMake(kScreenWidth, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}


- (void)clearnSearchHistory:(UIButton *)sender {
    __weak LLSearchView *weakSelf = self;
    SJAlertModel *alertModel = [[SJAlertModel alloc] initWithTitle:@"确认"  handler:^(id content) {
        [self.searchHistoryView removeFromSuperview];
        self.searchHistoryView = [self setNoHistoryView];
        [weakSelf.historyArray removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.historyArray forKey:@"HistorySearch"];
        [self addSubview:weakSelf.searchHistoryView];
        CGRect frame = weakSelf.hotSearchView.frame;
        frame.origin.y = CGRectGetHeight(weakSelf.searchHistoryView.frame);
        weakSelf.hotSearchView.frame = frame;
    }];
    SJAlertModel *cancelModel = [[SJAlertModel alloc] initWithTitle:@"取消" handler:^(id content) {
    }];
    SJAlertView *alertView = [SJAlertView alertWithTitle:@"是否确认清除历史搜索记录?" message:@"" type:SJAlertShowTypeNormal alertModels:@[alertModel,cancelModel]];
    [alertView showAlertView];
}

- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index {
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    [[NSUserDefaults standardUserDefaults] setObject:testArr forKey:@"HistorySearch"];
}



@end
