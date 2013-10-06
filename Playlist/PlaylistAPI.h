//
//  PlaylistAPI.h
//  Playlist
//
//  Created by Ames Bielenberg on 10/2/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//


// this could be a singleton, or we could just have lots of class methods...


#import <Foundation/Foundation.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <RestKit/RestKit.h>

#import "Song.h"
#import "Playlist.h"


@interface PlaylistAPI : NSObject

//+ (id)callAPIEndpoint:(NSString *)method

@end
