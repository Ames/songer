//
//  AddViewController.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

@synthesize theNewTrack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[[self nameField] becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	if(textField==self.nameField){
		[textField resignFirstResponder];
	}
	
	return YES;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if([[segue identifier] isEqualToString:@"ReturnInput"]){
		if([self.nameField.text length]){
			theNewTrack = self.nameField.text;
		}
	}
}
@end
