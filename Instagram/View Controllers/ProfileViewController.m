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

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *myPosts;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.myPosts = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self loadProfilePosts];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 4;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1))/ postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)loadProfilePosts {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
//    [postQuery whereKey:@"username" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"author"];
    postQuery.limit = 100;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            NSLog(@"😎😎😎 Successfully loaded photos");
            for (Post *post in posts) {
                if ([post[@"author"][@"username"] isEqualToString:[PFUser currentUser][@"username"]]) {
                    [self.myPosts insertObject:post atIndex:0];
                }
            }
            NSLog(@"MY POSTS:%@", self.myPosts);
            self.usernameLabel.text = [PFUser currentUser][@"username"];
            self.bioLabel.text = [PFUser currentUser][@"bio"];
//            NSLog(@"BIO: %@", [PFUser currentUser][@"bio"]);
            NSLog(@"PROFILEPIC: %@", [PFUser currentUser][@"ProfilePic"]);
            PFFileObject *imageFile = [PFUser currentUser][@"ProfilePic"];
            NSURL *photoURL = [NSURL URLWithString:imageFile.url];
//            NSURL *photoURL = [PFUser currentUser][@"ProfilePic"];
            self.profilePhotoView.image = nil;
            [self.profilePhotoView setImageWithURL:photoURL];
            
            NSLog(@"PF USER :%@", [PFUser currentUser]);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
