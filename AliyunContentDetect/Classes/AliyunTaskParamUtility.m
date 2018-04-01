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
            params = [self.class imageDetectParamsWithURL:url scene:@"porn"];
            break;
        }
        case EImageTerrorism:
        {
            params = [self.class imageDetectParamsWithURL:url scene:@"terrorism"];
            break;
        }
        case EImageOCR:
        {
            params = [self.class imageDetectParamsWithURL:url scene:@"ocr"];
            break;
        }
        case EImageSface:
        {
            params = [self.class imageDetectParamsWithURL:url scene:@"sface"];
            break;
        }
        case EImageAd:
        {
            params = [self.class imageDetectParamsWithURL:url scene:@"ad"];
            break;
        }
        case EImageQrcode:
        {
            params = [self.class imageDetectParamsWithURL:url scene:@"qrcode"];
            break;
        }
        case EImageLive:
        {
            params = [self.class imageDetectParamsWithURL:url scene:@"live"];
            break;
        }
        case EImageLogo:
        {
            params = [self.class imageDetectParamsWithURL:url scene:@"logo"];
            break;
        }
        case EVideoPorn:
        {
            params = [self.class videoDetectParamsWithURL:url scene:@"porn"];
            break;
        }
        case EVideoTerrorism:
        {
            params = [self.class videoDetectParamsWithURL:url scene:@"terrorism"];
            break;
        }
        case EVideoLive:
        {
            params = [self.class videoDetectParamsWithURL:url scene:@"live"];
            break;
        }
        case EVideoSface:
        {
            params = [self.class videoDetectParamsWithURL:url scene:@"sface"];
            break;
        }
        case EVideoAd:
        {
            params = [self.class videoDetectParamsWithURL:url scene:@"ad"];
            break;
        }
        case EVideoLogo:
        {
            params = [self.class videoDetectParamsWithURL:url scene:@"logo"];
            break;
        }
        case EVoiceAntispam:
        {
            break;
        }
        case ETextAntispam:
        {
            break;
        }
            
        default:
            break;
    }
    return params;
}

+ (NSDictionary *)imageDetectParamsWithURL:(NSString *)url scene:(NSString *)scene
{
    if (url && scene)
    {
        NSDictionary *taskURL = @{@"url":url};
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@[scene] forKey:@"scenes"];
        [params setObject:@[taskURL] forKey:@"tasks"];
        
        return params;
    }
    else
    {
        return nil;
    }
}

+ (NSDictionary *)videoDetectParamsWithURL:(NSString *)url scene:(NSString *)scene
{
    if (url && scene)
    {
        NSDictionary *taskParam = @{@"url":url,@"interval":@"1",@"maxFrames":@"200",@"dataId":url};
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@[scene] forKey:@"scenes"];
        [params setObject:@[taskParam] forKey:@"tasks"];
        
        return params;
    }
    else
    {
        return nil;
    }
}
@end
