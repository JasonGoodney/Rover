//
//  JTGRover.m
//  JTGRover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import "JTGRover.h"

@implementation JTGRover

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)roverDictionary {
    NSString *name = roverDictionary[@"name"];
    NSString *landingDate = roverDictionary[@"landing_date"];
    NSString *launchDate = roverDictionary[@"launch_date"];
    NSNumber *maxSol = roverDictionary[@"max_sol"];
    NSString *maxDate = roverDictionary[@"max_date"];
    NSNumber *totalPhotos = roverDictionary[@"total_photos"];
    
    JTGRoverStatus roverStatus = JTGRoverStatusActive;
    if ([roverDictionary[@"status"] isEqualToString:@"complete"]) {
        roverStatus = JTGRoverStatusComplete;
    }
    
    if (    ![name isKindOfClass:[NSString class]]       || ![landingDate isKindOfClass:[NSString class]] ||
            ![launchDate isKindOfClass:[NSString class]] || ![maxDate isKindOfClass:[NSString class]] ||
            ![maxSol isKindOfClass:[NSNumber class]]     || ![totalPhotos isKindOfClass:[NSNumber class]])
    {
        return nil;
    }
    
    if (self = [super init]) {
        _name = name;
        _landingDate = landingDate;
        _launchDate = launchDate;
        _maxSol = maxSol;
        _maxDate = maxDate;
        _totalPhotos = totalPhotos;
        _roverStatus = roverStatus;
    }
    return self;
}

@end
