//
//  SJRouteListCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/20.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJRouteListCell.h"
#import "SJOverlayHeadView.h"
#import "SJSuffingView.h"
#import "JARouteListModel.h"

@interface SJRouteListCell () <SJSuffingViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidthCons;
@property (weak, nonatomic) IBOutlet SJOverlayHeadView *overlayHeadView;
@property (weak, nonatomic) IBOutlet SJSuffingView *suffingView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *seenLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestLabel;

@end

@implementation SJRouteListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    __weak typeof(self)weakSelf = self;
    self.overlayHeadView.clickBlock = ^(JAUserAccountPosList *posModel) {
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(routeListCell:didClickPosModel:)])
        {
            [weakSelf.delegate routeListCell:self didClickPosModel:posModel];
        }
    };
    
    self.tagLabel.layer.cornerRadius = 4.0;
    self.tagLabel.clipsToBounds = YES;
    
    self.suffingView.isRadius = YES;
    self.suffingView.delegate = self;
}

#pragma mark - setter
- (void)setItemModel:(JARouteListItemModel *)itemModel
{
    _itemModel = itemModel;
    self.suffingView.bannerList = itemModel.pictureUrl;
    if (kArrayIsEmpty(itemModel.pictureUrl)) {
        
        self.tagLabel.text = @"0/0";
    } else {
        self.tagLabel.text = [NSString stringWithFormat:@"%zd/%zd", itemModel.currentIndex>=1?itemModel.currentIndex:1, itemModel.pictureUrl.count];
    }
    self.nameLabel.text = itemModel.title;
    if (itemModel.pageviews < 10000) {
        self.seenLabel.text = [NSString stringWithFormat:@"%zd", itemModel.pageviews];
    } else {
        CGFloat pageNum = itemModel.pageviews*1.0/10000;
        self.seenLabel.text = [NSString stringWithFormat:@"%.1fW", pageNum];
    }
    
    NSString *interestStr = [NSString stringWithFormat:@"%zd人感兴趣", itemModel.collection];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:interestStr];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"888888" alpha:1]}
                  range:[interestStr rangeOfString:@"人感兴趣"]];
    self.interestLabel.attributedText = attr;
    self.overlayHeadView.accountList = itemModel.collectionUserList;
    self.overlayHeadView.hidden = kArrayIsEmpty(itemModel.collectionUserList);
    if (!kArrayIsEmpty(itemModel.collectionUserList)) {
        self.headViewWidthCons.constant = (itemModel.collectionUserList.count)*25+(itemModel.collectionUserList.count-1)*5;
    } else {
        self.headViewWidthCons.constant = -25;
    }
}

#pragma mark - SJSuffingViewDelegate
- (void)suffingView:(SJSuffingView *)suffingView scrollToIndex:(NSInteger)index
{
    if ([suffingView isEqual:self.suffingView])
    {
        self.itemModel.currentIndex = index;
        self.tagLabel.text = [NSString stringWithFormat:@"%zd/%zd", index, suffingView.bannerList.count];
    }
}

- (void)suffingView:(SJSuffingView *)suffingView didSelectedIndex:(NSInteger)selectedIndex
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}


@end
