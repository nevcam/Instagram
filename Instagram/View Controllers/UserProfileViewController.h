//
//  UserProfileViewController.h
//  Instagram
//
//  Created by nev on 7/11/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "UserProfileCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "TimelineViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (nonatomic, strong) PFUser *user;

@end

NS_ASSUME_NONNULL_END
