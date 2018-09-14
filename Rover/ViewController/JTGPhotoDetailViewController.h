//
//  JTGPhotoDetailViewController.h
//  Rover
//
//  Created by Jason Goodney on 9/13/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTGPhoto.h"
#import "JTGMarsRoverClient.h"
#import "JTGPhotoCache.h"

@interface JTGPhotoDetailViewController : UIViewController

@property (nonatomic) JTGPhoto *photo;

- (NSString *) formateDateFromDateString:(NSString *)dateString;

@end
