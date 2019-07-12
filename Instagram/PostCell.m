//
//  PostCell.m
//  Instagram
//
//  Created by nev on 7/9/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePhotoView addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePhotoView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *usernameTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.usernameLabel addGestureRecognizer:usernameTapGestureRecognizer];
    [self.usernameLabel setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapFav:(id)sender {
    if(self.post.favorited) {
        self.post.favorited = NO;
        NSNumber *likes = [NSNumber numberWithFloat:([self.post.likeCount floatValue] - 1)];
        self.post.likeCount = likes;
        
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                UIImage *defaultFav = [UIImage imageNamed:@"like"];
                [self.likeButton setImage:defaultFav forState:UIControlStateNormal];
                [self refreshData];
            } else {
                NSLog(@"Error unliking!: %@", error.localizedDescription);
            }
        }];
        
    } else {
        self.post.favorited = YES;
        NSNumber *likes = [NSNumber numberWithFloat:([self.post.likeCount floatValue] + 1)];
        self.post.likeCount = likes;
        [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                UIImage *redFav = [UIImage imageNamed:@"like-red"];
                [self.likeButton setImage:redFav forState:UIControlStateNormal];
                [self refreshData];
            } else {
                NSLog(@"Error liking!: %@", error.localizedDescription);
            }
        }];
    }
}

- (void)refreshData {
    self.likeCountLabel.text = [self.post.likeCount stringValue];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
    [self.delegate postCell:self didTap:self.post.author];
    
}
@end
