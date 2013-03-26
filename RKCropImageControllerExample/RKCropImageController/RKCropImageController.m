//
//  CropImageViewController.m
//  Image To PDF
//
//  Created by ren6 on 3/25/13.
//  Copyright (c) 2013 ren6. All rights reserved.
//

#import "RKCropImageController.h"
#import "UIImage+Extensions.h"
@interface RKCropImageController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *drawView;
@end

@implementation RKCropImageController{
    IBOutlet UIImageView* arrow1;
    IBOutlet UIImageView* arrow2;
    IBOutlet UIImageView* arrow3;
    IBOutlet UIImageView* arrow4;
    
    IBOutlet UIView *lineLeft;
    IBOutlet UIView *lineRight;
    IBOutlet UIView *lineTop;
    IBOutlet UIView *lineBottom;
    IBOutlet UIView *cropView;
    CGPoint panGestureStartPoint;
    
}
@synthesize startInset;
-(id) initWithImage:(UIImage *)image{
    self = [super init];
    if (self){
        [self view];
        [self setImage:image];
    }
    return self;
}
-(void) setLineGesturesEnabled:(BOOL) enableLineGestures{
    [[lineTop.gestureRecognizers objectAtIndex:0] setEnabled:enableLineGestures];
    [[lineBottom.gestureRecognizers objectAtIndex:0] setEnabled:enableLineGestures];
    [[lineLeft.gestureRecognizers objectAtIndex:0] setEnabled:enableLineGestures];
    [[lineRight.gestureRecognizers objectAtIndex:0] setEnabled:enableLineGestures];
}
-(void)setCornerGesturesEnabled:(BOOL)enableLineGestures{
    [[arrow1.gestureRecognizers objectAtIndex:0] setEnabled:enableLineGestures];
    [[arrow2.gestureRecognizers objectAtIndex:0] setEnabled:enableLineGestures];
    [[arrow3.gestureRecognizers objectAtIndex:0] setEnabled:enableLineGestures];
    [[arrow4.gestureRecognizers objectAtIndex:0] setEnabled:enableLineGestures];
}
-(void)setImage:(UIImage *)image{
    self.imageView.image = image;
    CGPoint center = self.scrollView.center;
    CGFloat heightWillBe;
    CGFloat widthWillBe;
    CGSize size;
    CGFloat widthKoef = self.scrollView.frame.size.width/self.imageView.image.size.width;
    CGFloat heightKoef = self.scrollView.frame.size.height/self.imageView.image.size.height;
    if ( widthKoef < heightKoef){
        // width is bigger than height
        heightWillBe  = self.imageView.image.size.height * self.imageView.frame.size.width/self.imageView.image.size.width;
        size = CGSizeMake(self.imageView.frame.size.width, heightWillBe);
    } else {
        // height is bigger than width
        widthWillBe  = self.imageView.image.size.width * self.imageView.frame.size.height/self.imageView.image.size.height;
        size = CGSizeMake(widthWillBe, self.imageView.frame.size.height);
    }
    [self.scrollView setBounds:CGRectMake(0, 0, size.width, size.height)];
    [self.imageView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.scrollView setCenter:center];
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.alwaysBounceVertical = NO;
    
    startInset = UIEdgeInsetsMake(15, 15, 15, 15); // default inset
    [self configureInitialLinesAndCorners];
}
-(IBAction)cancelTapped{
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction) saveTapped{
    if ([[self delegate] respondsToSelector:@selector(cropImageViewControllerDidFinished:)]){
        [self.delegate cropImageViewControllerDidFinished:[self cropImage]];
    }
    [self dismissModalViewControllerAnimated:YES];
}
- (CGRect) visibleRect{
    CGRect visibleRect;
    visibleRect.origin = CGPointMake(lineLeft.center.x, lineTop.center.y);
    visibleRect.size = CGSizeMake(lineRight.center.x-lineLeft.center.x, lineBottom.center.y-lineTop.center.y);
    return visibleRect;
}
-(UIImage*) cropImage{
    CGRect rect = [self visibleRect];
    CGFloat koef = self.imageView.image.size.width / self.scrollView.frame.size.width;
    CGRect finalImageRect = CGRectMake(rect.origin.x*koef, rect.origin.y*koef, rect.size.width*koef, rect.size.height*koef);
    UIImage *croppedImage = [self.imageView.image imageAtRect:finalImageRect];
    return croppedImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 5.0f;

}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (self.scrollView.scrollEnabled)
     return self.drawView;
    else return nil;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(float)scale {
    [aScrollView setZoomScale:scale+0.01 animated:NO];
    [aScrollView setZoomScale:scale animated:NO];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        self.scrollView.scrollEnabled = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(allowScrollingAndZooming) object:nil];
        [self performSelector:@selector(allowScrollingAndZooming) withObject:nil afterDelay:0.2];
    }
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void) allowScrollingAndZooming{
    self.scrollView.scrollEnabled = YES;
}






