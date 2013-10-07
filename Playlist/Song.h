//
//  Song.h
//  Playlist
//
//  Created by Ames Bielenberg on 10/2/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *album75x75;
@property (strong, nonatomic) NSString *album150x150;
@property (strong, nonatomic) NSString *album800x800;
@property (strong, nonatomic) NSNumber *serverId;
@property (strong, nonatomic) NSNumber *mNetId;

// ...

-(id)initWithTitle:(NSString *)title artist:(NSString *)artist;
-(id)initWithDictionary:(id)track;

+(id)songWithTitle:(NSString *)title artist:(NSString *)artist;
+(id)songWithDictionary:(id)track;
@end
