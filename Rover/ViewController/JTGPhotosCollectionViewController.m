//
//  JTGPhotosCollectionViewController.m
//  Rover
//
//  Created by Jason Goodney on 9/12/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import "JTGPhotosCollectionViewController.h"

@interface JTGPhotosCollectionViewController ()

@property (nonatomic) JTGMarsRoverClient *client;
@property (nonatomic) NSMutableArray<UIImage *> *photoImages;

@end

@implementation JTGPhotosCollectionViewController

static NSString * const reuseIdentifier = @"photoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self fetchPhotoReferences];
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [self.collectionView reloadData];
//
//    });
    
    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.photoImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTGPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.photoImageView.image = self.photoImages[indexPath.row];
    
    return cell;
}

- (void) fetchPhotoReferences {
    _client = [[JTGMarsRoverClient alloc] init];
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [_client fetchPhotosFromRover:_rover sol:_sol withBlock:^(NSArray<JTGPhoto *> * _Nullable photos, NSError * _Nullable error) {
        
//        self.photos = photos;
        self.photoImages = [[NSMutableArray alloc] init];
        
        for (JTGPhoto *photo in photos) {
            dispatch_group_enter(group);
            [self.client fetchImageDataForPhoto:photo withBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                
                UIImage *image = [UIImage imageWithData:data];
                
                [self.photoImages addObject:image];
                dispatch_group_leave(group);
            }];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
