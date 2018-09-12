//
//  SJPhotoCell.h
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJPhotoCell.h"
#import "SJPhotoModel.h"
#import "JAPhotoListModel.h"
#import <Photos/Photos.h>
#import "SJPhotoComponents.h"
#import <AVFoundation/AVFoundation.h>

@interface SJPhotoCell ()

//图片
@property (nonatomic, weak) UIImageView *imageView;
//选中标识
@property (nonatomic, weak) UIButton *selectButton;
//缓存图片
@property (nonatomic, strong) PHCachingImageManager *pImageManager;

@end

@implementation SJPhotoCell

#pragma mark - lazy loading
- (PHCachingImageManager *)pImageManager
{
    if (!_pImageManager)
    {
        _pImageManager = [[PHCachingImageManager alloc] init];
    }
    return _pImageManager;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        selectButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        selectButton.imageView.clipsToBounds = YES;
        [self.contentView addSubview:selectButton];
        self.selectButton = selectButton;
    }
    return self;
}

#pragma mark - event
- (void)selectBtnClick
{
    if (self.photoCallBack) {
        self.photoCallBack(self.photoModel?self.photoModel:self.pictureModel);
    }
}


- (void)setPictureModel:(JAPhotoModel *)pictureModel
{
    _pictureModel = pictureModel;

    [self.imageView sd_setImageWithURL:pictureModel.address.mj_url placeholderImage:[UIImage imageNamed:@"default_picture"]];
    self.selectButton.hidden = (pictureModel.showType == SJMyPictureShowTypeNormal);
    [self.selectButton setImage:pictureModel.selected?[UIImage imageNamed:@"photo_selected"]:[UIImage imageNamed:@"photo_unSelect"] forState:UIControlStateNormal];
}

// 设置图片
- (void)setPhotoModel:(SJPhotoModel *)photoModel
{
    _photoModel = photoModel;
    
    [self.selectButton setImage:photoModel.selected?[UIImage imageNamed:@"photo_selected"]:[UIImage imageNamed:@"photo_unSelect"] forState:UIControlStateNormal];
    if (photoModel.thumbnailImage)
    {
        self.imageView.image = photoModel.thumbnailImage;
    } else {
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        CGSize kAssetGridThumbnailSize =  [SJPhotoComponents assetGridCellSize];
        CGFloat scale = [UIScreen mainScreen].scale;
        kAssetGridThumbnailSize = CGSizeMake(kAssetGridThumbnailSize.width * scale, kAssetGridThumbnailSize.height * scale);
        [self.pImageManager requestImageForAsset:photoModel.mAsset targetSize:kAssetGridThumbnailSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            photoModel.thumbnailImage = result;
            self.imageView.image = result;
        }];
    }
}

// 布局视图
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
    CGFloat btnW = self.width*0.4;
    self.selectButton.frame = CGRectMake(self.contentView.frame.size.width - btnW, 0, btnW, btnW);
}

@end

