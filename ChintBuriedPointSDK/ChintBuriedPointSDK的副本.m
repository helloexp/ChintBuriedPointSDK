//
//  ChintBuriedPointSDK.m
//  ChintBuriedPointSDK
//
//  Created by lucky－ios on 2018/9/6.
//  Copyright © 2018年 com.chint. All rights reserved.
//

#import "ChintBuriedPointSDK.h"
#import "ChintSAMKeychain.h"
#import "ChintPhoneType.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define userDicKey @"userDicKey"
#define userIdKey @"userIdKey"
#define inTimeKey @"inTimeKey"
#define prePageKey @"prePageKey"
#define outKey @"outKey"
#define outInfoKey @"outInfoKey"
#define formatStr @"yyyyMMdd HH:mm:ss"
#define sdk_version @"1.2.0"

//#define userInfoUrl @"https://t-web-data.fastretailing.cn/datarcvr/user/app"
//#define eventUrl @"https://t-web-data.fastretailing.cn/datarcvr/event"
//#define userInfoUrl @"http://10.5.107.155:8080/user/app"
//#define eventUrl @"http://10.5.107.155:8080/event"

//https://hk-ecbi-uat.fastretailing.com 香港测试
//https://hk-ecbi-event.fastretailing.com 香港正式

@interface ChintBuriedPointSDK()<CLLocationManagerDelegate>
@property(nonatomic, strong)CLLocationManager *manager;
@property(nonatomic, strong)CLLocation *location;
@property(nonatomic, copy)NSString *startTime;

@property(nonatomic, copy)NSString *userInfoUrl;
@property(nonatomic, copy)NSString *eventUrl;
@end

@implementation ChintBuriedPointSDK
NSMutableArray *pageArray;
+ (instancetype)sharedManager{
    static ChintBuriedPointSDK* sdk;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk = [ChintBuriedPointSDK new];
        pageArray = [NSMutableArray array];
        sdk.userInfoUrl = @"https://t-web-data.fastretailing.cn/datarcvr/user/app";
        sdk.eventUrl = @"https://t-web-data.fastretailing.cn/datarcvr/event";
    });
    
    return sdk;
}

- (void)setupWithAppId:(NSString *)appId local:(NSString *)local{
    if (local.length > 0 || [[local lowercaseString] isEqualToString:@"hk"]) {
        if(self.product){
            self.userInfoUrl = @"https://hk-ecbi-event.fastretailing.com/datarcvr/user/app";
            self.eventUrl = @"https://hk-ecbi-event.fastretailing.com/datarcvr/event";
        }else{
            self.userInfoUrl = @"https://hk-ecbi-uat.fastretailing.com/datarcvr/user/app";
            self.eventUrl = @"https://hk-ecbi-uat.fastretailing.com/datarcvr/event";
        }
    }
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[df valueForKey:outInfoKey]];
    //上传上次退出时间
    if (dic != nil && dic.allKeys.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(self.userInfoUrl.length > 0){
                if (self.debug) {
                    NSLog(@"%s, userInfoUrl:%@", __FUNCTION__, self.userInfoUrl);
                }
                [self requestDataUseBody:self.userInfoUrl method:@"post" paramDic:dic success:^{
                    [df removeObjectForKey:outInfoKey];
                    [df synchronize];
                } fail:nil];
            }
        });
    }
    
    [self.manager requestWhenInUseAuthorization];
    [self.manager startUpdatingLocation];
}

