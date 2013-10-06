//
//  MasterViewController.h
//  SongSearch
//
//  Created by Ames Bielenberg on 9/30/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaNet.h"
#import "MNet.h"

@class ResultViewController;

@interface SearchViewController : UITableViewController <UISearchDisplayDelegate>

@property (strong, nonatomic) ResultViewController *resultViewController;
@property (strong, nonatomic) NSOperationQueue *searchQueue;
@property (strong, nonatomic) NSMutableArray *searchResults;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *mainTable;

@end
