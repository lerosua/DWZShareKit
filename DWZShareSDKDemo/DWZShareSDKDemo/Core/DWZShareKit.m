//
//  DWZShareSDK.m
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "DWZShareKit.h"
#import "WeiboSDK.h"        //sina weibo
#import "TencentOAuth.h"
#import "QQApiInterface.h"
#import "TencentApiInterface.h"
#import "WXApi.h"           //wechat
#import "DWZShareViewController.h"
#import <objc/runtime.h>
#import <MessageUI/MessageUI.h>

#import "DWZSocialView.h"
#import "DWZShareContent.h"

@import ImageIO;

NSString *ShareKitKeyToken = @"ShareKitKeyToken";
NSString *ShareKitKeyExpire = @"ShareKitKeyExpire";
NSString *ShareKitKeyUserId = @"ShareKitKeyUserId";
NSString *ShareKitKeyAppId = @"ShareKitKeyAppId";

@interface DWZShareKit()<WeiboSDKDelegate,
                        TencentSessionDelegate,
                        WXApiDelegate,
                        QQApiInterfaceDelegate,
                        DWZSocialDelegate,
                        MFMailComposeViewControllerDelegate
                        >

//新浪数据
@property (nonatomic,strong) NSString *sinaWeiboAppKey;
@property (nonatomic,strong) NSString *sinaWeiboAppSecret;
@property (nonatomic,strong) NSString *sinaWeiboAppUrl;
@property (nonatomic,strong) NSString *sinaWeiboToken;

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

@property (nonatomic,assign) BOOL clickWhenNoInstalled;

@end

@implementation DWZShareKit

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
    
    DWZShareKit *kit = [DWZShareKit shareInstance];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:appKey];
    
    kit.sinaWeiboAppKey = appKey;
    kit.sinaWeiboAppSecret = appSecret;
    kit.sinaWeiboAppUrl = redirectUri;
    
    
}

+ (void)connectQZoneWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    kit.qqZoneAppKey = appKey;
    kit.qqZoneAppSecret = appSecret;
    kit.tencentOAuth = [[TencentOAuth alloc] initWithAppId:appKey andDelegate:kit];
}

+ (void)connectWeChatWithAppId:(NSString *)appId
                     wechatCls:(Class)wechatCls
{
    [WXApi registerApp:appId];
    DWZShareKit *kit = [DWZShareKit shareInstance];
    kit.weChatAppId = appId;
    
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
    
    DWZShareKit *kit = [DWZShareKit shareInstance];
    kit.shareContent = content;
    kit.socialList = shareList;
    kit.delegate = pDelegate;
    
    DWZSocialView *view = [[DWZSocialView alloc] initWithArray:shareList withDelegate:kit];
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
    
    DWZShareKit *kit = [DWZShareKit shareInstance];
    kit.shareContent = content;
    kit.socialList = shareList;
    kit.delegate = pDelegate;
    DWZSocialView *view = [[DWZSocialView alloc] initWithArray:shareList withDelegate:kit];
    view.customShareObject = shareObject;
    [view show];
    
    return nil;
}


#pragma mark -
- (void)socialButton:(UIButton *)sender clickedAtIndex:(NSInteger)index {
    ShareType shareType =(int) index;
    
    [self handleShareWithShareType:shareType];
}

+ (int)countTheStrLength:(NSString*)aString {
    
    int strlength = 0;
    char* p = (char*)[aString cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[aString lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength + 1) / 2;
}

#pragma mark - Public API

- (void)resetShareContent:(DWZShareContent *)content {
    self.shareContent = content;
}

- (void)shareContent:(DWZShareContent *)shareContent
           shareType:(ShareType)shareType {
    DWZShareKit *kit = [DWZShareKit shareInstance];
    kit.shareContent = shareContent;
    
    [self handleShareWithShareType:shareType];
}


+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id)pDelegate {
    NSLog(@"get ---url %@",[url absoluteString]);
    DWZShareKit *kit = [DWZShareKit shareInstance];
    NSString *weiboURLPrefix = [DWZShareKit sinaWeiboForHandleURLPrefix];
    NSString *wechatURLPrefix = [DWZShareKit wechatForHandleURLPrefx];
    if ([[url absoluteString] hasPrefix:wechatURLPrefix]) {
        return [WXApi handleOpenURL:url delegate:kit];
    } else if ([[url absoluteString] hasPrefix:@"tencent"]) {
        return [TencentOAuth HandleOpenURL:url];
    } else if ([[url absoluteString] hasPrefix:weiboURLPrefix]) {
        return [WeiboSDK handleOpenURL:url delegate:kit];
    }
    
    return YES;
}

#pragma mark - Previte API

