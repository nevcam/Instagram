//
//  ProfileEditViewController.h
//  Instagram
//
//  Created by nev on 7/10/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *bioField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

NS_ASSUME_NONNULL_END
