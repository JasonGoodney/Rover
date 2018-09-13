//
//  JTGRoversTableViewController.m
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import "JTGRoversTableViewController.h"

@interface JTGRoversTableViewController ()

@property (nonatomic) NSMutableArray<JTGRover *> *rovers;

@end

@implementation JTGRoversTableViewController

static NSString * const reuseIdentifier = @"roverCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_group_t group = dispatch_group_create();

    JTGMarsRoverClient *client = [[JTGMarsRoverClient alloc] init];
    self.rovers = [[NSMutableArray alloc] init];
    
    dispatch_group_enter(group);
    [client fetchAllMarsRoversWithCompletion:^(NSArray<NSString *> * _Nullable roverNames, NSError * _Nullable error) {
        
        for (NSString *roverName in roverNames) {
            
            dispatch_group_enter(group);
            [client fetchMissionManifestForRoverNamed:roverName withBlock:^(JTGRover * _Nullable rover, NSError * _Nullable error) {
                
                [self.rovers addObject:rover];
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self rovers] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    JTGRover *rover = [[self rovers] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = rover.name;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
