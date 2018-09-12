//
//  SJMessageListViewController.m
//  BirdDriver
//
//  Created by 宋明月 on 2018/8/22.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJMessageListViewController.h"
#import "SJMessageListTableViewCell.h"
#import "SJMessageVC.h"
#import "SJSystemMessageViewController.h"

@interface SJMessageListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)NSMutableArray *imageArray;
@property (nonatomic, retain)NSMutableArray *nickNameArray;

@property (nonatomic, retain)JAResponseModel *model;


@end

@implementation SJMessageListViewController

-(void)readAction{
    [self readMessageList:0 messageId:0];
}

-(void)readMessageList:(NSInteger)messageType messageId:(NSInteger)messageId
{
    [JAMessagePresenter postreadAllMessage:messageType messageId:messageId Result:^(JAReadAllMsgModel * _Nullable model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.success) {
                
                if (model.data.nsjMessageId>0) {
                    [[NSUserDefaults standardUserDefaults] setInteger:model.data.nsjMessageId forKey:@"systemMessageIdB"];
                }
                if (messageType == 0 || messageId != 0) {
                    
                    [self getNotRead];
                    [self.listView reloadData];
                }
            }
        });
    }];
}

-(void)getNotRead{
    [JAMessagePresenter postNotReadMessageCount:MessageTypeAll
                                         Result:^(JAResponseModel * _Nullable model) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [self.listView.mj_header endRefreshing];
                                                 self.model = model;
                                                 [self.listView reloadData];
                                             });
                                         }];
}

-(void)beginRefreshing{
    [self getNotRead];
}

- (void)viewDidLoad {
    self.tableViewStyle = UITableViewStylePlain;
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"一键已读" style:UIBarButtonItemStyleDone target:self action:@selector(readAction)];
    [self.navigationItem.rightBarButtonItem setTintColor:SJ_TITLE_COLOR];
     [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.listView.separatorColor = [UIColor colorWithHexString:@"EEEEEE" alpha:1];
    // Do any additional setup after loading the view.
    self.listView.layoutMargins = UIEdgeInsetsMake(0, 65, 0, 0);
    [self.listView registerNib:[UINib nibWithNibName:@"SJMessageListTableViewCell" bundle:nil]
        forCellReuseIdentifier:@"SJMessageListTableViewCell"];
    
    self.imageArray = [@[@"secretary_icon",@"comment_icon",@"praise_icon",@"follow_icon"] mutableCopy];
    self.nickNameArray = [@[@"鸟斯基小秘书",@"评论",@"点赞",@"关注"] mutableCopy];
    
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self beginRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"SJMessageListTableViewCell";
    SJMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    cell.porImageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
    cell.nickNameLabel.text = [self.nickNameArray objectAtIndex:indexPath.row];
    cell.notReadNum.hidden = YES;
    if (indexPath.row == 0 && self.model.nsjMessageCount > 0) {
        cell.notReadNum.hidden = NO;
        if (self.model.nsjMessageCount > 99) {
            [cell.notReadNum setTitle:@"99+" forState:UIControlStateNormal];
        } else {
            [cell.notReadNum setTitle:[NSString stringWithFormat:@"%ld",self.model.nsjMessageCount] forState:UIControlStateNormal];
        }
    } else if (indexPath.row == 1 && self.model.commentNotReadMsgCount > 0){
        cell.notReadNum.hidden = NO;
        if (self.model.commentNotReadMsgCount > 99) {
            [cell.notReadNum setTitle:@"99+" forState:UIControlStateNormal];
        } else {
            [cell.notReadNum setTitle:[NSString stringWithFormat:@"%ld",self.model.commentNotReadMsgCount] forState:UIControlStateNormal];
        }
    } else if (indexPath.row == 2 && self.model.likeToReadMsgCount > 0){
        cell.notReadNum.hidden = NO;
        if (self.model.likeToReadMsgCount > 99) {
            [cell.notReadNum setTitle:@"99+" forState:UIControlStateNormal];
        } else {
           [cell.notReadNum setTitle:[NSString stringWithFormat:@"%ld",self.model.likeToReadMsgCount] forState:UIControlStateNormal];
        }
    } else if (indexPath.row == 3 && self.model.concernedUnreadMsgCount > 0){
        cell.notReadNum.hidden = NO;
        if (self.model.concernedUnreadMsgCount > 99) {
            [cell.notReadNum setTitle:@"99+" forState:UIControlStateNormal];
        } else {
            [cell.notReadNum setTitle:[NSString stringWithFormat:@"%ld",self.model.concernedUnreadMsgCount] forState:UIControlStateNormal];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (self.model.nsjMessageCount > 0) {
            
            NSString *messageID = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemMessageId"];
            if ([messageID isKindOfClass:[NSString class]]) {
                if (kStringIsEmpty(messageID)) {
                    messageID = @"0";
                }
            } else {
                if (kObjectIsEmpty(messageID)) {
                    messageID = @"0";
                }
            }
            self.model.nsjMessageCount = 0;
            [self readMessageList:20 messageId:[messageID integerValue]];
        }
        SJSystemMessageViewController * messageVC = [[SJSystemMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    } else if (indexPath.row == 1){
        if (self.model.commentNotReadMsgCount > 0) {
            [self readMessageList:2 messageId:0];
            [self readMessageList:6 messageId:0];
        }
        SJMessageVC * messageVC = [[SJMessageVC alloc] init];
        messageVC.messageType = MessageTypeComment;
        messageVC.navTitle = [self.nickNameArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:messageVC animated:YES];
    } else if (indexPath.row == 2){
        if (self.model.likeToReadMsgCount > 0) {
            [self readMessageList:3 messageId:0];
            [self readMessageList:5 messageId:0];
        }
        SJMessageVC * messageVC = [[SJMessageVC alloc] init];
        messageVC.messageType = MessageTypeLike;
        messageVC.navTitle = [self.nickNameArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:messageVC animated:YES];
    } else if (indexPath.row == 3){
        if (self.model.concernedUnreadMsgCount > 0) {
            [self readMessageList:4 messageId:0];
        }
        SJMessageVC * messageVC = [[SJMessageVC alloc] init];
        messageVC.messageType = MessageTypeAttention;
        messageVC.navTitle = [self.nickNameArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}


@end
