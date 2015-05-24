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
    // 这是另外一种方式
//    NSArray *shareArray = [DWZShareKit getShareListWithType:ShareTypeCustom,ShareTypeSinaWeibo,ShareTypeQQ,ShareTypeQQSpace,ShareTypeWeChatSession,ShareTypeWeChatTimeline,nil];
//    [DWZShareKit showDefaultShareWith:content serviceShareList:shareArray withDelegate:self];
    
    
    NSArray *shareArray = [DWZShareKit getShareListWithType:ShareTypeSinaWeibo, ShareTypeQQ, ShareTypeQQSpace, ShareTypeWeChatTimeline, ShareTypeCustom, nil];
    
    UIImage *image = [UIImage imageNamed:@"dwzsharesdk_qq"];
    DWZShareContent *content = [DWZShareKit content:@"视频描述" image:image title:@"视频标题" url:@"http://baidu.com"];
    
    DWZCustomShareObject *shareObject = [[DWZCustomShareObject alloc] init];
    shareObject.icons = image;
    shareObject.name = @"自定义盒子";
    
    [DWZShareKit showDefaultShareWith:content  serviceShareList:shareArray withCustomShare:shareObject withDelegate:self];
}

- (void)shareSDKResponse:(ShareType)socialType operationType:(OperationType)operationType
{
    NSLog(@"sharesdk response back %d", operationType);
}

- (void)shareSDKLoginResponse:(ShareType)socialType authInfo:(NSDictionary *)userInfo operationType:(OperationType)operationType
{
    if (operationType == OperationTypeSuccess && socialType == ShareTypeQQ) {
        [DWZShareKit getQQLoginUserInfo];
    }
    NSLog(@"auth status : %d", operationType);
}

- (void)shareSDKUserInfo:(NSDictionary *)userInfo success:(BOOL)success {
    if (success)
    {
        NSMutableString *str=[NSMutableString stringWithFormat:@""];
        for (id key in userInfo) {
            [str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[userInfo objectForKey:key]]];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
                              
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", @"获取用户信息失败"]
                              
                                                       delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
        [alert show];
    }
}

- (void) shareKit:(DWZShareKit *)kit willAction:(ShareType)socialType
{
    NSLog(@"get shareKit action %d",socialType);
    DWZShareContent *content = [DWZShareKit content:@"视频xxxxx" image:nil title:@"视频xxxx" url:@"http://xxxx.com"];
    
    [kit resetShareContent:content];
    
}

- (IBAction)SinaLoginAction:(id)sender {
    [DWZShareKit loginWithSinaWithDelegate:(id<DWZShareKitAuthDelegate>)self];
}

- (IBAction)QQLoginAction:(id)sender {
    [DWZShareKit loginWithQQWithDelegate:(id<DWZShareKitAuthDelegate>)self];
}
@end
