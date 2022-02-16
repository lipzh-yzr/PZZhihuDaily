//
//  PZRefreshFooter.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/4.
//

#import "PZRefreshFooter.h"
#import "Masonry.h"
#import "UIScrollView+PullRefresh.h"

#define CIRCLE_WIDTH 30

NSString *const MJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const MJRefreshKeyPathContentInset = @"contentInset";
NSString *const MJRefreshKeyPathContentSize = @"contentSize";
NSString *const MJRefreshKeyPathPanState = @"state";

NSString *const PZRotateAnimKey = @"rotateKey";

@interface PZRefreshFooter ()
@property(nonatomic) UIImageView *refreshCircle;
@property(nonatomic,weak) id target;
@property(nonatomic) SEL action;
@property(nonatomic,weak) UIScrollView *scrollView;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@end

@implementation PZRefreshFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.refreshCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rotate"]];
        self.refreshCircle.contentMode = UIViewContentModeScaleAspectFit;
        _refreshCircle.frame = CGRectMake(0, 0, CIRCLE_WIDTH, CIRCLE_WIDTH);
        [self addSubview:self.refreshCircle];
        self.layer.cornerRadius = CIRCLE_WIDTH/2;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+(instancetype) pz_refreshFooterWithTarget:(id) target action:(SEL) action {
    PZRefreshFooter *footer = [[PZRefreshFooter alloc] init];
    
    footer.target = target;
    footer.action = action;
    return footer;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) { // 新的父控件
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        
        // 添加监听
        [self addObservers];
    }
}

//- (void)didMoveToSuperview {
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.offset(0);
//        make.centerY.offset(-CIRCLE_WIDTH/2 - 10);
//    }];
//
//}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(CIRCLE_WIDTH, CIRCLE_WIDTH);
}

#pragma mark - private
- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentSize];
    [self.pan removeObserver:self forKeyPath:MJRefreshKeyPathPanState];
    self.pan = nil;
}

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentOffset options:options context:nil];
//    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentSize options:options context:nil];
//    self.pan = self.scrollView.panGestureRecognizer;
//    [self.pan addObserver:self forKeyPath:MJRefreshKeyPathPanState options:options context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:MJRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    if (_scrollView.mj_contentH > _scrollView.frame.size.height) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
        if (_scrollView.mj_offsetY >= _scrollView.mj_contentH - _scrollView.frame.size.height) {
            // 防止手松开时连续调用
            CGPoint old = [change[@"old"] CGPointValue];
            CGPoint new = [change[@"new"] CGPointValue];
            if (new.y <= old.y) return;
            
//            if (_scrollView.isDragging) {
//                self.triggerByDrag = YES;
//            }
            
            [self beginRefreshing];
        }
    }
}

-(void) beginRefreshing {
    
    self.frame = CGRectMake((_scrollView.mj_contentW - CIRCLE_WIDTH)/2, _scrollView.mj_contentH - CIRCLE_WIDTH, CIRCLE_WIDTH, CIRCLE_WIDTH);
    [self setHidden:NO];
    [_scrollView bringSubviewToFront:self];
//    [_scrollView layoutIfNeeded];
    
    CABasicAnimation *rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.fromValue = @(0);
    rotateAnim.toValue = @(M_PI * 2);
    rotateAnim.duration = 2;
    rotateAnim.repeatCount = MAXFLOAT;
    
    [self.layer addAnimation:rotateAnim forKey:PZRotateAnimKey];
    
    [self executeRefreshingCallback];
}

- (void)executeRefreshingCallback {
    if (self.target && self.action) {
        [_target performSelector:_action];
    }
}

-(void) endRefreshing {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t) 1 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        [self.layer removeAnimationForKey:PZRotateAnimKey];
        [self.scrollView sendSubviewToBack:self];
        [self setHidden:YES];
    });
}

@end
