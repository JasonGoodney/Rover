//
//  JTGPhoto.m
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import "JTGPhoto.h"

@implementation JTGPhoto

- (BOOL)isEqualToPhoto:(JTGPhoto *)photo {
    return
    [self.identifier isEqualToNumber:photo.identifier]  &&
    [self.sol isEqualToNumber:photo.sol] &&
    [self.cameraName isEqualToString:photo.cameraName] &&
    [self.imageURLString isEqualToString:photo.imageURLString] &&
    [self.earthDateCaptured isEqualToString:photo.earthDateCaptured];
}

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)photoDictionary{
    NSNumber *identifier = photoDictionary[@"id"];
    NSNumber *sol = photoDictionary[@"sol"];
    NSString *cameraName = photoDictionary[@"camera"][@"name"];
    NSString *imageURLString = photoDictionary[@"img_src"];
    NSString *earthDateCaptured = photoDictionary[@"earth_date"];
    
    if (    ![identifier isKindOfClass:[NSNumber class]] || ![sol isKindOfClass:[NSNumber class]] ||
            ![cameraName isKindOfClass:[NSString class]] || ![imageURLString isKindOfClass:[NSString class]] ||
            ![earthDateCaptured isKindOfClass:[NSString class]])
    {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _identifier = identifier;
        _sol = sol;
        _cameraName = cameraName;
        _imageURLString = imageURLString;
        _earthDateCaptured = earthDateCaptured;
    }
    return self;
}

@end
