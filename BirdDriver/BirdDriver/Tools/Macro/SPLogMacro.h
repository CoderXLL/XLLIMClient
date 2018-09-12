//
//  SPLogMacro.h
//  BirdDriver
//
//  Created by Soul on 2018/5/14.
//  Copyright © 2018年 Hangzhou Eneesi Technology Co.,Ltd. All rights reserved.
//

#ifndef SPLogMacro_h
#define SPLogMacro_h

/*
 * safe
 */
//==========================================
#pragma mark - 判断数据是否为空

//字符串是否为空
#define kStringIsEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]) || ([(_ref) isEqual:@"<null>"])|| ([(_ref) isEqual:@"(null)"]))

//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)

//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
//==========================================

// PROPERTY
#define STRONG(__class__, __property__)\
@property (nonatomic, strong)__class__  * __property__;

#define READONLY(__class__, __property__)\
@property(nonatomic, readonly)__class__   __property__;

#define ASSIGN(__class__, __property__)\
@property (nonatomic, assign)__class__  __property__;

#define COPY(__class__, __property__)\
@property (nonatomic, copy)__class__  *__property__;

#define WEAK(__class__, __property__)\
@property (nonatomic, weak)__class__  *__property__;

/*
 * __weak
 */
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;


#if DEBUG

#define LogD(...) NSLog(__VA_ARGS__);
#define LogE(...) NSLog(__VA_ARGS__);

#else

#define LogD(...) ;
#define LogE(...) NSLog(__VA_ARGS__);
#endif

#endif /* SPLogMacro_h */
