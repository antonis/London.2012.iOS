//
//  SpeachViewController.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventViewController.h"
#import "AppDelegate.h"

@implementation EventViewController

@synthesize dictionary;

#pragma mark - Actions

- (NSString *)urlEncodedString:(NSString*) string {
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)string, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8) autorelease];
}

- (void) google {
    NSLog(@"google");
    NSString *searchTerm = [NSString stringWithFormat:@"http://www.google.com/m?q=%@",[self urlEncodedString:[dictionary objectForKey:@"title"]]];
    NSLog(@"searchTerm=%@",searchTerm);
    NSURL *url = [NSURL URLWithString:searchTerm];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void) wikipedia {
    NSLog(@"wikipedia");
	NSString *searchTerm = [NSString stringWithFormat:@"http://www.wikipedia.org/w/index.php?search=%@",[self urlEncodedString:[dictionary objectForKey:@"title"]]];
    NSLog(@"searchTerm=%@",searchTerm);
    NSURL *url = [NSURL URLWithString:searchTerm];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void) officialSite {
    NSLog(@"officialSite");
    NSURL *url = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);    
}

- (void) sendSms {
    NSLog(@"sendSms");
    NSString *bodyOfMessage = [NSString stringWithFormat:@"Check out %@: %@", [dictionary objectForKey:@"title"],[dictionary objectForKey:@"description"]];  
    if([bodyOfMessage length]>115) bodyOfMessage = [bodyOfMessage substringToIndex:115];
    bodyOfMessage = [bodyOfMessage stringByAppendingFormat:@" via %@",APP_LINK];
    NSLog(@"bodyOfMessage=%@",bodyOfMessage);
    NSArray *recipients = [NSArray arrayWithObjects:nil];
	MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
	if([MFMessageComposeViewController canSendText]){
		controller.body = bodyOfMessage;    
		controller.recipients = recipients;
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	} 
}

- (void) tweet {
    NSString *tweet = [NSString stringWithFormat:@"Check out %@: %@", [dictionary objectForKey:@"title"],[dictionary objectForKey:@"description"]];  
    if([tweet length]>115) tweet = [tweet substringToIndex:114];
    tweet = [tweet stringByAppendingFormat:@" via %@",APP_LINK];
    NSLog(@"tweet=%@",tweet);
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:tweet];
    [self presentViewController:twitter animated:YES completion:nil];
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        [self dismissModalViewControllerAnimated:YES];
    };
}

- (void) email {
    if([MFMailComposeViewController canSendMail]){
        NSString *email = [NSString stringWithFormat:@"Check out %@: %@", [dictionary objectForKey:@"title"],[dictionary objectForKey:@"description"]];  
        email = [email stringByAppendingFormat:@"via %@",APP_LINK];
        NSLog(@"email=%@",email);
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setTitle:@"Share by e-mail" ];
        [controller setSubject:APP_NAME];
        [controller setMessageBody:email isHTML:NO];
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:controller animated:YES];
        [controller release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME 
                                                        message:@"You have to setup at least one email account before you can send e-mail"
                                                       delegate:nil 
                                              cancelButtonTitle:NSLocalizedString(@"ok", @"") 
                                              otherButtonTitles: nil];
        [alert show];
        [alert release]; 
    }
}

