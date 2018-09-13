//
//  JTGSolDescription.m
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import "JTGSolDescription.h"

@implementation JTGSolDescription

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)solDictionary {
    NSNumber *sol = solDictionary[@"sol"];
    NSNumber *numberOfPhotos = solDictionary[@"total_photos"];
    NSArray<NSString *> *cameras = solDictionary[@"cameras"];
    
    if (![sol isKindOfClass:[NSNumber class]] ||
        ![numberOfPhotos isKindOfClass:[NSNumber class]] ||
        ![cameras isKindOfClass:[NSArray class]]) {
        
        return nil;
    }
    
    if (self = [super init]) {
        _sol = sol;
        _numberOfPhotos = numberOfPhotos;
        _cameras = cameras;
    }
    return self;
}

@end
