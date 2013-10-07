//
//  Playlist.h
//  Playlist
//
//  Created by Ames Bielenberg on 10/2/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Song.h"

@class Song;

@interface Playlist : NSObject

@property (strong, nonatomic) NSMutableArray *playlist;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *serverId;


// factories
+ (Playlist *) playlist;
+ (Playlist *) playlistWithArray:(NSArray *)playlistArray;
+ (Playlist *) playlistWithName:(NSString *)name;

// special init
- (Playlist *) initWithArray:(NSArray *)playlistArray;
- (Playlist *) initWithName:(NSString *)name;

// utility
- (Song *) getSongAtIndex:(NSUInteger)index;
- (NSUInteger) length;

// manipulation
- (void) insertSong:(Song *)song atIndex:(NSUInteger)index;
- (Song *) removeSongAtIndex:(NSUInteger)index;
- (void) moveSongFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
- (void) loadPlaylistFromArray:(NSArray *)fromArray;
- (NSArray *) exportPlaylistToArray;

@end
