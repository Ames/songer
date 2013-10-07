//
//  ResultViewController.h
//  SongSearch
//
//  Created by Ames Bielenberg on 9/30/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ResultViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Song *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;

@property (strong, nonatomic) IBOutlet UITableView *view;

@end
