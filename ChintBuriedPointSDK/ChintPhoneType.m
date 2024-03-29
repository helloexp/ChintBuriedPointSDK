//
//  ChintPhoneType.m
//  ChintBuriedPointSDK
//
//  Created by lucky－ios on 2018/9/11.
//  Copyright © 2018年 com.chint. All rights reserved.
//

#import "ChintPhoneType.h"
#import "ChintPhoneType.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "ChintReachability.h"

@implementation ChintPhoneType
+ (NSString*)iphoneType{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    return platform;
}
+ (NSString *)getNetconnType{
    
    NSString *netconnType = @"";
    
    ChintReachability *reach = [ChintReachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case CNotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case CReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case CReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}
@end
