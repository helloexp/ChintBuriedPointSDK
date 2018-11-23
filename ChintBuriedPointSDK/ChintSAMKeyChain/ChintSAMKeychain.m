//
//  ChintSAMKeychain.m
//  ChintBuriedPointSDK
//
//  Created by lucky－ios on 2018/9/11.
//  Copyright © 2018年 com.chint. All rights reserved.
//

#import "ChintSAMKeychain.h"
#import "ChintSAMKeychainQuery.h"

NSString *const kSAMKeychainErrorDomain = @"com.samsoffes.samkeychain";
NSString *const kSAMKeychainAccountKey = @"acct";
NSString *const kSAMKeychainCreatedAtKey = @"cdat";
NSString *const kSAMKeychainClassKey = @"labl";
NSString *const kSAMKeychainDescriptionKey = @"desc";
NSString *const kSAMKeychainLabelKey = @"labl";
NSString *const kSAMKeychainLastModifiedKey = @"mdat";
NSString *const kSAMKeychainWhereKey = @"svce";

#if __IPHONE_4_0 && TARGET_OS_IPHONE
static CFTypeRef SAMKeychainAccessibilityType = NULL;
#endif

@implementation ChintSAMKeychain

+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account {
    return [self passwordForService:serviceName account:account error:nil];
}


+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    ChintSAMKeychainQuery *query = [[ChintSAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    [query fetch:error];
    return query.password;
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account {
    return [self passwordDataForService:serviceName account:account error:nil];
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    ChintSAMKeychainQuery *query = [[ChintSAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    [query fetch:error];
    
    return query.passwordData;
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account {
    return [self deletePasswordForService:serviceName account:account error:nil];
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    ChintSAMKeychainQuery *query = [[ChintSAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    return [query deleteItem:error];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account {
    return [self setPassword:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    ChintSAMKeychainQuery *query = [[ChintSAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.password = password;
    return [query save:error];
}

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account {
    return [self setPasswordData:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    ChintSAMKeychainQuery *query = [[ChintSAMKeychainQuery alloc] init];
    query.service = serviceName;
    query.account = account;
    query.passwordData = password;
    return [query save:error];
}

+ (nullable NSArray *)allAccounts {
    return [self allAccounts:nil];
}


+ (nullable NSArray *)allAccounts:(NSError *__autoreleasing *)error {
    return [self accountsForService:nil error:error];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName {
    return [self accountsForService:serviceName error:nil];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName error:(NSError *__autoreleasing *)error {
    ChintSAMKeychainQuery *query = [[ChintSAMKeychainQuery alloc] init];
    query.service = serviceName;
    return [query fetchAll:error];
}


#if __IPHONE_4_0 && TARGET_OS_IPHONE
+ (CFTypeRef)accessibilityType {
    return SAMKeychainAccessibilityType;
}


+ (void)setAccessibilityType:(CFTypeRef)accessibilityType {
    CFRetain(accessibilityType);
    if (SAMKeychainAccessibilityType) {
        CFRelease(SAMKeychainAccessibilityType);
    }
    SAMKeychainAccessibilityType = accessibilityType;
}
#endif

@end
