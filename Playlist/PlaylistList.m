//
//  PlaylistManager.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/6/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "PlaylistList.h"


@implementation PlaylistList

@synthesize list;

- (id)init{
    self = [super init];
    if (self) {
        list = [NSMutableArray array];
    }
    return self;
}

-(NSInteger)count{
	return [list count];
}

-(Playlist *)getPlaylistAtIndex:(NSInteger)index{
	return list[index];
}

// returns index of added playlist
-(NSInteger)addPlaylist:(Playlist *)playlist{
	[list insertObject:playlist atIndex:list.count];
	
	//[self sortByName]; meh
	
	return [list indexOfObject:playlist];
}

-(void)deletePlaylistAtIndex:(NSInteger)index{
	[list removeObjectAtIndex:index];
}

-(void)sortByName{
	// sort by name
	NSArray *sortedArray;
	sortedArray = [list sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		return [((Playlist *)a).name compare:((Playlist *)b).name];
	}];
	
	[list setArray:sortedArray];
}


@end
