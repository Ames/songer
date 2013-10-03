//
//  MasterViewController.h
//  SongSearch
//
//  Created by Ames Bielenberg on 9/30/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MediaNet.h"


@class ResultViewController;

@interface SearchViewController : UITableViewController <UISearchDisplayDelegate>

@property (strong, nonatomic) ResultViewController *resultViewController;

@property (strong, nonatomic) NSOperationQueue *searchQueue;


// for now just an array of strings. Eventually array of Song objects
@property (strong, nonatomic) NSMutableArray *searchResults;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//@property (strong, nonatomic) UISearchDisplayController *searchController;

@property (strong, nonatomic) IBOutlet UITableView *mainTable;

@end
