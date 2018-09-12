//
//  SJRouteHeaderView.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteHeaderView.h"
#import "SJSuffingView.h"
#import "JARouteListModel.h"

@interface SJRouteHeaderView () <SJSuffingViewDelegate>

@property (weak, nonatomic) IBOutlet SJSuffingView *suffingView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation SJRouteHeaderView

+ (instancetype)createCellWithXib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SJRouteHeaderView" owner:nil options:nil] objectAtIndex:0];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.descLabel.layer.cornerRadius = 4.0;
    self.descLabel.clipsToBounds = YES;
    self.suffingView.delegate = self;
}

#pragma mark - setter
- (void)setItemModel:(JARouteListItemModel *)itemModel
{
    _itemModel = itemModel;
    self.suffingView.bannerList = itemModel.pictureUrl;
    if (kArrayIsEmpty(itemModel.pictureUrl)) {
        self.descLabel.text = @"0/0";
    } else {
        self.descLabel.text = [NSString stringWithFormat:@"1/%zd", itemModel.pictureUrl.count];
    }
}

#pragma mark - SJSuffingViewDelegate
- (void)suffingView:(SJSuffingView *)suffingView scrollToIndex:(NSInteger)index
{
    if ([suffingView isEqual:self.suffingView])
    {
        self.descLabel.text = [NSString stringWithFormat:@"%zd/%zd", index, suffingView.bannerList.count];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.suffingView.frame = self.bounds;
}

@end
