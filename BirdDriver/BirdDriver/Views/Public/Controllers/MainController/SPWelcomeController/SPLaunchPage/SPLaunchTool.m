//
//  SPLaunchTool.m
//  ChooseRoot
//
//  Created by 宋明月 on 2018/1/10.
//  Copyright © 2018年 宋明月. All rights reserved.
//

#import "SPLaunchTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import "SPAdDetailController.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>

@implementation SPLaunchTool

#pragma mark -
#pragma mark 复杂类型对象的读写
+ (void)writeBannerModel2Disk:(GOBannerModel *)bannerModel {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:bannerModel];
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"hh.text"];
    [data writeToFile:path atomically:YES];
    NSLog(@"%@", path);
}

+ (GOBannerModel *)readBannerFromDisk{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [array lastObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"hh.text"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 反序列化，解档
    
    GOBannerModel *bannerModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return bannerModel;
}

+ (void)writeImageData2Disk:(NSData *)data {
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [arr lastObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"data.text"];
    [data writeToFile:path atomically:YES];
    NSLog(@"%@", path);
}

+ (NSData *)readImageDataFromDisk{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [array lastObject];
    path = [NSString stringWithFormat:@"%@/%@", path, @"data.text"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 反序列化，解档
    return data;
}

/**
 * 加载广告
 */
+ (void)loadPromotionPageData:(GOBannerModel *)bannerModel {
    if (bannerModel.Pic.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GO_SERVER_H5,bannerModel.Pic]];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url
                                                              options:SDWebImageDownloaderUseNSURLCache
                                                             progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        }
                                                            completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image && finished) {
                // 开始存储图片
                [SPLaunchTool writeImageData2Disk:data];
            }
        }];
    }
}

//网络请求获取启动页
+ (void)downLoadAdsImageOnline{
    [GOBannerPresenter postGetBannerListPosition:PositionAD
                                          result:^(GOBannerListModel *model) {
                                              if([model.Code isEqualToString:@"200"] && model.BannerModels.count > 0){
                                                  //暂时只取一张广告
                                                  GOBannerModel *bannerModel = model.BannerModels.firstObject;
                                                  [SPLaunchTool writeBannerModel2Disk:bannerModel];
                                                  [SPLaunchTool loadPromotionPageData:bannerModel];
                                              }
                                          }];
}

@end
