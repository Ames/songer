//
//  DetailViewController.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "SongViewController.h"


@interface SongViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation SongViewController

@synthesize song;

#pragma mark - Managing the detail item

- (void)setSong:(id)newSong
{
    if (song != newSong) {
        song = newSong;
        
        // Update the view.
        [self configureView];
    }

	// this looks like iPad stuff...
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
	
	if (song) {
		NSURL *artUrl = [NSURL URLWithString:song.album800x800];
		
		self.titleLabel.text = [song title];
		self.artistLabel.text = [song artist];
		self.albumLabel.text = [song album];
		self.durationLabel.text = [song duration];
		[self.albumImage setImageWithURL:artUrl];
		
		self.titleLabelL.text = [song title];
		self.artistLabelL.text = [song artist];
		self.albumLabelL.text = [song album];
		self.durationLabelL.text = [song duration];
		[self.albumImageL setImageWithURL:artUrl];
	}
}

- (void)viewWillAppear:(BOOL)animated{
	[self changeForOrientation:self.interfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	
	[UIView animateWithDuration:duration animations:^{
		[self changeForOrientation:toInterfaceOrientation];
	}];

}

-(void)changeForOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
		self.landscapeView.alpha=0;
		self.portraitView.alpha=1;
	}else{
		self.landscapeView.alpha=1;
		self.portraitView.alpha=0;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
