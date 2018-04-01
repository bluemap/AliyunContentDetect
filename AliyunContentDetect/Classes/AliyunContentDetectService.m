/*
 *****************************************************************************
 * File            : AliyunContentDetectService
 *
 * Description    : AliyunContentDetectService
 *
 * Author        : bluemap@163.com
 *
 * History        : Creation, 2018.03.04, bluemap@163.com, Create the file
 * 协议：https://help.aliyun.com/document_detail/63003.html?spm=a2c4g.11186623.6.553.hdPAyc
 ******************************************************************************
 **/

#import "AliyunContentDetectService.h"
#import <AFNetworking/AFNetworking.h>
#import "AliyunContentDetectTask.h"
#import "AliyunContentDetectConfig.h"
#import "ObserverContainer.h"
#import <NSString+Hash.h>
#import "AliyunTaskParamUtility.h"

#define kIdentifyQureyVideoResults @"kIdentifyQureyVideoResults"

@interface AliyunContentDetectService() <AliyunContentDetectTaskDelegate>

@property (nonatomic, strong) NSMutableDictionary   *detectCache;
@property (nonatomic, strong) NSMutableDictionary   *videoResults;
@property (nonatomic, strong) NSMutableArray        *tasks;
@property (nonatomic, strong) NSTimer               *timer;
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
        self.videoResults = [[NSMutableDictionary alloc]init];
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

- (NSDictionary *)detectResultForURL:(NSString *)url
{
    NSString *identify = [url md5String];
    return  [self cacheForIdentify:identify];
}

- (NSDictionary *)cacheForIdentify:(NSString *)identify
{
    return [self.detectCache objectForKey:identify];
}

- (void)imageDetectWithURL:(NSString *)url type:(EDetectType)type
{
    NSString *identify = url;
    
    NSDictionary *cache = [self cacheForIdentify:identify];
    if (cache)
    {
        [self notifyContectDetectFinish:identify result:cache error:nil];
        return;
    }
    
    NSDictionary *params = [AliyunTaskParamUtility taskParamsWithURL:url type:type];
    
    AliyunContentDetectTask *detectTask = [[AliyunContentDetectTask alloc] initWithAccessKey:[self accessKey] secretKey:[self secretKey] baseAddr:kAliyunContentBaseAddr uri:kImagePornDetectUri];
    detectTask.params = params;
    detectTask.identify = identify;
    detectTask.delegate = self;
    [detectTask startTask];
    
    [self.tasks addObject:detectTask];
}

- (void)videoDetectWithURL:(NSString *)url type:(EDetectType)type
{
    NSString *identify = url;
    
    NSDictionary *cache = [self cacheForIdentify:identify];
    if (cache)
    {
        [self notifyContectDetectFinish:identify result:cache error:nil];
        return;
    }
    
    NSDictionary *params = [AliyunTaskParamUtility taskParamsWithURL:url type:type];
    
    AliyunContentDetectTask *detectTask = [[AliyunContentDetectTask alloc] initWithAccessKey:[self accessKey] secretKey:[self secretKey] baseAddr:kAliyunContentBaseAddr uri:kVideoPornDetectUri];
    detectTask.params = params;
    detectTask.identify = identify;
    detectTask.delegate = self;
    [detectTask startTask];
    
    [self.tasks addObject:detectTask];
}

- (void)notifyContectDetectFinish:(NSString *)url result:(NSDictionary *)result error:(NSError *)error
{
    [self.observers enumerateObjectsUsingBlock:^(NSObject<AliyunContentDetectServiceObserver> * _Nonnull observer, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([observer respondsToSelector:@selector(contectDetectFinish:result:error:)])
        {
            [observer contectDetectFinish:url result:result error:error];
        }
        
    }];
}

- (void)startTimer
{
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(queryVideoResults) userInfo:nil repeats:YES];
    }
}

//轮训视频检测结果
- (void)queryVideoResults
{
    NSMutableArray *taskIds = [NSMutableArray array];
    
    [self.detectCache enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSDictionary *result = (NSDictionary *)obj;
        if (result)
        {
            NSArray *array = [result objectForKey:@"data"];
            NSDictionary *taskInfo = [array firstObject];
            if (taskInfo && [taskInfo objectForKey:@"dataId"])
            {//只有video相关接口设置了dataId
                NSString *taskId = [taskInfo objectForKey:@"taskId"];
                if (taskId && ![self.videoResults objectForKey:taskId])
                {
                    [taskIds addObject:taskId];
                }
            }
        }
    }];
    
    if (taskIds.count > 0)
    {
        AliyunContentDetectTask *detectTask = [[AliyunContentDetectTask alloc] initWithAccessKey:[self accessKey] secretKey:[self secretKey] baseAddr:kAliyunContentBaseAddr uri:kVideoPornResultUri];
        detectTask.arrayParams = taskIds;
        detectTask.identify = kIdentifyQureyVideoResults;
        detectTask.delegate = self;
        [detectTask startTask];
        
        [self.tasks addObject:detectTask];
    }
}
#pragma mark AliyunContentDetectTaskDelegate
- (void)taskFinished:(AliyunContentDetectTask *)task result:(NSDictionary *)result error:(NSError *)error
{
    if (result && [[result objectForKey:@"code"]integerValue] == 200)
    {
        if ([task.identify isEqualToString:kIdentifyQureyVideoResults])
        {//视频检测结果
            NSArray *results = [result objectForKey:@"data"];
            for (NSDictionary *videoResult in results)
            {
                NSString *taskId = [videoResult objectForKey:@"taskId"];
                if (taskId)
                {
                    [self.videoResults setObject:videoResult forKey:taskId];
                }
            }
        }
        else
        {
            [self.detectCache setObject:result forKey:task.identify];
            
            NSArray *array = [result objectForKey:@"data"];
            NSDictionary *taskInfo = [array firstObject];
            if (taskInfo && [taskInfo objectForKey:@"dataId"])
            {
                [self startTimer];
            }
        }
    }
    
    [self notifyContectDetectFinish:task.identify result:result error:error];
    
    [self.tasks removeObject:task];
}

@end
