//
//  ProfileEditViewController.h
//  Instagram
//
//  Created by nev on 7/10/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ProfileEditViewControllerDelegate
- (void)didSave;
@end

@interface ProfileEditViewController : UIViewController
@property (nonatomic, weak) id<ProfileEditViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *bioField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) PFUser *user;
@end

NS_ASSUME_NONNULL_END
