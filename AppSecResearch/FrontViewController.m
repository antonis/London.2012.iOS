//
//  MainView.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FrontViewController.h"

@interface FrontViewController() {
    UIButton *menuButton;
}

@property (retain, nonatomic) UIPanGestureRecognizer *navigationBarPanGestureRecognizer;

@end

@implementation FrontViewController

@synthesize navigationBarPanGestureRecognizer = _navigationBarPanGestureRecognizer;

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		// Check if a UIPanGestureRecognizer already sits atop our NavigationBar.
		if (![[self.navigationController.navigationBar gestureRecognizers] containsObject:self.navigationBarPanGestureRecognizer])
		{
			// If not, allocate one and add it.
			UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
			self.navigationBarPanGestureRecognizer = panGestureRecognizer;
			[panGestureRecognizer release];
			
			[self.navigationController.navigationBar addGestureRecognizer:self.navigationBarPanGestureRecognizer];
            
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		}
		
		// Check if we have a revealButton already.
		if (![self.navigationItem leftBarButtonItem])
		{
            UIImage *image = [UIImage imageNamed:@"m-menu"];
            menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuButton setImage:image forState:UIControlStateNormal];
            menuButton.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
            [menuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];

                        
			//UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self.navigationController.parentViewController action:@selector(revealToggle:)];
            
            UIBarButtonItem *revealButton = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
            
			self.navigationItem.leftBarButtonItem = revealButton;
			[revealButton release];
		}
	}
}

#pragma mark - Example Code

- (void)pushExample:(id)sender
{
	UIViewController *stubController = [[UIViewController alloc] init];
	stubController.view.backgroundColor = [UIColor whiteColor];
	[self.navigationController pushViewController:stubController animated:YES];
	[stubController release];
}

#pragma - ZUUIRevealControllerDelegate Protocol.

/*
 * All of the methods below are optional. You can use them to control the behavior of the ZUUIRevealController, 
 * or react to certain events.
 */
- (BOOL)revealController:(ZUUIRevealController *)revealController shouldRevealRearViewController:(UIViewController *)rearViewController
{
	return YES;
}

- (BOOL)revealController:(ZUUIRevealController *)revealController shouldHideRearViewController:(UIViewController *)rearViewController 
{
	return YES;
}

- (void)revealController:(ZUUIRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController 
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(ZUUIRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
    [menuButton setImage:[UIImage imageNamed:@"m-menu-back"] forState:UIControlStateNormal];
}

- (void)revealController:(ZUUIRevealController *)revealController willHideRearViewController:(UIViewController *)rearViewController
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(ZUUIRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController 
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
    [menuButton setImage:[UIImage imageNamed:@"m-menu"] forState:UIControlStateNormal];
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self.navigationController.navigationBar removeGestureRecognizer:self.navigationBarPanGestureRecognizer];
	[_navigationBarPanGestureRecognizer release], self.navigationBarPanGestureRecognizer = nil;
    
	[super dealloc];
}

@end
