//
//  RootViewController.m
//  TimerScroller
//
//  Created by Andrew Carter on 12/4/11.

#import "TimeScrollerViewController.h"
#import "EventViewController.h"
#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"
#import "AppDelegate.h"

#define CELL_WIDTH self.view.bounds.size.width
#define CELL_HEIGHT 100.0f
#define CELL_MARGIN 2.0f

@implementation TimeScrollerViewController

@synthesize data;
@synthesize dataDateFiltered;
@synthesize actionSheetPicker = _actionSheetPicker;
@synthesize sports;

- (void) reloadTable {
    if([data count]==0){
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME 
//                                                        message:@"No events found for the date and/or sport you selected!"
//                                                       delegate:nil 
//                                              cancelButtonTitle:NSLocalizedString(@"ok", @"") 
//                                              otherButtonTitles: nil];
//        [alert show];
//        [alert release];
        [self.view addSubview:_noDataHint];
    } else {
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_noDataHint removeFromSuperview];
    }
    [_tableView reloadData];
}

- (BOOL) date:(NSDate *) date isTheSameDayWith: (NSDate *) other {
	NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit) fromDate:date];
	NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit) fromDate:other];
	return (([components1 year] == [components2 year]) &&
			([components1 month] == [components2 month]) && 
			([components1 day] == [components2 day]));
}

- (BOOL) quickDate:(NSDate *) date isTheSameDayWith: (NSDate *) other {
	NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:date];
	NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:other];
	return ([components1 day] == [components2 day]);
}

- (BOOL) isToday: (NSDate *) date {
	return [self date:date isTheSameDayWith:[NSDate date]];
}

- (NSString *) getTrackName:(int)track{
    return [self.sports objectAtIndex:track];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [((ZUUIRevealController*)self.navigationController.parentViewController) revealToggle:nil];//show the menu on load
    
    self.title = @"Schedule";
    
    self.sports = [NSArray arrayWithObjects:@"Ceremony",@"Archery", @"Athletics", @"Badminton",
                       @"Basketball", @"Beach Volleyball", @"Boxing", @"Canoe Slalom",
                       @"Canoe Sprint", @"Cycling - BMX", @"Cycling - Mountain Bike",
                       @"Cycling - Road", @"Cycling - Track", @"Diving", @"Equestrian",
                       @"Fencing", @"Football", @"Gymnastics - Artistic",
                       @"Gymnastics - Rhythmic", @"Handball", @"Hockey", @"Judo",
                       @"Modern Pentathlon", @"Rowing", @"Sailing", @"Shooting", @"Swimming",
                       @"Synchronised Swimming", @"Table Tennis", @"Taekwondo", @"Tennis",
                       @"Trampoline", @"Triathlon", @"Volleyball", @"Water Polo",
                       @"Weightlifting", @"Wrestling",nil];
    
    if (![self.navigationItem rightBarButtonItem]) {
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showFilter:)];
        
        self.navigationItem.rightBarButtonItem = filterButton;
        [filterButton release];
    }
    
    selectedTrack = -1;
    [dataDateFiltered addObjectsFromArray:appDelegate.events];
    [data addObjectsFromArray:appDelegate.events];
}

- (void)allDates {
    NSLog(@"allDates");
    self.title = @"Schedule";
    [dataDateFiltered removeAllObjects];
    [data removeAllObjects];
    [dataDateFiltered addObjectsFromArray:appDelegate.events];
    [data addObjectsFromArray:appDelegate.events];
    [self reloadTable];
}

- (void)today {
    NSLog(@"today");
    self.title = @"Today";
    [data removeAllObjects];
    [dataDateFiltered removeAllObjects];
    for (NSDictionary *s in appDelegate.events)
        if([self isToday:[s objectForKey:@"start"]]) 
            [dataDateFiltered addObject:s];
    [data addObjectsFromArray:dataDateFiltered];
    [self reloadTable];
}

