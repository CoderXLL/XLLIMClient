//
//  SPLaunchTool.h
//  ChooseRoot
//
//  Created by 宋明月 on 2018/1/10.
//  Copyright © 2018年 宋明月. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOBannerPresenter.h"
#import <UIKit/UIKit.h>

@interface SPLaunchTool : NSObject

#pragma mark 复杂类型对象的读写

+ (void)writeBannerModel2Disk:(GOBannerModel *)bannerModel;

+ (GOBannerModel *)readBannerFromDisk;

+ (void)writeImageData2Disk:(NSData *)data ;

+ (NSData *)readImageDataFromDisk;

//网络请求获取启动页
+ (void)downLoadAdsImageOnline;

@end