-(void) configureInitialLinesAndCorners{
    int half = lineTop.frame.size.height/2; // half of line view
    
    lineTop.frame= CGRectMake(startInset.left, startInset.top-half, self.imageView.frame.size.width-startInset.left-startInset.right,lineTop.frame.size.height);
    
    lineBottom.frame= CGRectMake(startInset.left, self.imageView.frame.size.height-startInset.bottom-half, self.imageView.frame.size.width-startInset.left-startInset.right,lineBottom.frame.size.height);
    
    lineLeft.frame = CGRectMake(startInset.left-half, startInset.top, lineLeft.frame.size.width, self.imageView.frame.size.height-startInset.top-startInset.bottom);
    lineRight.frame = CGRectMake(self.imageView.frame.size.width-startInset.right-startInset.left, startInset.top, lineRight.frame.size.width, self.imageView.frame.size.height-startInset.top-startInset.bottom);
    [self configureLinesAndCorners];
}
-(void) configureLinesAndCorners{
    lineTop.frame= CGRectMake(lineLeft.center.x, lineTop.frame.origin.y, lineRight.center.x-lineLeft.center.x,lineTop.frame.size.height);
    lineBottom.frame= CGRectMake(lineLeft.center.x, lineBottom.frame.origin.y, lineRight.center.x-lineLeft.center.x,lineBottom.frame.size.height);
    lineLeft.frame = CGRectMake(lineLeft.frame.origin.x, lineTop.center.y, lineLeft.frame.size.width, lineBottom.center.y-lineTop.center.y);
    lineRight.frame = CGRectMake(lineRight.frame.origin.x, lineTop.center.y, lineRight.frame.size.width, lineBottom.center.y-lineTop.center.y);
    [arrow1 setCenter:CGPointMake(lineLeft.center.x, lineTop.center.y)];
    [arrow2 setCenter:CGPointMake(lineRight.center.x, lineTop.center.y)];
    [arrow3 setCenter:CGPointMake(lineLeft.center.x, lineBottom.center.y)];
    [arrow4 setCenter:CGPointMake(lineRight.center.x, lineBottom.center.y)];
    [cropView setFrame:CGRectMake(arrow1.center.x, arrow1.center.y, lineTop.frame.size.width, lineRight.frame.size.height)];
}
-(void) moveLine:(UIView*)line withPoint:(CGPoint)point{
    CGPoint finalPoint;
    
    if (line==lineLeft || line==lineRight){
        point = CGPointMake(point.x, line.frame.origin.y);
        finalPoint = CGPointMake(point.x+panGestureStartPoint.x,point.y);
    }else{
        point = CGPointMake(line.frame.origin.x,point.y);
        finalPoint = CGPointMake(point.x,point.y+panGestureStartPoint.y);
    }
    CGRect frame = line.frame;
    CGFloat halfWidth = lineLeft.frame.size.width/2;
    
    if (line==lineTop){
        CGFloat y =  MAX(-halfWidth,MIN(lineBottom.center.y-halfWidth*3,finalPoint.y));
        frame.origin.y = y;
    } else if (line==lineBottom){
        frame.origin.y = MIN(self.imageView.frame.size.height-halfWidth, MAX(finalPoint.y,lineTop.center.y+halfWidth));
    } else if (line==lineLeft){
        frame.origin.x = MAX(-halfWidth,MIN(lineRight.center.x-halfWidth*3,finalPoint.x));
    } else if (line==lineRight){
        frame.origin.x = MIN(self.imageView.frame.size.width-halfWidth,MAX(finalPoint.x,lineLeft.center.x+halfWidth));
    }
    line.frame = frame;
    
}
-(IBAction) lineMoved:(UIPanGestureRecognizer*)pan{
    if (self.scrollView.panGestureRecognizer.state==UIGestureRecognizerStateBegan ||
        self.scrollView.panGestureRecognizer.state==UIGestureRecognizerStateChanged) return;
    self.scrollView.scrollEnabled = NO;
    
    if (pan.state==UIGestureRecognizerStateEnded){
        self.scrollView.scrollEnabled = YES;
    }
    if (pan.state==UIGestureRecognizerStateBegan){
        panGestureStartPoint = pan.view.frame.origin;
    }
    [self moveLine:pan.view withPoint:[pan translationInView:self.drawView]];
    [self configureLinesAndCorners];
}
-(IBAction) cornerViewMoved:(UIPanGestureRecognizer*)pan{
    if (self.scrollView.panGestureRecognizer.state==UIGestureRecognizerStateBegan ||
        self.scrollView.panGestureRecognizer.state==UIGestureRecognizerStateChanged) return;
    self.scrollView.scrollEnabled = NO;
    if (pan.state==UIGestureRecognizerStateEnded){
        self.scrollView.scrollEnabled = YES;
    }
    if (pan.state==UIGestureRecognizerStateBegan){
        panGestureStartPoint = pan.view.frame.origin;
    }
    if (pan.view==arrow1){
        [self moveLine:lineLeft withPoint:[pan translationInView:self.drawView]];
        [self moveLine:lineTop withPoint:[pan translationInView:self.drawView]];
    }else if (pan.view==arrow2){
        [self moveLine:lineTop withPoint:[pan translationInView:self.drawView]];
        [self moveLine:lineRight withPoint:[pan translationInView:self.drawView]];
    } else if (pan.view==arrow3){
        [self moveLine:lineLeft withPoint:[pan translationInView:self.drawView]];
        [self moveLine:lineBottom withPoint:[pan translationInView:self.drawView]];
    } else if (pan.view==arrow4){
        [self moveLine:lineBottom withPoint:[pan translationInView:self.drawView]];
        [self moveLine:lineRight withPoint:[pan translationInView:self.drawView]];
    }
    [self configureLinesAndCorners];
}
@end