- (void)onlyDate:(int)d {
     NSLog(@"onlyDate.d=%d",d); 
    NSString *dateStr = [NSString stringWithFormat:@"20120%d%@%d",d<13?8:7,d<10?@"0":@"",d];
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormat dateFromString:dateStr];  
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"EEEE, MMM d"];
    self.title = [dateFormat stringFromDate:date];
    [dateFormat release];
//    //Filter table
//    [data removeAllObjects];
//    [dataDateFiltered removeAllObjects];
//    for (NSDictionary *s in appDelegate.events)
//        if([self date:date isTheSameDayWith:[s objectForKey:@"start"]]) 
//            [dataDateFiltered addObject:s];
//    [data addObjectsFromArray:dataDateFiltered];
//    [self reloadTable];
    [data removeAllObjects];
    [dataDateFiltered removeAllObjects];
    for (NSDictionary *s in appDelegate.events)
        if(d==[[s objectForKey:@"day"] intValue]) 
            [dataDateFiltered addObject:s];
    [data addObjectsFromArray:dataDateFiltered];
    [self reloadTable];
}

- (void)favorites {
    NSLog(@"favorites");
    self.title = @"Favorites";
    [data removeAllObjects];
    [dataDateFiltered removeAllObjects];
    for (NSDictionary *s in appDelegate.events)
        if ([s objectForKey:@"bookmark"] && [[s objectForKey:@"bookmark"] isEqualToString:@"YES"])
            [dataDateFiltered addObject:s];
    [data addObjectsFromArray:dataDateFiltered];
    [self reloadTable];
}
       
- (void)filterSelected:(NSString*) selected {
    NSLog(@"filterSelected=%@",selected);
    selectedTrack = -1;
    for (NSDictionary *d in appDelegate.sports){
        if([[d objectForKey:@"name"] isEqualToString:selected]){
            selectedTrack = [[d objectForKey:@"id"] intValue];
        }
    }
    NSLog(@"filterSelected.id=%d",selectedTrack);
    [data removeAllObjects];
    if (selectedTrack==-1) {
        [data addObjectsFromArray:dataDateFiltered];
    } else {        
        for (NSDictionary *s in dataDateFiltered) {
            if ([[s objectForKey:@"track"] intValue]==selectedTrack) {
                [data addObject:s];
            }
        }
    }
    [self reloadTable];
}
                                         
- (void)showFilter:(id)sender{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self filterSelected:selectedValue];
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Picker Canceled");
    };
    
    NSMutableArray *tracks = [[NSMutableArray alloc] init];
    [tracks addObject:@"All Sports"];
    for (NSDictionary *d in appDelegate.sports)
        [tracks addObject:[d objectForKey:@"name"]];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Sport" rows:tracks initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];

}

- (void) adDidAppear {
    [_tableView setFrame: VIEW_FRAME_WITH_AD];
}

- (void) adDidFail {
    [_tableView setFrame: VIEW_FRAME];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
        
        _tableView = [[UITableView alloc] initWithFrame:VIEW_FRAME style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];       
        data = [[NSMutableArray alloc] init];
        dataDateFiltered = [[NSMutableArray alloc] init];
        
        _noDataHint = [[UILabel alloc] initWithFrame:VIEW_FRAME];
        _noDataHint.text = @" No  events  found  for  the  date  and/or  sport  you  selected.  Please  refine  your  criteria.";
        _noDataHint.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        [_noDataHint setTextColor:[UIColor lightTextColor]];
        [_noDataHint setTextAlignment:UITextAlignmentCenter];
        _noDataHint.numberOfLines = 5;
    }

    return self;
}

- (void)dealloc {
    self.actionSheetPicker = nil;
    [data dealloc];
    [dataDateFiltered dealloc];
    [sports release];
    [_tableView release];
    [_noDataHint release];
    [_timeScroller release];
    [super dealloc];
}

