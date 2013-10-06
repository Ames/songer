//
//  MasterViewController.h
//  Playlist
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultViewController.h"
#import "Playlist.h"
#import "Song.h"

@class DetailViewController;


@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) Playlist* playlist;


@end
