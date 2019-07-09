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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *posts;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 450;
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
    
    return cell;
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