- (void)loadView {
    
    UIView *view = [[UIView alloc] initWithFrame:VIEW_FRAME];
    
    [view addSubview:_tableView];
    
    self.view = view;
    [view release];
    
}

#pragma mark TimeScrollerDelegate Methods

- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
    return _tableView;
}

- (NSDate *)dateForCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSDictionary *dictionary = [data objectAtIndex:indexPath.row];
    
    BOOL isBookmarked = ([dictionary objectForKey:@"bookmark"] && [[dictionary objectForKey:@"bookmark"] isEqualToString:@"YES"]);
    [_timeScroller isGreen:isBookmarked];
    
    NSDate *date = [dictionary objectForKey:@"start"];
    return date;
}

#pragma mark UIScrollViewDelegateMethods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [_timeScroller scrollViewDidEndDecelerating];
    }
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    //if([[[data objectAtIndex:indexPath.row] objectForKey:@"track"] intValue]==0) return;
    EventViewController *speach= [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
    speach.dictionary = [data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:speach animated:YES];
	[speach release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(	0.0f,	0.0f,	CELL_WIDTH, CELL_HEIGHT)] autorelease];
    //Date
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(CELL_MARGIN, CELL_MARGIN, CELL_WIDTH/3.0f-2.0f*CELL_MARGIN, CELL_HEIGHT/2.0f-2.0f*CELL_MARGIN)];
    lblTemp.tag = 1;
    lblTemp.textColor = [UIColor darkGrayColor];
    lblTemp.textAlignment = UITextAlignmentCenter;
    lblTemp.lineBreakMode = UILineBreakModeWordWrap;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.numberOfLines = 2;
    [cell.contentView addSubview:lblTemp];
    [lblTemp release];
    //Time
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(CELL_MARGIN, CELL_HEIGHT/2.0f+CELL_MARGIN, CELL_WIDTH/3.0f-2.0f*CELL_MARGIN, CELL_HEIGHT/2.0f-2.0f*CELL_MARGIN)];
    lblTemp.tag = 2;
    lblTemp.textColor = [UIColor darkTextColor];
    lblTemp.textAlignment = UITextAlignmentCenter;
    lblTemp.lineBreakMode = UILineBreakModeWordWrap;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.numberOfLines = 2;
    [cell.contentView addSubview:lblTemp];
    [lblTemp release];
    //Title
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(CELL_WIDTH/3.0f+CELL_MARGIN, CELL_MARGIN, 2.0f*CELL_WIDTH/3.0f-2.0f*CELL_MARGIN, CELL_HEIGHT/2.0f-2.0f*CELL_MARGIN)];
    lblTemp.tag = 3;
    lblTemp.textColor = [UIColor darkTextColor];
    lblTemp.textAlignment = UITextAlignmentLeft;
    lblTemp.lineBreakMode = UILineBreakModeWordWrap;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.numberOfLines = 2;
    [cell.contentView addSubview:lblTemp];
    [lblTemp release];
    //Subtitle
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(CELL_WIDTH/3.0f+CELL_MARGIN, CELL_HEIGHT/2.0f+CELL_MARGIN, 2.0f*CELL_WIDTH/3.0f-2.0f*CELL_MARGIN, CELL_HEIGHT/2.0f-2.0f*CELL_MARGIN)];
    lblTemp.tag = 4;
    lblTemp.textColor = [UIColor darkGrayColor];
    lblTemp.textAlignment = UITextAlignmentLeft;
    lblTemp.lineBreakMode = UILineBreakModeWordWrap;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.numberOfLines = 2;
    [cell.contentView addSubview:lblTemp];
    [lblTemp release];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *identifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getCellContentView:identifier];
    }
    
    UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
    UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
    UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
    UILabel *lblTemp4 = (UILabel *)[cell viewWithTag:4];
        
    NSDictionary *dictionary = [data objectAtIndex:indexPath.row];
        
    NSDate *start = [dictionary objectForKey:@"start"];
    NSDate *local = [dictionary objectForKey:@"start"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:TIMEZONE_ABBREVIATION]];
    [dateFormatter setDateFormat:@"EEEE"];
    lblTemp1.text = [self getTrackName:[[dictionary objectForKey:@"track"] intValue]];
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *s = [dateFormatter stringFromDate:start];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    lblTemp2.text = [NSString stringWithFormat:@"%@\n(%@)",s,[dateFormatter stringFromDate:local]];
    [dateFormatter release];
    
    lblTemp3.text = [dictionary objectForKey:@"title"];
    
    lblTemp4.text = [dictionary objectForKey:@"description"];
    
    switch ([[dictionary objectForKey:@"track"] intValue]/2) {
        case 18:
            cell.contentView.backgroundColor = UIColorFromRGB(0xEFFAB4);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 17:
            cell.contentView.backgroundColor = UIColorFromRGB(0xFFC48C);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 16:
            cell.contentView.backgroundColor = UIColorFromRGB(0xFF9F80);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 15:
            cell.contentView.backgroundColor = UIColorFromRGB(0xF56991);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 14:
            cell.contentView.backgroundColor = UIColorFromRGB(0x69D2E7);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 13:
            cell.contentView.backgroundColor = UIColorFromRGB(0xA7DBD8);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 12:
            cell.contentView.backgroundColor = UIColorFromRGB(0xE0E4CC);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 11:
            cell.contentView.backgroundColor = UIColorFromRGB(0xF38630);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 10:
            cell.contentView.backgroundColor = UIColorFromRGB(0xFA6900);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 9:
            cell.contentView.backgroundColor = UIColorFromRGB(0x4ECDC4);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 8:
            cell.contentView.backgroundColor = UIColorFromRGB(0xC02942);
            lblTemp1.textColor = [UIColor lightTextColor];
            lblTemp2.textColor = [UIColor whiteColor];
            lblTemp3.textColor = [UIColor whiteColor];
            lblTemp4.textColor = [UIColor lightTextColor];
            break;
        case 7:
            cell.contentView.backgroundColor = UIColorFromRGB(0xFF6B6B);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 6:
            cell.contentView.backgroundColor = UIColorFromRGB(0xC44D58);
            lblTemp1.textColor = [UIColor lightTextColor];
            lblTemp2.textColor = [UIColor whiteColor];
            lblTemp3.textColor = [UIColor whiteColor];
            lblTemp4.textColor = [UIColor lightTextColor];
            break;
        case 5:
            cell.contentView.backgroundColor = UIColorFromRGB(0x556270);
            lblTemp1.textColor = [UIColor lightTextColor];
            lblTemp2.textColor = [UIColor whiteColor];
            lblTemp3.textColor = [UIColor whiteColor];
            lblTemp4.textColor = [UIColor lightTextColor];
            break;
        case 4:
            cell.contentView.backgroundColor = UIColorFromRGB(0x3A89C9);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 3:
            cell.contentView.backgroundColor = UIColorFromRGB(0xE9F2F9);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 2:
            cell.contentView.backgroundColor = UIColorFromRGB(0x9CC4E4);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 1:
            cell.contentView.backgroundColor = UIColorFromRGB(0xF26C4F);
            lblTemp1.textColor = [UIColor lightTextColor];
            lblTemp2.textColor = [UIColor whiteColor];
            lblTemp3.textColor = [UIColor whiteColor];
            lblTemp4.textColor = [UIColor lightTextColor];
            break;
        case 0:
            cell.contentView.backgroundColor = UIColorFromRGB(0xC7F464);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;        
        default:
            cell.contentView.backgroundColor = UIColorFromRGB(0x1B325F);
            lblTemp1.textColor = [UIColor lightGrayColor];
            lblTemp2.textColor = [UIColor lightTextColor];
            lblTemp3.textColor = [UIColor lightTextColor];
            lblTemp4.textColor = [UIColor lightGrayColor];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = cell.contentView.backgroundColor;
}

@end
