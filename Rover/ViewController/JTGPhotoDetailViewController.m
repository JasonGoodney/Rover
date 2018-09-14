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
    
    NSString *earthDateCapturedFormatted = [self formateDateFromDateString:_photo.earthDateCaptured];
    
    _dateLabel.text = [NSString stringWithFormat:@"Date: %@", earthDateCapturedFormatted];
    
}

- (void)setPhoto:(JTGPhoto *)photo {
    _photo = photo;
    
    _client = [[JTGMarsRoverClient alloc] init];
    
    NSData *cachedData = [[JTGPhotoCache shared] imageDataForIdentifier:[photo.identifier integerValue]];
    UIImage *image = [UIImage imageWithData:cachedData];
    if (image) {
        _photoImageView.image = image;
        
    } else {
        _photoImageView.image = [UIImage imageNamed:@"MarsPlaceholder"];
    }
    
    [_client fetchImageDataForPhoto:_photo withBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error fetching image data: %@", error);
        }
        UIImage *image = [UIImage imageWithData:data];
        
        [JTGPhotoCache.shared cacheImageData:data forIdentifier:[photo.identifier integerValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoImageView.image = image;
        });
        
    }];
}

- (NSString *) formateDateFromDateString:(NSString *)dateString; {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"EEEE, MMM d, yyyy"];
    return [formatter stringFromDate:date];
}

@end
