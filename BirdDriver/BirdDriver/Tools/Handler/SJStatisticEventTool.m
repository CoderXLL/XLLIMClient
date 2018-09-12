//
//  SJStatisticEventTool.m
//  BirdDriver
//
//  Created by Soul on 2018/8/13.
//  Copyright © 2018年 Hangzhou Wesley Technology Co.,Ltd. All rights reserved.
//

#import "SJStatisticEventTool.h"

@implementation SJStatisticEventTool

+ (void)umengEvent:(UMengEventId)eventId
             NsjId:(NSString *)nsjId
           NsjName:(NSString *)nsjName
{
    NSDictionary *attributes = @{
                                 @"Name":nsjName,
                                 @"NsjId":nsjId
                                 };
    NSString *eventStr = [NSString stringWithFormat:@"%ld",eventId];
    
    [MobClick event:eventStr
         attributes:attributes
            counter:329];
}

+ (void)umengEventName:(NSString *)name{
    NSDictionary *attributes = @{
                                 @"Name":name
                                 };
    NSString *eventStr = [NSString stringWithFormat:@"%ld",Nsj_Event_Common];
    
    [MobClick event:eventStr
         attributes:attributes
            counter:329];
}

+ (void)umengEvent:(UMengEventId)eventId
             Times:(NSInteger)counter
        Parameters:(NSDictionary *)parameters{
    
    NSString *eventStr = [NSString stringWithFormat:@"%ld",eventId];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if(!kDictIsEmpty(parameters)){
         [attributes addEntriesFromDictionary:parameters];
    }
    
    [MobClick event:eventStr
         attributes:attributes
            counter:(int)counter];
}

@end
