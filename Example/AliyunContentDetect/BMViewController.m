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
//#import <AliyunContentDetect/AliyunContentDetect-umbrella.h>b

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
    [AliyunContentDetectService sharedInstance];
}
@end
