/*
 *****************************************************************************
 * File            : AliyunContentDetectService
 *
 * Description    : AliyunContentDetectService
 *
 * Author        : bluemap@163.com
 *
 * History        : Creation, 2018.03.04, bluemap@163.com, Create the file
 ******************************************************************************
 **/

#import "AliyunContentDetectService.h"
#import <AFNetworking/AFNetworking.h>

@interface AliyunContentDetectService()

@end

static NSString *g_accessKey = nil;
static NSString *g_secretKey = nil;

@implementation AliyunContentDetectService

+ (void)setAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    g_accessKey = accessKey;
    g_secretKey = secretKey;
}

+ (id)sharedInstance
{
    static AliyunContentDetectService *g_instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_instace = [[AliyunContentDetectService alloc] init];
    });
    return g_instace;
}

- (NSString *)accessKey
{
    return g_accessKey;
}

- (NSString *)secretKey
{
    return g_secretKey;
}
@end
