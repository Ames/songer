//
//  PlaylistAPI.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/2/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "PlaylistAPI.h"

@implementation PlaylistAPI


-(id)init{
	self = [super init];
	
	// init stuff
	
	return self;
}

// singleton magic
+(PlaylistAPI *)api{
	static PlaylistAPI *thePlaylistAPI;

    @synchronized(self){
		if(!thePlaylistAPI){
			if(thePlaylistAPI==NULL)
				thePlaylistAPI = [[self alloc] init];
		}
	}
	return thePlaylistAPI;
}



@end
