//
//  AliyunTaskParamUtility.h
//  AFNetworking
//
//  Created by lijin on 2018/3/18.
//

#import <Foundation/Foundation.h>

#define kSeparate           @"\n"

@interface AliyunTaskParamUtility : NSObject

+ (NSString *)UUIDString;
+ (NSArray *)sortParamKeyArray:(NSArray *)paramKeys;
+ (NSString *)signatureWithParams:(NSDictionary *)params sortedKeys:(NSArray *)sortedKeys;

@end
