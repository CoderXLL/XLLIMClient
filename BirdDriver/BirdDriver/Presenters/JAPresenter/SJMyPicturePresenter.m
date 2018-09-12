//
//  SJMyPicturePresenter.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/5/25.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMyPicturePresenter.h"
#import "JABbsPresenter.h"

@interface SJMyPicturePresenter ()


@end

@implementation SJMyPicturePresenter

- (void)deletePictureWithAtlasList:(NSArray<JAAtlasModel *> *)lasList
{
    [SVProgressHUD show];
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *deletedArray = [NSMutableArray array];
    for (JAAtlasModel *lasModel in lasList) {
        
        dispatch_group_enter(group);
        [JABbsPresenter postUpdateAtlas:lasModel.ID WithAtlasName:lasModel.atlasName WithAtlasStatus:JAAtlasStatusOnlyMyself WithIsDelete:YES WithRemark:nil Result:^(JAResponseModel * _Nullable model) {
            
            if (model.success) {
                
                [deletedArray addObject:lasModel];
            } else {
                [SVProgressHUD showErrorWithStatus:@"删除出错"];
            }
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        [SVProgressHUD dismiss];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSucceedDelete:)])
        {
            [self.delegate didSucceedDelete:deletedArray];
        }
    });
}

- (void)getPicturesWithPage:(NSInteger)page userId:(NSInteger)userId
{
    // 调用接口
    [SVProgressHUD show];
    [JABbsPresenter postQueryUserAtlas:userId IsPaging:YES WithCurrentPage:page WithLimit:10 Result:^(JAAtlasListModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (model.success)
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(setPictureLists:)])
                {
                    [self.delegate setPictureLists:[model.atlasList mutableCopy]];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
            if (self.delegate && [self.delegate respondsToSelector:@selector(didEndLoading)])
            {
                [self.delegate didEndLoading];
            }
        });
    }];
}

- (void)createPictureWithName:(NSString *)name
{
    [SVProgressHUD show];
    [JABbsPresenter postBuildAtlas:name WithAtlasStatus:JAAtlasStatusOpen WithIsDeleted:NO Result:^(JANewAtlasModel * _Nullable model) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (model.success)
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(didSucceedCreatePicture:)])
                {
                    [self.delegate didSucceedCreatePicture:model.atlas];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
            }
            [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default];
        });
    }];
}

@end
