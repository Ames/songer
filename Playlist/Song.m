//
//  Song.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/2/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "Song.h"

@implementation Song


-(id)initWithTitle:(NSString *)songTitle artist:(NSString *)songArtist{
	self = [super init];
	self.title = songTitle;
	self.artist = songArtist;
	return self;
}

// create a song from a MediaNet Search API query result
-(id)initWithDictionary:(id)track{
	self = [super init];
	
	self.title = track[@"Title"];
	self.artist = track[@"Artist"][@"Name"];
	self.album = track[@"Album"][@"Title"];
	self.duration = track[@"Duration"];
	self.album75x75 = track[@"Album"][@"Images"][@"Album75x75"];
	self.album150x150 = track[@"Album"][@"Images"][@"Album150x150"];
	self.album800x800 = track[@"Album"][@"Images"][@"Album800x800"];
	self.mNetId = track[@"MnetId"];
	
	return self;
}

+(id)songWithTitle:(NSString *)title artist:(NSString *)artist{
	Song *song = [self alloc];
	return [song initWithTitle:title artist:artist];
}
+(id)songWithDictionary:(id)track{
	Song *song = [self alloc];
	return [song initWithDictionary:track];
}

- (NSString *)description{
	return self.title;
}
@end
