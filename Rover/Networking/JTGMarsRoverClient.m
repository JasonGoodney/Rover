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
+ (NSURL *) URLForInfoForRover:(NSString *)roverName {
    NSURL *roverManifestURL = [[[self baseURL] URLByAppendingPathComponent:@"manifests"] URLByAppendingPathComponent:[roverName lowercaseString]];
    NSURLComponents *components = [NSURLComponents componentsWithURL:roverManifestURL resolvingAgainstBaseURL:YES];
    components.queryItems = @[[JTGMarsRoverClient apiKeyQueryItem]];
    return components.URL;
}

+ (NSURL *) URLForPhotosFromRover:(NSString *)roverName sol:(NSNumber *)sol {
    NSURL *roverURL = [[[[self baseURL]
                         URLByAppendingPathComponent:@"rovers"]
                         URLByAppendingPathComponent:[roverName lowercaseString]]
                         URLByAppendingPathComponent:@"photos"];
    
    NSString *solString = [NSString stringWithFormat:@"%@", sol];
    NSURLComponents *components = [NSURLComponents componentsWithURL:roverURL resolvingAgainstBaseURL:YES];
    NSURLQueryItem *solQueryItem = [NSURLQueryItem queryItemWithName:@"sol" value:solString];
    
    components.queryItems = @[solQueryItem, [JTGMarsRoverClient apiKeyQueryItem]];
    
    return components.URL;
}

- (void)fetchAllMarsRoversWithCompletion:(void (^)(NSArray<NSString *> * _Nullable, NSError * _Nullable))block {
    NSURL *roversURL = [JTGMarsRoverClient URLForAllRovers];
    [[[NSURLSession sharedSession] dataTaskWithURL:roversURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@ %@", error, error.localizedDescription);
            block(nil, error); return;
        }
        
//        NSLog(@"\n\n%@\n\n", response);
        
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

- (void)fetchMissionManifestForRoverNamed:(NSString *)roverName withBlock:(void (^)(JTGRover * _Nullable, NSError * _Nullable))block {
    NSURL *roverURL = [JTGMarsRoverClient URLForInfoForRover:roverName];
    [[[NSURLSession sharedSession] dataTaskWithURL:roverURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@ %@", error, error.localizedDescription);
            block(nil, error); return;
        }
        
//        NSLog(@"\n\n%@\n\n", response);
        
        if (!data) {
            NSLog(@"NO DATA: %@ %@", error, error.localizedDescription);
            block(nil, error); return;
        }
        
        NSError *err = nil;
        NSDictionary *topLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:2 error:&err];
        
        NSDictionary *roverDictionary = topLevelDictionary[@"photo_manifest"];
        
        JTGRover *rover = [[JTGRover alloc] initWithDictionary:roverDictionary];
        rover.solDescriptions = [self solDescriptionFromDicionary:roverDictionary];
                
        block(rover, nil);
    }] resume];
}

- (void)fetchPhotosFromRover:(JTGRover *)rover sol:(NSNumber *)sol withBlock:(void (^)(NSArray<JTGPhoto *> * _Nullable, NSError * _Nullable))block {
    
    NSURL *photosURL = [JTGMarsRoverClient URLForPhotosFromRover:rover.name sol:sol];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:photosURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@ %@", error, error.localizedDescription);
            block(nil, error); return;
        }
        
//        NSLog(@"\n\n%@\n\n", response);
        
        if (!data) {
            NSLog(@"NO DATA: %@ %@", error, error.localizedDescription);
            block(nil, error); return;
        }
        
        NSError *err = nil;
        NSDictionary *topLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:2 error:&err];
        NSArray *photosArray = topLevelDictionary[@"photos"];
        NSMutableArray *photosToComplete = [[NSMutableArray alloc] init];
        
        for (NSDictionary *photoDictionary in photosArray) {
            JTGPhoto *photo = [[JTGPhoto alloc] initWithDictionary:photoDictionary];
            [photosToComplete addObject:photo];
        }
        
        block(photosToComplete, nil);
    }] resume];
}

- (void)fetchImageDataForPhoto:(JTGPhoto *)photo withBlock:(void (^)(NSData * _Nullable, NSError * _Nullable))block {
    
    if (!photo) {
        NSLog(@"no photo object for image data fetch");
        block(nil, nil);
        return;
    }
    
    NSURL *imageURL = [NSURL URLWithString:photo.imageURLString];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, error.localizedDescription);
            block(nil, error); return;
        }
        
        NSLog(@"\n\n%@\n\n", response);
        
        if (!data) {
            NSLog(@"NO DATA: %@ %@", error, error.localizedDescription);
            block(nil, error); return;
        }
        
        block(data, nil);
        
    }] resume];
}

- (NSArray *) solDescriptionFromDicionary:(NSDictionary *)roverDictionary {
    NSMutableArray *solDescriptions = [[NSMutableArray alloc] init];
    NSDictionary<NSString *, id> *photos = roverDictionary[@"photos"];
    
    for (NSDictionary *photo in photos) {
        JTGSolDescription *solDescription = [[JTGSolDescription alloc] initWithDictionary:photo];
        [solDescriptions addObject:solDescription];
    }
    
    return solDescriptions;
}

@end

























