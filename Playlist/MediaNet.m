//
//  MediaNet.m
//  SongSearch
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//

#import "MediaNet.h"

@implementation MediaNet


+(NSArray *)searchTracksWithKeyword:(NSString *)keyword{
	
	NSNumber *nResultsDefault = @20;
	
	return [self searchTracksWithKeyword:keyword nResults:nResultsDefault];
}

+(NSArray *)searchTracksWithKeyword:(NSString *)keyword nResults:(NSNumber *)nResults{
	
	NSString *escapedKeyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSDictionary *args=
		@{
		  @"method": @"Search.GetTracks",
		  @"keyword": escapedKeyword,
		  @"pageSize": [nResults stringValue]
		  };
	
	id qResults = [self mediaNetQueryWithArguments:args];
	
	NSMutableArray *results = [NSMutableArray array];

	
	if(!qResults[@"Success"]){
		return results;
	}
	
	for(id track in qResults[@"Tracks"]){
		[results addObject:[Song songWithDictionary:track]];
	}

	
	return results;
}

+(id)mediaNetQueryWithArguments:(NSMutableDictionary *)arguments{
	
	
	NSMutableDictionary *args = [NSMutableDictionary dictionaryWithDictionary:arguments];
	
	NSString *baseURL =@"http://ie-api.mndigital.com/";

	args[@"apiKey"] = @"kxgTlZ6Tig7nRy6qDvipG5PsL";
	args[@"format"] = @"json";
	
	
	
	NSMutableString *urlString = [NSMutableString stringWithString:baseURL];
	
	
	BOOL first = true;
	for(NSString *key in args){
		if(first){
			[urlString appendFormat:@"?%@=%@",key,args[key]];
			first=false;
		}else{
			[urlString appendFormat:@"&%@=%@",key,args[key]];
		}
	}
	
	
	// example: http://ie-api.mndigital.com/?method=Search.GetTracks&keyword=lunar&format=json&pageSize=1&apiKey=kxgTlZ6Tig7nRy6qDvipG5PsL
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSData *data = [NSData dataWithContentsOfURL:url];
	
	if(!data)
		return nil;

	NSError *error = nil;
	id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
	
	if (error){
		NSLog(@"%@", error);
		return nil;
	}
	
	return result;
}


@end
