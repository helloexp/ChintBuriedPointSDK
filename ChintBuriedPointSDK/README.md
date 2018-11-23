ChintBuriedPointSDK

简介：埋点程序SDK1.1.6
版本：1.1.4    时间：20180930 修改：去除埋点数据中多余的回车换行字符；
版本：1.1.5    时间：20181016 修改：setupWithAppId修改为私有方法，并增加local参数；
                                                              local值默认为CN，香港传HK；
                                                              修复Reachability冲突bug；
版本：1.1.6    时间：20181024 修改：修复网络异常闪退问题；
                                                              优化了日志的顺序，生成新用户id打印不再是null；
版本：1.1.7    时间：20181024 修改：香港服务器地址变更为//hk-ecbi-event.fastretailing.com 
版本：1.1.8    时间：20181029 修改：product=NO香港服务器地址为: hk-ecbi-uat.fastretailing.com
                                                             product=YES(默认)香港服务器地址为: hk-ecbi-event.fastretailing.com
版本：1.2.2    时间：20181119 修改：上传id改为uuid，上传时间格式统一为时间戳（in_time）

备注：只支持真机调试，版本 >= iOS 9
组成：
	ChintBuriedPointSDK.h
	libChintBuriedPointSDK.a
更新：
        事件接口，scan事件增加shop参数，后台传入经纬度坐标
用法：
	1.将包含两个文件的文件夹导入工程；

	2.info.plist文件需要添加NSLocationWhenInUseUsageDescription设置
	或直接添加一下代码
		<key>NSLocationWhenInUseUsageDescription</key>
		<string>需要授权才能访问位置</string>
	3.初始化代码：
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [[ChintBuriedPointSDK sharedManager] setupWithAppId:appId local:@"CN|HK"];
    		return YES;
      }
	4.退出app代码
	- (void)applicationWillTerminate:(UIApplication *)application {
    		[ChintBuriedPointSDK exitApp:userId];//userId为用户会员id，可为nil
	}

打开调试日志模式：
[ChintBuriedPointSDK sharedManager].debug = YES;

事件跟踪接口用法：
1. 首页
1.1 参数说明
/**
事件跟踪
@param userId 登录用户id（可为nil）
@param pageName 页面Url（必填）
@param pageType 页面类型（必填）
@param eventName 事件名称（必填firstPage）
@param eventProp 自定义字典（为nil）
*/
1.2 示例：
[ChintBuriedPointSDK traceEventWithUserId:nil pageName:@"firstPageUrl" pageType:@"customPageType" eventName:firstPage eventProp:nil];

2. 跳转
2.1 参数说明
/**
事件跟踪
@param userId 登录用户id（可为nil）
@param pageName 页面Url（必填）
@param pageType 页面类型（必填）
@param eventName 事件名称（必填redirect）
@param eventProp 自定义字典（为nil）
*/
2.2 示例：
[ChintBuriedPointSDK traceEventWithUserId:nil pageName:@"curPageUrl" pageType:@"customPageType" eventName:redirect eventProp:nil];

3. 搜索
3.1 参数说明
/**
事件跟踪
@param userId 登录用户id（可为nil）
@param pageName 页面Url（必填）
@param pageType 页面类型（必填）
@param eventName 事件名称（必填search）
@param eventProp 自定义字典（必须，格式: @{@“keywords”:@"keyword1, keyword2, ..."}）
*/
3.2  示例：
[ChintBuriedPointSDK traceEventWithUserId:nil pageName:@"curPageUrl" pageType:@"customPageType" eventName:search eventProp:@{@"keywords", @"商品1, 商品2"}];

