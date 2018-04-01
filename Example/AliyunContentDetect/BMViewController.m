//
//  BMViewController.m
//  AliyunContentDetect
//
//  Created by lijin on 03/04/2018.
//  Copyright (c) 2018 lijin. All rights reserved.
//

#import "BMViewController.h"
#import "BMImageAndVideoDetectViewController.h"
#import <AliyunContentDetect/AliyunContectDetect.h>
#import "BMDetectModel.h"

@interface BMViewController ()

@property (nonatomic, retain) UIButton *testBtn;
@property (nonatomic, retain) NSArray *detectList;

@end

@implementation BMViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.detectList = @[@"图片鉴黄",
                            @"图片涉政",
                            @"OCR图文识别",
                            @"图片敏感人脸",
                            @"图片广告识别",
                            @"图片二维码识别",
                            @"图片不良场景识别",
                            @"图片logo检测",
                            @"视频鉴黄",
                            @"视频涉政",
                            @"视频敏感人脸",
                            @"视频广告",
                            @"视频不良场景",
                            @"视频logo识别"
                            //@"文本反垃圾",
                            //@"语音反垃圾"
                            ];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"阿里云内容安全检测";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.detectList.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *identify = @"contentDetect";
     UITableViewCell *cell = nil;
 
     if (!cell)
     {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
         cell.textLabel.text = [self.detectList objectAtIndex:indexPath.row];
     }
 
 return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = nil;
    if (indexPath.row <= EVideoLogo)
    {
        controller = [[BMImageAndVideoDetectViewController alloc] initWithType:indexPath.row urls:[self defaultUrlsForIndex:indexPath.row]];
    }
    
    controller.title = [self.detectList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSArray *)defaultUrlsForIndex:(NSInteger)index
{
    return [[BMDetectModel sharedModel]defaultUrlsForType:index];
}
@end
