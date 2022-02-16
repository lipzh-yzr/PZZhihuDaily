//
//  PZRefreshHelper.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/4.
//

#import "PZRefreshHelper.h"
#import "PZRefreshHeaderControl.h"
#import "Masonry.h"
#import "PZMacro.h"

#define MAXHEIGHT 200
#define CIRCLE_WIDTH 30

@interface PZRefreshHelper ()<UIGestureRecognizerDelegate>
@property(nonatomic, weak, readwrite) UIScrollView *scrollView;
@property(nonatomic, weak, readwrite) PZRefreshHeaderControl *refreshControl;
@property(nonatomic) UIViewPropertyAnimator *animator;
@end

@implementation PZRefreshHelper

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) setScrollView:(UIScrollView * _Nullable)scrollView andRefreshControl:(PZRefreshHeaderControl *) refreshControl {
    _scrollView = scrollView;
    _refreshControl = refreshControl;
    
    CGFloat x = (SCREEN_WIDTH - CIRCLE_WIDTH)/2;
    CGFloat y = 0 - CIRCLE_WIDTH/2;
    refreshControl.frame = CGRectMake(x, y, CIRCLE_WIDTH, CIRCLE_WIDTH);
    [scrollView insertSubview:refreshControl atIndex:0];
    [refreshControl setHidden:YES];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [scrollView addGestureRecognizer:panGesture];
    panGesture.delegate = self;
}

#pragma mark - private
-(void) handlePanGesture: (UIPanGestureRecognizer *) panGesture {
    UIGestureRecognizerState state = panGesture.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            [_scrollView bringSubviewToFront:_refreshControl];
            [_refreshControl setHidden:NO];
//            _scrollView.scrollEnabled = NO;
            [self makeAnimators];
        }
            break;
        
        case UIGestureRecognizerStateChanged:
        {
            [self panDidChange:panGesture];
        }
            break;
        
        case UIGestureRecognizerStateEnded:
        {
            [self panDidEnd:panGesture];
        }
            break;
            
        case UIGestureRecognizerStateCancelled:
        {
            [self panDidEnd:panGesture];
        }
            break;
        default:
            break;
    }
}

-(void) nullifyAnimator {
    _animator = nil;
    [self.refreshControl setHidden:YES];
    [self.refreshControl sendSubviewToBack:self.refreshControl];
}

-(void) makeAnimators {
    if (!_animator) {
        _animator = [[UIViewPropertyAnimator alloc] initWithDuration:1 curve:UIViewAnimationCurveEaseOut animations:^{
            
//            [self.refreshControl mas_updateConstraints:^(MASConstraintMaker *make) {
//                            make.centerY.equalTo(self.scrollView.mas_top).offset(MAXHEIGHT);
//            }];
            CGFloat y = self.refreshControl.center.y + MAXHEIGHT;
            self.refreshControl.center = CGPointMake(self.refreshControl.center.x, y);
            self.refreshControl.transform = CGAffineTransformMakeRotation(M_PI);
//            [self.refreshControl layoutIfNeeded];
        }];
        
        
        WEAKIFY(self);
        [_animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
                    if (finalPosition == UIViewAnimatingPositionStart) {
                        
                    } else if (finalPosition == UIViewAnimatingPositionCurrent) {
                        
                    } else if (finalPosition == UIViewAnimatingPositionEnd) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:PZREFRESH_ROTATE_SUCCESS object:nil];
//                        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
//                        animGroup.duration = 3;
//                        CABasicAnimation *rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//                        rotateAnim.byValue = @(M_PI);
//                        rotateAnim.toValue = @(M_PI * 2);
//                        rotateAnim.duration = 1;
//                        rotateAnim.repeatDuration = 2;
//
//                        CABasicAnimation *yTranslateAnim = [CABasicAnimation animationWithKeyPath:@"transform.translate.y"];
////                        rotateAnim.byValue = @(M_PI);
//                        yTranslateAnim.beginTime = 2;
//                        yTranslateAnim.toValue = @(-MAXHEIGHT);
//                        yTranslateAnim.duration = 1;
//
//                        animGroup.animations = @[rotateAnim, yTranslateAnim];
//                        animGroup.removedOnCompletion = NO;
//                        animGroup.fillMode = kCAFillModeForwards;
//
//                        [WEAK_SELF.refreshControl.layer addAnimation:animGroup forKey:@"endAnimGroup"];
                        
                        [UIView animateWithDuration:1 animations:^{
                            WEAK_SELF.refreshControl.transform = CGAffineTransformMakeRotation(-M_PI_2);
                        } completion:^(BOOL finished) {
                            if (finished) {
                                [UIView animateWithDuration:0.5 animations:^{
                                    WEAK_SELF.refreshControl.center = CGPointMake(WEAK_SELF.refreshControl.center.x, WEAK_SELF.refreshControl.center.y - MAXHEIGHT);
                                    WEAK_SELF.refreshControl.transform = CGAffineTransformMakeRotation(M_PI_2);
                                } completion:^(BOOL finished) {
                                    if (finished) {
                                        [WEAK_SELF nullifyAnimator];
                                    }
                                }];
                            }
                        }];
                    }
            
//            _scrollView.scrollEnabled = YES;
        }];
        
        [_animator pauseAnimation];
//        [_animator setPausesOnCompletion:YES];
    }
}

-(void) panDidChange:(UIPanGestureRecognizer *) panGesture {
    
        CGFloat fractionUpdate = [panGesture translationInView:_scrollView].y / MAXHEIGHT;
        CGFloat newFraction = _animator.fractionComplete + fractionUpdate;
        _animator.fractionComplete = newFraction > 1? 1: newFraction;
    
    [panGesture setTranslation:CGPointZero inView:_scrollView];
}

-(void) panDidEnd:(UIPanGestureRecognizer *) panGesture {
//    WEAKIFY(self);
    CGFloat fraction = _animator.fractionComplete;
    if (fraction >= 0.9) {
//        [_animator addAnimations:^{
//            WEAK_SELF.refreshControl.transform = CGAffineTransformRotate(WEAK_SELF.refreshControl.transform, M_PI_2);
//        } delayFactor:0];
        [_animator stopAnimation:NO];
        [_animator finishAnimationAtPosition:UIViewAnimatingPositionEnd];
        
    } else if (fraction <= 0.1) {
        [_animator stopAnimation:NO];
        [_animator finishAnimationAtPosition:UIViewAnimatingPositionStart];
    } else {
        [_animator stopAnimation:NO];
        [_animator finishAnimationAtPosition:UIViewAnimatingPositionCurrent];
    }
//    [self.animator setReversed:YES];
//    [self.animator continueAnimationWithTimingParameters:nil durationFactor:1];
//    [self.animator finishAnimationAtPosition:UIViewAnimatingPositionStart];
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_scrollView.contentOffset.y == 0 && [(UIPanGestureRecognizer *) gestureRecognizer translationInView:_scrollView].y > 0) {
        return true;
    }
    return false;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
//        return true;
//    }
//    else {
//        return false;
//    }
    return true;
}

@end