+ (void)traceEventWithUserId:(NSString *)userId pageName:(NSString *)pageName pageType:(NSString *)pageType eventName:(EVENT_NAME)eventName eventProp:(NSMutableDictionary *)eventProp{
    
    ChintBuriedPointSDK *sdk = [ChintBuriedPointSDK sharedManager];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (userId != nil && userId.length > 0) {
        [dic setObject:userId forKey:@"user_id"];
    }
    if (pageName != nil && pageName.length > 0) {
        [dic setObject:pageName forKey:@"current_url"];
    }
    if (pageType != nil && pageType.length > 0) {
        
        if ([pageType isEqualToString:@"NewWebViewController"]) {
            pageType = @"DEL";
        }else if ([pageType isEqualToString:@"商品详情页"]) {
            pageType = @"PL4";
        }else if ([pageType isEqualToString:@"APP首页"]) {
            pageType = @"MK1";
        }else {
            pageType = @"OTH";
        }
        
        [dic setObject:pageType forKey:@"page_type"];
    }
    [dic setObject:@"app" forKey:@"platform"];
    [dic setObject:[sdk getTempUserId] forKey:@"uuid_tmp"];
    [dic setObject:[sdk getDeviceId] forKey:@"uuid"];
    NSString *inTime = [sdk timeNow];
    
    [dic setObject:@([sdk getTimeStamp:inTime]) forKey:@"event_time"];
    if (eventName == firstPage) {
        [dic setObject:@"firstPage" forKey:@"event_name"];
    }else if(eventName == redirect){
        [dic setObject:@"redirect" forKey:@"event_name"];
    }else if(eventName == search){
        [dic setObject:@"search" forKey:@"event_name"];
    }else if(eventName == addcart){
        [dic setObject:@"addcart" forKey:@"event_name"];
    }else if(eventName == collect){
        [dic setObject:@"collect" forKey:@"event_name"];
    }else if(eventName == scan){
        [dic setObject:@"scan" forKey:@"event_name"];
        [eventProp setObject:@(sdk.location.coordinate.latitude) forKey:@"latitude"];
        [eventProp setObject:@(sdk.location.coordinate.longitude) forKey:@"longitude"];
    }else if(eventName == share){
        [dic setObject:@"share" forKey:@"event_name"];
    }else if(eventName == registering){
        [dic setObject:@"register" forKey:@"event_name"];
    }
    
    if (eventProp != nil) {
        NSString *propsStr = [ChintBuriedPointSDK convertToJsonData:eventProp];
        if (propsStr != nil) {
            [dic setObject:propsStr forKey:@"event_prop"];
        }
    }
    
    NSMutableDictionary *pageDic = [pageArray lastObject];
    if (pageDic != nil) {
        [dic setObject:pageDic[@"referrer"] forKey:@"referrer"];
        [dic setObject:pageDic[@"in_time"] forKey:@"in_time"];
    }
    
    //保存到队列
    pageDic = [NSMutableDictionary dictionary];
    [pageDic setObject:pageName forKey:@"referrer"];
    [pageDic setObject:inTime forKey:@"in_time"];
    [pageArray addObject:pageDic];
    
    if (sdk.eventUrl.length > 0) {
        if (sdk.debug) {
            NSLog(@"%s, eventUrl:%@", __FUNCTION__, sdk.eventUrl);
        }
        [sdk requestDataUseBody:sdk.eventUrl method:@"post" paramDic:dic success:nil fail:nil];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%s, %@", __FUNCTION__, error);
}

bool locationed;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    if (locationed) {
        return;
    }
    locationed = YES;
    //经纬度
    _location = [locations firstObject];
    
    [self.manager stopUpdatingLocation];
    
    //临时用户id
    NSString *tempUserId = [self getTempUserId];
    //设备id
    NSString *deviceId =  [self getDeviceId];
    //分辨率
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat screenX = [UIScreen mainScreen].bounds.size.width * scale;
    CGFloat screenY = [UIScreen mainScreen].bounds.size.height * scale;
    NSString *resolution = [NSString stringWithFormat:@"%@*%@", @(screenX), @(screenY)];
    //机型
    NSString *deviceType = [ChintPhoneType iphoneType];
    //系统版本
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    //app版本
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    //运营商
    NSString *telInfo = [self telInfo];
    //网络类型
    NSString *networkType = [ChintPhoneType getNetconnType];
    _startTime = [self timeNow];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary: @{@"uuid_tmp":tempUserId, @"uuid":deviceId, @"platform":@"app", @"software_version":appVersion, @"latitude":@(_location.coordinate.latitude), @"longitude":@(_location.coordinate.longitude), @"mb_brand":@"iPhone", @"mb_model":deviceType, @"os":@"iOS", @"os_version":systemVersion, @"network_operator":telInfo, @"network_type":networkType, @"screen_resolution":resolution, @"app_startup_time":@([[ChintBuriedPointSDK sharedManager]getTimeStamp:_startTime])}];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.userInfoUrl.length > 0) {
            if (self.debug) {
                NSLog(@"%s, userInfoUrl:%@", __FUNCTION__, self.userInfoUrl);
            }
            
            [self requestDataUseBody:self.userInfoUrl method:@"post" paramDic:paramDic success:nil fail:nil];
        }
    });
}

