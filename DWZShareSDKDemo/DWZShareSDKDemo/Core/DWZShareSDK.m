//
//  DWZShareSDK.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZShareSDK.h"
#import "WeiboSDK.h"
#import "DWZShareViewController.h"

@interface DWZShareSDK()<WeiboSDKDelegate,
                        WBHttpRequestDelegate,
                        UIActionSheetDelegate>

//新浪数据
@property (nonatomic,strong) NSString *sinaWeiboAppKey;
@property (nonatomic,strong) NSString *sinaWeiboAppSecret;
@property (nonatomic,strong) NSString *sinaWeiboAppUrl;
@property (nonatomic,strong) NSString *sinaWeiboToken;
//腾讯微博数据
@property (nonatomic,strong) NSString *tcWeiboAppKey;
@property (nonatomic,strong) NSString *tcWeiboAppSecret;
@property (nonatomic,strong) NSString *tcWeiboAppUrl;

//QQ空间数据
@property (nonatomic,strong) NSString *qqZoneAppKey;
@property (nonatomic,strong) NSString *qqZoneAppSecret;

//微信数据
@property (nonatomic,strong) NSString *weChatAppId;


@property (nonatomic,weak) UIViewController *baseViewController;



@end

@implementation DWZShareSDK
#pragma mark -
+ (instancetype) shareInstance
{
    static DWZShareSDK *_currentShareSDK;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _currentShareSDK = [[DWZShareSDK alloc] init];
    });
    return _currentShareSDK;
}
#pragma mark -
+ (void)connectSinaWeiboWithAppKey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                       redirectUri:(NSString *)redirectUri
{
    
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:appKey];
    
    shareSDK.sinaWeiboAppKey = appKey;
    shareSDK.sinaWeiboAppSecret = appSecret;
    shareSDK.sinaWeiboAppUrl = redirectUri;
    
    
}


+ (void)connectTencentWeiboWithAppKey:(NSString *)appKey
                            appSecret:(NSString *)appSecret
                          redirectUri:(NSString *)redirectUri
{
    
}


+ (void)connectQZoneWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
{
    
}

+ (void)connectWeChatWithAppId:(NSString *)appId
                     wechatCls:(Class)wechatCls
{
    
}

+ (id) showDefaultShareWithTitle:(NSString *)title
                serviceShareList:(NSArray *)shareList
              withViewController:(UIViewController *)viewController;

{
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    shareSDK.baseViewController = viewController;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil,nil];

    [sheet addButtonWithTitle:@"新浪微博"];
    [sheet addButtonWithTitle:@"腾讯微博"];
    [sheet addButtonWithTitle:@"QQ空间"];
    [sheet addButtonWithTitle:@"微信"];
    [sheet addButtonWithTitle:@"取消"];
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;

    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    
    return nil;
    
}

+ (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"click %d",buttonIndex);
//    switch (buttonIndex) {
//        case 0:
//
//            break;
//        case 1:
//        default:
//            break;
//    }
    

//    DWZShareViewController *viewController = [[DWZShareViewController alloc] init];
//
//    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
//    [shareSDK.baseViewController presentViewController:viewController animated:YES completion:nil];
    
    if(![WeiboSDK isWeiboAppInstalled]){
        DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
//        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
//        request.redirectURI = shareSDK.sinaWeiboAppUrl;
//        request.scope = @"all";
//        request.userInfo = @{@"shareMessageFrom":@"DWZShareSDKDemo"};
//        [WeiboSDK sendRequest:request];
        
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = shareSDK.sinaWeiboAppUrl;
        request.scope = @"all";
        request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        [WeiboSDK sendRequest:request];
        
    }else{
        WBMessageObject *obj = [DWZShareSDK weiboMessageFrom:@"测试数据"];
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:obj];
        request.userInfo = @{@"shareMessageFrom":@"DWZShareSDKDemo"};
        [WeiboSDK sendRequest:request];
    }
}

+ (WBMessageObject *)weiboMessageFrom:(NSString *)text
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = text;
    return message;
}


#pragma mark - weibo回调
+ (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    NSLog(@"get weibo request");
}

+ (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"get weibo response");
    if([response isKindOfClass:WBAuthorizeResponse.class]){
        DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
        shareSDK.sinaWeiboToken = [(WBAuthorizeResponse *)response accessToken];
        NSLog(@"get weibo token %@",shareSDK.sinaWeiboToken);
    }
}

+ (BOOL) handleOpenURL:(NSURL *)url delegate:(id) pDelegate
{
    NSLog(@"get url %@",[url absoluteString]);
    
    return YES;
}
@end
