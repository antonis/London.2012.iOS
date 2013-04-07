//
//  AppDelegate.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "NoRootNavigationController.h"

@interface AppDelegate()

@property (retain, nonatomic) ZUUIRevealController *revealController;
@property (retain, nonatomic) NoRootNavigationController *navigationController;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize revealController = _revealController;
@synthesize navigationController = _navigationController;
@synthesize defaultFrontController = _defaultFrontController;
@synthesize data;
@synthesize dates;
@synthesize sports;
@synthesize events;
@synthesize adBanner;

- (void)dealloc
{
    [dates release];
    [sports release];
    [events release];
    [_navigationController release];
    [_viewController release];
    [_window release];
    [super dealloc];
}

- (void) loadData {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@".appdata2.plist"];
    //NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"appdata" ofType:@"plist"];
	if (![fileManager fileExistsAtPath: dataPath]) {		
		NSString *bundle = [[NSBundle mainBundle] pathForResource:@"appdata2" ofType:@"plist"];
		[fileManager copyItemAtPath:bundle toPath: dataPath error:&error];
	}
	self.data = [[NSMutableDictionary alloc] initWithContentsOfFile:dataPath];
    self.dates = [self.data objectForKey:@"dates"];
    self.sports = [self.data objectForKey:@"sports"];
    self.events = [self.data objectForKey:@"events"];
    
    NSMutableArray *raw = [self.data objectForKey:@"events"];
    NSArray *sorted = [raw sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(NSDictionary*)a objectForKey:@"start"];
        NSDate *second = [(NSDictionary*)b objectForKey:@"start"];
        return [first compare:second];
    }];
    self.events = [NSMutableArray arrayWithArray:sorted];
    
    
    NSLog(@"loadData: dates=%d, sports=%d, events=%d",[self.dates count],[self.sports count],[self.events count]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
   
    MenuViewController *menu = [[MenuViewController alloc] init];
    _defaultFrontController = [[TimeScrollerViewController alloc] initWithNibName:nil bundle:nil];
    
    _navigationController = [[NoRootNavigationController alloc] initWithRootViewController:_defaultFrontController];
	
	_revealController = [[ZUUIRevealController alloc] initWithFrontViewController:_navigationController rearViewController:menu];
    _revealController.delegate = _defaultFrontController;
	self.viewController = _revealController;
	[menu release];
	[_revealController release];
        
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.viewController;
    
    [self loadData];
    
    if(HAS_ADS){
        adBanner = [[ADBannerView alloc] initWithFrame:CGRectZero];
        adBanner.currentContentSizeIdentifier =ADBannerContentSizeIdentifierPortrait;
        adBanner.delegate = self;
        adBanner.backgroundColor = [UIColor clearColor];
        adBanner.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@".appdata2.plist"];
    [self.data writeToFile: dataPath atomically:YES];
}

- (void) setDefaultFrontViewController {
    [self setFrontViewController:_defaultFrontController];
}

- (void) setFrontViewController:(FrontViewController*) root {
    [_navigationController setRootViewController:root];
    _revealController.delegate = root;
    [_revealController revealToggle:nil];
}

#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"bannerViewDidLoadAd");
    [((MenuViewController*)_revealController.rearViewController) adDidAppear];
    [_defaultFrontController adDidAppear];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"bannerView:didFailToReceiveAdWithError.error=%@",[error localizedDescription]);
    if(error.code != ADErrorBannerVisibleWithoutContent){
        [((MenuViewController*)_revealController.rearViewController) adDidFail];
        [_defaultFrontController adDidFail];
    }
}

@end
