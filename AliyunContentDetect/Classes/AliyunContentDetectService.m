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
#import "ObserverContainer.h"
#import <NSString+Hash.h>
#import "AliyunTaskParamUtility.h"


@interface AliyunContentDetectService() <AliyunContentDetectTaskDelegate>

@property (nonatomic, strong) NSMutableDictionary *detectCache;
@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) ObserverContainer<NSObject<AliyunContentDetectServiceObserver> *> *observers;

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

- (id)init
{
    self = [super init];
    if (self)
    {
        self.observers = [[ObserverContainer<NSObject<AliyunContentDetectServiceObserver> *> alloc]init];
        self.detectCache = [[NSMutableDictionary alloc]init];
        self.tasks = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSString *)accessKey
{
    return g_accessKey;
}

- (NSString *)secretKey
{
    return g_secretKey;
}

- (void)addObserver:(NSObject<AliyunContentDetectServiceObserver> *)observer
{
    [self.observers addObserver:observer];
}

- (void)removeObserver:(NSObject<AliyunContentDetectServiceObserver> *)observer
{
    [self.observers removeObserver:observer];
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
- (void)pornImageDetectWithURL:(NSString *)url
{
    NSString *identify = [url md5String];
    
    NSDictionary *params = [AliyunTaskParamUtility taskParamsWithURL:url type:EImagePorn];
    
    AliyunContentDetectTask *detectTask = [[AliyunContentDetectTask alloc] initWithAccessKey:[self accessKey] secretKey:[self secretKey] baseAddr:kAliyunContentBaseAddr uri:kPornDetectUri];
    detectTask.params = params;
    detectTask.identify = identify;
    detectTask.delegate = self;
    [detectTask startTask];
    
    [self.tasks addObject:detectTask];
}

- (void)notifyContectDetectFinish:(NSDictionary *)result error:(NSError *)error
{
    [self.observers enumerateObjectsUsingBlock:^(NSObject<AliyunContentDetectServiceObserver> * _Nonnull observer, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([observer respondsToSelector:@selector(contectDetectFinish:error:)])
        {
            [observer contectDetectFinish:result error:error];
        }
        
    }];
}

#pragma mark AliyunContentDetectTaskDelegate
- (void)taskFinished:(AliyunContentDetectTask *)task result:(NSDictionary *)result error:(NSError *)error
{
    if (result && [[result objectForKey:@"code"]integerValue] == 200)
    {
        [self.detectCache setObject:result forKey:task.identify];
    }
    
    [self notifyContectDetectFinish:result error:error];
    
    [self.tasks removeObject:task];
}

@end
