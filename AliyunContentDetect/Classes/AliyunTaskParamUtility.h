//
//  AliyunTaskParamUtility.h
//  AFNetworking
//
//  Created by lijin on 2018/3/18.
//

#import <Foundation/Foundation.h>
#import "AliyunContectDetectDefine.h"

@interface AliyunTaskParamUtility : NSObject

+ (NSString *)UUIDString;
+ (NSArray *)sortParamKeyArray:(NSArray *)paramKeys;
+ (NSString *)signatureWithParams:(NSDictionary *)params sortedKeys:(NSArray *)sortedKeys;
+ (NSDictionary *)taskParamsWithURL:(NSString *)url type:(EDetectType)type;

@end
