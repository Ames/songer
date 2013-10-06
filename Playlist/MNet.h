//
//  MediaNet.h
//  SongSearch
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <RestKit/RestKit.h>

#import "Settings.h"
#import "Song.h"

@interface MNet : NSObject
//
//+(NSArray *)searchTracksWithKeyword:(NSString *)keyword;

+(void)searchTracksWithKeyword:(NSString *)keyword nResults:(NSNumber *)nResults success:(void(^)(NSArray *results))success failure:(void(^)(NSError *error))failure;

+(void)queryWithParameters:(NSMutableDictionary *)params success:(void(^)(NSArray *results))success failure:(void(^)(NSError *error))failure;

@end
