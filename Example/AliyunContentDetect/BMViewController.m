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

@interface BMViewController ()

@property (nonatomic, retain) UIButton *testBtn;

@end

@implementation BMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
//    [[AliyunContentDetectService sharedInstance]pornDetectWithURL:@"http://pic.yesky.com/uploadImages/2015/131/14/33G2Z2V4TPSU.jpg"];
//    [[AliyunContentDetectService sharedInstance]pornDetectWithURL:@"http://img2.ph.126.net/X5WRomEJM7U7xF4dTRP41g==/6597756961425803090.jpg"];
//    [[AliyunContentDetectService sharedInstance]pornDetectWithURL:@"http://image.tianjimedia.com/uploadImages/2014/214/17/81IJ6AO7SB2U_1000x500.jpg"];
//    [[AliyunContentDetectService sharedInstance]pornDetectWithURL:@"http://www.laosizhou.com/uploads/allimg/150113/1-150113140616.jpg"];
    //[[AliyunContentDetectService sharedInstance]pornDetectWithURL:@"http://img1.imgtn.bdimg.com/it/u=438018361,68406850&fm=27&gp=0.jpg"];
    
}
@end
