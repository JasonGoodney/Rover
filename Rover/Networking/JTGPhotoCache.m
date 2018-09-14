//
//  JTGPhotoCache.m
//  Rover
//
//  Created by Jason Goodney on 9/13/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import "JTGPhotoCache.h"

@interface JTGPhotoCache ()

@property (nonatomic) NSCache *cache;

@end

@implementation JTGPhotoCache


+ (JTGPhotoCache *)shared
{
    static JTGPhotoCache *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [JTGPhotoCache new];
    });
    return shared;
}

- (instancetype)initWithCache:(NSCache *)cache {
    
    self = [super init];
    if (self) {
        _cache = cache;
        [_cache setName:@"com.jasongoodney.MarsRover.PhotosCache"];
    }
    return self;
}

- (void)cacheImageData:(NSData *)data forIdentifier:(NSInteger)identifier {    
    [_cache setObject:data forKey:@(identifier)];
}

- (NSData *)imageDataForIdentifier:(NSInteger)identifier {
    return [_cache objectForKey:@(identifier)];
}

@end