- (void)handleShareWithShareType:(ShareType)shareType {
    DWZShareKit *kit = [DWZShareKit shareInstance];
    
    if([kit.delegate respondsToSelector:@selector(shareKit:willAction:)]){
        [kit.delegate shareKit:kit willAction:shareType];
    }
    
    switch (shareType) {
        case ShareTypeCustom:
        {
            [self shareToCustom];
        }
            break;
        case ShareTypeSinaWeibo:     //sina weibo
        {
            [self shareToSinaWeiBo];
        }
            break;
        case ShareTypeTencentWeibo: //tencent weibo 暂不处理
        {

        }
            break;
        case ShareTypeQQ:
        case ShareTypeQQSpace://QQZone
        {
            [self shareToQQWithShareType:shareType];
        }
            break;
        case ShareTypeWeChatSession:   //wechat好友
        case ShareTypeWeChatTimeline:  //wechat 朋友圈
        {
            [self shareToWeChatWithShareType:shareType];
        }
            break;
        case ShareTypeEmail: {
            [self shareToEmail];
        }
            break;
        default:
            break;
    }
}

- (void)shareToSinaWeiBo {
    if ([WeiboSDK isWeiboAppInstalled]) {
        DWZShareKit *kit = [DWZShareKit shareInstance];
        
        WBMessageObject *obj = [DWZShareKit weiboMessageFrom:kit.shareContent];
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:obj];
        request.userInfo = @{@"shareMessageFrom":@"DWZShareKitDemo"};
        [WeiboSDK sendRequest:request];
        
    } else {
        NSLog(@"not install sina");
    }
}

- (void)shareToQQWithShareType:(ShareType)shareType {
    if([QQApiInterface isQQInstalled]|| [TencentApiInterface isTencentAppInstall:kIphoneQZONE]){
        DWZShareKit *kit = [DWZShareKit shareInstance];
        
        QQApiNewsObject *newsObject = [DWZShareKit qqMessageFrom:kit.shareContent];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObject];
        QQApiSendResultCode sent;
        if (shareType == ShareTypeQQ) {
            sent = [QQApiInterface sendReq:req];
        } else if(shareType == ShareTypeQQSpace) {
            sent = [QQApiInterface SendReqToQZone:req];
        } else {
            // 消除警告
            sent = EQQAPISENDFAILD;
        }
        NSLog(@"sent %d",sent);
        
        
    }else{
        NSLog(@"not install QQ");
        
    }
}

- (void)shareToCustom {
    DWZShareKit *kit = [DWZShareKit shareInstance];
    
    if ([kit.delegate respondsToSelector:@selector(shareSDKResponse:operationType:)]) {
        [kit.delegate shareSDKResponse:ShareTypeCustom operationType:OperationTypeSuccess];
    }
}

- (void)shareToWeChatWithShareType:(ShareType)shareType {
    if ([WXApi isWXAppInstalled]) {
        DWZShareKit *kit = [DWZShareKit shareInstance];
        
        SendMessageToWXReq *wechatReq = [[SendMessageToWXReq alloc] init];
        WXMediaMessage *message = [DWZShareKit wechatMessageFrom:kit.shareContent shareType:shareType];
        wechatReq.message = message;
        wechatReq.bText = NO;
        if (shareType == ShareTypeWeChatSession) {
            wechatReq.scene = WXSceneSession;
        } else {
            wechatReq.scene = WXSceneTimeline;
        }
        [WXApi sendReq:wechatReq];
    } else {
        NSLog(@"not install wechat");
        
    }
}

- (void)shareToEmail {
    DWZShareKit *kit = [DWZShareKit shareInstance];
    DWZShareContent *shareContent = kit.shareContent;
    
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController setSubject:shareContent.title];
    [mailComposeViewController setMessageBody:[NSString stringWithFormat:@"%@ %@\n点击链接:%@", shareContent.title, shareContent.content, shareContent.url] isHTML:YES];
    NSData *imageData = UIImagePNGRepresentation(shareContent.image);
    [mailComposeViewController addAttachmentData:imageData mimeType:@"" fileName: @"Icon.png"];
    if (mailComposeViewController) {
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:mailComposeViewController animated:YES completion:nil];
    }
}

#pragma mark - fixSinaBundleID

+ (void) fixSinaBundleID:(NSString *)sinaBundleID
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

#pragma mark - URL Prefix Handle Methods

+ (NSString *) sinaWeiboForHandleURLPrefix
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    return [NSString stringWithFormat:@"wb%@",kit.sinaWeiboAppKey];
}
+ (NSString *) wechatForHandleURLPrefx
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    return [NSString stringWithFormat:@"%@://",kit.weChatAppId];
}

+ (NSString *) sinaWeiboToken
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    return kit.sinaWeiboToken;
}

+ (NSString *) tencentWeiboToken
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    return kit.tencentWeiboToken;
}
+ (NSString *) tencentWeiboOpenId
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    return kit.tencentWeiboOpenId;
}

