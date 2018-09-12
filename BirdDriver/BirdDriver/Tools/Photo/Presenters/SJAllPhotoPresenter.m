//
//  SJAllPhotoPresenter.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJAllPhotoPresenter.h"
#import "SJPhotoModel.h"

@interface SJAllPhotoPresenter ()

//是否第一次加载
@property (nonatomic, assign) BOOL isFirstLoad;
//所有图片集合
@property (nonatomic, strong) NSMutableArray <SJPhotoModel *>*photoResults;

@end

@implementation SJAllPhotoPresenter

#pragma mark - lazy loading
- (NSMutableArray<SJPhotoModel *> *)photoResults
{
    if (_photoResults == nil)
    {
        _photoResults = [NSMutableArray array];
    }
    return _photoResults;
}


- (instancetype)init
{
    if (self = [super init])
    {
        self.isFirstLoad = YES;
    }
    return self;
}

- (void)getAllPhotosWithSelectedAssets:(NSArray<SJPhotoModel *> *)selectedAssets
{
    PHFetchOptions *mOptions = [[PHFetchOptions alloc] init];
    mOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    mOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    PHFetchResult <PHAsset *>*allPHAssets = [PHAsset fetchAssetsWithOptions:mOptions];
    
    for (PHAsset *mAsset in allPHAssets) {
        
        SJPhotoModel *photoModel = [[SJPhotoModel alloc] initWithAsset:mAsset];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.localIdentifier CONTAINS [c]%@", photoModel.localIdentifier];
        NSArray *filterArray = [selectedAssets filteredArrayUsingPredicate:predicate];
        if (filterArray.count == 0) {
            [self.photoResults addObject:photoModel];
        } else {
            SJPhotoModel *selectModel = filterArray.firstObject;
            selectModel.isSelected = YES;
            [self.photoResults addObject:selectModel];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(setAllPhotos:)])
    {
        [self.delegate setAllPhotos:self.photoResults];
    }
}


@end