/**
 原生请求方法
 */
- (void)requestDataUseBody:(NSString *)urlString method:(NSString *)method paramDic:(NSMutableDictionary *)paramDic success:(void(^)(void))success fail:(void(^)(void))fail{
    if (self.debug)
        NSLog(@"%s, paramDic:%@\n", __FUNCTION__, paramDic);
    if (paramDic == nil || paramDic.allKeys.count == 0) {
        return;
    }else{
        [paramDic setObject:sdk_version forKey:@"sdk_version"];
    }
    //服务器URL
    NSURL *url = [NSURL URLWithString:urlString];
    
    //分割符
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //http 参数body的字符串
    NSMutableString *paraBody=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [paramDic allKeys];
    //遍历keys
    for(int i = 0; i < [keys count] ; i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [paraBody appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [paraBody appendFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n",key];
        //添加字段的值
        [paraBody appendFormat:@"%@\r\n",[paramDic objectForKey:key]];
        if(self.debug)
            NSLog(@"参数%@ == %@",key,[paramDic objectForKey:key]);
    }
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData = [[NSMutableData alloc] init];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[paraBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //构建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"content-type"];
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%@", @([myRequestData length])] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:method];
    [request setHTTPBody:myRequestData];
    
    //构建会话
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    //会话任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *ra = (NSHTTPURLResponse *)response;
       
        if (data == nil && error != nil) {
            if (self.debug) {
                NSLog(@"%@, response:%@, data:%@, error:%@", urlString, response, data, error);
            }
            return;
        }
        
        NSDictionary *dictFromData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (self.debug) {
            NSLog(@"%@, response:%@, data:%@,error:%@", urlString, response, dictFromData, error);
        }
        if (ra.statusCode != 200) {
            if (fail) {
                fail();
            }
        }else{
            if (success) {
                success();
            }
        }
    }];
    [task resume];
}

- (NSString *)getDeviceId{
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    NSString *deviceId = [ChintSAMKeychain passwordForService:bundleId account:@"deviceId"];
    if (deviceId == nil || deviceId.length == 0) {
        deviceId = [self createUUID];
        [ChintSAMKeychain setPassword:deviceId forService:bundleId account:@"deviceId"];
    }
    return deviceId;
}

//获取本机运营商名称
- (NSString *)telInfo{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    //当前手机所属运营商名称
    NSString *mobile;
    
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        if (self.debug) {
            NSLog(@"没有SIM卡");
        }
        mobile = @"无运营商";
    }else{
        mobile = [carrier carrierName];
    }
    return mobile;
}

//生成uuid
- (NSString *)createUUID
{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
    CFRelease(uuidObject);
    return uuidStr;
}

- (NSString *)timeNow{
    NSDate *dateNow = [NSDate date];
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:formatStr];
    NSString *dateString = [date stringFromDate:dateNow];
    return dateString;
}

