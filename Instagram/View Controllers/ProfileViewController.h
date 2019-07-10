//
//  ProfileViewController.h
//  Instagram
//
//  Created by nev on 7/10/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@end

NS_ASSUME_NONNULL_END
