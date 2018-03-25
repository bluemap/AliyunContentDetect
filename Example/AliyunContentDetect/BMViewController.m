//
//  BMViewController.m
//  AliyunContentDetect
//
//  Created by lijin on 03/04/2018.
//  Copyright (c) 2018 lijin. All rights reserved.
//

#import "BMViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AliyunContentDetect/AliyunContentDetectService.h>
#import "BMImageDetectViewController.h"

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
                            @"视频logo识别",
                            @"文本反垃圾",
                            @"语音反垃圾"];
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
    
    [self prepareTestBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareTestBtn
{
    self.testBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 60, 40)];
    self.testBtn.backgroundColor = [UIColor greenColor];
    [self.testBtn addTarget:self action:@selector(testBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.testBtn];
}

- (void)testBtnClicked:(UIButton *)sender
{
    [AliyunContentDetectService setAccessKey:@"6i9h5df23p10nrcnogkrriy7" secretKey:@"40KKfzXJAz46um6dekrYglX4EEE="];
    [[AliyunContentDetectService sharedInstance]pornImageDetectWithURL:@"http://pic.yesky.com/uploadImages/2015/131/14/33G2Z2V4TPSU.jpg"];
//    [[AliyunContentDetectService sharedInstance]pornImageDetectWithURL:@"http://img2.ph.126.net/X5WRomEJM7U7xF4dTRP41g==/6597756961425803090.jpg"];
//    [[AliyunContentDetectService sharedInstance]pornImageDetectWithURL:@"http://image.tianjimedia.com/uploadImages/2014/214/17/81IJ6AO7SB2U_1000x500.jpg"];
//    [[AliyunContentDetectService sharedInstance]pornImageDetectWithURL:@"http://www.laosizhou.com/uploads/allimg/150113/1-150113140616.jpg"];
    //[[AliyunContentDetectService sharedInstance]pornImageDetectWithURL:@"http://img1.imgtn.bdimg.com/it/u=438018361,68406850&fm=27&gp=0.jpg"];
    
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
    BMImageDetectViewController *controller = [[BMImageDetectViewController alloc] init];
    controller.title = [self.detectList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
