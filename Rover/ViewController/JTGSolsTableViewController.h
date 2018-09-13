//
//  JTGSolsTableViewController.h
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTGRover.h"
#import "JTGMarsRoverClient.h"
#import "JTGPhoto.h"
#import "JTGSolDescription.h"
#import "JTGPhotosCollectionViewController.h"

@interface JTGSolsTableViewController : UITableViewController

@property (nonatomic) JTGRover *rover;
//@property (nonatomic) JTGSolDescription *solDescription;

@end
