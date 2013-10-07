//
//  PlaylistManager.h
//  Playlist
//
//  Created by Ames Bielenberg on 10/6/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playlist.h"

@interface PlaylistList : NSObject

@property (strong, nonatomic) NSMutableArray *list;

-(NSInteger) count;
-(Playlist*) getPlaylistAtIndex:(NSInteger)index;
-(NSInteger)addPlaylist:(Playlist *)playlist;
-(void) deletePlaylistAtIndex:(NSInteger)index;

-(void)sortByName;

@end
