//
//  JTGMarsRoverClient.h
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JTGRover.h"
#import "JTGPhoto.h"

@interface JTGMarsRoverClient : NSObject

// has a completion block as a parameter that returns an array of rover names, and an error.
- (void) fetchAllMarsRoversWithCompletion:(void(^)(NSArray<NSString *> * _Nullable roverNames, NSError * _Nullable error))block;

// takes in a string and has a completion block that returns an instance of your rover model, and an error
- (void) fetchMissionManifestForRoverNamed:(NSString *)roverName
                                 withBlock:(void(^)(JTGRover * _Nullable rover, NSError * _Nullable error ))block;

// takes in an instance of your rover model, which sol you want photos for, and a completion block that returns an array of photos, and an error.
- (void) fetchPhotosFromRover:(JTGRover *)rover sol:(NSNumber *)sol
                    withBlock:(void(^)(NSArray<JTGPhoto *> * _Nullable photos, NSError * _Nullable error ))block;

// takes in an instance of your photo model, and has a completion block that returns imageData ( NSData, not Data )
- (void) fetchImageDataForPhoto:(JTGPhoto *)photo
                      withBlock:(void(^)(NSData * _Nullable data, NSError * _Nullable error))block;

@end
