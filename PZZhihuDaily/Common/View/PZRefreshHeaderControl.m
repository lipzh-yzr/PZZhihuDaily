//
//  PZRefreshControl.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/2/4.
//

#import "PZRefreshHeaderControl.h"

@interface PZRefreshHeaderControl ()
@property(nonatomic) UIImageView *refreshCircle;
@property(nonatomic,weak) id target;
@property(nonatomic) SEL action;
@end

#define CIRCLE_WIDTH 30

@implementation PZRefreshHeaderControl

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
+(instancetype) refreshControlWithTarget:(id) target action:(SEL) sel {
    PZRefreshHeaderControl *refreshControl = [[PZRefreshHeaderControl alloc] init];
    
    refreshControl.target = target;
    refreshControl.action = sel;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:PZREFRESH_ROTATE_SUCCESS object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [target performSelector:sel];
    }];
    return refreshControl;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(CIRCLE_WIDTH, CIRCLE_WIDTH);
}

@end
