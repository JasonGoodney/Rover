//
//  JTGRover.h
//  JTGRover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

// api_key = bZmxxthFzctlbjVgj6Ge8bJOocsUyYIcicXwXXgG

#import <Foundation/Foundation.h>
#import "JTGSolDescription.h"

typedef NS_ENUM(NSInteger, JTGRoverStatus) {
    JTGRoverStatusActive,
    JTGRoverStatusComplete
};

@interface JTGRover : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *landingDate;
@property (nonatomic, readonly, copy) NSString *launchDate;
@property (nonatomic, readonly, copy) NSNumber *maxSol;
@property (nonatomic, readonly, copy) NSString *maxDate;
@property (nonatomic, readonly, copy) NSNumber *totalPhotos;
@property (nonatomic) NSArray<JTGSolDescription *> *solDescriptions;
@property (nonatomic) JTGRoverStatus roverStatus;


- (instancetype) initWithDictionary:(NSDictionary<NSString *, id> *)roverDictionary;

@end

