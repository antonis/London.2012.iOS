//
//  AppDelegate.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeScrollerViewController.h"
#import "iAd/ADBannerView.h"

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define APP_NAME @"2012 Summer Games Schedule"
#define APP_LINK @"http://bit.ly/PPFGOp"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define NOT_IPAD (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
#define PORTRAIT ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait)
#define LANDSCAPE ([[UIDevice currentDevice] orientation] != UIInterfaceOrientationPortrait)

#define UIColorFromRGB(rgbValue) [UIColor   colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                            green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
                                            blue:((float)(rgbValue & 0x0000FF))/255.0 \
                                            alpha:1.0]

#define SCREEN_WIDTH (IS_IPAD?768.0f:320.0f)
#define SCREEN_HEIGHT (IS_IPAD?1024.0f:480.0f)
#define NAVIGATION_BAR 44.0f
#define STATUS_BAR 20.0f
#define TAB_BAR 49.0f

#define HAS_ADS YES
#define SharedAdBannerView ((AppDelegate *)[[UIApplication sharedApplication] delegate]).adBanner
#define AdBannerViewHeight (HAS_ADS?(IS_IPAD?66.0f:50.0f):0.0f)

#define VIEW_FRAME CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR-STATUS_BAR)
#define VIEW_FRAME_WITH_AD CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR-STATUS_BAR-AdBannerViewHeight)

@class ZUUIRevealController;
@class FrontViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ADBannerViewDelegate> {
    NSMutableDictionary *data;
    NSMutableArray *dates;
    NSMutableArray *sports;
    NSMutableArray *events;
    ADBannerView *adBanner;
}

@property (retain, nonatomic) ADBannerView *adBanner;
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) ZUUIRevealController *viewController;
@property (retain, nonatomic) NSMutableDictionary *data;
@property (retain, nonatomic) NSMutableArray *dates;
@property (retain, nonatomic) NSMutableArray *sports;
@property (retain, nonatomic) NSMutableArray *events;

@property (retain, nonatomic) TimeScrollerViewController *defaultFrontController;

- (void) setDefaultFrontViewController;
- (void) setFrontViewController:(FrontViewController*) root;

@end
