//
//  Playlist.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/2/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "Playlist.h"

@implementation Playlist

@synthesize playlist;

+ (Playlist *) playlist{
	return [[self alloc] init];
}
+ (Playlist *) playlistWithArray:(NSArray *)playlistArray{
	return [[self alloc] initWithArray:playlistArray];
}
+ (Playlist *) playlistWithName:(NSString *)name{
	return [[self alloc] initWithName:name];
}

- (Playlist *) init{
	self = [super init];
	playlist = [NSMutableArray array];
	_loaded = NO;
	return self;
}
- (Playlist *) initWithArray:(NSArray *)playlistArray{
	self = [self init];
	[self loadPlaylistFromArray:playlistArray];
	_loaded = YES;
	return self;
}
-(Playlist *) initWithName:(NSString *)name{
	self = [self init];
	self.name = name;
	_loaded = YES;
	return self;
}


- (Song *) getSongAtIndex:(NSUInteger)index{
	return playlist[index];
}
- (NSUInteger) length{
	return [playlist count];
}


- (void) insertSong:(Song *)song atIndex:(NSUInteger)index{
	song.playlistId = self.playlistId;
	[playlist insertObject:song atIndex:index];
}
- (Song *) removeSongAtIndex:(NSUInteger)index{
	Song *song = playlist[index];
	[playlist removeObjectAtIndex:index];
	return song;
}
- (void) moveSongFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex{
	Song *song = [self removeSongAtIndex:fromIndex];
	[self insertSong:song atIndex:toIndex];
}
- (void) loadPlaylistFromArray:(NSArray *)fromArray{
	// TODO
}
- (NSArray *) exportPlaylistToArray{
	// TODO
	return NULL;
}

@end
