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

@interface ProfileEditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.user.delegate = self;
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
    NSData *imageData = UIImageJPEGRepresentation(self.profilePhoto.image, 0.5f);
    PFFileObject *imageFile = [PFFileObject fileObjectWithName:@"Profileimage.png" data:imageData];
    self.user[@"ProfilePic"] = imageFile;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // handle error
        }
    }];
}
- (IBAction)didTapChangeProfilePhoto:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    UIImage *resizedEdited = [self resizeImage:editedImage withSize:CGSizeMake(450, 450)];
    UIImage *resizedOriginal = [self resizeImage:originalImage withSize:CGSizeMake(450, 450)];
    // Do something with the images (based on your use case)
    self.profilePhoto.image = resizedEdited;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
