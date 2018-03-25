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

@protocol AliyunContentDetectServiceObserver<NSObject>
@optional
- (void)contectDetectFinish:(NSDictionary *)result error:(NSError *)error;
@end

@interface AliyunContentDetectService : NSObject

+ (void)setAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

+ (instancetype)sharedInstance;

- (void)addObserver:(NSObject<AliyunContentDetectServiceObserver> *)observer;
- (void)removeObserver:(NSObject<AliyunContentDetectServiceObserver> *)observer;
- (void)pornImageDetectWithURL:(NSString *)url;

@end
