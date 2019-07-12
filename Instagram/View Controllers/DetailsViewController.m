//
//  DetailsViewController.m
//  Instagram
//
//  Created by nev on 7/9/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *photoURL = [NSURL URLWithString:self.post.image.url];
    self.photoView.image = nil;
    [self.photoView setImageWithURL:photoURL];
    
    self.captionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
    // Convert String to Date
    NSDate *date = self.post.createdAt;
    // Convert Date to String
    self.timestampLabel.text = date.timeAgoSinceNow;
    self.likeCountLabel.text = [self.post.likeCount stringValue];
    PFFileObject *imageFile = self.post.author[@"ProfilePic"];
    NSURL *profilePhotoURL = [NSURL URLWithString:imageFile.url];
    self.profilePhotoView.image = nil;
    [self.profilePhotoView setImageWithURL:profilePhotoURL];
    // make profile photo a circle
    self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.height /2;
    self.profilePhotoView.layer.masksToBounds = YES;
    self.profilePhotoView.layer.borderWidth = 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
