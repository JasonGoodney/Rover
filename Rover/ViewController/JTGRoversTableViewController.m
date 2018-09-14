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

@property (nonatomic, copy) NSArray<NSString *> *roverNames;

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
    return _rovers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    JTGRover *rover = [_rovers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = rover.name;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqual:@"toSolsVC"]) {
        
        JTGSolsTableViewController *destinationVC = [segue destinationViewController];
        
        NSInteger index = [self.tableView indexPathForSelectedRow].row;
        JTGRover *rover = [_rovers objectAtIndex:index];
        destinationVC.rover = rover;
    }
}


@end
