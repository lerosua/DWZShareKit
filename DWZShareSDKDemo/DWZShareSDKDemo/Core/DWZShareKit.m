//
//  DWZShareSDK.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZShareKit.h"
#import "WeiboSDK.h"        //sina weibo
#import "WeiboApi.h"        //tencent weibo
#import "TencentOAuth.h"
#import "QQApiInterface.h"
#import "TencentApiInterface.h"
#import "WXApi.h"           //wechat
#import "DWZShareViewController.h"
#import <objc/runtime.h>

#import "DWZSocialView.h"
#import "DWZShareContent.h"
NSString *ShareKitKeyToken = @"ShareKitKeyToken";
NSString *ShareKitKeyExpire = @"ShareKitKeyExpire";
NSString *ShareKitKeyUserId = @"ShareKitKeyUserId";
NSString *ShareKitKeyAppId = @"ShareKitKeyAppId";

@interface DWZShareKit()<WeiboSDKDelegate,
//                        WBHttpRequestDelegate,
//                        WeiboRequestDelegate,WeiboAuthDelegate,
                        TencentSessionDelegate,
                        WXApiDelegate,
                        QQApiInterfaceDelegate,
                        DWZSocialDelegate
                        >

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

@property (nonatomic,weak) id<DWZShareSDKDelegate> delegate;
@property (nonatomic,weak) id<DWZShareKitAuthDelegate> authDelegate;

@property (nonatomic,strong) DWZShareContent *shareContent;
@property (nonatomic,strong) NSArray *socialList;

@end

@implementation DWZShareKit

#pragma mark -
//- (TencentOAuth *)tencentOAuth
//{
//    if(!_tencentOAuth){
//        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:self.qqZoneAppKey andDelegate:(id<TencentSessionDelegate>)self];
//    }
//    return _tencentOAuth;
//}

#pragma mark -
+ (instancetype) shareInstance
{
    static DWZShareKit *_currentShareSDK;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _currentShareSDK = [[DWZShareKit alloc] init];
    });
    return _currentShareSDK;
}
#pragma mark - conecnt method
+ (void)connectSinaWeiboWithAppKey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                       redirectUri:(NSString *)redirectUri
{
    
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    
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
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    shareSDK.tencentWeiboApi = [[WeiboApi alloc] initWithAppKey:appKey andSecret:appSecret andRedirectUri:redirectUri];
    
    
}


+ (void)connectQZoneWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
{
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    shareSDK.qqZoneAppKey = appKey;
    shareSDK.qqZoneAppSecret = appSecret;
    shareSDK.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appKey andDelegate:(id<TencentSessionDelegate>)self];


}

+ (void)connectWeChatWithAppId:(NSString *)appId
                     wechatCls:(Class)wechatCls
{
    [WXApi registerApp:appId];
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    shareSDK.weChatAppId = appId;
    
}
#pragma mark -
+ (id) showDefaultShareWith:(DWZShareContent *)content
                serviceShareList:(NSArray *)shareList
               withDelegate:(id<DWZShareSDKDelegate>)pDelegate
{
    if(!shareList){
        NSLog(@"please at less get on social account");
        return nil;
    }

    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    shareSDK.shareContent = content;
    shareSDK.socialList = shareList;
    shareSDK.delegate = pDelegate;

    DWZSocialView *view = [[DWZSocialView alloc] initWithArray:shareList withDelegate:shareSDK];
    [view show];
    
    return nil;
}

+ (id) showDefaultShareWith:(DWZShareContent *)content
           serviceShareList:(NSArray *)shareList
            withCustomShare:(DWZCustomShareObject *)shareObject
               withDelegate:(id<DWZShareSDKDelegate>)pDelegate
{
    if(!shareList){
        NSLog(@"please at less get on social account");
        return nil;
    }
    
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    shareSDK.shareContent = content;
    shareSDK.socialList = shareList;
    shareSDK.delegate = pDelegate;
    DWZSocialView *view = [[DWZSocialView alloc] initWithArray:shareList withDelegate:shareSDK];
    view.customShareObject = shareObject;
    [view show];
    
    return nil;
}


