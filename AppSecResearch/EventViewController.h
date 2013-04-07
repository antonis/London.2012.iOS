//
//  SpeachViewController.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MessageUI.h>

@interface EventViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate> {
    IBOutlet UITableView *_tableView;
    BOOL isBookmarked;
}

@property (nonatomic, retain) NSDictionary *dictionary;

@end
