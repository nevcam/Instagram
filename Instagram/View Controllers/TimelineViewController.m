//
//  TimelineViewController.m
//  Instagram
//
//  Created by nev on 7/8/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import "TimelineViewController.h"
#import "LoginViewController.h"
#import "Post.h"
#import "PostCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "AppDelegate.h"
#import "InfiniteScrollActivityView.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (nonatomic, strong) NSMutableArray *posts;
@end

@implementation TimelineViewController

bool isMoreDataLoading = false;
InfiniteScrollActivityView* loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 450;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    //infinite scroll
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    //load homepage
    [self loadHomePage];
}

- (void)loadHomePage {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.posts = posts;
            NSLog(@"%@", self.posts);
            [self.tableView reloadData];
        }
        else {
            // handle error
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self loadHomePage];
    [refreshControl endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    //Set tweet labels
    Post *post = self.posts[indexPath.row];
    
    NSURL *photoURL = [NSURL URLWithString:post.image.url];
    cell.photoView.image = nil;
    [cell.photoView setImageWithURL:photoURL];

    cell.captionLabel.text = post.caption;
    cell.usernameLabel.text = post.author.username;
    cell.likeCountLabel.text = [post.likeCount stringValue];
    
//    NSURL *profilePhotoURL = [NSURL URLWithString:post.author.];
//    cell.profilePhotoView.image = nil;
//    [cell.profilePhotoView setImageWithURL:profilePhotoURL];
    
    return cell;
}
- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    //    [self performSegueWithIdentifier:@"logoutSegue" sender:nil];
    NSLog(@"%@", @"Logged out successfully!");
}

// loading more data for infinite scroll
- (void)loadMoreData {
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            NSLog(@"Successfully loaded more data");
            // Update flag
            self.isMoreDataLoading = false;
            [loadingMoreView stopAnimating];
            
            // check this part
            NSMutableArray *updatedPosts = [self.posts arrayByAddingObjectsFromArray:posts];
            self.posts = updatedPosts;
            
            NSLog(@"%@", self.posts);
            [self.tableView reloadData];
        }
        else {
            // handle error
            NSLog(@"Error getting more data: %@", error.localizedDescription);
        }
    }];
}

// infinite scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            
            // Code to load more results
            [self loadMoreData];
        }
        
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    // get the indexPath for the tapped cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    // get the tapped movie using the indexPath for the tapped cell
    Post *post = self.posts[indexPath.row];
    // to hand the movie : get the new view controller using [segue destinationViewController] and cast it
    DetailsViewController *detailsViewController = [segue destinationViewController];
    
    detailsViewController.post = post;
}


@end
