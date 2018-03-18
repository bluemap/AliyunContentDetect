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
#import "AliyunContentDetectTask.h"
#import "AliyunContentDetectConfig.h"

@interface AliyunContentDetectService()

@property (nonatomic, strong) AliyunContentDetectTask *pornTask;

@end

static NSString *g_accessKey = nil;
static NSString *g_secretKey = nil;

@implementation AliyunContentDetectService

+ (void)setAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey
{
    g_accessKey = accessKey;
    g_secretKey = secretKey;
}

+ (instancetype)sharedInstance
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

/*
{
    "scenes": ["porn"],
    "tasks": [
              {
                  "dataId": "test2NInmO$tAON6qYUrtCRgLo-1mwxdi",
                  "url": "https://img.alicdn.com/tfs/TB1urBOQFXXXXbMXFXXXXXXXXXX-1442-257.png"
              }
              ]
}
*/
- (void)pornDetectWithURL:(NSString *)url
{
    NSDictionary *task = @{@"url":url};
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@[@"porn"] forKey:@"scenes"];
    [params setObject:@[task] forKey:@"tasks"];
    
    self.pornTask = [[AliyunContentDetectTask alloc] initWithAccessKey:[self accessKey] baseAddr:kAliyunContentBaseAddr uri:kPornDetectUri];
    self.pornTask.params = params;
    [self.pornTask startTask];
    
}

@end
