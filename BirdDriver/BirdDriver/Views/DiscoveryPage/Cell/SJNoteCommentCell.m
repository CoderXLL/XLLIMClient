//
//  SJNoteCommentCell.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/7/16.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJNoteCommentCell.h"
#import "JAPostCommentModel.h"

@interface SJNoteCommentCell ()

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *childCommentBtn;
@property (weak, nonatomic) IBOutlet UIView *childCoverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *childCoverHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *replyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyTextWidthCons;

@end

@implementation SJNoteCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headBtn.imageView.clipsToBounds = YES;
}

- (void)setCommentModel:(JAPostCommentItemModel *)commentModel
{
    _commentModel = commentModel;
    [self.headBtn sd_setImageWithURL:commentModel.photoSrc.mj_url
                            forState:UIControlStateNormal
                    placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    self.nameLabel.text = commentModel.nickName;
    self.dateLabel.text = [SPDateHandler getTimeLongStringFromTimestamp:commentModel.createTime];
    self.contentLabel.text = commentModel.content;
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
    if (!kStringIsEmpty(commentModel.commentVO.content)) {
        
        NSMutableAttributedString *replyAttr = [[NSMutableAttributedString alloc] initWithString:commentModel.commentVO.content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        [replyAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, commentModel.commentVO.content.length)];
        [replyAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"2B3248" alpha:1.0], NSFontAttributeName:SPBFont(12.0)} range:[commentModel.commentVO.content rangeOfString:[NSString stringWithFormat:@"@%@：", commentModel.commentVO.replyNickName]]];
        self.replyTextLabel.attributedText = replyAttr;
        self.replyTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    self.replyTextWidthCons.constant = self.childCoverView.width-10-5-15-self.replyNameLabel.width;
    
    [self.childCommentBtn setTitle:[NSString stringWithFormat:@"还有%zd条评论>", commentModel.childCommentNum-1] forState:UIControlStateNormal];
    if (kStringIsEmpty(commentModel.commentVO.replyNickName)) {
        self.replyNameLabel.text = [NSString stringWithFormat:@"%@:", commentModel.commentVO.nickName];
    } else {
        self.replyNameLabel.text = commentModel.commentVO.nickName;
    }
}

- (void)setFloorCount:(NSInteger)floorCount
{
    _floorCount = floorCount;
    self.descLabel.text = [NSString stringWithFormat:@"%zd楼", floorCount];
}

- (IBAction)moreBtnClick:(UIButton *)sender {
    
    CGRect tempRect = [sender convertRect:sender.bounds toView:[UIApplication sharedApplication].keyWindow];
    if (self.delegate && [self.delegate respondsToSelector:@selector(noteCommentModel:didClickReportBtn:)])
    {
        [self.delegate noteCommentModel:self.commentModel didClickReportBtn:tempRect.origin];
    }
}

- (IBAction)childCommentClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMoreReply:)])
    {
        [self.delegate didClickMoreReply:self.commentModel];
    }
}


- (IBAction)headBtnClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickUserHead:)])
    {
        [self.delegate didClickUserHead:self.commentModel];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
