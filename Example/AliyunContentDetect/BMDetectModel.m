//
//  BMDetectModel.m
//  AliyunContentDetect_Example
//
//  Created by lijin on 2018/4/1.
//  Copyright © 2018年 lijin. All rights reserved.
//

#import "BMDetectModel.h"

#define kDetectUrls     @"kDetectUrls"

@interface BMDetectModel()

@property (nonatomic, retain) NSMutableDictionary *cacheUrls;
@property (nonatomic, retain) NSMutableDictionary *cacheCapture;

@end

@implementation BMDetectModel

+ (instancetype)sharedModel
{
    static BMDetectModel *g_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_instance = [[self.class alloc]init];
    });
    return g_instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.cacheCapture = [NSMutableDictionary dictionary];
        self.cacheUrls = [NSMutableDictionary dictionary];
        NSDictionary *savedDict = [[NSUserDefaults standardUserDefaults]objectForKey:kDetectUrls];
        savedDict = nil;
        if (savedDict)
        {
            [self.cacheUrls setDictionary:savedDict];
        }
        else
        {
            [self.cacheUrls setDictionary:[self defaultUrls]];
        }
    }
    return self;
}

- (NSDictionary *)defaultUrls
{
    NSDictionary *defaultUrls = @{[NSString stringWithFormat:@"%zd",EImagePorn]:@[@"http://pic.yesky.com/uploadImages/2015/131/14/33G2Z2V4TPSU.jpg",
                                                                                  @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1974905028,1527890886&fm=27&gp=0.jpg",
                                                                                  @"http://image.tianjimedia.com/uploadImages/2014/214/17/81IJ6AO7SB2U_1000x500.jpg"],
                                  [NSString stringWithFormat:@"%zd",EImageTerrorism]:@[@"http://paper.ce.cn/jjrb/res/1/1/2018-03/18/01/res04_attpic_brief.jpg",@"http://img0.ph.126.net/C6kAdhb5R5y4MkdK8AqXjQ==/1348265138461086840.jpg",@"http://img.ifeng.com/hres/200905/11/06/07dcb8cd655c5bd24db948a2d9faf790.jpg"],
                                  [NSString stringWithFormat:@"%zd",EImageOCR]:@[@"http://img3.xitongzhijia.net/141230/47-141230162529254.jpg",@"http://photocdn.sohu.com/20160315/mp63419838_1457977637894_1_th.jpeg",@"http://s1.sinaimg.cn/mw690/003YW7Apzy7gQMiXyAoa0&690"],
                                  [NSString stringWithFormat:@"%zd",EImageSface]:@[@"http://paper.ce.cn/jjrb/res/1/1/2018-03/18/01/res04_attpic_brief.jpg",@"http://img0.ph.126.net/C6kAdhb5R5y4MkdK8AqXjQ==/1348265138461086840.jpg",@"http://img.ifeng.com/hres/200905/11/06/07dcb8cd655c5bd24db948a2d9faf790.jpg"],
                                  [NSString stringWithFormat:@"%zd",EImageAd]:@[@"https://tse2-mm.cn.bing.net/th?id=OIP.nk1uhvvB86-nNaZGD84xMgHaG1&p=0&o=5&pid=1.1",@"http://pic33.nipic.com/20130921/9580330_113239577387_2.jpg",@"http://pica.nipic.com/2007-11-17/2007111714162903_2.jpg"],
                                  [NSString stringWithFormat:@"%zd",EImageQrcode]:@[@"http://pic22.nipic.com/20120725/2034846_104946009384_2.jpg",@"http://pic35.nipic.com/20131125/11678986_113639001309_2.jpg",@"http://pic22.nipic.com/20120725/2034846_175320071305_2.jpg"],
                                  [NSString stringWithFormat:@"%zd",EImageLive]:@[@"http://1802.img.pp.sohu.com.cn/images/blog/2008/6/2/7/23/11aeb41c466.jpg",@"http://dyrb.zjol.com.cn/res/1/20101224/72831293200709906.jpg",@"http://images.ccoo.cn/bbs/2011814/20118149255816.jpg"],
                                  [NSString stringWithFormat:@"%zd",EImageLogo]:@[@"http://img01.store.sogou.com/app/a/07/c33d3a9d85be5bec8ee0a8b30b667c27",@"http://www.haoqu.net/uploadfile/2013/0902/20130902015448336.jpg",@"https://tse1-mm.cn.bing.net/th?id=OIP.d6MOhWoh-Vx_ttqT6R0TsQHaFj&p=0&o=5&pid=1.1"],
                                  [NSString stringWithFormat:@"%zd",EVideoPorn]:@[@"https://d2.xia12345.com/down/2017/3/11001/173110726.mp4",@"https://d2.xia12345.com/down/2017/3/11001/173110164.mp4"],
                                  [NSString stringWithFormat:@"%zd",EVideoAd]:@[@"https://d2.xia12345.com/down/2017/3/11001/173110726.mp4",@"https://d2.xia12345.com/down/2017/3/11001/173110164.mp4"],
                                  [NSString stringWithFormat:@"%zd",EVideoTerrorism]:@[@"https://d2.xia12345.com/down/2017/3/11001/173110726.mp4",@"https://d2.xia12345.com/down/2017/3/11001/173110164.mp4"]
                                  };
    return defaultUrls;
}

- (NSArray *)defaultUrlsForType:(EDetectType)type
{
    NSArray *urls = [self.cacheUrls objectForKey:[NSString stringWithFormat:@"%zd",type]];
    
    return urls;
}

- (void)updateDefaultUrlsForType:(EDetectType)type urls:(NSArray *)urls
{
    if (urls)
    {
        [self.cacheUrls setObject:urls forKey:[NSString stringWithFormat:@"%zd",type]];
        [[NSUserDefaults standardUserDefaults] setObject:self.cacheUrls forKey:kDetectUrls];
    }
}

- (UIImage *)captureForURL:(NSString *)url
{
    return [self.cacheCapture objectForKey:url];
}

- (void)setCapture:(UIImage *)capture forURL:(NSString *)url
{
    if (capture && url)
    {
        [self.cacheCapture setObject:capture forKey:url];
    }
}

@end
