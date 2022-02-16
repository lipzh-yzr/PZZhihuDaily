//
//  PZNewsViewController.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/29.
//

#import "PZNewsViewController.h"
#import <WebKit/WKWebView.h>
#import "PZCommentBarView.h"
#import "PZMacro.h"
#import "PZHTTPManager.h"
#import "PZCommentViewController.h"

#define COMMENTBAR_HEIGHT 48
@interface PZNewsViewController ()

@property(nonatomic) PZStoryModel *storyModel;
@property(nonatomic) WKWebView *webView;
@property(nonatomic) PZCommentBarView *commentBarView;
@property(nonatomic) PZExtraModel *extraModel;

@end

@implementation PZNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UISheetPresentationController *sheetPresentationController = self.sheetPresentationController;
//    [sheetPresentationController setDetents:[NSArray arrayWithObjects:UISheetPresentationControllerDetentIdentifierMedium, UISheetPresentationControllerDetentIdentifierLarge, nil]];
//    sheetPresentationController.prefersGrabberVisible = YES;
//    sheetPresentationController.largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(STATUS_BAR_HEIGHT);
            make.leading.trailing.offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(- COMMENTBAR_HEIGHT);
    }];
    
    NSString *newsUrl = [NSString stringWithFormat:@"https://daily.zhihu.com/story/%@",_storyModel.newsId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:newsUrl]];
    [_webView loadRequest:request];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void) createCommentBarView {
    _commentBarView = [[PZCommentBarView alloc] initWithExtraModel:_extraModel];
    [self.view addSubview:_commentBarView];
    [_commentBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom);
        make.height.mas_equalTo(COMMENTBAR_HEIGHT);
        make.leading.trailing.equalTo(self.webView);
    }];
    
    WEAKIFY(self);
    _commentBarView.backButtonBlock = ^{
        [WEAK_SELF.navigationController popViewControllerAnimated:YES];
        
    };
    
    _commentBarView.commentButtonBlock = ^{
        PZCommentViewController *commentController = [[PZCommentViewController alloc] initWithNewsId:WEAK_SELF.storyModel.newsId];
        
        [WEAK_SELF.navigationController.navigationBar.layer addAnimation:[WEAK_SELF pullAnimation] forKey:@"transition"];
        [WEAK_SELF.navigationController pushViewController:commentController animated:NO];
    };
    
    _commentBarView.likeButtonBlock = ^{
        
    };
    
    _commentBarView.starButtonBlock = ^{
        [PZFavoriteModel dealWithFav:WEAK_SELF.storyModel];
    };
}

-(instancetype) initWithStoryModel:(PZStoryModel *) storyModel {
    self = [super init];
    if (self) {
        _storyModel = storyModel;
        [[PZHTTPManager defaultManager] getExtraWithStory:_storyModel.newsId Success:^(PZExtraModel * _Nonnull extraModel) {
            extraModel.isStared = [PZFavoriteModel isInFavList:self.storyModel];
                    self.extraModel = extraModel;
            [self createCommentBarView];
                } error:^(NSError * _Nonnull error) {
                    
                }];
    }
    return self;
}

#pragma mark - private
-(CATransition *) pullAnimation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.type = @"cube";
    transition.subtype = kCATransitionFromLeft;
    return transition;
}

@end
