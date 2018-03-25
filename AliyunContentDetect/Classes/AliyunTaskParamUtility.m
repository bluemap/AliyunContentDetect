//
//  AliyunTaskParamUtility.m
//  AFNetworking
//
//  Created by lijin on 2018/3/18.
//

#import "AliyunTaskParamUtility.h"

@implementation AliyunTaskParamUtility

+ (NSString *)UUIDString
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

+ (NSArray *)sortParamKeyArray:(NSArray *)paramKeys
{
    NSArray *sortedArray = nil;
    if(paramKeys)
    {
        sortedArray = [paramKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *key1 = obj1;
            NSString *key2 = obj2;
            return [key1 compare:key2];
        }];
    }
    return sortedArray;
}

+ (NSString *)signatureWithParams:(NSDictionary *)params sortedKeys:(NSArray *)sortedKeys
{
    NSMutableString *dataStr = [[NSMutableString alloc] init];
    
    for (NSString *key in sortedKeys)
    {
        NSString *value = [params objectForKey:key];
        if (value)
        {
            NSString *paramStr = [NSString stringWithFormat:@"%@:%@%@",key,value,kSeparate];
            [dataStr appendString:paramStr];
        }
    }
    return dataStr;
}

@end
