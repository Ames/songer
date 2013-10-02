//
//  ResultViewController.m
//  SongSearch
//
//  Created by Ames Bielenberg on 9/30/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation ResultViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Song *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
	
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
	
	if (self.detailItem) {
		
		self.artistLabel.text = [self.detailItem artist];
		self.titleLabel.text = [self.detailItem title];
		self.albumLabel.text = [self.detailItem album];
		self.durationLabel.text = [self.detailItem duration];
		//self.albumImage.image
		
		/// MAKE THIS ASYNC! ///
		NSURL *imgUrl = [NSURL URLWithString:self.detailItem.album150x150];
		NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
		UIImage *img = [UIImage imageWithData:imgData];
		
		self.albumImage.image = img;
		
	    //self.detailDescriptionLabel.text = [self.detailItem description];
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



//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return 6;
//}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//	if([[segue identifier] isEqualToString:@"ReturnInput"]){
//		
//		
//		
//		
//		if([self.titleLabel.text length]){
//			theNewTrack = [Song songWithTitle:self.nameField.text artist:self.artistField.text];
//		}
//	}
//}


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
