//
//  SJHomeHotUserCell.m
//  BirdDriver
//
//  Created by Soul on 2018/5/18.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#import "SJHomeHotUserCell.h"
#import "JAUserAccount.h"
#import "JABBSModel.h"

@interface SJHomeHotUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCons;

@end

@implementation SJHomeHotUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headView.layer.cornerRadius = self.headView.frame.size.height/2;
    self.headView.layer.masksToBounds = YES;

    self.label1.hidden = YES;
    self.label2.hidden = YES;
    self.label3.hidden = YES;
    self.label4.hidden = YES;
    self.label1.layer.cornerRadius = self.label1.frame.size.height/2;
    self.label2.layer.cornerRadius = self.label2.frame.size.height/2;
    self.label3.layer.cornerRadius = self.label3.frame.size.height/2;
    self.label4.layer.cornerRadius = self.label4.frame.size.height/2;
    self.label1.layer.masksToBounds = YES;
    self.label2.layer.masksToBounds = YES;
    self.label3.layer.masksToBounds = YES;
    self.label4.layer.masksToBounds = YES;
    self.label1.adjustsFontSizeToFitWidth = YES;
    self.label2.adjustsFontSizeToFitWidth = YES;
    self.label3.adjustsFontSizeToFitWidth = YES;
    self.label4.adjustsFontSizeToFitWidth = YES;
}

- (void)setModel:(id)model
{
    _model = model;
    if ([model isKindOfClass:[JAUserAccount class]]) {
        JAUserAccount *userAccount = (JAUserAccount *)model;
        [self setUserAccount:userAccount];
    } else if ([model isKindOfClass:[JAUserAccountPosList class]]) {
        JAUserAccountPosList *posModel = (JAUserAccountPosList *)model;
        [self setPosModel:posModel];
    }
}

- (void)setPosModel:(JAUserAccountPosList *)posModel
{
    self.nameLabel.text = posModel.nickName;
      [self.headView sd_setImageWithURL:posModel.photoSrc.mj_url placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    if (posModel.labelsList.count > 0) {
        
        NSArray *hobbysArray = posModel.labelsList;
        self.label1.hidden = (hobbysArray.count == 0);
        self.label2.hidden = (hobbysArray.count <= 1);
        self.label3.hidden = (hobbysArray.count <= 2);
        self.label4.hidden = (hobbysArray.count <= 3);
        for (int i = 0; i < [hobbysArray count]; i++) {
            if (i == 0) {
                self.label1.text = [hobbysArray objectAtIndex:i];
            } else if (i == 1){
                self.label2.text = [hobbysArray objectAtIndex:i];
            } else if (i == 2){
                self.label3.text = [hobbysArray objectAtIndex:i];
            } else if (i == 3){
                self.label4.text = [hobbysArray objectAtIndex:i];
            }
        }
    } else {
        self.label1.hidden = YES;
        self.label2.hidden = YES;
        self.label3.hidden = YES;
        self.label4.hidden = YES;
    }
}

- (void)setUserAccount:(JAUserAccount *)userAccount {
    self.nameLabel.text = [userAccount getShowNickName];
    [self.headView sd_setImageWithURL:userAccount.avatarUrl.mj_url placeholderImage:[UIImage imageNamed:@"default_portrait"]];
    
    if (userAccount.hobbies.length > 0) {
        NSString *hobbies = [userAccount.hobbies stringByReplacingOccurrencesOfString:@"#" withString:@""];
        NSArray *hobbysArray = [hobbies componentsSeparatedByString:@","];
        self.label1.hidden = (hobbysArray.count == 0);
        self.label2.hidden = (hobbysArray.count <= 1);
        self.label3.hidden = (hobbysArray.count <= 2);
        self.label4.hidden = (hobbysArray.count <= 3);
        for (int i = 0; i < [hobbysArray count]; i++) {
            if (i == 0) {
                self.label1.text = [hobbysArray objectAtIndex:i];
            } else if (i == 1){
                self.label2.text = [hobbysArray objectAtIndex:i];
            } else if (i == 2){
                self.label3.text = [hobbysArray objectAtIndex:i];
            } else if (i == 3){
                self.label4.text = [hobbysArray objectAtIndex:i];
            }
        }
    } else {
        self.label1.hidden = YES;
        self.label2.hidden = YES;
        self.label3.hidden = YES;
        self.label4.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.labelCons.constant = (self.width-20-6)*0.5;
}

@end
