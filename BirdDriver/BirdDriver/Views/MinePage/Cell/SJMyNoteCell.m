//
//  SJMyNoteCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/21.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMyNoteCell.h"
#import "JAActivityListModel.h"

@interface SJMyNoteCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *seenLabel;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationWidthCons;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *examineView;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;
@property (weak, nonatomic) IBOutlet UIImageView *seenView;

@end

@implementation SJMyNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.locationLabel.layer.cornerRadius = self.locationLabel.height*0.5;
    self.locationLabel.layer.borderColor = [UIColor colorWithHexString:@"CCCCCC" alpha:1].CGColor;
    self.locationLabel.layer.borderWidth = 1.0;
    self.locationLabel.clipsToBounds = YES;
    
    self.headView.layer.cornerRadius = 8.5;
    self.headView.layer.masksToBounds = YES;
    
    self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.editLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureClick:)];
    longGesture.minimumPressDuration = 1.0;
    [self.contentView addGestureRecognizer:longGesture];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - event
- (void)longGestureClick:(UILongPressGestureRecognizer *)longGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLongPressed:)])
    {
        [self.delegate didLongPressed:self];
    }
}

- (void)setIsMineNote:(BOOL)isMineNote
{
    _isMineNote = isMineNote;
    self.headView.hidden = isMineNote;
    self.nameLabel.hidden = isMineNote;
    self.timeLabel.hidden = !isMineNote;
}

- (void)setPostsModel:(JAPostsModel *)postsModel
{
    _postsModel = postsModel;
    self.coverView.hidden = (postsModel.runStatus != JAPostsRunStatusDraft);
    self.examineView.hidden = YES;
    if (postsModel.runStatus == JAPostsRunStatusAuditing || postsModel.runStatus == JAPostsRunStatusAuditFailed) {
        self.examineView.hidden = NO;
        self.collectionLabel.hidden = YES;
        self.seenLabel.hidden = YES;
        self.collectionImage.hidden = YES;
        self.seenView.hidden = YES;
        if (postsModel.runStatus == JAPostsRunStatusAuditing) {
            [self.examineView setImage:[UIImage imageNamed:@"examine"]];
        } else {
            [self.examineView setImage:[UIImage imageNamed:@"examineFailed"]];
        }
    }
    
    [self.iconView sd_setImageWithURL:postsModel.imagesAddressList.firstObject.mj_url placeholderImage:[UIImage imageNamed:@"default_picture"]];
    self.titleLabel.text = postsModel.detailsName;
    self.locationLabel.text = postsModel.detailsLabels;
    
    CGFloat locationWidth = [postsModel.detailsLabels boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SPFont(10.0)} context:nil].size.width;
    self.locationWidthCons.constant = locationWidth+10;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(postsModel.createTime/1000.0)];
    self.timeLabel.text = [dateFormatter stringFromDate:date];
    self.collectionLabel.text = [NSString stringWithFormat:@"%zd", postsModel.collections];
    self.seenLabel.text = [NSString stringWithFormat:@"%zd", postsModel.pageviews];
    [self.headView sd_setImageWithURL:postsModel.photoSrc.mj_url placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nameLabel.text = postsModel.nickName;
}


@end
