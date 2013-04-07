//
//  RootViewController.h
//  TimerScroller
//
//  Created by Andrew Carter on 12/4/11.

#import <UIKit/UIKit.h>

#import "TimeScroller.h"
#import "FrontViewController.h"

@class AbstractActionSheetPicker;

@interface TimeScrollerViewController : FrontViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, TimeScrollerDelegate> {
    UITableView *_tableView;
    TimeScroller *_timeScroller;
    
    UILabel *_noDataHint;
    
    NSMutableArray *data;
    NSMutableArray *dataDateFiltered;
    NSInteger selectedTrack;
    
    NSArray *sports;
}

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *dataDateFiltered;
@property (nonatomic, retain) AbstractActionSheetPicker *actionSheetPicker;
@property (nonatomic, retain) NSArray *sports;

- (void)allDates;
- (void)today;
- (void)favorites;
- (void)onlyDate:(int)d;

- (void) adDidAppear;
- (void) adDidFail;

@end
