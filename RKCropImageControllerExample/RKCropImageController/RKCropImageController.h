//
//  CropImageViewController.h
//  Image To PDF
//
//  Created by ren6 on 3/25/13.
//  Copyright (c) 2013 ren6. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RKCropImageViewDelegate <NSObject>
-(void) cropImageViewControllerDidFinished:(UIImage*)image; // cropped image
@end

@interface RKCropImageController : UIViewController
-(id) initWithImage:(UIImage*)image; // this is the only way to initialize controller with image to crop
-(void) setLineGesturesEnabled:(BOOL) enableLineGestures; // default is YES. Changing to NO will disable line gestures and only corner gestures will be active. It is not comfortable enough to zoom an image with fingers when line gestures are enabled.
-(void) setCornerGesturesEnabled:(BOOL) enableLineGestures; // default is YES. Changing to NO will disable corner gestures and only line gestures will be active
@property (nonatomic, assign) UIEdgeInsets startInset; // default crop inset is (15, 15, 15, 15)
@property (nonatomic, assign) id<RKCropImageViewDelegate> delegate;

@end
