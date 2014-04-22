//
//  DWZShareSDKTypeDef.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-22.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#ifndef DWZShareSDKDemo_DWZShareSDKTypeDef_h
#define DWZShareSDKDemo_DWZShareSDKTypeDef_h

typedef enum
{
	ShareTypeSinaWeibo = 1,         /**< 新浪微博 */
	ShareTypeTencentWeibo = 2,      /**< 腾讯微博 */
	ShareTypeSohuWeibo = 3,         /**< 搜狐微博 */
    ShareType163Weibo = 4,          /**< 网易微博 */
	ShareTypeDouBan = 5,            /**< 豆瓣社区 */
	ShareTypeQQSpace = 6,           /**< QQ空间 */
	ShareTypeRenren = 7,            /**< 人人网 */
	ShareTypeKaixin = 8,            /**< 开心网 */
	ShareTypePengyou = 9,           /**< 朋友网 */
	ShareTypeFacebook = 10,         /**< Facebook */
	ShareTypeTwitter = 11,          /**< Twitter */
	ShareTypeEvernote = 12,         /**< 印象笔记 */
	ShareTypeFoursquare = 13,       /**< Foursquare */
	ShareTypeGooglePlus = 14,       /**< Google＋ */
	ShareTypeInstagram = 15,        /**< Instagram */
	ShareTypeLinkedIn = 16,         /**< LinkedIn */
	ShareTypeTumblr = 17,           /**< Tumbir */
    ShareTypeMail = 18,             /**< 邮件分享 */
	ShareTypeSMS = 19,              /**< 短信分享 */
	ShareTypeAirPrint = 20,         /**< 打印 */
	ShareTypeCopy = 21,             /**< 拷贝 */
    ShareTypeWeChatSession = 22,     /**< 微信好友 */
	ShareTypeWeChatTimeline = 23,    /**< 微信朋友圈 */
    ShareTypeQQ = 24,               /**< QQ */
    ShareTypeInstapaper = 25,       /**< Instapaper */
    ShareTypePocket = 26,           /**< Pocket */
    ShareTypeYouDaoNote = 27,       /**< 有道云笔记 */
    ShareTypeSohuKan = 28,          /**< 搜狐随身看 */
    ShareTypePinterest = 30,        /**< Pinterest */
    ShareTypeFlickr = 34,           /**< Flickr */
    ShareTypeDropbox = 35,          /**< Dropbox */
    ShareTypeVKontakte = 36,        /**< VKontakte */
    ShareTypeWeChatFav = 37,         /**< 微信收藏 */
    ShareTypeYiXinSession = 38,     /**< 易信好友 */
    ShareTypeYiXinTimeline = 39,    /**< 易信朋友圈 */
    ShareTypeYiXinFav = 40,         /**< 易信收藏 */
    ShareTypeAny = 99               /**< 任意平台 */
}
ShareType;

typedef NS_ENUM(NSInteger, SocialDWZTag) {
    SinaWeiboDWZTag = 0,
    TencentWeiboDWZTag,
    QQZoneDWZTag,
    WechatDWZTag
};

/**
 *	@brief	分享内容的消息类型，仅对微信、QQApi有效
 */
typedef enum
{
	SSPublishContentMediaTypeText = 0, /**< 文本 */
	SSPublishContentMediaTypeImage = 1, /**< 图片 */
	SSPublishContentMediaTypeNews = 2, /**< 新闻 */
	SSPublishContentMediaTypeMusic = 3, /**< 音乐 */
	SSPublishContentMediaTypeVideo = 4, /**< 视频 */
    SSPublishContentMediaTypeApp = 5, /**< 应用,仅供微信使用 */
    SSPublishContentMediaTypeNonGif = 6, /**< 非Gif消息,仅供微信使用 */
    SSPublishContentMediaTypeGif = 7 /**< Gif消息,仅供微信使用 */
}
SSPublishContentMediaType;

#endif
