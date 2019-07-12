//
//  ProfileViewController.m
//  Instagram
//
//  Created by nev on 7/10/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import "ProfileViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "AppDelegate.h"
#import "PhotoGridCell.h"
#import "ProfileEditViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ProfileEditViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *myPosts;
@property (nonatomic, strong) PFUser *user;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.myPosts = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self loadProfile];
    [self.collectionView reloadData];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1))/ postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}


- (void)loadProfile {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 100;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            NSLog(@"😎😎😎 Successfully loaded photos");
            for (Post *post in posts) {
                if ([post[@"author"][@"username"] isEqualToString:[PFUser currentUser][@"username"]]) {
                    [self.myPosts addObject:post ];
                }
            }
            NSLog(@"MY POSTS:%@", self.myPosts);
            self.usernameLabel.text = [PFUser currentUser][@"username"];
            self.bioLabel.text = [PFUser currentUser][@"bio"];
            PFFileObject *imageFile = [PFUser currentUser][@"ProfilePic"];
            NSURL *photoURL = [NSURL URLWithString:imageFile.url];
            self.profilePhotoView.image = nil;
            [self.profilePhotoView setImageWithURL:photoURL];
            self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.width / 2;
            self.profilePhotoView.layer.masksToBounds = YES;
            [self.view addSubview: self.profilePhotoView];
            
            NSLog(@"PF USER :%@", [PFUser currentUser]);
            self.user = [PFUser currentUser];
            [self.collectionView reloadData];
        }
        else {
            // handle error
            NSLog(@"😫😫😫 Error getting photos: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapEditProfile:(id)sender {
    [self performSegueWithIdentifier:@"editSegue" sender:nil];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    NSLog(@"%@", @"Logged out successfully!");
}



- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PhotoGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoGridCell" forIndexPath:indexPath];
    Post *post = self.myPosts[indexPath.item];
    
    NSURL *photoURL = [NSURL URLWithString:post.image.url];
    cell.photoGridView.image = nil;
    [cell.photoGridView setImageWithURL:photoURL];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myPosts.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"editSegue"]){
        PFUser *user = self.user;
        ProfileEditViewController *profileEditViewController = [segue destinationViewController];
        profileEditViewController.user = user;
        profileEditViewController.delegate = self;
    }
}


- (void)didSave {
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 100;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            NSLog(@"😎😎😎 Successfully loaded photos");
            self.usernameLabel.text = [PFUser currentUser][@"username"];
            self.bioLabel.text = [PFUser currentUser][@"bio"];

            PFFileObject *imageFile = [PFUser currentUser][@"ProfilePic"];
            NSURL *photoURL = [NSURL URLWithString:imageFile.url];

            self.profilePhotoView.image = nil;
            [self.profilePhotoView setImageWithURL:photoURL];
            self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.width / 2;
            self.profilePhotoView.layer.masksToBounds = YES;
            [self.view addSubview: self.profilePhotoView];
            self.user = [PFUser currentUser];
            [self.collectionView reloadData];
        }
        else {
            // handle error
            NSLog(@"😫😫😫 Error getting photos: %@", error.localizedDescription);
        }
    }];
}

@end
