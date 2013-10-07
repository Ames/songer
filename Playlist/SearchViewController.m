//
//  MasterViewController.m
//  SongSearch
//
//  Created by Ames Bielenberg on 9/30/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//
// using async approach from http://deeperdesign.wordpress.com/2011/05/30/cancellable-asynchronous-searching-with-uisearchdisplaycontroller/
//


#import "SearchViewController.h"
#import "ResultViewController.h"


@implementation SearchViewController

// persist the query between searches.
static NSString *previousQuery;


@synthesize searchResults, searchQueue;


- (void)awakeFromNib
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    self.clearsSelectionOnViewWillAppear = NO;
	    self.preferredContentSize = CGSizeMake(320.0, 600.0);
	}
    [super awakeFromNib];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	

	self.resultViewController = (ResultViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	
	
	if(previousQuery == NULL){
		previousQuery = @"";
	}
	
	searchResults = [NSMutableArray array];
	
	// used for async search
	self.searchQueue = [NSOperationQueue new];
	[self.searchQueue setMaxConcurrentOperationCount:1];
		
	
	// there was a weird glitch where an extra table view seemed to appear behind the search results. This dirty hack seems to fix it :/
	
	double delayInSeconds = .1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
		[self.searchDisplayController setActive:YES animated:YES];
		self.searchDisplayController.searchBar.text = previousQuery;
		[[self searchBar] becomeFirstResponder];
	});
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	// idk why tableView seems different from mainTable here
	// perhaps tableView is the search results table, which is different.

    UITableViewCell *cell = [self.mainTable dequeueReusableCellWithIdentifier:@"Cell"];
	
	Song *result = searchResults[indexPath.row];
	
	cell.textLabel.text = result.title;
	cell.detailTextLabel.text = result.artist;
	
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
	return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		id object = searchResults[indexPath.row];
        self.resultViewController.detailItem = object;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
		id object = searchResults[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
	
	[self.searchQueue cancelAllOperations];
}



-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{

	[self.searchQueue cancelAllOperations];
	
	// this timing hack (is it actually hacky?) solves a visual timing issue.
	// there is probably a better way to solve this problem.
	double delayInSeconds = .1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		
		[self dismissViewControllerAnimated:YES completion:NULL];
		
	});
	
}

// from http://stackoverflow.com/a/18590693
-(void)setSearchStatus:(NSString *)status{
	
	for (UIView *v in self.searchDisplayController.searchResultsTableView.subviews) {
		if ([v isKindOfClass:[UILabel self]]) {
			((UILabel *)v).text = status;
			break;
		}
	}
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
	
	previousQuery = searchString;

	
	if([searchString isEqualToString:@""])
		return NO;
	
	[self setSearchStatus:@"Searching..."];

	// we do the search operation in a seperate OperationQueue,
	// then update the table in the main queue.
	
	[self.searchQueue cancelAllOperations];
	
	[self.searchQueue addOperationWithBlock:^{
		NSArray *newResults = [MediaNet searchTracksWithKeyword:searchString];
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			[searchResults setArray:newResults];
			[self.searchDisplayController.searchResultsTableView reloadData];
			
			if(searchResults.count == 0){
				[self setSearchStatus:@"No Results"];
			}
		}];
	}];
	
	
	
//	[MNet searchTracksWithKeyword:searchString nResults:@20 success:^(NSArray *results) {
//		NSLog(@"%d results",results.count);
//	}];

	return NO;
}

@end
