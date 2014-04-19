//
//  DWZAppDelegate.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-17.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <UIKit/UIKit.h>

#define sinaAppKey             @"2045436852"
#define sinaAppSecret          @"2bdd7461162c3f390706b3d22be5a764"
#define sinaAppRedirectURI     @"http://www.sina.com"


#define GESinaWeiboSDKAppKey            @"2336231021"
#define GETencentWeiboSDKAppKey         @"801495844"
#define GEQZoneSDKAppKey                @"101057351"
#define GEWechatSDKAppKey               @"wxa7696fefdabee869"

#define GESinaWeiboSDKAppSecret            @"c2c8d9720b33346a6c3ab297391e1eb7"
#define GETencentWeiboSDKAppSecret         @"9325b2a9ba96904e83038a09e2c8132a"
#define GEQZoneSDKAppSecret                @"9ed02b5f1e56c99b40114a81318b479f"
#define GEWechatSDKAppSecret               @"5fa3786df552bbaac15024442583f41b"

#define GESinaWeiboSDKAppUri            @"https://openapi.baidu.com/social/oauth/2.0/receiver"
#define GETencentWeiboSDKAppUr          @"http://sns.whalecloud.com/app/TOA5iO"
#define GEQZoneSDKAppUr                 @"http://app.5253.com/"
#define GEWechatSDKAppUr                @"http://app.5253.com/"

@interface DWZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
