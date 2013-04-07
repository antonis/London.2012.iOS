//
//  InfoWebViewController.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontViewController.h"

@interface InfoWebViewController : FrontViewController <UIWebViewDelegate> {
    NSString *filePath;
    NSString *pageTitle;
}

@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *pageTitle;

@end
