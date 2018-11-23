//
//  ChintBuriedPointSDK.h
//  ChintBuriedPointSDK
//
//  Created by lucky－ios on 2018/9/6.
//  Copyright © 2018年 com.chint. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, EVENT_NAME){
    firstPage = 0,
    redirect,
    search,
    addcart,
    collect,
    scan,
    share,
    registering
};

@interface ChintBuriedPointSDK : NSObject
/** 日志打印开关 默认NO*/
@property(nonatomic, assign)BOOL debug;
/** 发布版本开关 默认NO*/
@property(nonatomic, assign)BOOL product;
/** 获取单例 */
+ (instancetype)sharedManager;

/**
 ChintBuriedPointSDK 初始化
 @param appId appId
 @param local @"CN | HK, default value is CN"
 */
- (void)setupWithAppId:(NSString *)appId local:(NSString *)local;

/**
 退出app
 @param userId 会员id
 */
+ (void)exitApp:(NSString *)userId;

/**
 事件跟踪
 @param userId 会员id
 @param pageName 页面Url
 @param pageType 页面类型
 @param eventName 事件名称
 @param eventProp 自定义字典
 */
+ (void)traceEventWithUserId:(NSString *)userId pageName:(NSString*)pageName pageType:(NSString *)pageType eventName:(EVENT_NAME)eventName eventProp:(NSMutableDictionary *)eventProp;

@end