#pragma mark -
- (void) socialButton:(UIButton *)sender clickedAtIndex:(NSInteger) index;
{
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];

    ShareType socialNo = index;
    switch (socialNo) {
        case ShareTypeCustom:
        {
            [shareSDK.delegate shareSDKResponse:ShareTypeCustom Success:YES];

        }
            break;
        case ShareTypeSinaWeibo:     //sina weibo
        {
            if([WeiboSDK isWeiboAppInstalled]){
                WBMessageObject *obj = [DWZShareKit weiboMessageFrom:shareSDK.shareContent];
                WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:obj];
                request.userInfo = @{@"shareMessageFrom":@"DWZShareKitDemo"};
                [WeiboSDK sendRequest:request];
                
            }else{

            }
            
        }
            
            break;
        case ShareTypeTencentWeibo: //tencent weibo 暂不处理
        {
            if([DWZShareKit isTencentWeiboInstalled]){

                
            }else{

            }
            
            
        }
            break;
        case ShareTypeQQ:
        case ShareTypeQQSpace://QQZone
        {
            if([QQApiInterface isQQInstalled]|| [TencentApiInterface isTencentAppInstall:kIphoneQZONE]){
                
                QQApiNewsObject *newsObject = [DWZShareKit qqMessageFrom:shareSDK.shareContent];
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObject];
                QQApiSendResultCode sent;
                if(socialNo == ShareTypeQQ){
                    sent = [QQApiInterface sendReq:req];
                }else if(socialNo == ShareTypeQQSpace){
                    sent = [QQApiInterface SendReqToQZone:req];
                }else{
                    //消除警告
                    sent = EQQAPISENDFAILD;
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
                WXMediaMessage *message = [DWZShareKit wechatMessageFrom:shareSDK.shareContent];
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
    if(message.text.length >140){
        NSString *str = [NSString stringWithFormat:@"%@ %@",pContent.title,pContent.content];
        if(str.length > 140-pContent.url.length){
            message.text = [NSString stringWithFormat:@"%@ %@",[str substringToIndex:140-pContent.url.length],pContent.url];
        }else{
            message.text = [message.text substringToIndex:139];
        }
    }
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
    message.title = pContent.title;
    message.description = [NSString stringWithFormat:@"%@ %@", pContent.content,pContent.url];

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
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    return [NSString stringWithFormat:@"wb%@",shareSDK.sinaWeiboAppKey];
}
+ (NSString *) wechatForHandleURLPrefx
{
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    return [NSString stringWithFormat:@"%@://",shareSDK.weChatAppId];
}

+ (NSString *) sinaWeiboToken
{
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    return shareSDK.sinaWeiboToken;
}

+ (NSString *) tencentWeiboToken
{
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    return shareSDK.tencentWeiboToken;
}
+ (NSString *) tencentWeiboOpenId
{
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    return shareSDK.tencentWeiboOpenId;
}
#pragma mark - tencent weibo
+ (void) tencentWeiboSendMessage:(DWZShareContent *)pContent
{
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
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
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];

    if([response isKindOfClass:WBSendMessageToWeiboResponse.class]){

        if(response.statusCode == WeiboSDKResponseStatusCodeSuccess){
            //新浪分享成功
            NSLog(@"sina share success");
            [shareSDK.delegate shareSDKResponse:ShareTypeSinaWeibo Success:YES];
            
        }else{
            [shareSDK.delegate shareSDKResponse:ShareTypeSinaWeibo Success:NO];
            NSLog(@"sina share cancel");
        }
        
    }else if ([response isKindOfClass:[WBAuthorizeResponse class]]){
        if([shareSDK.authDelegate respondsToSelector:@selector(shareSDKLoginResponse:WithInfo:Success:)]){
            WBAuthorizeResponse *authResponse = (WBAuthorizeResponse *)response;
            
            if(response.statusCode == WeiboSDKResponseStatusCodeSuccess && authResponse.accessToken && authResponse.expirationDate && authResponse.userID){
                NSDictionary *userInfo = @{ShareKitKeyToken: authResponse.accessToken,
                                           ShareKitKeyExpire: authResponse.expirationDate,
                                           ShareKitKeyUserId: authResponse.userID
                                           };
                [shareSDK.authDelegate shareSDKLoginResponse:ShareTypeSinaWeibo WithInfo:userInfo Success:YES];
            }else{
                [shareSDK.authDelegate shareSDKLoginResponse:ShareTypeSinaWeibo WithInfo:nil Success:NO];
            }
        }
    }
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
}

#pragma mark - 系统回调
+ (BOOL) handleOpenURL:(NSURL *)url delegate:(id) pDelegate
{
    NSLog(@"get ---url %@",[url absoluteString]);
    NSString *weiboURLPrefix = [DWZShareKit sinaWeiboForHandleURLPrefix];
    NSString *wechatURLPrefix = [DWZShareKit wechatForHandleURLPrefx];
    if([[url absoluteString] hasPrefix:wechatURLPrefix]){
        return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)self];
    }else if([[url absoluteString] hasPrefix:@"tencent"]){
        return [TencentOAuth HandleOpenURL:url];
//        return [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)self];
//        return [TencentApiInterface handleOpenURL:url delegate:(id<TencentApiInterfaceDelegate>)self];
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
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];
    shareSDK.tencentWeiboApi = wbapi_;
    
    
