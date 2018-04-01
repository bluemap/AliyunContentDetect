//
//  BMDetectModel.h
//  AliyunContentDetect_Example
//
//  Created by lijin on 2018/4/1.
//  Copyright © 2018年 lijin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunContentDetect/AliyunContectDetect.h>

@interface BMDetectModel : NSObject

+ (instancetype)sharedModel;

- (NSArray *)defaultUrlsForType:(EDetectType)type;
- (void)updateDefaultUrlsForType:(EDetectType)type urls:(NSArray *)urls;
- (UIImage *)captureForURL:(NSString *)url;
- (void)setCapture:(UIImage *)capture forURL:(NSString *)url;

@end
