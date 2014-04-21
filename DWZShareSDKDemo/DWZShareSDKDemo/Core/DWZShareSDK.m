//
//  DWZShareSDK.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZShareSDK.h"
#import "WeiboSDK.h"        //sina weibo
#import "WeiboApi.h"        //tencent weibo
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"           //wechat
#import "DWZShareViewController.h"

@interface DWZShareSDK()<WeiboSDKDelegate,
                        WBHttpRequestDelegate,
                        WeiboRequestDelegate,WeiboAuthDelegate,
                        TencentSessionDelegate,
                        WXApiDelegate,
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

@property (nonatomic,strong) WeiboApi *tencentWeiboApi;
//QQ空间数据
@property (nonatomic,strong) NSString *qqZoneAppKey;
@property (nonatomic,strong) NSString *qqZoneAppSecret;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;

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
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    shareSDK.tencentWeiboApi = [[WeiboApi alloc] initWithAppKey:appKey andSecret:appSecret andRedirectUri:redirectUri];
    
    
}


+ (void)connectQZoneWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
{
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    shareSDK.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appKey andDelegate:(id<TencentSessionDelegate>)self];
    
}

+ (void)connectWeChatWithAppId:(NSString *)appId
                     wechatCls:(Class)wechatCls
{
    [WXApi registerApp:appId];
    
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
+ (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"click %d",buttonIndex);
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];

    switch (buttonIndex) {
        case 0:     //sina weibo
        {
            if(![WeiboSDK isWeiboAppInstalled]){
                WBAuthorizeRequest *request = [WBAuthorizeRequest request];
                request.redirectURI = shareSDK.sinaWeiboAppUrl;
                request.scope = @"email,direct_messages_write";
                request.userInfo = @{@"shareMessageFrom":@"DWZShareSDKDemo"};
                request.shouldOpenWeiboAppInstallPageIfNotInstalled=NO;
                [WeiboSDK sendRequest:request];
                [shareSDK.baseViewController showSinaWeiboAuthView:shareSDK.sinaWeiboAppUrl];

                
            }else{
                WBMessageObject *obj = [DWZShareSDK weiboMessageFrom:@"测试数据"];
                WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:obj];
                request.userInfo = @{@"shareMessageFrom":@"DWZShareSDKDemo"};
                [WeiboSDK sendRequest:request];
            }
            
        }

            break;
        case 1: //tencent weibo
        {
            [shareSDK.tencentWeiboApi loginWithDelegate:self andRootController:shareSDK.baseViewController];
            
        }
            break;
        case 2: //QQZone
        {
//            if([QQApiInterface isQQInstalled]){
                NSArray* permissions = [NSArray arrayWithObjects:
                                        kOPEN_PERMISSION_GET_USER_INFO,
                                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                        kOPEN_PERMISSION_ADD_ALBUM,
                                        kOPEN_PERMISSION_ADD_IDOL,
                                        kOPEN_PERMISSION_ADD_ONE_BLOG,
                                        kOPEN_PERMISSION_ADD_PIC_T,
                                        kOPEN_PERMISSION_ADD_SHARE,
                                        kOPEN_PERMISSION_ADD_TOPIC,
                                        kOPEN_PERMISSION_CHECK_PAGE_FANS,
                                        kOPEN_PERMISSION_DEL_IDOL,
                                        kOPEN_PERMISSION_DEL_T,
                                        kOPEN_PERMISSION_GET_FANSLIST,
                                        kOPEN_PERMISSION_GET_IDOLLIST,
                                        kOPEN_PERMISSION_GET_INFO,
                                        kOPEN_PERMISSION_GET_OTHER_INFO,
                                        kOPEN_PERMISSION_GET_REPOST_LIST,
                                        kOPEN_PERMISSION_LIST_ALBUM,
                                        kOPEN_PERMISSION_UPLOAD_PIC,
                                        kOPEN_PERMISSION_GET_VIP_INFO,
                                        kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                                        kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                                        kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                                        nil];
                [shareSDK.tencentOAuth authorize:permissions inSafari:YES];
//            }else{
//                
//            }
        }
            break;
        case 3: //weichat
        {
            SendMessageToWXReq *wechatReq = [[SendMessageToWXReq alloc] init];
            wechatReq.bText = YES;
            wechatReq.text = @"测试微信分享";
            [WXApi sendReq:wechatReq];
        }
            break;
        default:
            break;
    }
    

//    DWZShareViewController *viewController = [[DWZShareViewController alloc] init];
//    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
//    [shareSDK.baseViewController presentViewController:viewController animated:YES completion:nil];
    

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
    if([[url absoluteString] hasSuffix:@"platformId=wechat"]){
        return [WXApi handleOpenURL:url delegate:pDelegate];
    }else if([[url absoluteString] hasPrefix:@"tencent"]){
        return [TencentOAuth HandleOpenURL:url];
    }
    
    return YES;
}


#pragma mark -
#pragma mark WeiboRequestDelegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
+ (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    //[NSString stringWithCharacters:[data bytes] length:[data length]];
    NSLog(@"result = %@",strResult);
    
}
/**
 * @brief   接口调用失败后的回调
 * @param   INPUT   error   接口返回的错误信息
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
+ (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    NSLog(@"result = %@",str);

}



#pragma mark WeiboAuthDelegate

/**
 * @brief   重刷授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
+ (void)DidAuthRefreshed:(WeiboApi *)wbapi_
{
    
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    
    NSLog(@"result = %@",str);

    
}

/**
 * @brief   重刷授权失败后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
+ (void)DidAuthRefreshFail:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
 
    NSLog(@"result = %@",str);

}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
+ (void)DidAuthFinished:(WeiboApi *)wbapi_
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    
    NSLog(@"result = %@",str);

}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
+ (void)DidAuthCanceled:(WeiboApi *)wbapi_
{
    
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
+ (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    NSLog(@"result = %@",str);

}


#pragma mark - wechat delegate
+ (void) onReq:(BaseReq *)req
{
    NSLog(@"get req %@",req);

    
}

+ (void) onResp:(BaseResp *)resp
{
    NSLog(@"get resp %@",resp);
}
@end