4.加购
4.1 参数说明
/**
事件跟踪
@param userId 登录用户id（必填）
@param pageName 页面Url（必填）
@param pageType 页面类型（必填）
@param eventName 事件名称（必填addcart）
@param eventProp 自定义字典（必须，格式: 
                                                                        {det：[
                                                                        {
                                                                        sku : ’sku’ ,  //选填，商品的sku
                                                                        spu : ’spu’,   //必填，商品的spu
                                                                        num : num   //必填，商品的加购数量
                                                                        }，
                                                                        {
                                                                        sku : ’sku’ ,  //选填，商品的sku
                                                                        spu : ’spu’,   //必填，商品的spu
                                                                        num : num   //必填，商品的加购数量
                                                                        }
                                                                        ],...}) 
*/
示例：
NSDictionary *productA = @{@"sku":@"sku", @"spu":@"spu", @"num": @(1)};
NSDictionary *productB = @{@"sku":@"sku", @"spu":@"spu", @"num": @(1)};
NSDictionary *eventPro = @{@"det":@[productA, productB]};
[ChintBuriedPointSDK traceEventWithUserId:nil pageName:@"curPageUrl" pageType:@"customPageType" eventName:addcart eventProp:eventPro];

5.收藏
5.1 参数说明
/**
事件跟踪
@param userId 登录用户id（必填）
@param pageName 页面Url（必填）
@param pageType 页面类型（必填）
@param eventName 事件名称（必填，collect）
@param eventProp 自定义字典（必须，格式: 
                                                                    {
                                                                        optype : ’add | del’,  //必填，收藏的操作方向
                                                                        det：[
                                                                        {
                                                                            sku : ’sku’ ,  //选填，商品的sku
                                                                            spu : ’spu’   //必填，商品的spu
                                                                        }
                                                                        ]
                                                                    }
) 
*/
示例：
NSDictionary *productA = @{@"sku":@"sku", @"spu":@"spu", @"num": @(1)};
NSDictionary *eventPro = @{@"optype":@"add", @"det":@[productA]};
[ChintBuriedPointSDK traceEventWithUserId:nil pageName:@"curPageUrl" pageType:@"customPageType" eventName:collect eventProp:eventPro];

6.扫码
6.1 参数说明
/**
事件跟踪
@param userId 登录用户id（可选）
@param pageName 页面Url（必填）
@param pageType 页面类型（必填）
@param eventName 事件名称（必填scan）
@param eventProp 自定义字典（必须，格式: 
                                                                        {
                                                                            sku : ’sku’ ,  //选填，商品的sku
                                                                            spu : ’spu’  //必填，商品的spu
                                                                            shop : ’shop’  //必填，商铺的名称
                                                                        }) 
*/
示例：
NSDictionary *eventPro = @{@"sku":@"sku", @"spu":@"spu", @"num": @(1)};
[ChintBuriedPointSDK traceEventWithUserId:nil pageName:@"curPageUrl" pageType:@"customPageType" eventName:scan eventProp:eventPro];

7.分享
7.1 参数说明
/**
事件跟踪
@param userId 登录用户id（可选）
@param pageName 页面Url（必填）
@param pageType 页面类型（必填）
@param eventName 事件名称（必填share）
@param eventProp 自定义字典（必须，格式: 
                                                                        {
                                                                            sku : ’sku’ ,  //选填，商品的sku
                                                                            spu : ’spu’  //必填，商品的spu
                                                                        }) 
*/
示例：
NSDictionary *eventPro = @{@"sku":@"sku", @"spu":@"spu", @"num": @(1)};
[ChintBuriedPointSDK traceEventWithUserId:nil pageName:@"curPageUrl" pageType:@"customPageType" eventName:share eventProp:eventPro];

8.注册
8.1 参数说明
/**
事件跟踪
@param userId 登录用户id（可选）
@param pageName 页面Url（必填）
@param pageType 页面类型（必填）
@param eventName 事件名称（必填registering）
@param eventProp 自定义字典（为nil）
*/
示例：
[ChintBuriedPointSDK traceEventWithUserId:nil pageName:@"curPageUrl" pageType:@"customPageType" eventName:registering eventProp:nil];
