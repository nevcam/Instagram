//
//  ProfileEditViewController.m
//  Instagram
//
//  Created by nev on 7/10/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "Post.h"
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"user: %@", self.user);
    // Do any additional setup after loading the view.
    self.usernameField.text = self.user[@"username"];
    self.bioField.text = self.user[@"bio"];
    self.emailField.text = self.user[@"email"];
    PFFileObject *imageFile = self.user[@"ProfilePic"];
    NSURL *photoURL = [NSURL URLWithString:imageFile.url];
    self.profilePhoto.image = nil;
    [self.profilePhoto setImageWithURL:photoURL];
    
}
- (IBAction)didTapSave:(id)sender {
    self.user[@"bio"] = self.bioField.text;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
