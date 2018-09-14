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
@property (nonatomic) NSArray<JTGPhoto *> *photosReferences;

@end

@implementation JTGPhotosCollectionViewController

static NSString * const reuseIdentifier = @"photoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchPhotoReferences];

}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [_solDescription.numberOfPhotos integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTGPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    _client = [[JTGMarsRoverClient alloc] init];
    JTGPhoto *photo = _photosReferences[indexPath.row];

    NSData *cachedData = [[JTGPhotoCache shared] imageDataForIdentifier:[photo.identifier integerValue]];
    UIImage *image = [UIImage imageWithData:cachedData];
    if (image) {
        cell.photoImageView.image = image;
        return cell;
    } else {
        cell.photoImageView.image = [UIImage imageNamed:@"MarsPlaceholder"];
    }
    
    
    [self.client fetchImageDataForPhoto:photo withBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        [JTGPhotoCache.shared cacheImageData:data forIdentifier:[photo.identifier integerValue]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.photoImageView.image = image;
        });
    }];
    
    return cell;
}

- (void) fetchPhotoReferences {
    _client = [[JTGMarsRoverClient alloc] init];
    [_client fetchPhotosFromRover:_rover sol:_solDescription.sol withBlock:^(NSArray<JTGPhoto *> * _Nullable photos, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photosReferences = photos;
        });
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqual:@"toPhotoDetailsVC"]) {
        
        JTGPhotoDetailViewController *destinationVC = [segue destinationViewController];
        JTGPhotoCollectionViewCell *cell = sender;
        
        NSInteger index = [self.collectionView indexPathForCell:cell].row;
        
        JTGPhoto *photo = _photosReferences[index];
        
        destinationVC.photo = photo;
    }
}

@end
