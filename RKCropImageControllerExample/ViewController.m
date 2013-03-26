//
//  ViewController.m
//  RKCropImageControllerExample
//
//  Created by ren6 on 3/26/13.
//  Copyright (c) 2013 ren6. All rights reserved.
//

#import "ViewController.h"
#import "RKCropImageController.h"
@interface ViewController ()<RKCropImageViewDelegate>

@end

@implementation ViewController{
    IBOutlet UIImageView *imageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cropTapped)];
    [imageView addGestureRecognizer:tap];
    
}
-(void) cropTapped{
    RKCropImageController *cropController = [[RKCropImageController alloc] initWithImage:imageView.image];
    cropController.delegate = self;
    [self presentModalViewController:cropController animated:YES];
}
-(void)cropImageViewControllerDidFinished:(UIImage *)image{
    imageView.image = image;
}
@end
