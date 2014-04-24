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
#import "TencentOAuth.h"
#import "QQApiInterface.h"
#import "TencentApiInterface.h"
#import "WXApi.h"           //wechat
#import "DWZShareViewController.h"

#import "DWZSocialView.h"
#import "DWZShareContent.h"

@interface DWZShareSDK()<WeiboSDKDelegate,
                        WBHttpRequestDelegate,
                        WeiboRequestDelegate,WeiboAuthDelegate,
                        TencentSessionDelegate,
                        WXApiDelegate,
                        DWZSocialDelegate,
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
@property (nonatomic,strong) NSString *tencentWeiboToken;
@property (nonatomic,strong) NSString *tencentWeiboOpenId;
//QQ空间数据
@property (nonatomic,strong) NSString *qqZoneAppKey;
@property (nonatomic,strong) NSString *qqZoneAppSecret;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;

//微信数据
@property (nonatomic,strong) NSString *weChatAppId;


@property (nonatomic,weak) UIViewController *baseViewController;

@property (nonatomic,strong) DWZShareContent *shareContent;
@property (nonatomic,strong) NSArray *socialList;

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
#pragma mark - conecnt method
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
#pragma mark -
+ (id) showDefaultShareWith:(DWZShareContent *)content
                serviceShareList:(NSArray *)shareList
              withViewController:(UIViewController *)viewController;

{
    if(!shareList){
        NSLog(@"please at less get on social account");
        return nil;
    }

    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    shareSDK.baseViewController = viewController;
    shareSDK.shareContent = content;
    shareSDK.socialList = shareList;
    
    
    DWZSocialView *view = [[DWZSocialView alloc] initWithArray:shareList];
    view.delegate = shareSDK;
    [view show];
    

    return nil;
    
}

#pragma mark -
- (void) socialButton:(UIButton *)sender clickedAtIndex:(NSInteger) index;
{
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];

    ShareType socialNo = index;
    switch (socialNo) {
        case ShareTypeSinaWeibo:     //sina weibo
        {
            if([WeiboSDK isWeiboAppInstalled]){
                WBMessageObject *obj = [DWZShareSDK weiboMessageFrom:shareSDK.shareContent];
                WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:obj];
                request.userInfo = @{@"shareMessageFrom":@"DWZShareSDKDemo"};
                [WeiboSDK sendRequest:request];
                
            }else{

            }
            
        }
            
            break;
        case ShareTypeTencentWeibo: //tencent weibo 暂不处理
        {
            if([DWZShareSDK isTencentWeiboInstalled]){

                
            }else{

            }
            
            
        }
            break;
        case ShareTypeQQ:
        case ShareTypeQQSpace://QQZone
        {
            if([QQApiInterface isQQInstalled]|| [TencentApiInterface isTencentAppInstall:kIphoneQZONE]){
                
                QQApiNewsObject *newsObject = [DWZShareSDK qqMessageFrom:shareSDK.shareContent];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObject];
                QQApiSendResultCode sent;
                if(socialNo == ShareTypeQQ){
                    sent = [QQApiInterface sendReq:req];
                }else if(socialNo == ShareTypeQQSpace){
                    sent = [QQApiInterface SendReqToQZone:req];
                }
                NSLog(@"sent %d",sent);
                
                
            }
        }
            break;
        case ShareTypeWeChatSession:   //wechat好友
        case ShareTypeWeChatTimeline:  //wechat 朋友圈
        {
            if([WXApi isWXAppInstalled]){
                SendMessageToWXReq *wechatReq = [[SendMessageToWXReq alloc] init];
                WXMediaMessage *message = [DWZShareSDK wechatMessageFrom:shareSDK.shareContent];
                wechatReq.message = message;
                wechatReq.bText = NO;
                if(socialNo == ShareTypeWeChatSession){
                    wechatReq.scene = WXSceneSession;
                }else{
                    wechatReq.scene = WXSceneTimeline;
                }
                [WXApi sendReq:wechatReq];
            }
        }
            break;
        default:
            break;
    }

    
}

#pragma mark - sina weibo
+ (WBMessageObject *)weiboMessageFrom:(DWZShareContent *)pContent
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@ %@ %@",pContent.title,pContent.content,pContent.url];
    if(pContent.image){
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(pContent.image, 0.7);
        message.imageObject = imageObject;
    }
    return message;
}

+ (WXMediaMessage *)wechatMessageFrom:(DWZShareContent *)pContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"分享自Game5253";
    message.description = [NSString stringWithFormat:@"%@, %@ %@",pContent.title, pContent.content,pContent.url];
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = pContent.url;
    if(pContent.image){
        NSData *imageData = UIImageJPEGRepresentation(pContent.image, 0.7);
        [message setThumbData:imageData];
    }
    message.mediaObject = webpageObject;
    return message;
}

