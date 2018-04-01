//
//  BMImageDetectViewController.m
//  AliyunContentDetect_Example
//
//  Created by lijin on 2018/3/25.
//  Copyright © 2018年 lijin. All rights reserved.
//

#import "BMImageAndVideoDetectViewController.h"
#import <AliyunContentDetect/AliyunContectDetect.h>
#import "BMImageCollectionViewCell.h"
#import "BMVideoCollectionViewCell.h"
#import "BMDetectModel.h"

#define kTextFieldHeight    40
#define kSpace              10

@interface BMImageAndVideoDetectViewController ()<UICollectionViewDataSource,
                                            UICollectionViewDelegate,
                                            UITextFieldDelegate,
                                            AliyunContentDetectServiceObserver>

@property (nonatomic, assign) NSInteger         type;
@property (nonatomic, strong) UITextField       *textField;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UITextView        *textView;
@property (nonatomic, strong) NSMutableArray    *urls;

@end

@implementation BMImageAndVideoDetectViewController

static NSString *const identify = @"identify";

- (id)initWithType:(NSInteger)type urls:(NSArray *)urls
{
    self = [super init];
    if (self)
    {
        self.type = type;
        self.urls = [[NSMutableArray alloc] init];
        if (urls)
        {
            [self.urls addObjectsFromArray:urls];
        }
        [[AliyunContentDetectService sharedInstance] addObserver:self];
    }
    return self;
}

- (void)dealloc
{
    [[AliyunContentDetectService sharedInstance] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareTextField];
    [self prepareCollectionView];
    [self prepareTextView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[BMDetectModel sharedModel] updateDefaultUrlsForType:self.type urls:self.urls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareTextField
{
    float yOffset = CGRectGetMaxY(self.navigationController.navigationBar.frame) + kSpace;
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, yOffset, self.view.bounds.size.width, kTextFieldHeight)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.rightViewMode = UITextFieldViewModeWhileEditing;
    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kTextFieldHeight, kTextFieldHeight)];
    UIImage *delImage = [UIImage imageNamed:@"res/textField_del.png"];
    [delBtn setImage:delImage forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(textFieldClear:) forControlEvents:UIControlEventTouchUpInside];
    _textField.rightView = delBtn;
    _textField.placeholder = @"请输入资源URL";
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [self.view addSubview:_textField];
}

- (void)prepareCollectionView
{
    NSInteger sep = 3;
    if (self.type >= EVideoPorn)
    {
        sep = 2;
    }
    float imageWidth = self.view.frame.size.width/sep;
    float imageHeight = self.view.frame.size.width/3;
    
    //自动网格布局
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(imageWidth, imageHeight);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    //网格布局
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,
                                                                        CGRectGetMaxY(self.textField.frame) + kSpace,
                                                                        self.view.frame.size.width,
                                                                        imageHeight *2)
                                        collectionViewLayout:flowLayout];
    //注册cell
    if (self.type < EVideoPorn)
    {
        [_collectionView registerClass:[BMImageCollectionViewCell class] forCellWithReuseIdentifier:identify];
    }
    else
    {
        [_collectionView registerClass:[BMVideoCollectionViewCell class] forCellWithReuseIdentifier:identify];
    }
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.layer.borderWidth = 2;
    _collectionView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //设置数据源代理
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [self.view addSubview:_collectionView];
}

- (void)prepareTextView
{
    float yOffset = CGRectGetMaxY(self.collectionView.frame);
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0,
                                                            yOffset + kSpace,
                                                            self.view.bounds.size.width,
                                                            self.view.bounds.size.height - yOffset - kSpace)];
    _textView.layer.borderWidth = 2;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.editable = NO;
    [self.view addSubview:_textView];
}
#pragma mark action

- (void)textFieldClear:(UIButton *)btn
{
    self.textField.text = nil;
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urls.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    if (self.type < EVideoPorn)
    {
        if (!cell)
        {
            cell = [[BMImageCollectionViewCell alloc] init];
        }
        ((BMImageCollectionViewCell*)cell).url = [self.urls objectAtIndex:indexPath.row];
    }
    else
    {
        if (!cell)
        {
            cell = [[BMVideoCollectionViewCell alloc] init];
        }
        ((BMVideoCollectionViewCell*)cell).url = [self.urls objectAtIndex:indexPath.row];
    }
    
    
    
    return cell;
}

- (void)detectWithURL:(NSString *)url
{
    switch (self.type)
    {
        case EImagePorn:
        case EImageTerrorism:
        case EImageOCR:
        case EImageSface:
        case EImageAd:
        case EImageQrcode:
        case EImageLive:
        case EImageLogo:
        {
            [[AliyunContentDetectService sharedInstance]imageDetectWithURL:url type:self.type];
            break;
        }
        case EVideoPorn:
        case EVideoTerrorism:
        case EVideoSface:
        case EVideoAd:
        case EVideoLive:
        case EVideoLogo:
        {
            [[AliyunContentDetectService sharedInstance]videoDetectWithURL:url type:self.type];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.textView.text = @"检测中...";
    NSString *url = [self.urls objectAtIndex:indexPath.row];
    [self detectWithURL:url];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    NSString *url = textField.text;
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && ![self.urls containsObject:url])
    {
        [self.urls addObject:url];

        [self.collectionView reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:self.urls.count - 1];
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
        });
        
        [self detectWithURL:url];
    }
    return YES;
}

#pragma mark AliyunContentDetectServiceObserver
- (void)contectDetectFinish:(NSString *)url result:(NSDictionary *)result error:(NSError *)error
{
    if (error)
    {
        self.textView.text = [error description];
    }
    else
    {
        self.textView.text = [result description];
    }
}
@end
