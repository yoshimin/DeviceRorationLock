//
//  UINavigationController+AutoRotate.m
//  PageCurl
//
//  Created by Shingai Yoshimi on 2/2/13.
//  Copyright (c) 2013 Shingai Yoshimi. All rights reserved.
//

#import "UINavigationController+AutoRotate.h"

@implementation UINavigationController (AutoRotate)

- (BOOL)shouldAutorotate {
    
    return [self.visibleViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    
	return [self.visibleViewController supportedInterfaceOrientations];
}


@end
