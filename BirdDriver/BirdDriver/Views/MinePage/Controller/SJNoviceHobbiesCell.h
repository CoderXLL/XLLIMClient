//
//  SJNoviceHobbiesCell.h
//  BirdDriver
//
//  Created by Soul on 2018/8/24.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJNoviceHobbiesModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) BOOL canBeDeleted;

@end


@interface SJNoviceHobbiesCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_hobby;
@property (weak, nonatomic) IBOutlet UIButton *btn_del;

@property (strong, nonatomic) SJNoviceHobbiesModel *model;

@end
