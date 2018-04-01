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

#import <Foundation/Foundation.h>
#import "AliyunContectDetectDefine.h"

@protocol AliyunContentDetectServiceObserver<NSObject>
@optional
- (void)contectDetectFinish:(NSString *)url result:(NSDictionary *)result error:(NSError *)error;
@end

@interface AliyunContentDetectService : NSObject

+ (void)setAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

+ (instancetype)sharedInstance;

- (void)addObserver:(NSObject<AliyunContentDetectServiceObserver> *)observer;
- (void)removeObserver:(NSObject<AliyunContentDetectServiceObserver> *)observer;
- (void)imageDetectWithURL:(NSString *)url type:(EDetectType)type;
- (void)videoDetectWithURL:(NSString *)url type:(EDetectType)type;

- (NSDictionary *)detectResultForURL:(NSString *)url;

@end
