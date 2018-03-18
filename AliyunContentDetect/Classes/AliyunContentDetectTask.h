//
//  AliyunContentDetectTask.h
//  AFNetworking
//
//  Created by lijin on 2018/3/18.
//

#import <Foundation/Foundation.h>

@interface AliyunContentDetectTask : NSObject

- (id)initWithAccessKey:(NSString *)accessKey baseAddr:(NSString *)baseAddr uri:(NSString *)uri;

@property (nonatomic, strong) NSDictionary *params;

- (void)startTask;

@end
