//
//  AliyunContentDetectTask.m
//  AFNetworking
//
//  Created by lijin on 2018/3/18.
//

#import "AliyunContentDetectTask.h"
#import "NSData+MD5.h"
#import <Base64.h>
#import "AliyunTaskParamUtility.h"
#import <AFNetworking.h>

#define kHeaderAccept       @"Accept"
#define kHeaderContentType  @"Content-Type"
#define kHeaderContentMD5   @"Content-MD5"
#define kHeaderDate         @"Date"
#define kHeaderxacsversion          @"x-acs-version"            //内容安全接口版本，当前版本为：2017-01-12
#define kHeaderxacssignaturenonce   @"x-acs-signature-nonce"    //随机字符串，用来避免回放攻击
#define kHeaderxacssignatureversion @"x-acs-signature-version"  //签名版本，目前取值：1.0
#define kHeaderxacssignaturemethod  @"x-acs-signature-method"   //签名方法，目前只支持: HMAC-SHA1
//认证方式，取值格式为：”acs” + “ “ + AccessKeyId + “:” + signature。其中AccessKeyId从阿里云控制台申请所得，而signature为请求签名。
#define kHeaderAuthorization        @"Authorization"

#define kResponsCode        @"code"
#define kResponsMsg         @"msg"
#define kResponsRequestId   @"requestid"
#define kResponsData        @"data"


@interface AliyunContentDetectTask()
@property (nonatomic, strong) AFURLSessionManager *manager;
@end

@implementation AliyunContentDetectTask

- (NSString *)gmtTimeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss 'GMT'"];
    
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    return timeStr;
}

- (NSString *)signature
{
    return nil;
}

- (NSMutableURLRequest *)makeRequestWith:(NSDictionary *)parameters
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *contentMD5 = [[jsonData md5Data]base64EncodedString];
    
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:kHeaderAccept];
    [serializer setValue:@"application/json" forHTTPHeaderField:kHeaderContentType];
    [serializer setValue:contentMD5 forHTTPHeaderField:kHeaderContentMD5];//根据请求body计算所得，算法为先对body做md5，再做base64编码所得
    [serializer setValue:@"application/json" forHTTPHeaderField:kHeaderDate];
    [serializer setValue:[self gmtTimeStr] forHTTPHeaderField:kHeaderDate];
    [serializer setValue:@"2017-01-12" forHTTPHeaderField:kHeaderxacsversion];
    [serializer setValue:[AliyunTaskParamUtility UUIDString] forHTTPHeaderField:kHeaderxacssignaturenonce];
    [serializer setValue:@"1.0" forHTTPHeaderField:kHeaderxacssignatureversion];
    [serializer setValue:@"HMAC-SHA1" forHTTPHeaderField:kHeaderxacssignaturemethod];
    [serializer setValue:[NSString stringWithFormat:@"acs %@:%@",_accessKey,[self signature]] forHTTPHeaderField:kHeaderAuthorization];//todo:
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:self.url parameters:nil error:nil];
    [request setHTTPBody:jsonData];
    
    return request;
}

//{
//    "scenes": ["porn"],
//    "tasks": [
//              {
//                  "dataId": "test2NInmO$tAON6qYUrtCRgLo-1mwxdi",
//                  "url": "https://img.alicdn.com/tfs/TB1urBOQFXXXXbMXFXXXXXXXXXX-1442-257.png"
//              }
//              ]
//}
- (void)startTask
{
    NSDictionary *parameters = nil;//todo:
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                  URLString:self.url
                                                                                 parameters:parameters
                                                                                      error:nil];
    request.timeoutInterval = 25.0;
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //设置返回数据序列化对象
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
    }];
    
    [dataTask resume];
}

@end
