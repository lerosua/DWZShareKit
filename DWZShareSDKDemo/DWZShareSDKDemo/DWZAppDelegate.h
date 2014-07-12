//
//  DWZAppDelegate.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GESinaWeiboSDKAppKey            @"2xxxxxxx"
#define GETencentWeiboSDKAppKey         @"8xxxxxxxx"
#define GEQZoneSDKAppKey                @"1xxxxxx"
#define GEWechatSDKAppKey               @"wxa769xxxxx"

#define GESinaWeiboSDKAppSecret            @"cxxxxxxxxxxxxxxxxxxxxx7"
#define GETencentWeiboSDKAppSecret         @"9xxxxxxxa96xxxxxxx8axxxxxxx8132a"
#define GEQZoneSDKAppSecret                @"9exxxxxxx6c99xxxxxxxaxxxxxxx8b479f"
#define GEWechatSDKAppSecret               @"5xxxxxxxf552bxxxxxxx024xxxxxxx83f41b"

#define GESinaWeiboSDKAppUri            @"https://api.weibo.com/oauth2/default.html"
#define GETencentWeiboSDKAppUr          @"http://sns.whalecloud.com/app/TOA5iO"
#define GEQZoneSDKAppUr                 @"http://app.5253.com/"
#define GEWechatSDKAppUr                @"http://app.5253.com/"

@interface DWZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
