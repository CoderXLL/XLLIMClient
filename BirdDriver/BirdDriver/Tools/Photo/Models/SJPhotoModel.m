//
//  SJPhotoModel.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJPhotoModel.h"

@interface SJPhotoModel ()

@property (nonatomic, strong, readwrite) PHAsset *mAsset;

@end

@implementation SJPhotoModel

- (instancetype)initWithAsset:(PHAsset *)mAsset
{
    if (self = [super init])
    {
        _mAsset = mAsset;
    }
    return self;
}

- (NSString *)localIdentifier
{
    if (self.mAsset == nil)
    {
        return nil;
    }
    return self.mAsset.localIdentifier;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[SJPhotoModel class]]) {
        SJPhotoModel *photoModel = (SJPhotoModel *)object;
        return [photoModel.mAsset.localIdentifier isEqual:self.mAsset.localIdentifier];
    }
    return NO;
}

@end
