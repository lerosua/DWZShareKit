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

@interface DWZViewController ()<DWZShareSDKDelegate,DWZShareKitAuthDelegate>
- (IBAction)SinaLoginAction:(id)sender;

- (IBAction)QQLoginAction:(id)sender;
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
    NSArray *shareArray = [DWZShareKit getShareListWithType:ShareTypeCustom,ShareTypeSinaWeibo,ShareTypeQQ,ShareTypeQQSpace,ShareTypeWeChatSession,ShareTypeWeChatTimeline,nil];
//    NSArray *shareArray = [DWZShareKit getShareListWithType:ShareTypeSinaWeibo,ShareTypeQQ,ShareTypeQQSpace,ShareTypeWeChatSession,ShareTypeWeChatTimeline,nil];


    UIImage *image = [UIImage imageNamed:@"dwzsharesdk_qq"];
    DWZShareContent *content = [DWZShareKit content:@"视频描述" image:image title:@"视频标题" url:@"http://baidu.com"];
    
    DWZCustomShareObject *shareObject = [[DWZCustomShareObject alloc] init];
    shareObject.icons = image;
    shareObject.name = @"LOL盒子";
    
//    [DWZShareKit showDefaultShareWith:content serviceShareList:shareArray withDelegate:self];
    [DWZShareKit showDefaultShareWith:content  serviceShareList:shareArray withCustomShare:shareObject withDelegate:self];
}

- (void)shareSDKResponse:(ShareType)socialType Success:(BOOL)sucess
{
    NSLog(@"sharesdk response back %d",sucess);
}

- (void) shareSDKLoginResponse:(ShareType)socialType WithInfo:(NSDictionary *)userInfo Success:(BOOL)success
{
    
}

- (IBAction)SinaLoginAction:(id)sender {
    [DWZShareKit loginWithSinaWithDelegate:(id<DWZShareKitAuthDelegate>)self];
}

- (IBAction)QQLoginAction:(id)sender {
    [DWZShareKit loginWithQQWithDelegate:(id<DWZShareKitAuthDelegate>)self];
}
@end
