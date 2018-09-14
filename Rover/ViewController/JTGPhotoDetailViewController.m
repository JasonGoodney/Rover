//
//  JTGPhotoDetailViewController.m
//  Rover
//
//  Created by Jason Goodney on 9/13/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

#import "JTGPhotoDetailViewController.h"

@interface JTGPhotoDetailViewController ()

@property (nonatomic) JTGMarsRoverClient *client;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;
@property (weak, nonatomic) IBOutlet UILabel *solLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation JTGPhotoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cameraLabel.text = [NSString stringWithFormat:@"Camera: %@", _photo.cameraName];
    _solLabel.text = [NSString stringWithFormat:@"Sol: %@", _photo.sol];
    _dateLabel.text = [NSString stringWithFormat:@"Date: %@", _photo.earthDateCaptured];
    
    _client = [[JTGMarsRoverClient alloc] init];
    [_client fetchImageDataForPhoto:_photo withBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error fetching image data: %@", error);
        }
        UIImage *image = [UIImage imageWithData:data];
        
        // FIXME: - JPEGDecompressSurface : Picture decode failed
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoImageView.image = [UIImage imageWithData:data];
            
        });
        
    }];
    
}

- (void)setPhoto:(JTGPhoto *)photo {
    
    if (!photo) {
        return;
    }
    
    _photo = photo;
    
}

@end
