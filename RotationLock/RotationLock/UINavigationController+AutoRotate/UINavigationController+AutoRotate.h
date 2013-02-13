//
//  UINavigationController+AutoRotate.h
//  PageCurl
//
//  Created by Shingai Yoshimi on 2/2/13.
//  Copyright (c) 2013 Shingai Yoshimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (AutoRotate)

-(BOOL)shouldAutorotate;
-(NSUInteger)supportedInterfaceOrientations;

@end
