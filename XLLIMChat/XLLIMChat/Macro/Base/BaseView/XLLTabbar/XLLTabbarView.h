//
//  XLLTabbarView.h
//  XLLIMChat
//
//  Created by 肖乐 on 2018/7/20.
//  Copyright © 2018年 iOSCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

//类型
typedef NS_ENUM(NSInteger, XLLTabbarViewType) {
    
    XLLTabbarViewTypeMessage,  //消息
    XLLTabbarViewTypeContact,  //联系人
    XLLTabbarViewTypeMe        //我的
};

//方向
typedef NS_ENUM(NSInteger, XLLTabbarViewOrientation) {
    
    XLLTabbarViewOrientationLeft,   //面向左边
    XLLTabbarViewOrientationMiddle, //选中
    XLLTabbarViewOrientationRight   //面向右边
};

@interface XLLTabbarView : UIView

//当前应该的朝向
@property (nonatomic, assign) XLLTabbarViewOrientation tabOrientation;
//类型
@property (nonatomic, assign) XLLTabbarViewType tabbarType;
//item title
@property (nonatomic, copy) NSString *titleStr;

@end
