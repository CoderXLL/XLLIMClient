//
//  SJWaterCollectionViewCell.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/5/17.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJWaterCollectionViewCell.h"
#import "JAActivityListModel.h"

@interface SJWaterCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;//阴影View
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;//精选
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//昵称
@property (weak, nonatomic) IBOutlet UIButton *likeNumBtn;//点赞数
@property (weak, nonatomic) IBOutlet UIImageView *pictreImageView;//图片
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictHeightCons;

@end

@implementation SJWaterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.clipsToBounds = YES;
    //2B3248
    self.contentView.layer.shadowColor = [UIColor colorWithHexString:@"000000" alpha:1.0].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentView.layer.shadowOpacity = 0.25;
    self.contentView.layer.shadowRadius = 2.5;
    self.pictreImageView.layer.masksToBounds = YES;
    [self.likeNumBtn addTarget:self action:@selector(likeNumBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPostModel:(JAPostsModel *)postModel
{
    [super setPostModel:postModel];
    self.titleLabel.text = postModel.detailsName;
    self.nameLabel.text = postModel.nickName;
    [self.portraitImageView sd_setImageWithURL:postModel.photoSrc.mj_url placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    [self.likeNumBtn setTitle:[NSString stringWithFormat:@"%ld", (long)postModel.praises] forState:UIControlStateNormal];
    self.likeNumBtn.selected = postModel.praisesId;
    CGFloat titleHeight = [postModel.detailsName boundingRectWithSize:CGSizeMake(self.width-2*kSJMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0]} context:nil].size.height;
    self.titleHeightCons.constant = titleHeight+1;
    if (!kArrayIsEmpty(postModel.imagesAddressList) && postModel.imageHeight == 0) {
        UIImage *placeImage = [UIImage imageNamed:@"default_picture"];
        self.pictHeightCons.constant = self.width*placeImage.size.height*1.0/placeImage.size.width;
    } else {
        self.pictHeightCons.constant = postModel.imageHeight;
    }
    [self.pictreImageView sd_setImageWithURL:postModel.imagesAddressList.firstObject.mj_url placeholderImage:[UIImage imageNamed:@"default_picture"] options:SDWebImageProgressiveDownload completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (image) {
                
                if (!CGSizeEqualToSize(postModel.imageSize, image.size)) {
                    postModel.imageSize = image.size;
                    postModel.imageHeight = self.width*postModel.imageSize.height*1.0/postModel.imageSize.width;
                    self.pictHeightCons.constant = postModel.imageHeight;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(didSetupImageSize:)])
                    {
                        [self.delegate didSetupImageSize:postModel];
                    }
                }
            }
        }];
//    }
}

- (void)likeNumBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickLikeBtn:)])
    {
        [self.delegate didClickLikeBtn:self.postModel];
    }
}

@end
