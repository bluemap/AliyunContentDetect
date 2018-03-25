//
//  AliyunContectDetect.h
//  Pods
//
//  Created by lijin on 2018/3/25.
//

#ifndef AliyunContectDetectDefine_h
#define AliyunContectDetectDefine_h

#define kSeparate           @"\n"

typedef enum : NSUInteger {
    EImagePorn,         //图片鉴黄
    EImageTerrorism,    //图片涉政
    EImageOCR,          //OCR图文识别
    EImageSface,         //图片敏感人脸
    EImageAd,           //图片广告识别
    EImageQrcode,       //图片二维码识别
    EImageLive,         //图片不良场景识别
    EImageLogo,         //图片logo检测（未实现，api文档有问题）
    EVideoPorn,         //视频鉴黄
    EVideoTerrorism,    //视频涉政
    EVideoSface,        //视频敏感人脸
    EVideoAd,           //视频广告
    EVideoLive,         //视频不良场景
    EVideoLogo,         //视频logo识别
    ETextAntispam,      //文本反垃圾
    EVoiceAntispam      //语音反垃圾
} EDetectType;

#endif /* AliyunContectDetect_h */
