//
//  Settings.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/5/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//
//  a minimal settings manager

#import "Settings.h"

@implementation Settings

static NSDictionary *settings;

+(id)get:(NSString *)setting{

	if(!settings){
		NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
		settings = [[NSDictionary alloc] initWithContentsOfFile:path];
	}
	return settings[setting];
}

@end
