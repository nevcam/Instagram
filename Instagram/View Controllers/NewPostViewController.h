//
//  NewPostViewController.h
//  Instagram
//
//  Created by nev on 7/9/19.
//  Copyright © 2019 nev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <MBProgressHUD/MBProgressHUD.h>


NS_ASSUME_NONNULL_BEGIN

@interface NewPostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *captionField;
@property (weak, nonatomic) IBOutlet UIImageView *photoField;

@end

NS_ASSUME_NONNULL_END