//    DWZShareViewController *viewController = [[DWZShareViewController alloc] init];
//    viewController.socialTag = TencentWeiboDWZTag;
//    [shareSDK.baseViewController presentViewController:viewController animated:YES completion:nil];


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
    DWZShareKit *shareSDK = [DWZShareKit shareInstance];

    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        if(resp.errCode == 0){
            NSLog(@"wechat share success");
            [shareSDK.delegate shareSDKResponse:ShareTypeWeChatSession Success:YES];
            
        }else{
            NSLog(@"wechat share cancel");
            [shareSDK.delegate shareSDKResponse:ShareTypeWeChatSession Success:NO];

        }
    }else if ([resp isKindOfClass:[QQBaseResp class]]){
        SendMessageToQQResp *sendResp = (SendMessageToQQResp *)resp;
        if(sendResp.errorDescription == nil){
            NSLog(@"qq share sucess");
            [shareSDK.delegate shareSDKResponse:ShareTypeQQ Success:YES];
        }else{
            NSLog(@"qq share cancel");
            [shareSDK.delegate shareSDKResponse:ShareTypeQQ Success:NO];
        }
    }
}
- (void) onReq:(QQBaseReq *)req
{
    NSLog(@"get qq req login");
}
- (void) onResp:(QQBaseResp *)resp
{
    NSLog(@"get qq login resp");
}

#pragma mark -
+ (BOOL) isTencentWeiboInstalled
{
    NSURL *tencentWeiboURL = [NSURL URLWithString:@"tencentweibo://xx"];
    return [[UIApplication sharedApplication] canOpenURL:tencentWeiboURL];
}

+ (BOOL) isQQInstalled
{
    return [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi];
}
+ (BOOL) isWeiboInstalled
{
    return [WeiboSDK isWeiboAppInstalled];
}
+ (BOOL) isWeChatInstalled
{
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

#pragma mark -
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

#pragma mark - login
+ (void) loginWithSinaWithDelegate:(id<DWZShareKitAuthDelegate>)pDelegate
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    kit.authDelegate = pDelegate;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kit.sinaWeiboAppUrl;
    request.scope = @"email,direct_messages_write";
    request.userInfo = @{@"SSO_From": @"ShareKitLogin",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled=NO;
    [WeiboSDK sendRequest:request];
}

+ (void) loginWithQQWithDelegate:(id<DWZShareKitAuthDelegate>)pDelegate
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    kit.authDelegate = pDelegate;
    if([QQApiInterface isQQInstalled]){
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
        
        [kit.tencentOAuth authorize:permissions inSafari:NO];
        
    }else{
        NSLog(@"use webview login QQ");
    }
}


#pragma mark - tencent qq login delegate
+ (void)tencentDidLogin
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    if([kit.authDelegate respondsToSelector:@selector(shareSDKLoginResponse:WithInfo:Success:)]){
        NSDictionary *userInfo = @{ShareKitKeyToken: kit.tencentOAuth.accessToken,
                                   ShareKitKeyExpire: kit.tencentOAuth.expirationDate,
                                   ShareKitKeyUserId: kit.tencentOAuth.openId,
                                   ShareKitKeyAppId:  kit.tencentOAuth.appId
                                   };
        [kit.authDelegate shareSDKLoginResponse:ShareTypeQQ WithInfo:userInfo Success:YES];
    }

}

+ (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"qq login cancel");
    DWZShareKit *kit = [DWZShareKit shareInstance];

    if([kit.authDelegate respondsToSelector:@selector(shareSDKLoginResponse:WithInfo:Success:)]){
        [kit.authDelegate shareSDKLoginResponse:ShareTypeQQ WithInfo:nil Success:NO];
    }
}

+ (void)tencentDidNotNetWork
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    
    if([kit.authDelegate respondsToSelector:@selector(shareSDKLoginResponse:WithInfo:Success:)]){
        [kit.authDelegate shareSDKLoginResponse:ShareTypeQQ WithInfo:nil Success:NO];
    }
    
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    return nil;
}

+ (void)tencentDidLogout
{
    NSLog(@"qq DidLogout");
}


#pragma mark -
- (void) fixSinaBundleID:(NSString *)sinaBundleID
{
    Class c = objc_getClass("WeiboSDK3rdApp");
    id block = ^NSString*()
    {
        return sinaBundleID;
    };
    
    SEL selctor = NSSelectorFromString(@"bundleID");
    IMP test = imp_implementationWithBlock(block);
    Method origMethod = class_getInstanceMethod(c,
                                                selctor);
    
    if(!class_addMethod(c, selctor, test,
                        method_getTypeEncoding(origMethod)))
    {
        method_setImplementation(origMethod, test);
    }
}
@end
