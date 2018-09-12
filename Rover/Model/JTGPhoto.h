//
//  JTGPhoto.h
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTGPhoto : NSObject

@property (nonatomic, readonly, copy) NSNumber *identifier;
@property (nonatomic, readonly, copy) NSNumber *sol;
@property (nonatomic, readonly, copy) NSString *cameraName;
@property (nonatomic, readonly, copy) NSString *imageURLString;
@property (nonatomic, readonly, copy) NSString *earthDateCaptured;

- (instancetype) initWithDictionary:(NSDictionary<NSString *, id> *)photoDictionary;
    
@end
