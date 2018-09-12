//
//  SJNoteReplyCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/9.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteReplyCell.h"
#import "JAPostCommentModel.h"

@interface SJNoteReplyCell ()

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *childCommentBtn;
@property (weak, nonatomic) IBOutlet UIView *childCoverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *childCoverHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *replyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyTextWidthCons;

@end

@implementation SJNoteReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headBtn.imageView.clipsToBounds = YES;
}

- (void)setModel:(id)model
{
    _model = model;
    if ([model isKindOfClass:[JACommentVOModel class]]) {
        
        JACommentVOModel *detailModel = (JACommentVOModel *)model;
        [self setDetailModel:detailModel];
    } else {
        
        JAPostCommentItemModel *commentModel = (JAPostCommentItemModel *)model;
        [self setCommentModel:commentModel];
    }
}

- (void)setDetailModel:(JACommentVOModel *)detailModel
{
    self.headBtn.layer.borderWidth = 2.0;
    if (detailModel.sex == 1) {  //男
        
        self.headBtn.layer.borderColor = [UIColor colorWithHexString:@"6EEBEE" alpha:1].CGColor;
    } else { //女
        self.headBtn.layer.borderColor = [UIColor colorWithHexString:@"F9739B" alpha:1].CGColor;
    }
    [self.headBtn sd_setImageWithURL:detailModel.photoSrc.mj_url
                            forState:UIControlStateNormal
                    placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nameLabel.text = detailModel.nickName;
    self.dateLabel.text = [SPDateHandler getTimeLongStringFromTimestamp:detailModel.createTime];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    if (!kStringIsEmpty(detailModel.content)) {
        NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithString:detailModel.content];
        [contentAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailModel.content.length)];
        [contentAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"2B3248" alpha:1.0], NSFontAttributeName:SPBFont(14.0)} range:[detailModel.content rangeOfString:[NSString stringWithFormat:@"@%@：", detailModel.nickName]]];
        self.contentLabel.attributedText = contentAttr;
    }
    self.childCoverView.hidden = YES;
    self.childCoverHeightCons.constant = 0;
}

- (void)setCommentModel:(JAPostCommentItemModel *)commentModel
{
    [self.headBtn sd_setImageWithURL:commentModel.photoSrc.mj_url
                            forState:UIControlStateNormal
                    placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nameLabel.text = commentModel.nickName;
    self.dateLabel.text = [SPDateHandler getTimeLongStringFromTimestamp:commentModel.createTime];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    if (!kStringIsEmpty(commentModel.content)) {
        NSMutableAttributedString *contentAttr = [[NSMutableAttributedString alloc] initWithString:commentModel.content];
        [contentAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentModel.content.length)];
        [contentAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"2B3248" alpha:1.0], NSFontAttributeName:SPBFont(14.0)} range:[commentModel.content rangeOfString:[NSString stringWithFormat:@"@%@：", commentModel.nickName]]];
        self.contentLabel.attributedText = contentAttr;
    }
    
    if (commentModel.childCommentNum>=1) {
        self.childCoverView.hidden = NO;
    } else {
        self.childCoverView.hidden = YES;
    }
    //如果子评论只有一条，“还有xx条评论”按钮也需要隐藏
    if (commentModel.childCommentNum>1) {
        self.childCommentBtn.hidden = NO;
    } else {
        self.childCommentBtn.hidden = YES;
    }
    //不同情形设置灰色区域高度约束
    if (self.childCoverView.hidden) {
        self.childCoverHeightCons.constant = 0;
    } else if (!self.childCoverView.hidden && self.childCommentBtn.hidden) {
        self.childCoverHeightCons.constant = 35;
    } else if (!self.childCoverView.hidden && !self.childCoverView.hidden) {
        self.childCoverHeightCons.constant = 65.0;
    }
    [self.childCommentBtn setTitle:[NSString stringWithFormat:@"还有%zd条评论>", commentModel.childCommentNum-1] forState:UIControlStateNormal];
    
    if (!kStringIsEmpty(commentModel.commentVO.content)) {
        NSMutableAttributedString *replyAttr = [[NSMutableAttributedString alloc] initWithString:commentModel.commentVO.content];
        [replyAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentModel.commentVO.content.length)];
        [replyAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"2B3248" alpha:1.0], NSFontAttributeName:SPBFont(12.0)} range:[commentModel.commentVO.content rangeOfString:[NSString stringWithFormat:@"@%@：", commentModel.commentVO.replyNickName]]];
        self.replyTextLabel.attributedText = replyAttr;
        self.replyTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.replyTextWidthCons.constant = self.childCoverView.width-10-5-15-self.replyNameLabel.width;
    
    if (kStringIsEmpty(commentModel.commentVO.replyNickName)) {
        self.replyNameLabel.text = [NSString stringWithFormat:@"%@:", commentModel.commentVO.nickName];
    } else {
        self.replyNameLabel.text = commentModel.commentVO.nickName;
    }
}

- (void)setIsChildComment:(BOOL)isChildComment
{
    _isChildComment = isChildComment;
    self.contentView.backgroundColor = isChildComment?[UIColor colorWithHexString:@"F8F8F8" alpha:1]:[UIColor whiteColor];
}

#pragma mark - event
- (IBAction)childCommentClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMoreReply:)])
    {
        [self.delegate didClickMoreReply:self.model];
    }
}


- (IBAction)headBtnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickUserHead:)])
    {
        [self.delegate didClickUserHead:self.model];
    }
}

- (IBAction)replyBtnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickReply:)])
    {
        [self.delegate didClickReply:self.model];
    }
}

@end