- (void)bookmark {
    isBookmarked = !isBookmarked;
    [dictionary setValue:isBookmarked?@"YES":@"NO" forKey:@"bookmark"];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	[controller dismissModalViewControllerAnimated:YES];
	if (result == MessageComposeResultCancelled)
		NSLog(@"Message cancelled");
	else if (result == MessageComposeResultSent)
		NSLog(@"Message sent");
	else 
		NSLog(@"Message failed");
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [dictionary objectForKey:@"title"];
    isBookmarked = ([dictionary objectForKey:@"bookmark"] && [[dictionary objectForKey:@"bookmark"] isEqualToString:@"YES"]);
    
    switch ([[dictionary objectForKey:@"track"] intValue]/2) {
        case 18:
            _tableView.backgroundColor = UIColorFromRGB(0xEFFAB4);
            break;
        case 17:
            _tableView.backgroundColor = UIColorFromRGB(0xFFC48C);
            break;
        case 16:
            _tableView.backgroundColor = UIColorFromRGB(0xFF9F80);
            break;
        case 15:
            _tableView.backgroundColor = UIColorFromRGB(0xF56991);
            break;
        case 14:
            _tableView.backgroundColor = UIColorFromRGB(0x69D2E7);
            break;
        case 13:
            _tableView.backgroundColor = UIColorFromRGB(0xA7DBD8);
            break;
        case 12:
            _tableView.backgroundColor = UIColorFromRGB(0xE0E4CC);
            break;
        case 11:
            _tableView.backgroundColor = UIColorFromRGB(0xF38630);
            break;
        case 10:
            _tableView.backgroundColor = UIColorFromRGB(0xFA6900);
            break;
        case 9:
            _tableView.backgroundColor = UIColorFromRGB(0x4ECDC4);
            break;
        case 8:
            _tableView.backgroundColor = UIColorFromRGB(0xC02942);
            break;
        case 7:
            _tableView.backgroundColor = UIColorFromRGB(0xFF6B6B);
            break;
        case 6:
            _tableView.backgroundColor = UIColorFromRGB(0xC44D58);
            break;
        case 5:
            _tableView.backgroundColor = UIColorFromRGB(0x556270);
            break;
        case 4:
            _tableView.backgroundColor = UIColorFromRGB(0x3A89C9);
            break;
        case 3:
            _tableView.backgroundColor = UIColorFromRGB(0xE9F2F9);
            break;
        case 2:
            _tableView.backgroundColor = UIColorFromRGB(0x9CC4E4);
            break;
        case 1:
            _tableView.backgroundColor = UIColorFromRGB(0xF26C4F);
            break;
        case 0:
            _tableView.backgroundColor = UIColorFromRGB(0xC7F464);
            break;        
        default:
            _tableView.backgroundColor = UIColorFromRGB(0x1B325F);
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;//5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section==0) return 0;
    if (section==1) return 2;
    if (section==2) return 1;
    if (section==3) return 3;
    if (section==4) return 3;
	return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==0) return @"";//[dictionary objectForKey:@"description"];
	if (section==3) return @"";//@"Share";
    if (section==4) return @"Info";
	return @"";
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	//if (section==4) return APP_NAME;
	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PlainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.section==0&&indexPath.row==0) {
        cell.textLabel.text = [dictionary objectForKey:@"description"];
		cell.textLabel.textAlignment = UITextAlignmentLeft;
	} else if (indexPath.section==1&&indexPath.row==0) {
        NSDate *start = [dictionary objectForKey:@"start"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:TIMEZONE_ABBREVIATION]];
		cell.textLabel.text = [NSString stringWithFormat:@"London Time: %@",[dateFormatter stringFromDate:start]];
		cell.textLabel.textAlignment = UITextAlignmentLeft;
	} else if (indexPath.section==1&&indexPath.row==1) {
        NSDate *local = [dictionary objectForKey:@"start"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
		cell.textLabel.text = [NSString stringWithFormat:@"Your Time: %@",[dateFormatter stringFromDate:local]];
		cell.textLabel.textAlignment = UITextAlignmentLeft;
	} else if (indexPath.section==2&&indexPath.row==0) {
		cell.textLabel.text = isBookmarked?@"Remove from Favorites":@"Add to Favorites";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	} else if (indexPath.section==3&&indexPath.row==0) {
		cell.textLabel.text = @"twitter";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	} else if (indexPath.section==3&&indexPath.row==1) {
		cell.textLabel.text = @"e-mail";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	} else if (indexPath.section==3&&indexPath.row==2) {
		cell.textLabel.text = @"sms";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	} else if (indexPath.section==4&&indexPath.row==0) {
		cell.textLabel.text = @"Search on Google";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	} else if (indexPath.section==4&&indexPath.row==1) {
		cell.textLabel.text = @"Search in wikipedia";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	} else if (indexPath.section==4&&indexPath.row==2) {
		cell.textLabel.text = @"Official Site";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
	}
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section==0&&indexPath.row==0) {
        //Nothing
	} else if (indexPath.section==1&&indexPath.row==0) {
		//Nothing
	} else if (indexPath.section==1&&indexPath.row==1) {
		//Nothing
	} else if (indexPath.section==2&&indexPath.row==0) {
		[self bookmark];
        [_tableView reloadData];
	} else if (indexPath.section==3&&indexPath.row==0) {
		[self tweet];
	} else if (indexPath.section==3&&indexPath.row==1) {
		[self email];
	} else if (indexPath.section==3&&indexPath.row==2) {
		[self sendSms];
	} else if (indexPath.section==4&&indexPath.row==0) {
		[self google];
	} else if (indexPath.section==4&&indexPath.row==1) {
		[self wikipedia];
	} else if (indexPath.section==4&&indexPath.row==2) {
		[self officialSite];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section==4) return 50.0f;//space for the iAd
    return 5.0f;
}


@end
