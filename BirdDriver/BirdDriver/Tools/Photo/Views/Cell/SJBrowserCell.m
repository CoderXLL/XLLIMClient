//
//  SJBrowserCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJBrowserCell.h"
#import <Photos/Photos.h>
#import "SJZoomImageView.h"
#import "SJPhotoModel.h"
#import "JAPhotoListModel.h"

@interface SJBrowserCell ()

@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, weak) SJZoomImageView *zoomImageView;
@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation SJBrowserCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBase];
    }
    return self;
}


- (void)setupBase
{
//    self.gradientLayer = [CAGradientLayer layer];
//    self.gradientLayer.startPoint = CGPointMake(0, 0);
//    self.gradientLayer.endPoint = CGPointMake(0, 1);
//    self.gradientLayer.colors = @[(__bridge id)RGB(152, 202, 255).CGColor, (__bridge id)RGB(11, 37, 78).CGColor, (__bridge id)RGB(18, 65, 142).CGColor];
//    self.gradientLayer.locations = @[@0, @0.5, @1];
//    [self.contentView.layer addSublayer:self.gradientLayer];
    self.contentView.backgroundColor = [UIColor blackColor];
    
    SJZoomImageView *zoomImageView = [[SJZoomImageView alloc] init];
    [self.contentView addSubview:zoomImageView];
    self.zoomImageView = zoomImageView;
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.contentView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    UIView *coverView = [[UIView alloc] init];
    coverView.hidden = YES;
    coverView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:coverView];
    self.coverView = coverView;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorWithHexString:@"040404" alpha:0.6];
    [self.coverView addSubview:bgView];
    self.bgView = bgView;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor whiteColor];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.clipsToBounds = YES;
    [deleteBtn setTitle:@"删除照片" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor colorWithHexString:@"2B3248" alpha:1.0] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = SPFont(18.0);
    [self.coverView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
}

- (void)deleteBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteBrowserCell:)])
    {
        [self.delegate didDeleteBrowserCell:self];
    }
}

#pragma mark - setter
- (void)setModel:(id)model
{
    _model = model;
    if ([model isKindOfClass:[SJPhotoModel class]])
    {
        SJPhotoModel *photoModel = (SJPhotoModel *)model;
        [self setPhotoModel:photoModel];
    } else if ([model isKindOfClass:[JAPhotoModel class]]) {
        JAPhotoModel *pictureModel = (JAPhotoModel *)model;
        [self setPictureModel:pictureModel];
    } else if ([model isKindOfClass:[NSString class]]) {
        NSString *urlStr = (NSString *)model;
        [self setUrlStr:urlStr];
    }
}

- (void)setUrlStr:(NSString *)urlStr
{
    [self.indicatorView startAnimating];
    [self.zoomImageView.imageView sd_setImageWithURL:urlStr.mj_url placeholderImage:[UIImage imageNamed:@"default_picture"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.zoomImageView.image = image;
        [self.indicatorView stopAnimating];
    }];
}

- (void)setPictureModel:(JAPhotoModel *)pictureModel
{
    [self.indicatorView startAnimating];
    
    self.coverView.hidden = (pictureModel.showType == SJMyPictureShowTypeNormal);
    [self.zoomImageView.imageView sd_setImageWithURL:pictureModel.address.mj_url placeholderImage:[UIImage imageNamed:@"default_picture"] options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        self.zoomImageView.image = image;
        [self.indicatorView stopAnimating];
    }];
}

- (void)setPhotoModel:(SJPhotoModel *)photoModel
{
    [[PHImageManager defaultManager] requestImageForAsset:photoModel.mAsset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if ([info[PHImageResultIsDegradedKey] boolValue])
        {
            if (photoModel.thumbnailImage)
            {
                self.zoomImageView.image = photoModel.thumbnailImage;
            } else {
                self.zoomImageView.image = result;
            }
        } else {
            photoModel.thumbnailImage = result;
            self.zoomImageView.image = result;
        }
    }];
}


- (void)setZoomScale:(CGFloat)zoomScale
{
    _zoomScale = zoomScale;
    self.zoomImageView.zoomScale = _zoomScale;
}

#pragma mark - LayoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.coverView.frame = self.contentView.bounds;
    self.bgView.frame = self.coverView.bounds;
    self.deleteBtn.frame = CGRectMake(self.contentView.centerX-50, self.contentView.centerY-50, 100, 100);
    self.deleteBtn.layer.cornerRadius = 50.0;
    
    self.zoomImageView.frame = self.contentView.bounds;
    self.indicatorView.center = self.contentView.center;
    self.gradientLayer.frame = self.contentView.layer.bounds;
}

@end

