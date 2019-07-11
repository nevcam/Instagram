//
//  PostCell.h
//  Instagram
//
//  Created by nev on 7/9/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN
@protocol PostCellDelegate;

@interface PostCell : UITableViewCell
@property (weak, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (nonatomic, weak) id<PostCellDelegate> delegate;
@end

@protocol PostCellDelegate
// TODO: Add required methods the delegate needs to implement
- (void)postCell:(PostCell *) postCell didTap: (PFUser *)user;
//@property (nonatomic, weak) id<TweetCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
