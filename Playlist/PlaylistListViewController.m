//
//  PlaylistListViewController.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/6/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "PlaylistListViewController.h"

@interface PlaylistListViewController ()

@property NSInteger editIndex;

@end

@implementation PlaylistListViewController

@synthesize plList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.playlistViewController = (PlaylistViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
	
	
	plList = [PlaylistList new];
	

	//self.navigationItem.rightBarButtonItem.enabled = FALSE;
	
	[self loadPlaylists];
	 
	
	UIRefreshControl *refresh = [UIRefreshControl new];
	[refresh addTarget:self action:@selector(loadPlaylists) forControlEvents:UIControlEventValueChanged];
	self.refreshControl = refresh;
	
}

- (void)loadPlaylists{
	[[PlaylistAPI api] getPlaylists:^(NSArray *playlists) {
		//NSLog(@"%@",playlists);
		
		[plList.list setArray:playlists];
		[self.tableView reloadData];
		
		// load each playlist
		
		for(Playlist *playlist in playlists){
			//NSLog(@"load %@",playlist.name);
			[[PlaylistAPI api] loadPlaylist:playlist callback:^(Playlist *playlistObj) {
				
				playlistObj.loaded = TRUE;
				[self.tableView reloadData];
				
			}];
		}
		
		[self.refreshControl endRefreshing];

	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.tableView reloadData];  // to update song counts
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.plList.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	// Configure the cell...
	
	Playlist *playlist = plList.list[indexPath.row];
	cell.textLabel.text = playlist.name;
	
	cell.textLabel.tag = indexPath.row;
	
	if(playlist.loaded){
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d song%@",playlist.length,playlist.length==1?@"":@"s"];
	}else{
		cell.detailTextLabel.text = @"loading...";
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	
	UILongPressGestureRecognizer *longPressGesture =
	[[UILongPressGestureRecognizer alloc]
	  initWithTarget:self action:@selector(longPress:)];
	[cell addGestureRecognizer:longPressGesture];
	
    return cell;
}


// http://www.cocoanetics.com/2010/08/taphold-for-tableview-cells-then-and-now/
-(void)longPress:(UILongPressGestureRecognizer *)gesture{
	//NSLog(@"%@",gesture);
	
	
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
		
		// get indexPath of cell
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
		
		// do something with this action
		//NSLog(@"Long-pressed cell at row %@", indexPath);
		[self renamePlaylistAtIndex:indexPath.row];
	}
}

-(void)renamePlaylistAtIndex:(NSInteger)index{
	
	Playlist *playlist = [plList getPlaylistAtIndex:index];
	self.editIndex = index;

	UIAlertView *renameAlert = [[UIAlertView alloc] initWithTitle:@"Rename Playlist" message:@"Enter a new name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
	renameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
	[renameAlert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
	[[renameAlert textFieldAtIndex:0] setText:playlist.name];
	[renameAlert setTag:3];
	[renameAlert show];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		
		Playlist *playlist = [plList getPlaylistAtIndex:indexPath.row];
		
		NSString *alertTitle = [NSString stringWithFormat:@"Delete \"%@\"?",playlist.name];
		NSString *alertmessage = [NSString stringWithFormat:@"The playlist contains %d song%@.\nThis cannot be undone.",playlist.length,playlist.length==1?@"":@"s"];
		
		self.editIndex = indexPath.row;
		
		UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertmessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
		[deleteAlert setTag:2];
		[deleteAlert show];
				
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
}





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

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 
 */

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//		Song *song = [playlist getSongAtIndex:indexPath.row];
//        self.plListViewController.song = song;
//    }
//}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
	
    if ([identifier isEqualToString:@"showPlaylist"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		Playlist *playlist = plList.list[indexPath.row];
		
		return playlist.loaded;
    }
	
	return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPlaylist"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		Playlist *playlist = plList.list[indexPath.row];
        [(PlaylistViewController*)[segue destinationViewController] setPlaylist: playlist];
    }
}

- (IBAction)addButtonPressed:(id)sender {
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Playlist" message:@"Give it a name:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
	[alertView setTag:1];
	alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
	[alertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	// ADD modal
	if (alertView.tag==1 && buttonIndex==1) {
		NSString *name = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if(name.length){
			[self insertNewPlaylist:[Playlist playlistWithName:name]];
		}
	}
	
	// DELETE modal
	if (alertView.tag==2 && buttonIndex==1) {
		
		Playlist *playlist = [plList getPlaylistAtIndex:self.editIndex];
		
		[[PlaylistAPI api] deletePlaylist:playlist callback:^(NSArray *playlists) {
			//NSLog(@"deleted.");
		}];

		
		[plList deletePlaylistAtIndex:self.editIndex];
				
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.editIndex inSection:0];
		
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
	
	// RENAME modal
	if (alertView.tag==3 && buttonIndex==1) {
				
		Playlist *playlist = [plList getPlaylistAtIndex:self.editIndex];
		
		// trim whitespace
		NSString *name = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if(name.length && ![name isEqualToString:playlist.name]){
			
			playlist.name = name;
			[[PlaylistAPI api] savePlaylist:playlist callback:^(NSArray *playlists) {
				//NSLog(@"AOK");
			}];
			
			[self.tableView reloadData];
		}
		
	}
}

-(void)insertNewPlaylist:(Playlist *)playlist{
	NSInteger index = [plList addPlaylist: playlist];
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
	
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
	
	[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

	[self performSegueWithIdentifier:@"showPlaylist" sender:self.view];
	
	
	[[PlaylistAPI api] addPlaylist:playlist callback:^(NSArray *playlists) {
		//NSLog(@"kk");
	}];
}

@end
