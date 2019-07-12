//
//  SignUpViewController.m
//  Instagram
//
//  Created by nev on 7/8/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}


-(void)dismissKeyboard
{
    [self.usernameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}


- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
//    newUser.description = [NSString new];
    
    
    if (![newUser.username  isEqual: @""] && ![newUser.email  isEqual: @""]  && ![newUser.password  isEqual: @""] ) {
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign Up Error" message:@"Cannot create this account." preferredStyle:(UIAlertControllerStyleAlert)];
                
                // create a try again action
                UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                    // function calls itself to try again!
                }];
                
                // add the cancel action to the alertController
                [alert addAction:tryAgainAction];
                
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            } else {
                NSLog(@"User registered successfully");
                UIImage *chosenImage = [UIImage imageNamed:@"profile-pic-placeholder"];
                NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5f);
                PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"Profileimage.png" data:imageData];
                newUser[@"ProfilePic"] = imageFile;
                newUser[@"bio"] = @"";
                [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (! error) {
                        [self dismissViewControllerAnimated:true completion:nil];
                    }
                }];
                
            }
        }];
        
    }
    // if the text fields are empty, give an error and let user try again
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign Up Error" message:@"Make sure fields are not empty!" preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create a try again action
        UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again!" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            // function calls itself to try again!
        }];
        
        // add the cancel action to the alertController
        [alert addAction:tryAgainAction];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    
   
}

- (IBAction)closeSignUp:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
