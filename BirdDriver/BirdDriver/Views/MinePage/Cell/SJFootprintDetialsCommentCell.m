//
//  SJFootprintDetialsCommentCell.m
//  BirdDriver
//
//  Created by Soul on 2018/7/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJFootprintDetialsCommentCell.h"
#import "NSString+XHLStringSize.h"

#import "JABbsPresenter.h"

@interface SJFootprintDetialsCommentCell ()

@property (weak, nonatomic) IBOutlet UIButton *headView;

@end

@implementation SJFootprintDetialsCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headView.imageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentModel:(JACommentModel *)commentModel{
    _commentModel = commentModel;
    
    //头像
    if (commentModel.photoSrc) {
        NSString *photoUrl = commentModel.photoSrc;
        if ([[photoUrl substringToIndex:1]isEqualToString:@"/"]) {
            photoUrl = [JA_SERVER_WEB stringByAppendingString:photoUrl];
        }
        [self.img_authHead sd_setImageWithURL:[NSURL URLWithString:photoUrl]
                             placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    }else{
        [self.img_authHead setImage:[UIImage imageNamed:@"default_portrait"]];
    }
    
    //昵称
    if (commentModel.nickName) {
        [self.btn_authName setTitle:commentModel.nickName forState:UIControlStateNormal];
    }
    
    //内容
      NSString *commentStr = @"";
    if (commentModel.commentText) {
        commentStr = commentModel.commentText;
    }
//    if (commentModel.replyNickName.length > 0) {
//        commentStr = [NSString stringWithFormat:@"回复@%@: %@",commentModel.replyNickName, commentModel.commentText];
//    }
    
    //评论内容高度
    [self.tv_commentDes setText:commentStr];
    CGSize concentSize = [commentStr xhl_stringSizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]
                                                   maxWidth:(kScreenWidth - 32)];
    self.contentHeight.constant = concentSize.height;
    
    //时间
    if (commentModel.createTime) {
        NSString *time = [SPDateHandler getTimeLongStringFromTimestamp:commentModel.createTime];
        [self.lbl_creatTime setText:time];
    }else{
        [self.lbl_creatTime setText:@"未知"];
    }
    
    //点赞数
    if (commentModel.praises) {
        NSString *praise = [NSString stringWithFormat:@" %ld ",commentModel.praises];
        [self.btn_like setTitle:praise forState:UIControlStateNormal];
    }else{
        [self.btn_like setTitle:@" 0 " forState:UIControlStateNormal];
    }
    
    //是否已经点赞
    if (commentModel.praiseId == 0) {
        [self.btn_like setImage:[[UIImage imageNamed:@"discovery_like_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                       forState:UIControlStateNormal];
        [self.btn_like setSelected:NO];
    }else{
        [self.btn_like setImage:[[UIImage imageNamed:@"discovery_like_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                       forState:UIControlStateSelected];
        [self.btn_like setSelected:YES];
    }
    
    //图片集
//    NSArray *imgArr = [commentModel.imagesAddressList componentsSeparatedByString:@","];
    [self configureImageBox:commentModel.imagesAddressList];
    
    //评分
    if (commentModel.score) {
        self.lbl_score.text = [NSString stringWithFormat:@"%1.1f分",commentModel.score];
        [self refreashScore:commentModel.score];
    }else{
        self.lbl_score.text = @"0.0分";
        [self refreashScore:0.0f];
    }
    
    //回复评论
    if (commentModel.sonComments== 0) {
        self.returnView.hidden = YES;
        self.returnMoreBtn.hidden = YES;
        self.returnViewheight.constant = 0;
    } else {
        self.returnView.hidden = NO;
        self.returnMoreBtn.hidden = NO;
        [self.returnMoreBtn setTitle:[NSString stringWithFormat:@"还有%ld条评论>",commentModel.sonComments] forState:UIControlStateNormal];
    }
    [self.ReturnContentBtn addTarget:self action:@selector(openMoreCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.returnMoreBtn addTarget:self action:@selector(openMoreCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (commentModel.childComment) {
        
        //回复内容
         NSString *returnCommentStr = @"";
        if (commentModel.childComment.commentText) {
            returnCommentStr = [NSString stringWithFormat:@"%@: %@", commentModel.childComment.nickName,commentModel.childComment.commentText] ;
        }
        
        //回复评论内容
        [self.returnContent setText:returnCommentStr];
        CGSize concentSize = [returnCommentStr xhl_stringSizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]
                                                       maxWidth:(kScreenWidth - 32)];
        self.returnContentHeight.constant = concentSize.height;
        
        //回复图片
        [self showImage:commentModel.childComment.imagesAddressList];
        
        [self.returnImage_1 addTarget:self action:@selector(openReutrnImage:) forControlEvents:UIControlEventTouchUpInside];
       [self.returnImage_2 addTarget:self action:@selector(openReutrnImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.returnImage_3 addTarget:self action:@selector(openReutrnImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.returnImage_4 addTarget:self action:@selector(openReutrnImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.returnImage_5 addTarget:self action:@selector(openReutrnImage:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.imageboxHegiht.constant > 0) {
            self.returnViewTop.constant = 80;
        } else {
            self.returnViewTop.constant = 20;
        }
        self.returnViewheight.constant = self.returnContentHeight.constant + self.returnImageHeight.constant + 50;
    }
}

- (void)refreashScore:(float)score{
    NSArray *starArr = @[
                         self.img_star_1,
                         self.img_star_2,
                         self.img_star_3,
                         self.img_star_4,
                         self.img_star_5
                         ];
    
    for (UIImageView *imgV in starArr) {
//        LogD(@"第%ld颗星星",imgV.tag);
        if (imgV.tag <= score/2) {
            //亮星
            [imgV setImage:[UIImage imageNamed:@"review_starSel"]];
//            LogD(@"亮🌟");/
        }else if (imgV.tag>=(score/2+0.5) && imgV.tag<(score/2+1)){
            //半星
            [imgV setImage:[UIImage imageNamed:@"review_starHalf"]];
//             LogD(@"半🌟");
        }else{
            //暗星
            [imgV setImage:[UIImage imageNamed:@"review_starNor"]];
//             LogD(@"灭🌟");/
        }
    }
}


- (void)configureImageBox:(NSArray *)imgArr{
    //自适应高度
    CGFloat imgBoxH = 0;
    if (imgArr&&imgArr.count) {
        imgBoxH = (kScreenWidth-30-40)/(4+25.0/66);
        //box高度 = img高度 =（屏款-间隔）÷个数
        [self.v_imgBox setHidden:NO];
        //填充图片数据
        [self refreashImageBox:imgArr];
    }else{
        [self.v_imgBox setHidden:YES];
    }
    self.imageboxHegiht.constant = imgBoxH;
}

- (void)refreashImageBox:(NSArray *)imgArr{
    NSArray *btnArr = @[
                        self.btn_showImg_0,
                        self.btn_showImg_1,
                        self.btn_showImg_2,
                        self.btn_showImg_3,
                        self.btn_showImg_4
                        ];
    
    for (UIButton *btn in btnArr) {
        if (btn.tag < imgArr.count) {
            [btn setHidden:NO];
            if (btn.tag<4) {
                [btn sd_setImageWithURL:[NSURL URLWithString:imgArr[btn.tag]]
                               forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_picture"]];
            }else{
                if (imgArr.count>4) {
                    [btn setTitle:[NSString stringWithFormat:@"+%d",(int)(imgArr.count-4)]
                         forState:UIControlStateNormal];
                }
            }
        }else{
            [btn setHidden:YES];
        }
    }
}

- (IBAction)clickShowPhotoAction:(UIButton *)sender {
//    NSArray *imgArr = [self.commentModel.imagesAddressList componentsSeparatedByString:@","];
    
    if (self.photoBlock) {
        self.photoBlock(self.commentModel.imagesAddressList,sender.tag);
    }
}

- (IBAction)clickLikeAction:(UIButton *)sender {
    if (sender.isSelected) {
        [self delPraiseAction:sender];
    }else{
        [self addPraiseAction:sender];
    }
}

/**
 取消点赞

 @param sender 处理按钮
 */
- (void)delPraiseAction:(UIButton *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [sender setSelected:NO];
        [sender setImage:[[UIImage imageNamed:@"discovery_like_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                forState:UIControlStateNormal];
        self.commentModel.praises--;
        NSString *praise = [NSString stringWithFormat:@" %ld ",self.commentModel.praises];
        [sender setTitle:praise forState:UIControlStateNormal];
    });
    
    [JABbsPresenter postUpdatePraiseType:JADetailsTypeComment
                               detailsId:self.commentModel.ID
                                praiseId:self.commentModel.praiseId
                               isDeleted:YES
                                  Result:^(JAUpdatePraiseModel *model) {
                                      if (model.success) {
                                          LogD(@"评论取消点赞成功");
                                      }
                                  }];
}

/**
 点赞操作

 @param sender 处理按钮
 */
- (void)addPraiseAction:(UIButton *)sender{
    if (SPLocalInfo.hasBeenLogin == NO) {
        [SVProgressHUD showInfoWithStatus:@"请先登录，才能点赞哦～"];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [sender setSelected:YES];
        [sender setImage:[[UIImage imageNamed:@"discovery_like_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                forState:UIControlStateSelected];
        self.commentModel.praises++;
        NSString *praise = [NSString stringWithFormat:@" %ld ",self.commentModel.praises];
        [sender setTitle:praise forState:UIControlStateSelected];
    });
    
    [JABbsPresenter postAddPraise:JADetailsTypeComment
                    WithDetailsId:self.commentModel.ID
                           Result:^(JAAddPraiseModel * _Nullable model) {
                               if (model.success) {
                                   LogD(@"点赞成功");
                                   self.commentModel.praiseId = model.praisesRelationId;
                               }
                           }];
}

- (IBAction)showUserinfoAction:(id)sender {
    if (self.showUserinfoBlock) {
        self.showUserinfoBlock(self.commentModel.commentUserId);
    }
} 

- (IBAction)moreBtnClick:(UIButton *)sender {
    CGRect tempRect = [sender convertRect:sender.bounds toView:[UIApplication sharedApplication].keyWindow];
    tempRect.origin.x = tempRect.origin.x - 15;
    
    if (self.moreBlock) {
        self.moreBlock(self.commentModel, tempRect.origin);
    }
}

//回复
- (void)showImage:(NSArray *)imgArr{
    //自适应高度
    CGFloat imgBoxH = 0;
    if (imgArr&&imgArr.count) {
        imgBoxH = (kScreenWidth-30-40)/(4+25.0/66);
        //box高度 = img高度 =（屏款-间隔）÷个数
        [self.returnImageView setHidden:NO];
        //填充图片数据
        [self refreashImage:imgArr];
    }else{
        [self.returnImageView setHidden:YES];
    }
    self.returnImageHeight.constant = imgBoxH;   
}

- (void)refreashImage:(NSArray *)imgArr{
    NSArray *btnArr = @[
                        self.returnImage_1,
                        self.returnImage_2,
                        self.returnImage_3,
                        self.returnImage_4,
                        self.returnImage_5
                        ];
    
    for (UIButton *btn in btnArr) {
        if (btn.tag < imgArr.count) {
            [btn setHidden:NO];
            if (btn.tag<4) {
                [btn sd_setImageWithURL:[NSURL URLWithString:imgArr[btn.tag]]
                               forState:UIControlStateNormal];
            }else{
                if (imgArr.count>4) {
                    [btn setTitle:[NSString stringWithFormat:@"+%d",(int)(imgArr.count-4)]
                         forState:UIControlStateNormal];
                }
            }
        }else{
            [btn setHidden:YES];
        }
    }
}

- (void)openReutrnImage:(UIButton *)sender {
    if (self.photoBlock) {
        self.photoBlock(self.commentModel.childComment.imagesAddressList,sender.tag);
    }
}

-(void)openMoreCommentAction:(UIButton *)button{
    if (self.commentMoreBlock) {
        self.commentMoreBlock(self.commentModel.ID, self.commentModel.commentUserId);
    }
}




@end
