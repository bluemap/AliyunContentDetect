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

@interface AliyunContentDetectService : NSObject

+ (void)setAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;
+ (id)sharedInstance;

@end
