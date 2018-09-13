//
//  JTGMarsRoverClient.m
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import "JTGMarsRoverClient.h"

@implementation JTGMarsRoverClient

+ (NSString *)apiKey {
    static NSString *apiKey = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *apiKeysURL = [[NSBundle mainBundle] URLForResource:@"APIKeys" withExtension:@"plist"];
        if (!apiKeysURL) {
            NSLog(@"Error! APIKeys file not found!");
            return;
        }
        NSDictionary *apiKeys = [[NSDictionary alloc] initWithContentsOfURL:apiKeysURL];
        apiKey = apiKeys[@"APIKeys"];
    });
    return apiKey;
}

+ (NSURL *) baseURL {
    return [NSURL URLWithString:@"https://api.nasa.gov/mars-photos/api/v1/"];
}

+ (NSURL *) URLForAllRovers {
    NSURL *roversURL = [[self baseURL] URLByAppendingPathComponent:@"rovers"];
    NSURLComponents *components = [NSURLComponents componentsWithURL:roversURL resolvingAgainstBaseURL:YES];
    components.queryItems = @[[JTGMarsRoverClient apiKeyQueryItem]];
    return components.URL;
}

+ (NSURLQueryItem *) apiKeyQueryItem {
    return [NSURLQueryItem queryItemWithName:@"api_key" value:[JTGMarsRoverClient apiKey]];
}

// Returns manifest for rover with roverName
+ (NSURL *) URLForInforForRover:(NSString *)roverName {
    NSURL *roverManifestURL = [[[self baseURL] URLByAppendingPathComponent:@"manifests"] URLByAppendingPathComponent:roverName];
    NSURLComponents *components = [NSURLComponents componentsWithURL:roverManifestURL resolvingAgainstBaseURL:YES];
    components.queryItems = @[[JTGMarsRoverClient apiKeyQueryItem]];
    return components.URL;
}

+ (NSURL *) URLForPhotosFromRover:(NSString *)roverName sol:(NSNumber *)sol {
    NSURL *roverURL = [[[self baseURL] URLByAppendingPathComponent:@"rovers"] URLByAppendingPathComponent:roverName];
    NSString *solString = [NSString stringWithFormat:@"%@", sol];
    NSURLComponents *components = [NSURLComponents componentsWithURL:roverURL resolvingAgainstBaseURL:YES];
    NSURLQueryItem *solQueryItem = [NSURLQueryItem queryItemWithName:@"sol" value:solString];
    
    components.queryItems = @[solQueryItem, [JTGMarsRoverClient apiKeyQueryItem]];
    
    return components.URL;
}

- (void)fetchAllMarsRoversWithCompletion:(void (^)(NSArray<NSString *> * _Nullable, NSError * _Nullable))block {
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[JTGMarsRoverClient URLForAllRovers] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@ %@", error, error.localizedDescription);
            block(nil, error); return;
        }
        
        NSLog(@"\n\n%@\n\n", response);
        
        if (!data) {
            NSLog(@"NO DATA: %@ %@", error, error.localizedDescription);
            block(nil, error); return;
        }
        
        NSError *err = nil;
        
        NSDictionary *topLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:2 error:&err];
        
        NSArray *roversArray = topLevelDictionary[@"rovers"];
        NSMutableArray *roverNamesArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *roverDictionary in roversArray) {
            [roverNamesArray addObject:roverDictionary[@"name"]];
        }
        
        block(roverNamesArray, nil);
        
    }] resume];
}

- (void)fetchMissionManifestForRoverNamed:(NSString *)name withBlock:(void (^)(JTGRover * _Nullable, NSError * _Nullable))block {
    
    
}

@end

























