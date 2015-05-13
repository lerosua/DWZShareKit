//
//  DWZShareSDK.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWZShareSDKTypeDef.h"
#import "DWZCustomShareObject.h"

@class  WBMessageObject;
@class DWZShareContent;
@class DWZShareKit;

@protocol DWZShareSDKDelegate <NSObject>
/**
 *  shareSDK分享后的回调
 *
 *  @param socialType 所分享的社交类型
 *  @param sucess     分享的结果，YES为成功，反之失败,暂不计算失败类型
 */
- (void) shareSDKResponse:(ShareType)socialType Success:(BOOL)success;

@optional
- (void) shareKit:(DWZShareKit *)kit willAction:(ShareType)socialType;
- (void) shareKitResponse:(ShareType)socialType Success:(BOOL)success;

@end

@protocol DWZShareKitAuthDelegate <NSObject>
- (void) shareSDKLoginResponse:(ShareType)socialType WithInfo:(NSDictionary *)userInfo Success:(BOOL)success;
@end

@interface DWZShareKit : NSObject

#pragma mark - connect
/**
 *  @brief 连接新浪微博开放平台
 *
 *  @param appKey      应用Key
 *  @param appSecret   应用密钥
 *  @param redirectUri 应用回调地址,无回调页面或者不需要返回回调时可以填写新浪默认回调页面：https://api.weibo.com/oauth2/default.html
 *                          但新浪开放平台中应用的回调地址必须填写此值
 */
+ (void)connectSinaWeiboWithAppKey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                       redirectUri:(NSString *)redirectUri;


/**
 *	@brief	连接腾讯微博开放平台应用以使用相关功能,
 *          http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 *	@param 	redirectUri 	回调地址，此地址则为应用地址。
 */
+ (void)connectTencentWeiboWithAppKey:(NSString *)appKey
                            appSecret:(NSString *)appSecret
                          redirectUri:(NSString *)redirectUri;


/**
 *	@brief	连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
 *          http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
 *
 *	@param 	appKey 	应用Key
 *	@param 	appSecret 	应用密钥
 */
+ (void)connectQZoneWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret;


/**
 *	@brief	连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
 *          http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
 *
 *	@param 	appId 	应用ID
 *	@param 	wechatCls 	微信Api类型，引入WXApi.h后，将[WXApi class]传入此参数
 */
+ (void)connectWeChatWithAppId:(NSString *)appId
                     wechatCls:(Class)wechatCls;

#pragma mark - init
/**
 *  单例对象
 *
 *  @return 返回一个全局单例的DWZShareSDK对象
 */
+ (instancetype) shareInstance;

#pragma mark - Share
- (void)resetShareContent:(DWZShareContent *)content;

- (void)shareContent:(DWZShareContent *)shareContent
           shareType:(ShareType)shareType;

#pragma mark - handleOpenURL
/**
 *  @brief 通过URL启动第三方应用时传递的数据
 *
 *  @param url       启动第三方应用的URL
 *  @param pDelegate 用于接收SDK触发消息的委托
 *
 *  @return 返回布尔值
 */
+ (BOOL) handleOpenURL:(NSURL *)url delegate:(id) pDelegate;

#pragma mark - show ActionSheet
/**
 *  创建默认分享选项
 *
 *  @param title     分享视图标题
 *  @param shareList 分享服务列表,sina,qqzone这些
 *
 *  @return 暂未定义
 */
+ (id) showDefaultShareWith:(DWZShareContent *)content
           serviceShareList:(NSArray *)shareList
               withDelegate:(id<DWZShareSDKDelegate>)pDelegate;

+ (id) showDefaultShareWith:(DWZShareContent *)content
           serviceShareList:(NSArray *)shareList
            withCustomShare:(DWZCustomShareObject *)shareObject
               withDelegate:(id<DWZShareSDKDelegate>)pDelegate;

#pragma mark - something social
/**
 *  转换文本消息为微博消息对象
 *
 *  @param text 文本消息
 *
 *  @return 微博消息对象
 */
+ (WBMessageObject *)weiboMessageFrom:(DWZShareContent *)pContent;

/**
 *  返回handleURL需要的sina weibo的url的前缀
 *
 *  @return 返回wbxxxx的前缀
 */
+ (NSString *) sinaWeiboForHandleURLPrefix;
+ (NSString *) sinaWeiboToken;

+ (void) tencentWeiboSendMessage:(DWZShareContent *)pContent;

+ (BOOL) isTencentWeiboInstalled;
+ (BOOL) isQQInstalled;
+ (BOOL) isWeiboInstalled;
+ (BOOL) isWeChatInstalled;

+ (BOOL) canClickWhenNoInstalled;

#pragma mark -
/**
 *  获取要支持的分享列表
 *
 *  @param shareType 社会化平台类型
 *
 *  @return 分享列表
 */
+ (NSArray *)getShareListWithType:(ShareType)shareType, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  创建分享的对象
 *
 *  @param pConent 分享的内容
 *  @param pImage  分享的图标
 *  @param pTitle  分享的标题
 *  @param pUrl    分享的URL
 *
 *  @return 分享内容对象
 */
+ (DWZShareContent *)content:(NSString *)pConent image:(UIImage *)pImage title:(NSString *)pTitle url:(NSString *)pUrl;

/**
 *  创建分享的对象
 *
 *  @param pConent 分享的内容
 *  @param pImage  分享的图标
 *  @param pTitle  分享的标题
 *  @param pUrl    分享的URL
 
 *  @param shareImage 分享的大图
 *
 *  @return 分享内容对象
 */
+ (DWZShareContent *)content:(NSString *)pConent image:(UIImage *)pImage title:(NSString *)pTitle url:(NSString *)pUrl withShareImage:(UIImage *)shareImage;


+ (void) loginWithSinaWithDelegate:(id<DWZShareKitAuthDelegate>)pDelegate;
+ (void) loginWithQQWithDelegate:(id<DWZShareKitAuthDelegate>)pDelegate;

/**
 *  解决企业应用构建后bundleID变化后与新浪设置的bundleID不一致造成的不能返回的问题
 *
 *  @param sinaBundleID 新浪应用里设置的bundleID
 */
+ (void) fixSinaBundleID:(NSString *)sinaBundleID;
@end