#pragma mark - Get Message Model Helper Methods

+ (WBMessageObject *)weiboMessageFrom:(DWZShareContent *)pContent
{
    WBMessageObject *message = [WBMessageObject message];
    NSString *body = [NSString stringWithFormat:@"%@ %@",pContent.title,pContent.content];
    NSInteger urlLength = [self countTheStrLength:pContent.url];
    NSInteger contentLength = [self countTheStrLength:body];
    
    if(contentLength + urlLength > 140){
        message.text = [NSString stringWithFormat:@"%@ %@",[body substringToIndex:139-urlLength],pContent.url];
    }else{
        message.text = [NSString stringWithFormat:@"%@ %@",body,pContent.url];
        
    }
    
    if(pContent.shareImage){
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(pContent.shareImage, 0.7);
        message.imageObject = imageObject;
    }else if (pContent.image){
        WBImageObject *imageObject = [WBImageObject object];
        imageObject.imageData = UIImageJPEGRepresentation(pContent.image, 0.7);
        message.imageObject = imageObject;
    }
    
    return message;
}

+ (WXMediaMessage *)wechatMessageFrom:(DWZShareContent *)pContent shareType:(ShareType)socialNo {
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    if (socialNo == ShareTypeWeChatSession) {
        message.title = pContent.title;
        message.description = pContent.content;
        
    } else if (socialNo == ShareTypeWeChatTimeline) {
        
        message.title = [NSString stringWithFormat:@"%@ %@", pContent.title, pContent.content];
        
    }
    
    
    
    if(pContent.shareImage){
        NSData *imageData = UIImageJPEGRepresentation(pContent.shareImage, 0.7);
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = imageData;
        imageObject.imageUrl = pContent.url;
        message.mediaObject = imageObject;
    }else{
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = pContent.url;
        
        if(pContent.image){
            NSData *imageData = UIImageJPEGRepresentation(pContent.image, 0.7);
            [message setThumbData:imageData];
        }
        message.mediaObject = webpageObject;
    }
    
    return message;
}

+ (QQApiNewsObject *)qqMessageFrom:(DWZShareContent *)pContent
{
    NSData *imageData;
    if(pContent.image){
        imageData = UIImageJPEGRepresentation(pContent.image, 0.7);
    }
    
    QQApiNewsObject *newsObj;
    if(pContent.shareImage){
//        NSData *shareData = UIImageJPEGRepresentation(pContent.shareImage, 0.7);
//        NSArray *shareArray = @[shareData];
//        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:pContent.url] title:pContent.title description:pContent.content previewImageData:imageData imageDataArray:shareArray];
        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:pContent.url] title:pContent.title description:pContent.content previewImageData:imageData];

    }else{
        newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:pContent.url] title:pContent.title description:pContent.content previewImageData:imageData];
    }
    return newsObj;
}

#pragma mark - MFMailComposeViewController Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{    //关闭邮件发送窗口
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
}

#pragma mark - sina weibo delegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    NSLog(@"get weibo request");
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"get weibo response");
    DWZShareKit *kit = [DWZShareKit shareInstance];
    
    if([response isKindOfClass:[WBSendMessageToWeiboResponse class]]){
        WeiboSDKResponseStatusCode statusCode = response.statusCode;
        
        if(statusCode == WeiboSDKResponseStatusCodeSuccess) {
            //新浪分享成功
            NSLog(@"sina share success");
            if ([kit.delegate respondsToSelector:@selector(shareSDKResponse:operationType:)]) {
                [kit.delegate shareSDKResponse:ShareTypeSinaWeibo operationType:OperationTypeSuccess];
            }
            
        } else {
            OperationType operationType = OperationTypeNotNetwork;
            if (statusCode == WeiboSDKResponseStatusCodeUserCancel) {
                operationType = OperationTypeUserCancel;
            }
            if ([kit.delegate respondsToSelector:@selector(shareSDKResponse:operationType:)]) {
                [kit.delegate shareSDKResponse:ShareTypeSinaWeibo operationType:operationType];
            }
        }
        
    }else if ([response isKindOfClass:[WBAuthorizeResponse class]]){
        if ([kit.authDelegate respondsToSelector:@selector(shareSDKLoginResponse:authInfo:operationType:)]) {
            WBAuthorizeResponse *authorizeResponse = (WBAuthorizeResponse *)response;
            
            OperationType operationType = OperationTypeSuccess;
            
            if(response.statusCode == WeiboSDKResponseStatusCodeSuccess && authorizeResponse.accessToken && authorizeResponse.expirationDate && authorizeResponse.userID){
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:response.userInfo];
                [kit.authDelegate shareSDKLoginResponse:ShareTypeSinaWeibo authInfo:userInfo operationType:operationType];
            } else {
                if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
                    operationType = OperationTypeNotNetwork;
                } else {
                    operationType = OperationTypeUserCancel;
                }
                [kit.authDelegate shareSDKLoginResponse:ShareTypeSinaWeibo authInfo:nil operationType:operationType];
            }
        }
    }
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

