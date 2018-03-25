//
//  AliyunContentDetectTask.m
//  AFNetworking
//
//  Created by lijin on 2018/3/18.
//

#import "AliyunContentDetectTask.h"
#import <Base64.h>
#import <AFNetworking.h>
#import "AliyunTaskParamUtility.h"
#import "NSData+MD5.h"
#import "CocoaSecurity.h"
#import <NSString+URLEncode.h>

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

@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, strong) NSString *baseAddr;
@property (nonatomic, strong) NSString *uri;

@end

@implementation AliyunContentDetectTask

- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey baseAddr:(NSString *)baseAddr uri:(NSString *)uri
{
    self = [super init];
    if (self)
    {
        self.accessKey = accessKey;
        self.secretKey = secretKey;
        self.baseAddr = baseAddr;
        self.uri = uri;
    }
    return self;
}

- (NSString *)gmtTimeStr
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss 'GMT'"];
    
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    return timeStr;
}

- (NSString *)signatureWithHeaders:(NSDictionary *)headers
{
    NSArray *sortedKeys = @[kHeaderxacsversion,
                            kHeaderxacssignaturenonce,
                            kHeaderxacssignatureversion,
                            kHeaderxacssignaturemethod];
    sortedKeys = [AliyunTaskParamUtility sortParamKeyArray:sortedKeys];
    
    NSString *headerSign = [AliyunTaskParamUtility signatureWithParams:headers sortedKeys:sortedKeys];
    
    return headerSign;
}

- (NSString *)signatureContentWithHeaders:(NSDictionary *)headers
{
    NSString *signHeader = [self signatureWithHeaders:headers];
    
    NSMutableString *signContent = [[NSMutableString alloc] init];
    [signContent appendString:@"POST"];
    [signContent appendString:kSeparate];
    [signContent appendString:@"application/json"];
    [signContent appendString:kSeparate];
    [signContent appendString:headers[kHeaderContentMD5]];
    [signContent appendString:kSeparate];
    [signContent appendString:@"application/json"];
    [signContent appendString:kSeparate];
    [signContent appendString:headers[kHeaderDate]];
    [signContent appendString:kSeparate];
    [signContent appendString:signHeader];
    [signContent appendString:self.uri];
    
    return signContent;
}

- (NSString *)url
{
    if (self.uri.length > 0)
    {
        return [NSString stringWithFormat:@"%@%@",self.baseAddr,self.uri];
    }
    else
    {
        return self.baseAddr;
    }
}

- (NSMutableURLRequest *)makeRequest
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.params options:NSJSONWritingPrettyPrinted error:nil];
    
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
    
    NSString *signature = [self signatureContentWithHeaders:[serializer HTTPRequestHeaders]];
    signature = [CocoaSecurity hmacSha1:signature hmacKey:self.secretKey].base64;
    
    [serializer setValue:[NSString stringWithFormat:@"acs %@:%@",_accessKey,signature] forHTTPHeaderField:kHeaderAuthorization];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:[self url] parameters:nil error:nil];
    
    [request setHTTPBody:jsonData];
    
    return request;
}

- (void)startTask
{
    NSMutableURLRequest * request = [self makeRequest];
    request.timeoutInterval = 25.0;
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //设置返回数据序列化对象
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (self.delegate)
        {
            [self.delegate taskFinished:self result:responseObject error:error];
        }
    }];
    
    [dataTask resume];
}

@end
