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

+ (NSDictionary *)taskParamsWithURL:(NSString *)url type:(EDetectType)type
{
    NSDictionary *params = nil;
    switch (type) {
        case EImagePorn:
        {
            params = [self.class imagePornParamsWithURL:url];
            break;
        }
        case EImageTerrorism:
        {
            break;
        }
        case EImageOCR:
        {
            break;
        }
        case EImageSface:
        {
            break;
        }
        case ETextAntispam:
        {
            break;
        }
        case EImageAd:
        {
            break;
        }
        case EImageLive:
        {
            break;
        }
        case EImageLogo:
        {
            break;
        }
        case EVideoPorn:
        {
            break;
        }
        case EVideoTerrorism:
        {
            break;
        }
        case EVideoLive:
        {
            break;
        }
        case EVideoSface:
        {
            break;
        }
        case EVideoAd:
        {
            break;
        }
        case EVideoLogo:
        {
            break;
        }
        case EVoiceAntispam:
        {
            break;
        }
            
        default:
            break;
    }
    return params;
}

+ (NSDictionary *)imagePornParamsWithURL:(NSString *)url
{
    NSDictionary *taskURL = @{@"url":url};
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@[@"porn"] forKey:@"scenes"];
    [params setObject:@[taskURL] forKey:@"tasks"];
    
    return taskURL;
}
@end
