//
//  MediaNet.h
//  SongSearch
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Song.h"
#import "Settings.h"


@interface MediaNet : NSObject

+(NSArray *)searchTracksWithKeyword:(NSString *)keyword;
+(NSArray *)searchTracksWithKeyword:(NSString *)keyword nResults:(NSNumber *)nResults;

+(NSDictionary *)queryWithParameters:(NSDictionary *)params;

@end
