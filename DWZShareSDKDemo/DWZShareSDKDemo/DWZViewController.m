//
//  DWZViewController.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZViewController.h"
#import "DWZShareSDK.h"
#import "DWZAppDelegate.h"
#import "WeiboSDK.h"

@interface DWZViewController ()

@end

@implementation DWZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (IBAction)ShareButtonAction:(id)sender
{
    NSArray *shareArray = [DWZShareSDK getShareListWithType:ShareTypeSinaWeibo,ShareTypeTencentWeibo,ShareTypeQQSpace,ShareTypeWeChatSession,nil];

    UIImage *image = [UIImage imageNamed:@"QQIcon"];
    DWZShareContent *content = [DWZShareSDK content:@"视频描述" image:image title:@"视频标题" url:@"http://baidu.com"];
    
    [DWZShareSDK showDefaultShareWith:content serviceShareList:shareArray withViewController:self];
}



@end
