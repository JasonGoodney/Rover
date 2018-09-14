//
//  JTGSolsTableViewController.m
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import "JTGSolsTableViewController.h"

@interface JTGSolsTableViewController ()

@end

@implementation JTGSolsTableViewController

static NSString * const reuseIdentifier = @"solCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)setRover:(JTGRover *)rover {
    if (![rover isEqual:_rover]) {
        _rover = rover;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _rover.solDescriptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    

    JTGSolDescription *solDescription = [_rover.solDescriptions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Sol %@", solDescription.sol];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ Photos", solDescription.numberOfPhotos];
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqual:@"toPhotosVC"]) {
        
        JTGPhotosCollectionViewController *destinationVC = [segue destinationViewController];
        
        NSInteger index = [self.tableView indexPathForSelectedRow].row;
        
        destinationVC.rover = _rover;
        destinationVC.solDescription = [_rover.solDescriptions objectAtIndex:index];
    }
}

@end
