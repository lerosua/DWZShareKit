DWZShareKit
===========
DWZShareKit是一个简单的分享项目，目前支持新浪，QQ，QQ空间，微信 sso分享，新浪/QQ的sso登录。会自动检测手机里有没有装相对应的应用，如果已安装则直接跳到相应的应用里分享信息。如果没装则在分享界面显示灰色按钮，不能进行分享。

![image](https://raw.githubusercontent.com/lerosua/DWZShareKit/master/dwzsharekit-demo.png)

## 编译注意事项。
~~微信等SDK不支持64位编译，因此引入后要把 Target Build Setting中的Architectures改为 $(ARCHS\_STANDARD\_32\_BIT)
SDK里有用到C++混编，因此要最好把main.m改成main.mm才能通过编译。~~
1.2.6版本已经支持64位，至此SDK已匹配64位编译

###更新
1.3.1 更新微博SDK至3.1.1 以适配ios9的新策略

1.3  合并xhzengAIB大神的pr
	详情：1.添加分享操作类型区分 2.添加授权操作类型区分 3.统一代码风格和结构
1.2.7.pre
	更新QQ互联至2.9
	更新新浪微博SDK至3.0.0

1.2.6 更新64编译

1.2.5
微信SDK更新至1.5, 支持64位编译
新浪微博SDK更新至2.5.1,支持64位编译
~~QQ互联仍然是2.2, 不支持64位编译～～

***注意*** 
项目的info.plist文件里必须要注册相对应的URL,如图所示
![image](https://raw.githubusercontent.com/lerosua/DWZShareKit/master/URL-setting.png)

## Podfile
[CocosPods](http://cocosPods.org) is the recommended method to install DWZShareKit, just add the following line to `Podfile`

```
pod 'DWZShareKit'

```

## How to Use
在新浪/QQ/微信中注册好相应的应用app，取得相应的appkey,并在您的应用中填入.
比如以下,填入你应用相关信息
```objc
#define GESinaWeiboSDKAppKey            @"2xxxxxxx"
#define GEQZoneSDKAppKey                @"1xxxxxx"
#define GEWechatSDKAppKey               @"wxa769xxxxx"

#define GESinaWeiboSDKAppSecret            @"cxxxxxxxxxxxxxxxxxxxxx7"
#define GETencentWeiboSDKAppSecret         @"9xxxxxxxa96xxxxxxx8axxxxxxx8132a"
#define GEQZoneSDKAppSecret                @"9exxxxxxx6c99xxxxxxxaxxxxxxx8b479f"
#define GEWechatSDKAppSecret               @"5xxxxxxxf552bxxxxxxx024xxxxxxx83f41b"

#define GESinaWeiboSDKAppUri            @"https://api.weibo.com/oauth2/default.html"
````
在AppDelegate注册
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
        
	[DWZShareKit connectSinaWeiboWithAppKey:GESinaWeiboSDKAppKey appSecret:GESinaWeiboSDKAppSecret redirectUri:GESinaWeiboSDKAppUri];
	[DWZShareKit connectWeChatWithAppId:GEWechatSDKAppKey wechatCls:nil];
	[DWZShareKit connectQZoneWithAppKey:GEQZoneSDKAppKey appSecret:GEQZoneSDKAppSecret];
    
	return YES;
}

```

仍在AppDelegate中，响应回调
```objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [DWZShareKit handleOpenURL:url delegate:self];
}
```


在需要分享的ViewController，实现DWZShareSDKDelegate协议，
```objc
- (void)shareSDKResponse:(ShareType)socialType Success:(BOOL)sucess
{
    NSLog(@"sharesdk response back %d",sucess);
}
```
调用分享时
```objc
- (IBAction)ShareButtonAction:(id)sender
{
	NSArray *shareArray = [DWZShareKit getShareListWithType:ShareTypeSinaWeibo,ShareTypeQQ,ShareTypeQQSpace,ShareTypeWeChatSession,ShareTypeWeChatTimeline,nil];

	//图标不要过大，不然会分享失败
	UIImage *image = [UIImage imageNamed:@"QQIcon"];
	//内容不要超过120字，因为加上标题和链接，要求在140字以内。这里会自动截断。
	DWZShareContent *content = [DWZShareKit content:@"视频描述" image:image title:@"视频标题" url:@"http://baidu.com"];
	        
	[DWZShareKit showDefaultShareWith:content serviceShareList:shareArray withDelegate:self];
}

```

## 登录功能
在需要登录的ViewController,实现DWZShareKitAuthDelegate协议，
```objc
- (void) shareSDKLoginResponse:(ShareType)socialType WithInfo:(NSDictionary *)userInfo Success:(BOOL)success
{
    if(!success){
        return;
    }
    switch (socialType) {
        case ShareTypeSinaWeibo:
        {
	    //userInfo字典包含了以下数据:
	    //            NSString *ShareKitKeyToken = @"ShareKitKeyToken";
	    //            NSString *ShareKitKeyExpire = @"ShareKitKeyExpire";
	    //            NSString *ShareKitKeyUserId = @"ShareKitKeyUserId";
	    //            NSString *ShareKitKeyAppId = @"ShareKitKeyAppId";
	    
	    //GEUserEntity是虚拟的对象，演示把获取到的数据存储而已
            GEUserEntity *entity = [GEUserEntity shareInstance];
            [entity setupSinaWeibo:userInfo[ShareKitKeyUserId] Token:userInfo[ShareKitKeyToken] ExpirationDate:userInfo[ShareKitKeyExpire]];
            [GEUserInfo setLoginUser:entity];
        }
            break;
        case ShareTypeQQ:
        case ShareTypeQQSpace:
        {
            GEUserEntity *entity = [GEUserEntity shareInstance];
            [entity setupQQ:userInfo[ShareKitKeyUserId] Token:userInfo[ShareKitKeyToken] ExpirationDate:userInfo[ShareKitKeyExpire] AppId:userInfo[ShareKitKeyAppId]];
            [GEUserInfo setLoginUser:entity];
        }
            break;
        case ShareTypeWeChatSession:
        case ShareTypeWeChatTimeline:
            break;
        default:
            break;
    }
}
```
## License

中文:DWZShareKit 是在MIT协议下使用的，可以在LICENSE文件里面找到相关的使用协议信息。

English: DWZShareKit is available under the MIT license, see the LICENSE file for more information.


