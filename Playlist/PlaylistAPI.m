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
	
	RKLogConfigureByName("*",RKLogLevelError);
	
	manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[Settings get:@"ApiURL"]]];

	
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
	
	RKObjectMapping *playlistMapping = [RKObjectMapping mappingForClass:[Playlist class]];
	[playlistMapping addAttributeMappingsFromDictionary:
	 @{@"id": @"playlistId",
	   @"name":@"name",
	   }];
	
	RKObjectMapping* playlistRequestMapping = [RKObjectMapping requestMapping ];
	[playlistRequestMapping addAttributeMappingsFromDictionary:
	 @{@"playlistId": @"playlist[id]",
	   @"name":@"playlist[name]",
	   }];
	
	
	[manager addRequestDescriptorsFromArray:
	 @[[RKRequestDescriptor requestDescriptorWithMapping:songRequestMapping
											 objectClass:[Song class]
											 rootKeyPath:nil
												  method:RKRequestMethodAny],
	   [RKRequestDescriptor requestDescriptorWithMapping:playlistRequestMapping
											 objectClass:[Playlist class]
											 rootKeyPath:nil
												  method:RKRequestMethodPOST|RKRequestMethodPUT],
	   ]];
	
	[manager addResponseDescriptorsFromArray:
	 @[[RKResponseDescriptor responseDescriptorWithMapping:playlistMapping
													method:RKRequestMethodAny
											   pathPattern:@"playlists"
												   keyPath:nil
											   statusCodes:nil],
	   
	   [RKResponseDescriptor responseDescriptorWithMapping:playlistMapping
													method:RKRequestMethodAny
											   pathPattern:@"playlists/:playlistId"
												   keyPath:nil
											   statusCodes:nil],
	   
	   [RKResponseDescriptor responseDescriptorWithMapping:songMapping
													method:RKRequestMethodAny
											   pathPattern:@"playlists/:playlistId/songs/:songId"
												   keyPath:nil
											   statusCodes:nil],
	   
	   [RKResponseDescriptor responseDescriptorWithMapping:songMapping
													method:RKRequestMethodPOST
											   pathPattern:@"playlists/:playlistId/songs"
												   keyPath:nil
											   statusCodes:nil],
	   ]];
	
	
	[[RKObjectManager sharedManager].router.routeSet addRoutes:
	 @[[RKRoute routeWithClass:[Song class]
				   pathPattern:@"playlists/:playlistId/songs/:songId"
						method:RKRequestMethodGET|RKRequestMethodDELETE],
	   
	   [RKRoute routeWithClass:[Song class]
				   pathPattern:@"playlists/:playlistId/songs"
						method:RKRequestMethodPOST],
	   
	   [RKRoute routeWithClass:[Playlist class]
				   pathPattern:@"playlists/:playlistId"
						method:RKRequestMethodGET|RKRequestMethodDELETE|RKRequestMethodPUT],
	   
	   [RKRoute routeWithClass:[Playlist class]
				   pathPattern:@"playlists"
						method:RKRequestMethodPOST],
	   ]];
	
	
	[playlistMapping addPropertyMapping:
	 [RKRelationshipMapping relationshipMappingFromKeyPath:@"songs"
												 toKeyPath:@"playlist"
											   withMapping:songMapping]];
	

	
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
	
	[manager getObjectsAtPath:@"playlists"
				   parameters:nil
					  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
						  callback([mappingResult array]);
					  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
						  callback(nil);
					  }
	 ];
}


-(void)loadPlaylist:(Playlist *)playlist callback:(void (^)(Playlist *))callback{
	
	[manager getObject:playlist
				  path:nil
			parameters:nil
			   success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
				   
				   playlist.loaded = TRUE;
				   // assume [mappingResult array][0] == playlist
				   
				   callback([mappingResult array][0]);
				   
			   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
				   
				   
				   NSInteger status = operation.HTTPRequestOperation.response.statusCode;
				   if(status==404){
					   
					   // the playlist is gone.
					   NSLog(@"That playlist is gone bro.");
					   // we should delete our copy and make appropriate view changes.
					   
				   }
				   callback(nil);
			   }
	 ];
}

-(void)addPlaylist:(Playlist *)playlist callback:(void (^)(NSArray *))callback{
	
	[manager postObject:playlist
				   path:nil
			 parameters:nil
				success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
					callback([mappingResult array]);
					
				}failure: ^(RKObjectRequestOperation *operation, NSError *error) {
					callback(nil);
				}
	 ];
	
}

-(void)savePlaylist:(Playlist *)playlist callback:(void(^)(NSArray *playlists))callback{
	
	// they could all look like this; we're not really using most of the callbacks,
	//   but we probably should be for things like error handling
	
	[manager putObject:playlist
				  path:nil
			parameters:nil
			   success:nil
			   failure:nil];
}


-(void)deletePlaylist:(Playlist *)playlist callback:(void(^)(NSArray *playlists))callback{

	[manager deleteObject:playlist
					 path:nil
			   parameters:nil
				  success:nil
				  failure:nil];
}

-(void)addSong:(Song *)song callback:(void (^)(Playlist *))callback{
	
	[manager postObject:song
				   path:nil
			 parameters:nil
				success:nil
				failure:nil];
	
}

-(void)deleteSong:(Song *)song callback:(void (^)(Playlist *))callback{
	
	[manager deleteObject:song
					 path:nil
			   parameters:nil
				  success:nil
				  failure:nil];
}



@end
