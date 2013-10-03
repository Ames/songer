//
//  MasterViewController.m
//  SongSearch
//
//  Created by Ames Bielenberg on 9/30/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "SearchViewController.h"

#import "ResultViewController.h"


//
//@interface SearchViewController () {
//    //NSMutableArray *_objects;
//}
//@end

@implementation SearchViewController

static NSString *previousQuery;


@synthesize searchResults, searchQueue;


// using http://deeperdesign.wordpress.com/2011/05/30/cancellable-asynchronous-searching-with-uisearchdisplaycontroller/


//
//- (id)init
//{
//    if ((self = [super init]))
//    {
//        //self.searchResults = [NSMutableArray array];
//		self.searchQueue = [NSOperationQueue new];
//        [self.searchQueue setMaxConcurrentOperationCount:1];
//    }
//    return self;
//}


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
	
	// Do any additional setup after loading the view, typically from a nib.
	//self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	//self.navigationItem.rightBarButtonItem = addButton;
	self.resultViewController = (ResultViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	
	//static NSString *lastQuery;
	
	if(previousQuery == NULL){
		previousQuery = @"";
	}
	

	searchResults = [NSMutableArray array];
	
	self.searchQueue = [NSOperationQueue new];
	[self.searchQueue setMaxConcurrentOperationCount:1];
		
	
	//[[self searchBar] becomeFirstResponder];
	//[[[self searchDisplayController] searchBar] becomeFirstResponder];
	
	//[[self searchDisplayController] setActive:YES animated:YES];
	//[[self searchBar] becomeFirstResponder];

	
	//id sampleSearch = [MediaNet searchTracksWithKeyword:@"foo"];
	//NSLog(@"%@",sampleSearch);
	
	
	
	/*** !!! HACK HACK HACK HACK !!! ***/
	
	// there was a weird glitch where an extra table view seemed to appear behind the search results. This seems to fix it :/
	
	double delayInSeconds = .1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
		[self.searchDisplayController setActive:YES animated:YES];
		self.searchDisplayController.searchBar.text = previousQuery;
		[[self searchBar] becomeFirstResponder];
	});
	
	
}

//- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
//	
//	//[[self searchDisplayController] setActive:YES animated:YES];
//	//[[self searchBar] becomeFirstResponder];
//	
//	NSLog(@"didLoadSearchResultsTableView");
//	
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [searchResults count];
	//return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	// idk why tableView seems different from mainTable here
	
    UITableViewCell *cell = [self.mainTable dequeueReusableCellWithIdentifier:@"Cell"];
	
	//NSDate *object = _objects[indexPath.row];
	Song *result = searchResults[indexPath.row];
	
	cell.textLabel.text = result.title;
	cell.detailTextLabel.text = result.artist;
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    //return YES;
	return NO;
}
/*
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 [_objects removeObjectAtIndex:indexPath.row];
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }
 }
 */
/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


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
        //NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
	
}




//-(void)updateSearchResultsWithQuery:(NSString *)searchString{
//	[searchResults removeAllObjects];
//	
//	//	const NSUInteger nResults = 10;
//	//
//	//	for(int i=0;i<nResults;i++){
//	//		[searchResults addObject:[NSString stringWithFormat:@"%@ %d",searchString, i]];
//	//	}
//	
//	
//	
//	NSArray *newResults = [MediaNet searchTracksWithKeyword:searchString];
//	[searchResults setArray:newResults];
//	
//}


-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	//NSLog(@"Search Done!");

	
	double delayInSeconds = .1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		
		[self dismissViewControllerAnimated:YES completion:NULL];
		
	});
	
}

//-(void)search

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
	
	previousQuery = searchString;
	
	[self.searchQueue cancelAllOperations];
	[self.searchQueue addOperationWithBlock:^{
		NSArray *newResults = [MediaNet searchTracksWithKeyword:searchString];
		
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			
			[searchResults setArray:newResults];
			
			[self.searchDisplayController.searchResultsTableView reloadData];

		}];
		
	}];
	
//	
//	
//	
//	
//	// HACK HACK HACK
//	// lazy async
//	double delayInSeconds = 0.1;
//	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//		
//		[self updateSearchResultsWithQuery:searchString];
//		
//		[self.searchDisplayController.searchResultsTableView reloadData];
//	});
//	
//	
//	//[self updateSearchResultsWithQuery:searchString];
//	
//	//return YES;
	return NO;
}

@end
