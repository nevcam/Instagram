//
//  DetailsViewController.h
//  Instagram
//
//  Created by nev on 7/9/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "PostCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;

@end

NS_ASSUME_NONNULL_END
