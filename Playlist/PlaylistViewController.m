//
//  MasterViewController.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "PlaylistViewController.h"
#import "SongViewController.h"

#import "PlaylistAPI.h"

@implementation PlaylistViewController


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
	
	/*
	 //  edit button
	id addButton = self.navigationItem.rightBarButtonItem;
	
	self.navigationItem.rightBarButtonItems = @[addButton,self.editButtonItem];
	*/
	
	self.songViewController = (SongViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	

	
	UIRefreshControl *refresh = [UIRefreshControl new];
	[refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
	self.refreshControl = refresh;
}

- (void)refresh{
	[[PlaylistAPI api] loadPlaylist:playlist callback:^(Playlist *playlist) {
		[self.tableView reloadData];
		[self.refreshControl endRefreshing];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)insertNewSong:(Song *)song{
	
	NSUInteger index = playlist.length;
	
	[playlist insertSong:song atIndex:index];
	
	
	[[PlaylistAPI api] addSong:song callback:^(Playlist *playlist) {
		NSLog(@"added.");
	}];
	
	// woo animation
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	
}

-(void)setPlaylist:(Playlist *)newPlaylist{
	if (playlist != newPlaylist) {
		playlist = newPlaylist;
		
		// Update the view.
		[self.tableView reloadData]; // does this happend automatically?
		
		self.navigationItem.title = playlist.name;
	}
	
//		// this looks like iPad stuff...
//		if (self.masterPopoverController != nil) {
//			[self.masterPopoverController dismissPopoverAnimated:YES];
//		}
//	}
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
	
	cell.textLabel.text = song.title;
	cell.detailTextLabel.text = song.artist;
	
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
		
		[[PlaylistAPI api] deleteSong:[playlist getSongAtIndex:indexPath.row] callback:^(Playlist *playlist) {
			NSLog(@"deleted.");
		}];
		
		[playlist removeSongAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//	
//	[playlist moveSongFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
//	
//}


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
        self.songViewController.song = song;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSong"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Song *song = [playlist getSongAtIndex:indexPath.row];
        [[segue destinationViewController] setSong:song];
    }
}

-(IBAction)done:(UIStoryboardSegue *)segue
{
	ResultViewController *sourceVC = [segue sourceViewController];
	
	if(sourceVC.detailItem)
		[self insertNewSong:sourceVC.detailItem];
	
}

-(IBAction)cancel:(UIStoryboardSegue *)segue{
	
}

@end
