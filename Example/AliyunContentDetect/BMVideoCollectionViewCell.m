//
//  BMVideoCollectionView.m
//  AliyunContentDetect_Example
//
//  Created by lijin on 2018/4/1.
//  Copyright © 2018年 lijin. All rights reserved.
//

#import "BMVideoCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "BMDetectModel.h"

@interface BMVideoCollectionViewCell()

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer      *player;
@property (nonatomic, strong) UIImage       *cacheCapture;

@end

@implementation BMVideoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self prepareImageView];
        [self preparePlayer];
    }
    return self;
}

- (void)prepareImageView
{
    CGRect frame = self.bounds;
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageView];
}

- (void)preparePlayer
{
    if (!self.player && self.url)
    {
        NSURL * url = [NSURL URLWithString:self.url];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        self.playerLayer.frame = self.imageView.bounds;
    }
}

- (void)setUrl:(NSString *)url
{
    if (_url != url)
    {
        _url = url;
        
        self.cacheCapture = [[BMDetectModel sharedModel]captureForURL:url];
        
        self.imageView.image = [self videoImage];
        [self preparePlayer];
    }
}

- (UIImage *)videoImage
{
    if (self.cacheCapture)
    {
        return self.cacheCapture;
    }
    else
    {
        return [UIImage imageNamed:@"res/default_img"];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (selected)
    {
        self.backgroundColor = [UIColor greenColor];
        
        if (![self.playerLayer superlayer])
        {
            [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            
            [self.imageView.layer addSublayer:self.playerLayer];
            [self.player play];
            [self captureVideoLayer];
        }
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
        if ([self.playerLayer superlayer])
        {
            [self.player pause];
            [self.playerLayer removeFromSuperlayer];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
            {
                break;
            }
            case AVPlayerItemStatusReadyToPlay:
            {
                break;
            }
            case AVPlayerItemStatusUnknown:
            {
                break;
            }
            default:
                break;
        }
    }
    //移除监听（观察者）
    [object removeObserver:self forKeyPath:@"status"];
}

- (void)captureVideoLayer
{
    if (self.cacheCapture)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = nil;
        NSURL *URL = [NSURL URLWithString:self.url];
        AVURLAsset *urlAsset=[AVURLAsset assetWithURL:URL];
        AVAssetImageGenerator  *imageGen = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
        if (imageGen)
        {
            imageGen.appliesPreferredTrackTransform = YES;
            CMTime actualTime;
            CGImageRef cgImage = [imageGen copyCGImageAtTime:CMTimeMakeWithSeconds(10, 12) actualTime:&actualTime error:NULL];
            if (cgImage)
            {
                image = [UIImage imageWithCGImage:cgImage];
                CGImageRelease(cgImage);
            }
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.cacheCapture = image;
            self.imageView.image = self.cacheCapture ? self.cacheCapture:self.imageView.image;
            [[BMDetectModel sharedModel]setCapture:self.cacheCapture forURL:self.url];
        });
    });
}
@end
