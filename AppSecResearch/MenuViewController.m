//
//  MenuView.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "UIImage+OverlayColor.h"
#import "MenuTableViewCell.h"
#import "InfoWebViewController.h"

#include <QuartzCore/QuartzCore.h>

#define kCellText @"CellText"
#define kCellImage @"CellImage"
#define kCellID @"CellID"

#define ALL -1
#define TODAY -2
#define FAVORITES -3
#define ABOUT -4

@interface MenuViewController()

@property (nonatomic, strong) UITableView *menuTable;
@property (nonatomic, strong) NSArray *cellContents;

@end

@implementation MenuViewController

@synthesize menuTable = menuTable_;
@synthesize cellContents = cellContents_;

- (void) adDidAppear {
    [self.menuTable setFrame: CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT-15-AdBannerViewHeight)];
}

- (void) adDidFail {
    [self.menuTable setFrame: CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT-15)];
}

- (UIImage *)imageFromText:(NSString *)text withColor:(UIColor*)color {
    UIFont *font = [UIFont boldSystemFontOfSize:30.0];
    CGSize size  = CGSizeMake(35.0f, 35.0f);
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
	[text drawInRect:CGRectMake(0.0, 0.0, 35.0f, 35.0f) 
			withFont:font 
	   lineBreakMode:UILineBreakModeWordWrap 
		   alignment:UITextAlignmentCenter];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);//fixes bug adding gap at the top
    self.view.backgroundColor = UIColorFromRGB(0x1B325F);// [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-calendar"], kCellImage, @"All days", kCellText, [NSNumber numberWithInt:ALL], kCellID, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-program"], kCellImage, @"Today", kCellText,[NSNumber numberWithInt:TODAY], kCellID, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-star"], kCellImage, @"Favorites", kCellText,[NSNumber numberWithInt:FAVORITES], kCellID, nil]];
    
    for(NSDictionary *dict in appDelegate.dates)
        [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[self imageFromText:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]] withColor:[UIColor whiteColor]], kCellImage, [dict objectForKey:@"name"], kCellText,[dict objectForKey:@"id"], kCellID, nil]];
    
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-about"], kCellImage, @"About", kCellText, [NSNumber numberWithInt:ABOUT], kCellID, nil]];
    
    self.cellContents = contents;
    
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT-15) style:UITableViewStylePlain];
    self.menuTable = tableView;
    
    self.menuTable.backgroundColor = [UIColor clearColor];
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    [self.view addSubview:self.menuTable];
    [self.menuTable reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellContents_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.textLabel.text = [[cellContents_ objectAtIndex:indexPath.row] objectForKey:kCellText];
	cell.imageView.image = [[cellContents_ objectAtIndex:indexPath.row] objectForKey:kCellImage];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
}

InfoWebViewController *credits;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
    
    if(!credits){
        credits = [[InfoWebViewController alloc] init];
        credits.pageTitle = @"About";
        credits.filePath = [[NSBundle mainBundle] pathForResource:@"licenses" ofType:@"txt"];
    }
    
    int selectedID = [[[cellContents_ objectAtIndex:indexPath.row] objectForKey:kCellID] intValue];
    NSLog(@"selectedID=%d",selectedID);
    
    switch (selectedID)
    {
        case ALL:
            [appDelegate.defaultFrontController allDates];
            [appDelegate setDefaultFrontViewController];
            break;
        case TODAY:
            [appDelegate.defaultFrontController today];
            [appDelegate setDefaultFrontViewController];
            break;
        case FAVORITES:
            [appDelegate.defaultFrontController favorites];
            [appDelegate setDefaultFrontViewController];
            break;
        case ABOUT:
            [appDelegate setFrontViewController:credits];
            break;
        default:
            [appDelegate.defaultFrontController onlyDate:selectedID];
            [appDelegate setDefaultFrontViewController];
            break;
    }
}

@end
