//
//  UserProfileViewController.m
//  Instagram
//
//  Created by nev on 7/11/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Parse/Parse.h"


@interface UserProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSMutableArray *userPosts;
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.userPosts = [NSMutableArray new];
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
                if ([post[@"author"][@"username"] isEqualToString:self.user[@"username"]]) {
                    [self.userPosts addObject:post ];
                }
            }
            self.usernameLabel.text = self.user[@"username"];
            self.bioLabel.text = self.user[@"bio"];
            PFFileObject *imageFile = self.user[@"ProfilePic"];
            NSURL *photoURL = [NSURL URLWithString:imageFile.url];
            self.profilePhotoView.image = nil;
            [self.profilePhotoView setImageWithURL:photoURL];
            self.profilePhotoView.layer.cornerRadius = self.profilePhotoView.frame.size.width / 2;
            self.profilePhotoView.layer.masksToBounds = YES;
            [self.view addSubview: self.profilePhotoView];
            
            NSLog(@"PF USER :%@", self.user);
            [self.collectionView reloadData];
        }
        else {
            // handle error
            NSLog(@"😫😫😫 Error getting photos: %@", error.localizedDescription);
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserProfileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserProfileCell" forIndexPath:indexPath];
    Post *post = self.userPosts[indexPath.item];
    
    NSURL *photoURL = [NSURL URLWithString:post.image.url];
    cell.cellPhotoView.image = nil;
    [cell.cellPhotoView setImageWithURL:photoURL];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPosts.count;
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
