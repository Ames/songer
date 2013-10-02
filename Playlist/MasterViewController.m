//
//  MasterViewController.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

//@interface MasterViewController () {
//    NSMutableArray *_objects;
//}
//@end

@implementation MasterViewController


@synthesize playlist;

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
	self.navigationItem.leftBarButtonItem = self.editButtonItem;

	//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
	//self.navigationItem.rightBarButtonItem = addButton;
	
	self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

	// create that playlist
	playlist = [Playlist playlist];
}

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

- (void)insertNewTrack:(Song *)song{

	NSUInteger index = playlist.length;
	
	[playlist insertSong:song atIndex:index];
	
	// woo animation
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return playlist.length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	Song *song = [playlist getSongAtIndex:indexPath.row];
	//NSString *object = _objects[indexPath.row];
	cell.textLabel.text = song.title;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[playlist removeSongAtIndex:indexPath.row];
        //[_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	
	//NSLog(@"%@",_objects);

	[playlist moveSongFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
	
//	id tmp = _objects[fromIndexPath.row];
//	[_objects removeObjectAtIndex:fromIndexPath.row];
//	[_objects insertObject:tmp atIndex:toIndexPath.row];

	//NSLog(@"%@",_objects);
}


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
		Song *song = [playlist getSongAtIndex:indexPath.row];
        self.detailViewController.detailItem = song;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Song *song = [playlist getSongAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:song];
    }
}

-(IBAction)done:(UIStoryboardSegue *)segue{
	
	ResultViewController *sourceVC = [segue sourceViewController];
	
	if(sourceVC.detailItem){
		
		//[self insertNewTrack:sourceVC.theNewTrack];

		[self insertNewTrack:sourceVC.detailItem];
		
//NSLog(@"done: %@", sourceVC.theNewTrack);
		//[self insertNewTrackWithName:sourceVC.theNewTrack];
	}
	//NSLog(@"done");
}

-(IBAction)cancel:(UIStoryboardSegue *)segue{
	//NSLog(@"cancel");
}

@end