+ (QQApiNewsObject *)qqMessageFrom:(DWZShareContent *)pContent
{
    NSData *imageData;
    if(pContent.image){
        imageData = UIImageJPEGRepresentation(pContent.image, 0.7);
    }

    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:pContent.url] title:pContent.title description:[NSString stringWithFormat:@"%@ %@",pContent.content,pContent.url] previewImageData:imageData];
    
    return newsObj;
}

#pragma mark -
+ (NSString *) sinaWeiboForHandleURLPrefix
{
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    return [NSString stringWithFormat:@"wb%@",shareSDK.sinaWeiboAppKey];
}

+ (NSString *) sinaWeiboToken
{
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    return shareSDK.sinaWeiboToken;
}

+ (NSString *) tencentWeiboToken
{
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    return shareSDK.tencentWeiboToken;
}
+ (NSString *) tencentWeiboOpenId
{
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    return shareSDK.tencentWeiboOpenId;
}
#pragma mark - tencent weibo
+ (void) tencentWeiboSendMessage:(DWZShareContent *)pContent
{
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@",pContent.title,pContent.content,pContent.url];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:text forKey:@"content"];
    if(pContent.image){
        NSData *imageData =  UIImageJPEGRepresentation(pContent.image, 0.7);
        [params setObject:imageData forKey:@"pic"];
    }
    
    [shareSDK.tencentWeiboApi requestWithParams:params apiName:@"t/add" httpMethod:@"POST" delegate:(id<WeiboRequestDelegate>)self];

    
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
        NSLog(@"get weibo token %@ and expire data %@",shareSDK.sinaWeiboToken,[(WBAuthorizeResponse *)response expirationDate]);
        
//        DWZShareViewController *viewController = [[DWZShareViewController alloc] init];
//        viewController.socialTag = SinaWeiboDWZTag;
//        [shareSDK.baseViewController presentViewController:viewController animated:YES completion:nil];
    }
}

+ (BOOL) handleOpenURL:(NSURL *)url delegate:(id) pDelegate
{
    NSLog(@"get url %@",[url absoluteString]);
    NSString *weiboURLPrefix = [DWZShareSDK sinaWeiboForHandleURLPrefix];
    if([[url absoluteString] hasSuffix:@"platformId=wechat"]){
        return [WXApi handleOpenURL:url delegate:pDelegate];
    }else if([[url absoluteString] hasPrefix:@"tencent"]){
        return [TencentOAuth HandleOpenURL:url];
    }else if([[url absoluteString] hasPrefix:weiboURLPrefix]){
        return [WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)self];
    }
    
    return YES;
}


#pragma mark -
#pragma mark  WeiboRequestDelegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
+ (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"get all %@   -- %s",dict,__func__);

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
    
    NSLog(@"result = %@ , %s",str,__func__);

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
    
    NSLog(@"result = %@ , %s",str,__func__);

    
    

    
}

/**
 * @brief   重刷授权失败后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
+ (void)DidAuthRefreshFail:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
 
    NSLog(@"result = %@ , %s",str,__func__);


}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
+ (void)DidAuthFinished:(WeiboApi *)wbapi_
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    
    NSLog(@"result = %@ , %s",str,__func__);
    DWZShareSDK *shareSDK = [DWZShareSDK shareInstance];
    shareSDK.tencentWeiboApi = wbapi_;
    
    
    DWZShareViewController *viewController = [[DWZShareViewController alloc] init];
    viewController.socialTag = TencentWeiboDWZTag;
    [shareSDK.baseViewController presentViewController:viewController animated:YES completion:nil];


}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
+ (void)DidAuthCanceled:(WeiboApi *)wbapi_
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r", wbapi_.accessToken, wbapi_.openid, wbapi_.appKey, wbapi_.appSecret];
    NSLog(@"result = %@ , %s",str,__func__);

}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
+ (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    NSLog(@"result = %@ , %s",str,__func__);


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

#pragma mark -
+ (BOOL) isTencentWeiboInstalled
{
    NSURL *tencentWeiboURL = [NSURL URLWithString:@"tencentweibo://xx"];
    return [[UIApplication sharedApplication] canOpenURL:tencentWeiboURL];
}

+ (NSArray *)getShareListWithType:(ShareType)shareType, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *array = [NSMutableArray array];
    ShareType eachObject;
    va_list argmentList;
    if(shareType){
        [array addObject:@(shareType)];
        va_start(argmentList, shareType);
        while( (eachObject = va_arg(argmentList, ShareType))){
            [array addObject:@(eachObject)];
        }
        va_end(argmentList);
    }
    return [array copy];
}
+ (DWZShareContent *)content:(NSString *)pConent image:(UIImage *)pImage title:(NSString *)pTitle url:(NSString *)pUrl
{
    DWZShareContent *shareContent = [[DWZShareContent alloc] initWitContent:pConent title:pTitle image:pImage url:pUrl];
    return shareContent;
}
@end
