//
//  DWZShareViewController.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-18.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZShareViewController.h"
#import "weiboSDK.h"
#import "DWZShareKit.h"


#define is4Inch()                   ([[UIScreen mainScreen] bounds].size.height == 568)
#define DWZStatusBarOffet           ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? 20 : 0)
#define DWZSinaOpenApiUpdateURL     @"https://api.weibo.com/2/statuses/update.json"

@interface DWZShareViewController ()

@end

@implementation DWZShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"load from nib");

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customTopBar];
    [self customBody];
    
    self.titleLabel.text = @"分享内容";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
}
#pragma mark -
- (void) customTopBar
{
    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44 + DWZStatusBarOffet)];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, DWZStatusBarOffet, 60, 44)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(320-60, DWZStatusBarOffet, 60, 44)];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, DWZStatusBarOffet+2, 160, 40)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [topBar addSubview:self.titleLabel];
    [topBar addSubview:leftButton];
    [topBar addSubview:rightButton];
    
    topBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBar];
}

- (void) customBody
{
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+DWZStatusBarOffet, 320, [[UIScreen mainScreen] bounds].size.height-44-DWZStatusBarOffet)];
    backgroudView.backgroundColor = [UIColor whiteColor];
    backgroudView.alpha = 0.4;
    [self.view addSubview:backgroudView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, DWZStatusBarOffet+44+5, 310, 160)];
    [self.view addSubview:self.contentTextView];
    
    [self.contentTextView becomeFirstResponder];
    
}
- (void) cancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) confirmButtonAction:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *contentText = self.contentTextView.text;
    
    NSLog(@"get share content %@",contentText);
    
    if(self.socialTag == SinaWeiboDWZTag){
        [self sendSinaWeiboMessage:contentText];
    }else if (self.socialTag == TencentWeiboDWZTag){
        [self sendTencentWeiboMessage:contentText];
    }
}

#pragma mark -
- (void) sendSinaWeiboMessage:(NSString *)text
{
    NSString *urlEncodeText =  [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //post the sina
    NSURL *url = [NSURL URLWithString:DWZSinaOpenApiUpdateURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSString *paramsString = [NSString stringWithFormat:@"status=%@&access_token=%@", urlEncodeText, [DWZShareKit sinaWeiboToken]];
    NSData *data = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];

    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *error){

        NSString *retString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"get %s -- %@",__func__, retString);
    }];
    

}

- (void) sendTencentWeiboMessage:(NSString *)text
{
    
//    [DWZShareSDK tencentWeiboSendMessage:text];
    
}

@end
