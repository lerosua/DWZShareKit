//
//  DWZViewController.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZViewController.h"
#import "DWZShareKit.h"
#import "DWZAppDelegate.h"
#import "WeiboSDK.h"

@interface DWZViewController ()<DWZShareSDKDelegate>

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
    NSArray *shareArray = [DWZShareKit getShareListWithType:ShareTypeSinaWeibo,ShareTypeQQ,ShareTypeQQSpace,ShareTypeWeChatSession,ShareTypeWeChatTimeline,nil];

    UIImage *image = [UIImage imageNamed:@"QQIcon"];
    DWZShareContent *content = [DWZShareKit content:@"视频描述" image:image title:@"视频标题" url:@"http://baidu.com"];
    
    [DWZShareKit showDefaultShareWith:content serviceShareList:shareArray withDelegate:self];
}

- (void)shareSDKResponse:(ShareType)socialType Success:(BOOL)sucess
{
    NSLog(@"sharesdk response back %d",sucess);
}

@end
