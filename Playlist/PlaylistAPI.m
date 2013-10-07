//
//  PlaylistAPI.m
//  Playlist
//
//  Created by Ames Bielenberg on 10/2/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "PlaylistAPI.h"

@implementation PlaylistAPI


RKObjectManager *manager;

-(id)init{
	self = [super init];
	
	// init stuff
	
	
	manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[Settings get:@"ApiURL"]]];
	


	
	RKObjectMapping *playlistMapping = [RKObjectMapping mappingForClass:[Playlist class]];
	[playlistMapping addAttributeMappingsFromDictionary:
	 @{@"id": @"playlistId",
	   @"name":@"name",
	   }];
	
	
	RKObjectMapping* playlistRequestMapping = [RKObjectMapping requestMapping ]; // Shortcut for [RKObjectMapping mappingForClass:[NSMutableDictionary class] ]
	
	[playlistRequestMapping addAttributeMappingsFromDictionary:
	 @{@"playlistId": @"playlist[id]",
	   @"name":@"playlist[name]",
	   }];

	
	
	[manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:playlistMapping method:RKRequestMethodAny pathPattern:@"playlists" keyPath:nil statusCodes:nil]];
	
	
	[manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:playlistMapping method:RKRequestMethodAny pathPattern:@"playlists/:playlistId" keyPath:nil statusCodes:nil]];
	
	
	
//	[manager.mappingProvider setSerializationMapping:[listMapping inverseMapping] forClass:[List class]];

//	
//	[manager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:playlistMapping method:RKRequestMethodPOST pathPattern:@"playlists" keyPath:nil statusCodes:nil]];
	
	[manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:playlistRequestMapping objectClass:[Playlist class] rootKeyPath:nil method:RKRequestMethodPOST]];
	
//	RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userMapping
//																				   objectClass:[User class] rootKeyPath:nil];
//	
//	[objectManager addRequestDescriptor: requestDescriptor];
//	

	
	[[RKObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithClass:[Playlist class] pathPattern:@"playlists/:playlistId" method:RKRequestMethodGET|RKRequestMethodDELETE]];
	
	
	[[RKObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithClass:[Playlist class] pathPattern:@"playlists" method:RKRequestMethodPOST]];

	
	
	RKObjectMapping *songMapping = [RKObjectMapping mappingForClass:[Song class]];
	[songMapping addAttributeMappingsFromDictionary:
	 @{
	   @"title":       @"title",
	   @"artist_name": @"artist",
	   @"album_title": @"album",
	   @"duration":    @"duration",
	   @"album_150x150": @"album150x150",
	   @"album_800x800": @"album800x800",
	   @"mnet_id":     @"mNetId",
	   @"id":          @"songId",
	   @"playlist_id": @"playlistId",
	   }];
	
	RKObjectMapping *songRequestMapping = [RKObjectMapping requestMapping];
	[songRequestMapping addAttributeMappingsFromDictionary:
	 @{
	   @"title":       @"song[title]",
	   @"artist":      @"song[artist_name]",
	   @"album":	   @"song[album_title]",
	   @"duration":    @"song[duration]",
	   @"album150x150": @"song[album_150x150]",
	   @"album800x800": @"song[album_800x800]",
	   @"mNetId":      @"song[mnet_id]",
	   @"songId":      @"song[id]",
	   @"playlistId":  @"playlist[id]",
	   }];
	
	//[manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:songMapping method:RKRequestMethodAny pathPattern:@"playlists/:playlistId" keyPath:@"songs" statusCodes:nil]];
	
	
	
	//[playlistMapping addRelationshipMappingWithSourceKeyPath:@"playlist" mapping:songMapping];
	
	// Direct configuration of instances
	RKRelationshipMapping* playlistSongMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"songs" toKeyPath:@"playlist" withMapping:songMapping];
	[playlistMapping addPropertyMapping:playlistSongMapping];
	
	
	
	
	[manager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:songMapping method:RKRequestMethodAny pathPattern:@"playlists/:playlistId/songs/:songId" keyPath:nil statusCodes:nil]];
	
	
	[manager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:songRequestMapping objectClass:[Song class] rootKeyPath:nil method:RKRequestMethodAny]];
	
	
	[[RKObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithClass:[Song class] pathPattern:@"playlists/:playlistId/songs/:songId" method:RKRequestMethodGET|RKRequestMethodDELETE]];
	
	[[RKObjectManager sharedManager].router.routeSet addRoute:[RKRoute routeWithClass:[Song class] pathPattern:@"playlists/:playlistId/songs" method:RKRequestMethodPOST]];

	
	
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


-(void)getPlaylists:(void (^)(NSArray *))callback{
	

	[manager getObjectsAtPath:@"playlists" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		
		callback([mappingResult array]);
		
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		NSLog(@"%@",error);
		//callback(nil);
	}];
}


-(void)loadPlaylist:(Playlist *)playlist callback:(void (^)(Playlist *))callback{
	
	[manager getObject:playlist path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		
		playlist.loaded = TRUE;
		// assume [mappingResult array][0] == playlist
		
		callback([mappingResult array][0]);
		
		NSLog(@"%@",[mappingResult array]);
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		NSLog(@"%@",error);
	}];
}

-(void)addPlaylist:(Playlist *)playlist callback:(void (^)(NSArray *))callback{
	
	[manager postObject:playlist path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		NSLog(@"%@",mappingResult);
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		NSLog(@"%@",error);
	}];
	
}


-(void)deletePlaylist:(Playlist *)playlist callback:(void(^)(NSArray *playlists))callback{
	
	[manager deleteObject:playlist path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		NSLog(@"%@",mappingResult);
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		NSLog(@"%@",error);
	}];
}

-(void)addSong:(Song *)song callback:(void (^)(Playlist *))callback{
	
	[manager postObject:song path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		NSLog(@"%@",mappingResult);
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		NSLog(@"%@",error);
	}];
	
}

-(void)deleteSong:(Song *)song callback:(void (^)(Playlist *))callback{
	[manager deleteObject:song path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		NSLog(@"%@",mappingResult);
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		NSLog(@"%@",error);
	}];
}



@end
