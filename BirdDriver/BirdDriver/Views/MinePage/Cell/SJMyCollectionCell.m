//
//  SJMyCollectionCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMyCollectionCell.h"
#import "JAActivityListModel.h"
#import "SJStarView.h"

@interface SJMyCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet SJStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *collectionIcon;

@end

@implementation SJMyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureClick:)];
    longGesture.minimumPressDuration = 1.0;
    [self.contentView addGestureRecognizer:longGesture];
}

#pragma mark - EVENT
- (void)longGestureClick:(UILongPressGestureRecognizer *)longGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLongPressed:)])
    {
        [self.delegate didLongPressed:self];
    }
}

- (void)setActivityModel:(JAActivityModel *)activityModel
{
    _activityModel = activityModel;
    [self.iconView sd_setImageWithURL:activityModel.imagesAddressList.firstObject.mj_url placeholderImage:[UIImage imageNamed:@"default_picture"]];
    self.titleLabel.text = activityModel.detailsName;
    self.descLabel.text = activityModel.isMyCollection?activityModel.describtion:[NSString stringWithFormat:@"%zd 点评", activityModel.comments];
    self.pointLabel.text = [NSString stringWithFormat:@"%.1f", kObjectIsEmpty(activityModel.average)?0:activityModel.average.floatValue];
    self.starView.value = activityModel.average.floatValue;
    self.collectionLabel.text = [NSString stringWithFormat:@"%zd", activityModel.collections];
    self.collectionLabel.hidden = activityModel.isMyCollection;
    self.collectionIcon.hidden = activityModel.isMyCollection;
}

@end
