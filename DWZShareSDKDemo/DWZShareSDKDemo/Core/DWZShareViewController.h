//
//  DWZShareViewController.h
//  DWZShareSDKDemo
//
//  Created by lerosua on 14-4-18.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWZShareKit.h"

@interface DWZShareViewController : UIViewController

@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic) SocialDWZTag socialTag;
@end
