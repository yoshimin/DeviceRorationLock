//
//  YSBaseViewController.m
//  PageCurl
//
//  Created by Shingai Yoshimi on 2/5/13.
//  Copyright (c) 2013 Shingai Yoshimi. All rights reserved.
//

#import "YSBaseViewController.h"

@interface YSBaseViewController ()

@property (nonatomic, strong) UIButton *lockButton;
@property (nonatomic) BOOL screenLocked;

@end

@implementation YSBaseViewController


//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//
#pragma mark -- Initialize --
//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//
#pragma mark -- View Lifesycle --
//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self implementLockButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}


//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//
#pragma mark -- rotation lock --
//★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★─☆｡oﾟ｡★//

- (void)implementLockButton {
    
    self.lockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    UIImage *image = [UIImage imageNamed:@"unlock.png"];
    [_lockButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [_lockButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
    [_lockButton setImage:image forState:UIControlStateNormal];
    [_lockButton addTarget:self action:@selector(toggleForLockScreen) forControlEvents:UIControlEventTouchUpInside];
}

//for iOS5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (_screenLocked) {
        
        return NO;
    }
    
    return YES;
}

//for iOS6 (shouldAutorotateToInterfaceOrientation have been deprecated with iOS 6)
- (BOOL)shouldAutorotate {
    
    if (_screenLocked) {
        
        return NO;
    }
    
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self showLockButton];
}

- (void)showLockButton {
    
    [_lockButton setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
    
    [self.view addSubview:_lockButton];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeLockButton) object:nil];
    [self performSelector:@selector(removeLockButton) withObject:nil afterDelay:2.5];
}

- (void)removeLockButton {
    
    [_lockButton removeFromSuperview];
}

- (void)toggleForLockScreen {
    
    if (_screenLocked) {
        
        [_lockButton setImage:[UIImage imageNamed:@"unlock.png"] forState:UIControlStateNormal];
    } else {
        
        [_lockButton setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
    }
    _screenLocked = !_screenLocked;
}


- (void)deviceDidRotate:(NSNotification*)notification {
    
    UIDeviceOrientation orientation = [notification.object orientation];
    
    if (_screenLocked && (UIDeviceOrientationIsLandscape(orientation) || orientation == UIDeviceOrientationPortrait)) {
        
        [self showLockButton];
    }
}


@end
