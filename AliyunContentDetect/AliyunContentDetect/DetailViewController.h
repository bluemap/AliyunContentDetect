//
//  DetailViewController.h
//  AliyunContentDetect
//
//  Created by lijin on 18/3/3.
//  Copyright © 2018年 Bluemap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