+ (void)exitApp:(NSString *)userId{
    ChintBuriedPointSDK *sdk = [ChintBuriedPointSDK sharedManager];
    NSString *outTime = [[ChintBuriedPointSDK sharedManager]timeNow];
//    NSTimeInterval duration = [sdk duration:sdk.startTime endTime:outTime];
    
    //更新本地标记
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *uDic = [userDefault valueForKey:userDicKey];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionaryWithDictionary:uDic];
    
    [userDic setObject:@YES forKey:outKey];
    [userDefault setValue:userDic forKey:userDicKey];
    [userDefault synchronize];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"uuid_tmp":[sdk getTempUserId], @"uuid":[sdk getDeviceId], @"app_using_time":@([sdk getTimeStamp:outTime])}];
    
    userId != nil ? [dic setObject:userId forKey:@"user_id"] : nil;
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    [df setValue:dic forKey:outInfoKey];
    [df synchronize];
//    NSLog(@"%s, %@", __FUNCTION__, @"退出保存成功");

}

- (NSString *)getTempUserId{
    NSString *userid;
    NSString *msg;
    //查看本地是否已经有用户id，时间，是否下过线
    //如果没有，则生成，并保存
    //如果有，则检查时间
    //超过三小时，检查是否下过线
    //下过线，生成新的
    //未下过线，返回用户id
    //未超过三小时，返回用户id
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [userDefault valueForKey:userDicKey];
//    NSLog(@"检查用户缓存： %@", userDic);
    //本地没有用户则生成
    if (userDic == nil) {
        msg = [NSString stringWithFormat:@"生成新用户userid:%@", userid];
        userid = [self createUUID];
        [self saveTempUser:userid];
    }else{//若已存在用户，检查时间
        userid = [userDic valueForKey:userIdKey];
        NSString *inTimeStr = [userDic valueForKey:inTimeKey];
        BOOL outFlag = [[userDic valueForKey:outKey]boolValue];
        NSString *curTimeStr = [self timeNow];
        msg = [NSString stringWithFormat:@"已经存在用户userid:%@", userid];
        NSTimeInterval duration = [self duration:inTimeStr endTime:curTimeStr];
        if (duration > 3600*3 && outFlag) {//超过3小时，且下线过
            userid = [self createUUID];
            [self saveTempUser:userid];
            msg = [NSString stringWithFormat:@"用户已超时，新生成userid:%@", userid];
        }
    }
    if (self.debug) {
        NSLog(@"%s, msg:%@", __FUNCTION__, msg);
    }
    return userid;
}

/** 保存临时用户 */
- (void)saveTempUser:(NSString *)userId{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *timeStr = [self timeNow];
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    [userDic setObject:userId forKey:userIdKey];
    [userDic setObject:timeStr forKey:inTimeKey];
    [userDic setObject:@NO forKey:outKey];
    [userDefault setValue:userDic forKey:userDicKey];
    [userDefault synchronize];
}

- (NSTimeInterval)duration:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:formatStr];
    NSDate *inDate=[formatter dateFromString:startTime];
    NSTimeInterval inSeconds = [inDate timeIntervalSinceNow];
    NSDate *dateNow=[formatter dateFromString:endTime];
    NSTimeInterval nowSeconds = [dateNow timeIntervalSinceNow];
//    NSLog(@"startTime=%@, endTime=%@", startTime, endTime);
    NSTimeInterval duration = nowSeconds - inSeconds;
//    NSLog(@"nowSeconds=%@, inSeconds=%@, duration=%@", @(nowSeconds), @(inSeconds), @(duration));
    return duration;
}

- (NSTimeInterval)getTimeStamp:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:formatStr];
    NSDate *inDate=[formatter dateFromString:timeStr];
    return [inDate timeIntervalSince1970]*1000;
}

- (CLLocationManager *)manager{
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    if (dict == nil) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = @"";
    if (jsonData != nil)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return jsonString;
}

- (void)setProduct:(BOOL)product{
    _product = product;
    
    if(self.product){
        self.userInfoUrl = @"https://hk-ecbi-event.fastretailing.com/datarcvr/user/app";
        self.eventUrl = @"https://hk-ecbi-event.fastretailing.com/datarcvr/event";
    }else{
        self.userInfoUrl = @"https://hk-ecbi-uat.fastretailing.com/datarcvr/user/app";
        self.eventUrl = @"https://hk-ecbi-uat.fastretailing.com/datarcvr/event";
    }
}
@end
