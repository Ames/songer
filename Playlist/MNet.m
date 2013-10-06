//
//  MediaNet.m
//  SongSearch
//
//  Created by Ames Bielenberg on 10/1/13.
//  Copyright (c) 2013 Ames Bielenberg. All rights reserved.
//
//
//  MNet implements an asynchronous call to the MediaNet search api using RestKit.
//
// This was created to get familiar with RestKit, but it's not actually being used because what we were doing before )synchronous MediaNet.m and OperationQueue) works fine/better.
// I suppose if we were really motivated we could re-create the cancellable requestQueue system using RestKit, but... meh.
//


#import "MNet.h"

@implementation MNet



//+(NSArray *)searchTracksWithKeyword:(NSString *)keyword{
//	
//	NSNumber *nResultsDefault = @20;
//	
//	return [self searchTracksWithKeyword:keyword nResults:nResultsDefault];
//}


+(void)searchTracksWithKeyword:(NSString *)keyword nResults:(NSNumber *)nResults success:(void (^__strong)(NSArray *results))success failure:(void(^)(NSError *error))failure{
	
	
	NSString *escapedKeyword = [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:
	@{
	  @"method": @"Search.GetTracks",
	  @"keyword": escapedKeyword,
	  @"pageSize": [nResults stringValue]
	  }];
	
	
	[self queryWithParameters:params success:success failure:failure];
	
//	
//	id qResults = [self queryWithParameters:args];
//	
//	NSMutableArray *results = [NSMutableArray array];
//	
//	
//	if(!qResults[@"Success"]){
//		return results;
//	}
//	
//	for(id track in qResults[@"Tracks"]){
//		[results addObject:[Song songWithDictionary:track]];
//	}
//	
//	
//	return results;
}


/*
 - (void)getObject:(id)object path:(NSString *)path
 parameters:(NSDictionary *)parameters success:(void (^)(
 RKObjectRequestOperation *__strong, RKMappingResult *__strong))success
 failure:(void (^__strong)(RKObjectRequestOperation *__strong,
 NSError *__strong))failure;
 
 
 */




+(void)queryWithParameters:(NSMutableDictionary *)params success:(void(^)(NSArray *results))success failure:(void(^)(NSError *error))failure{

	static RKObjectMapping *trackMapping;
	if(trackMapping == NULL){
		trackMapping = [RKObjectMapping mappingForClass:[Song class]];
		[trackMapping addAttributeMappingsFromDictionary:
		 @{
		   @"Title":       @"title",
		   @"Artist.Name": @"artist",
		   @"Album.Title": @"album",
		   @"Duration":    @"duration",
		   
		   @"Album.Images.Album75x75":   @"album75x75",
		   @"Album.Images.Album150x150": @"album150x150",
		   @"Album.Images.Album800x800": @"album800x800",
		   }
		 ];
		trackMapping.forceCollectionMapping = YES; // RestKit cannot infer this is a collection, so we force it
		
	}
	
	
	
	
	NSMutableDictionary *args = [NSMutableDictionary dictionaryWithDictionary:params];
	
	NSString *baseURL = [Settings get:@"MediaNetURL"];
	
	params[@"apiKey"] = [Settings get:@"MediaNetApiKey"];
	args[@"format"] = @"json";
	
	
//	NSMutableString *urlString = [NSMutableString stringWithString:baseURL];
//	
//	BOOL first = true;
//	for(NSString *key in args){
//		if(first){
//			[urlString appendFormat:@"?%@=%@",key,args[key]];
//			first=false;
//		}else{
//			[urlString appendFormat:@"&%@=%@",key,args[key]];
//		}
//	}
//	
	// example: http://ie-api.mndigital.com/?method=Search.GetTracks&keyword=lunar&format=json&pageSize=1&apiKey=kxgTlZ6Tig7nRy6qDvipG5PsL
	
//	NSURL *url = [NSURL URLWithString:urlString];
//	
	
	
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:trackMapping method:RKRequestMethodAny pathPattern:nil keyPath:@"Tracks" statusCodes:nil];
	//
//	NSURLRequest *request = [NSURLRequest requestWithURL:url];
//	RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
	//
	//
	//
	RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:baseURL]];
	
	[manager addResponseDescriptor:responseDescriptor];
	
	[manager getObject:nil path:@"/" parameters:args success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
		NSLog(@"%@",mappingResult);
		
		success([mappingResult array]);
		
	} failure:^(RKObjectRequestOperation *operation, NSError *error) {
		NSLog(@"%@",error);
		
		failure(error);
		
	}];
	
	
//	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
//			NSLog(@"results: %@", [result array]);
//		} failure:nil];
//	[operation start];
	
//	
//	
//	NSData *data = [NSData dataWithContentsOfURL:url];
//	
//	if(!data)
//		return nil;
//	
//	NSError *error = nil;
//	id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//	
//	if (error){
//		NSLog(@"%@", error);
//		return nil;
//	}
//	
//	return result;
}


@end
