//
//  BMCollectionViewCell.m
//  AliyunContentDetect_Example
//
//  Created by lijin on 2018/4/1.
//  Copyright © 2018年 lijin. All rights reserved.
//

#import "BMImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BMImageCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BMImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self prepareImageView];
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

- (void)setUrl:(NSString *)url
{
    if (_url != url)
    {
        _url = url;
        NSURL *URL = [NSURL URLWithString:url];
        [self.imageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"res/default_img"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error)
            {
                self.imageView.image = [UIImage imageNamed:@"res/load_err"];
            }
        }];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (selected)
    {
        self.backgroundColor = [UIColor greenColor];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
