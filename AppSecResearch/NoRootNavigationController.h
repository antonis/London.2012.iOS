//
//  TVNavigationController.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoRootNavigationController : UINavigationController {
    UIViewController *fakeRootViewController;
}

@property(nonatomic, retain) UIViewController *fakeRootViewController;

-(void)setRootViewController:(UIViewController *)rootViewController;

@end