#pragma mark - wechat & qq & qqzone delegate

- (void)onReq:(BaseReq *)req {
    NSLog(@"get req %@",req);
    
}

- (void)onResp:(BaseResp *)resp {
    NSLog(@"get resp %@",resp);
    DWZShareKit *kit = [DWZShareKit shareInstance];
    
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        if(resp.errCode == 0){
            NSLog(@"wechat share success");
            if ([kit.delegate respondsToSelector:@selector(shareSDKResponse:operationType:)]) {
                [kit.delegate shareSDKResponse:ShareTypeWeChatSession operationType:OperationTypeSuccess];
            }
            
        }else{
            NSLog(@"wechat share cancel");
            if ([kit.delegate respondsToSelector:@selector(shareSDKResponse:operationType:)]) {
                [kit.delegate shareSDKResponse:ShareTypeWeChatSession operationType:OperationTypeUserCancel];
            }
            
        }
    }else if ([resp isKindOfClass:[QQBaseResp class]]){
        SendMessageToQQResp *sendResp = (SendMessageToQQResp *)resp;
        if(sendResp.errorDescription == nil){
            NSLog(@"qq share sucess");
            if ([kit.delegate respondsToSelector:@selector(shareSDKResponse:operationType:)]) {
                [kit.delegate shareSDKResponse:ShareTypeQQ operationType:OperationTypeSuccess];
            }
        }else{
            NSLog(@"qq share cancel");
            if ([kit.delegate respondsToSelector:@selector(shareSDKResponse:operationType:)]) {
                [kit.delegate shareSDKResponse:ShareTypeQQ operationType:OperationTypeUserCancel];
            }
        }
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response {
    
}

#pragma mark -
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

+ (BOOL) canClickWhenNoInstalled
{
    DWZShareKit *kit =  [DWZShareKit shareInstance];
    return kit.clickWhenNoInstalled;
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

+ (DWZShareContent *)content:(NSString *)pConent image:(UIImage *)pImage title:(NSString *)pTitle url:(NSString *)pUrl withShareImage:(UIImage *)shareImage;
{
    DWZShareContent *shareContent = [[DWZShareContent alloc] initWitContent:pConent title:pTitle image:pImage url:pUrl];
    shareContent.shareImage = shareImage;
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
        
        [kit.tencentOAuth authorize:permissions inSafari:YES];
        
    }else{
        NSLog(@"use webview login QQ");
    }
}

+ (BOOL) getQQLoginUserInfo {
    DWZShareKit *kit = [DWZShareKit shareInstance];
    return [kit.tencentOAuth getUserInfo];
}

#pragma mark - tencent qq login delegate

- (void)tencentDidLogin
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    if ([kit.authDelegate respondsToSelector:@selector(shareSDKLoginResponse:authInfo:operationType:)]) {
        NSDictionary *userInfo = @{ShareKitKeyToken: kit.tencentOAuth.accessToken,
                                   ShareKitKeyExpire: kit.tencentOAuth.expirationDate,
                                   ShareKitKeyUserId: kit.tencentOAuth.openId,
                                   ShareKitKeyAppId:  kit.tencentOAuth.appId
                                   };
        [kit.authDelegate shareSDKLoginResponse:ShareTypeQQ authInfo:userInfo operationType:OperationTypeSuccess];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"qq login cancel");
    DWZShareKit *kit = [DWZShareKit shareInstance];
    
    if ([kit.authDelegate respondsToSelector:@selector(shareSDKLoginResponse:authInfo:operationType:)]) {
        [kit.authDelegate shareSDKLoginResponse:ShareTypeQQ authInfo:nil operationType:OperationTypeUserCancel];
    }
}

- (void)tencentDidNotNetWork
{
    DWZShareKit *kit = [DWZShareKit shareInstance];
    if ([kit.authDelegate respondsToSelector:@selector(shareSDKLoginResponse:authInfo:operationType:)]) {
        [kit.authDelegate shareSDKLoginResponse:ShareTypeQQ authInfo:nil operationType:OperationTypeNotNetwork];
    }
}

- (void)getUserInfoResponse:(APIResponse*) response {
    DWZShareKit *kit = [DWZShareKit shareInstance];
    
    BOOL success = (response.retCode == URLREQUEST_SUCCEED);
    if ([kit.authDelegate respondsToSelector:@selector(shareSDKUserInfo:success:)]) {
        [kit.authDelegate shareSDKUserInfo:(success ? response.jsonResponse : nil) success:success];
    }
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    return nil;
}

- (void)tencentDidLogout
{
    NSLog(@"qq DidLogout");
}

@end
