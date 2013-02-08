//
//  YSViewController.h
//  RotationLock
//
//  Created by Shingai Yoshimi on 2/8/13.
//  Copyright (c) 2013 Shingai Yoshimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSBaseViewController.h"

@interface YSViewController : YSBaseViewController <UIActionSheetDelegate, UIWebViewDelegate>

- (id) initWithURL:(NSURL*)url;

@end
