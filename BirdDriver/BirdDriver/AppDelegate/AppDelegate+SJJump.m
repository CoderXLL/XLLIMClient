//
//  AppDelegate+SJJump.m
//  BirdDriver
//
//  Created by 肖乐 on 2018/8/17.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "AppDelegate+SJJump.h"
#import "SJTabBarController.h"
#import "SJNoteDetailController.h"
#import "SJFootprintDetailsController.h"
#import "SJNavController.h"
#import "SJFansViewController.h"
#import "SJChildCommentListViewController.h"
#import "SJNoteSubReplyController.h"
#import "JAMessageModel.h"
#import "JABbsPresenter.h"
#import "JAForumPresenter.h"

@implementation AppDelegate (SJJump)

//推送跳入指定页面
- (void)jumpViewController:(NSDictionary *)userInfo
{
    //弹一下
//    [self alertUserInfo:userInfo];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    JAMessageModel *messageModel = [JAMessageModel mj_objectWithKeyValues:userInfo];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (![app.window.rootViewController isKindOfClass:[SJTabBarController class]])
    {
        return;
    }
    NSString *messageType = userInfo[@"messageType"];
    if (kStringIsEmpty(messageType)) return;
    if (!kDictIsEmpty(userInfo)) {
        
        //点击进入详情
        switch (messageModel.messageType) {
            case 2:
            {
                LogD(@"跳转到评论详情...");
                NSString *rootId = userInfo[@"rootId"];
                if (kStringIsEmpty(rootId)) return;
                NSString *detailId = userInfo[@"detailId"];
                if (kStringIsEmpty(detailId)) return;
                [self pushNoteChildController:messageModel.rootId detailId:messageModel.detailId];
                break;
            }
            case 3:
            {
                LogD(@"跳转到帖子或者活动...");
                NSString *relevanceId = userInfo[@"relevanceId"];
                if (kStringIsEmpty(relevanceId)) return;
                [self pushToDetails:messageModel.relevanceId];
                break;
            }
            case 4:{
                LogD(@"关注产生的消息...");
                [self pushToFansController];
                break;
            }
            case 5:
            {
                LogD(@"跳转到帖子或者活动...");
                NSString *relevanceId = userInfo[@"relevanceId"];
                if (kStringIsEmpty(relevanceId)) return;
                [self pushActvityChildController:messageModel.relevanceId];
                break;
            }
            case 6:
            {
                LogD(@"跳转到评论详情...");
                NSString *rootId = userInfo[@"rootId"];
                if (kStringIsEmpty(rootId)) return;
                NSString *detailId = userInfo[@"detailId"];
                if (kStringIsEmpty(detailId)) return;
                [self pushNoteChildController:messageModel.rootId detailId:messageModel.detailId];
                break;
            }
            default:
                break;
        }
    }
}

//跳转到帖子或活动
- (void)pushToDetails:(NSInteger)relevanceId
{
    [JABbsPresenter postQueryDetails:relevanceId
                              Result:^(JABBSModel * _Nullable model) {
                                  if (model && model.success) {
                                      if (model.detail.detailsType == 1) {
                                          [self pushToNoteController:relevanceId];
                                      }else{
                                          [self pushToFootprintController:relevanceId];
                                      }
                                  } else {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [SVProgressHUD showErrorWithStatus:model.responseStatus.message];
                                          [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default*1.5];
                                      });
                                  }
                              }];
}

//跳到帖子详情
- (void)pushToNoteController:(NSInteger)noteId
{
    //帖子详情
    SJNoteDetailController *detailVC = [[SJNoteDetailController alloc] init];
    detailVC.noteId = noteId;
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (![app.window.rootViewController isKindOfClass:[SJTabBarController class]])
    {
        return;
    }
    SJTabBarController *tabVC = (SJTabBarController *)app.window.rootViewController;
    NSInteger currentIndex = tabVC.selectedIndex;
    SJNavController *nav = tabVC.childViewControllers[currentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [nav pushViewController:detailVC animated:YES];
    });
}

//跳到足迹详情
- (void)pushToFootprintController:(NSInteger)activityId
{
    //活动详情
    SJFootprintDetailsController *detailVC = [[SJFootprintDetailsController alloc] init];
    detailVC.activityId = activityId;
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (![app.window.rootViewController isKindOfClass:[SJTabBarController class]])
    {
        return;
    }
    SJTabBarController *tabVC = (SJTabBarController *)app.window.rootViewController;
    NSInteger currentIndex = tabVC.selectedIndex;
    SJNavController *nav = tabVC.childViewControllers[currentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [nav pushViewController:detailVC animated:YES];
    });
}

- (void)pushToFansController{
    SJFansViewController *fansVC = [[SJFansViewController alloc] init];
    fansVC.titleName = @"我的粉丝";
    fansVC.userId = SPLocalInfo.userModel.Id;
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (![app.window.rootViewController isKindOfClass:[SJTabBarController class]])
    {
        return;
    }
    SJTabBarController *tabVC = (SJTabBarController *)app.window.rootViewController;
    NSInteger currentIndex = tabVC.selectedIndex;
    SJNavController *nav = tabVC.childViewControllers[currentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [nav pushViewController:fansVC animated:YES];
    });
}

-(void)pushActvityChildController:(NSInteger)commentID{
    //足迹子评论
    SJChildCommentListViewController *childCommentListVC = [[SJChildCommentListViewController alloc] init];
    childCommentListVC.titleName = @"评论详情";
    childCommentListVC.commentId = commentID;
    childCommentListVC.activityId = 0;
    childCommentListVC.commentUserId = 0;
    childCommentListVC.authorId = 0;
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (![app.window.rootViewController isKindOfClass:[SJTabBarController class]])
    {
        return;
    }
    SJTabBarController *tabVC = (SJTabBarController *)app.window.rootViewController;
    NSInteger currentIndex = tabVC.selectedIndex;
    SJNavController *nav = tabVC.childViewControllers[currentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [nav pushViewController:childCommentListVC animated:YES];
    });
}

-(void)pushNoteChildController:(NSInteger)commentID detailId:(NSInteger)detailId
{
    //帖子子评论
    SJNoteSubReplyController *subReplyVC = [[SJNoteSubReplyController alloc] init];
    subReplyVC.titleName = @"评论详情";
    JAPostCommentItemModel *model = [[JAPostCommentItemModel alloc] init];
    model.detailId = detailId;
    model.ID = commentID;
    model.userId = 0;
    subReplyVC.superCommentModel = model;
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (![app.window.rootViewController isKindOfClass:[SJTabBarController class]])
    {
        return;
    }
    SJTabBarController *tabVC = (SJTabBarController *)app.window.rootViewController;
    NSInteger currentIndex = tabVC.selectedIndex;
    SJNavController *nav = tabVC.childViewControllers[currentIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        [nav pushViewController:subReplyVC animated:YES];
    });
}

- (void)alertUserInfo:(NSDictionary *)userInfo
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    } else {
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [SVProgressHUD showSuccessWithStatus:jsonString];
    }
    [SVProgressHUD dismissWithDelay:HUD_TimeInterval_default * 20];
}

@end
