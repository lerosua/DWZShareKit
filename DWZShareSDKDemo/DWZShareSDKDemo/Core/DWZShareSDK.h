//
//  DWZShareSDK.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  WBMessageObject;

@interface DWZShareSDK : NSObject
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

/**
 *  单例对象
 *
 *  @return 返回一个全局单例的DWZShareSDK对象
 */
+ (instancetype) shareInstance;

/**
 *  @brief 通过URL启动第三方应用时传递的数据
 *
 *  @param url       启动第三方应用的URL
 *  @param pDelegate 用于接收SDK触发消息的委托
 *
 *  @return 返回布尔值
 */
+ (BOOL) handleOpenURL:(NSURL *)url delegate:(id) pDelegate;

/**
 *  创建默认分享选项
 *
 *  @param title     分享视图标题
 *  @param shareList 分享服务列表,sina,qqzone这些
 *
 *  @return 暂未定义
 */
+ (id) showDefaultShareWithTitle:(NSString *)title
                serviceShareList:(NSArray *)shareList
              withViewController:(UIViewController *)viewController;

/**
 *  转换文本消息为微博消息对象
 *
 *  @param text 文本消息
 *
 *  @return 微博消息对象
 */
+ (WBMessageObject *)weiboMessageFrom:(NSString *)text;
@end
