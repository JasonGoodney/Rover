//
//  JTGSolDescription.h
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTGSolDescription : NSObject

@property (nonatomic, readonly, copy) NSNumber *sol;
@property (nonatomic, readonly, copy) NSArray<NSString *> *cameras;
@property (nonatomic, readonly, copy) NSNumber *numberOfPhotos;

- (instancetype) initWithDictionary:(NSDictionary<NSString *, id> *)solDictionary;

@end
