//
//  AliyunContentDetectTask.h
//  AFNetworking
//
//  Created by lijin on 2018/3/18.
//

#import <Foundation/Foundation.h>

@class AliyunContentDetectTask;

@protocol AliyunContentDetectTaskDelegate <NSObject>

- (void)taskFinished:(AliyunContentDetectTask *)task result:(NSDictionary *)result error:(NSError *)error;

@end

@interface AliyunContentDetectTask : NSObject

- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey baseAddr:(NSString *)baseAddr uri:(NSString *)uri;

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *identify;
@property (nonatomic, assign) NSObject <AliyunContentDetectTaskDelegate> *delegate;

- (void)startTask;

@end
