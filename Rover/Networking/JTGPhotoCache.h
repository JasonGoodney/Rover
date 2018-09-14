//
//  JTGPhotoCache.h
//  Rover
//
//  Created by Jason Goodney on 9/13/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTGPhotoCache : NSObject

+ (JTGPhotoCache *) shared;

- (instancetype) initWithCache:(NSCache *)cache;

- (void) cacheImageData:(NSData *)data forIdentifier:(NSInteger)identifier;

- (NSData *) imageDataForIdentifier:(NSInteger)identifier;

@end
