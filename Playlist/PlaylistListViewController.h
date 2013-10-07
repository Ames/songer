//
//  PlaylistListViewController.h
//  Playlist
//
//  Created by Ames Bielenberg on 10/6/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlaylistList.h"
#import "PlaylistViewController.h"
//@class PlaylistViewController;

@interface PlaylistListViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) PlaylistViewController *playlistViewController;


@property (strong, nonatomic) PlaylistList* plList;

- (IBAction)addButtonPressed:(id)sender;

- (void)insertNewPlaylist:(Playlist *)playlist;

@end
