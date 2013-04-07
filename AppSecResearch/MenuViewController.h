//
//  MenuView.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *menuTable_;
    NSArray *cellContents_;
}
- (void) adDidAppear;
- (void) adDidFail;

@end
