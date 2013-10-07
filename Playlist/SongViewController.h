//
//  DetailViewController.h
//  Playlist
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SongViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Song * song;

#pragma mark Portrait
@property (weak, nonatomic) IBOutlet UIView *portraitView;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;

#pragma mark Landscape
@property (weak, nonatomic) IBOutlet UIView *landscapeView;
@property (weak, nonatomic) IBOutlet UILabel *artistLabelL;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelL;
@property (weak, nonatomic) IBOutlet UILabel *albumLabelL;
@property (weak, nonatomic) IBOutlet UILabel *durationLabelL;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageL;



@end
