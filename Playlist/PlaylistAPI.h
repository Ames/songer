//
//  PlaylistAPI.h
//  Playlist
//
//  Created by Ames Bielenberg on 10/2/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//


// This is a singleton class.


// this system is fairly simple, with a few basic operations:
//   get a playlist
//   add a song to the playlist
//   move a song in a playlist
//   delete a song from a playlist

// possible multi-playlist management
//   get playlist list
//   add a playlist
//   [rename? delete?]

// a REST API has an endpoint for each of these operations.
// the fancy RestKit framework will do lots of fancy mapping and stuff


// all methods are asynchronous, using callback blocks

#import <Foundation/Foundation.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <RestKit/RestKit.h>

#import "Song.h"
#import "Playlist.h"
#import "Settings.h"


@interface PlaylistAPI : NSObject


+(PlaylistAPI *)api;


-(void)getPlaylists:(void(^)(NSArray *playlists))callback;
-(void)addPlaylist:(Playlist *)playlist callback:(void(^)(NSArray *playlists))callback;
// for rename
-(void)savePlaylist:(Playlist *)playlist callback:(void(^)(NSArray *playlists))callback;

-(void)deletePlaylist:(Playlist *)playlist callback:(void(^)(NSArray *playlists))callback;

-(void)loadPlaylist:(Playlist *)playlist callback:(void(^)(Playlist *playlist))callback;
-(void)addSong:(Song *)song callback:(void(^)(Playlist *playlist))callback;
-(void)deleteSong:(Song *)song callback:(void(^)(Playlist *playlist))callback;
//-(void)moveSong:(Song *)song from:(NSNumber *)fromIndex to:(NSNumber *)toIndex callback:(void(^)(Playlist *playlist))callback;

	
@end
