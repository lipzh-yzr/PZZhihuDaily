//
//  PZCommentViewController.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/31.
//

#import "PZCommentViewController.h"
#import "PZMacro.h"
#import "PZCommentTableViewCell.h"
#import "PZCommentTableHeaderView.h"

@interface PZCommentViewController () <UITableViewDelegate, UITableViewDataSource, PZCommentTableViewCellDelegate>
@property(nonatomic) NSString *newsId;
@property(nonatomic) UITableView *commentTabelView;
@property(nonatomic) NSArray<PZCommentModel *> *longCommentModels;
@property(nonatomic) NSArray<PZCommentModel *> *shortCommentModels;
@property(nonatomic) NSMutableArray<NSNumber *> *longShouldUnfoldArr;
@property(nonatomic) NSMutableArray<NSNumber *> *shortShouldUnfoldArr;
@end

@implementation PZCommentViewController

-(instancetype) initWithNewsId:(NSString *) newsId {
    self = [super init];
    if (self) {
        
        _newsId = newsId;
        _longCommentModels = @[];
        _shortCommentModels = @[];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    _commentTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    if (@available(iOS 15.0, *)) {
        _commentTabelView.sectionHeaderTopPadding = 0;
    }
    [_commentTabelView registerClass:PZCommentTableViewCell.class forCellReuseIdentifier:CELLKEY(PZCommentTableViewCell)];
    [_commentTabelView registerClass:PZCommentTableHeaderView.class forHeaderFooterViewReuseIdentifier:CELLKEY(PZCommentTableHeaderView)];
//    [_commentTabelView registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"CommentFooterView"];
    _commentTabelView.delegate = self;
    _commentTabelView.dataSource = self;
    _commentTabelView.allowsSelection = NO;
    [self.view addSubview:_commentTabelView];
    [_commentTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.leading.trailing.bottom.offset(0);
    }];
    
    [self getCommentModels];
    
    [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];

    UIImage *backImage = [UIImage imageNamed:@"back"];
    [UINavigationBar.appearance setBackIndicatorImage:backImage];
    [UINavigationBar.appearance setBackIndicatorTransitionMaskImage:backImage];
    
//    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] init];
//    backBarItem.image = [UIImage imageNamed:@"back"];
//    self.navigationItem.leftBarButtonItem = backBarItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - private
-(void) getCommentModels {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"oh no");
//        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//        [[PZHTTPManager defaultManager] getLongCommentsWithStory:self.newsId Success:^(NSArray<PZCommentModel *> * _Nonnull commentModels) {
//            self.longCommentModels = commentModels.copy;
//            self.longShouldUnfoldArr = [[NSMutableArray alloc] initWithCapacity:self.longCommentModels.count];
//            dispatch_semaphore_signal(sem);
//        } error:^(NSError * _Nonnull error) {
//            NSLog(@"%@", error);
//            dispatch_semaphore_signal(sem);
//        }];
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//    });
    dispatch_group_enter(group);
    [[PZHTTPManager defaultManager] getLongCommentsWithStory:self.newsId Success:^(NSArray<PZCommentModel *> * _Nonnull commentModels) {
        self.longCommentModels = commentModels.copy;
        NSUInteger modelCounts = self.longCommentModels.count;
        self.longShouldUnfoldArr = [[NSMutableArray alloc] initWithCapacity:modelCounts];
        for (int i = 0; i < modelCounts; ++i) {
            [self.longShouldUnfoldArr addObject:@(NO)];
        }
        dispatch_group_leave(group);
    } error:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        dispatch_group_leave(group);
    }];
    
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"oh no");
//        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//        [[PZHTTPManager defaultManager] getShortCommentsWithStory:self.newsId Success:^(NSArray<PZCommentModel *> * _Nonnull commentModels) {
//            self.shortCommentModels = commentModels.copy;
//            self.shortShouldUnfoldArr = [[NSMutableArray alloc] initWithCapacity:self.shortCommentModels.count];
//            dispatch_semaphore_signal(sem);
//        } error:^(NSError * _Nonnull error) {
//            NSLog(@"%@", error);
//            dispatch_semaphore_signal(sem);
//        }];
//        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//    });
    
    dispatch_group_enter(group);
    [[PZHTTPManager defaultManager] getShortCommentsWithStory:self.newsId Success:^(NSArray<PZCommentModel *> * _Nonnull commentModels) {
        self.shortCommentModels = commentModels.copy;
        NSUInteger modelCounts = self.shortCommentModels.count;
        self.shortShouldUnfoldArr = [[NSMutableArray alloc] initWithCapacity:modelCounts];
        for (int i = 0; i < modelCounts; ++i) {
            [self.shortShouldUnfoldArr addObject:@(NO)];
        }
        dispatch_group_leave(group);
    } error:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSInteger commentCount = self.longCommentModels.count + self.shortCommentModels.count;
            self.navigationItem.title = [NSString stringWithFormat:@"%li 条评论", commentCount];
            [self.commentTabelView reloadData];
        });
    });
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_longCommentModels.count && section == 0) {
        return _longCommentModels.count;
    } else {
        return _shortCommentModels.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
//
//    if (_longCommentModels.count && section == 0) {
//        if (_longShouldUnfoldArr[row]) {
//            if (_longCommentModels[row].unfoldHeight) {
//
//                return _longCommentModels[row].unfoldHeight;
//            }
//        } else {
//            if (_longCommentModels[row].foldHeight) {
//
//                return _longCommentModels[row].foldHeight;
//            }
//        }
//    } else {
//        if (_shortShouldUnfoldArr[row]) {
//            if (_shortCommentModels[row].unfoldHeight) {
//
//                return _shortCommentModels[row].unfoldHeight;
//            }
//        } else {
//            if (_shortCommentModels[row].foldHeight) {
//
//                return _shortCommentModels[row].foldHeight;
//            }
//        }
//    }
    return UITableViewAutomaticDimension;
}

//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
//    CGFloat height = cell.bounds.size.height;
//    if (_longCommentModels.count && section == 0) {
//        if (_longShouldUnfoldArr[row]) {
//            if (!_longCommentModels[row].unfoldHeight) {
//
//                _longCommentModels[row].unfoldHeight = height;
//            }
//        } else {
//            if (!_longCommentModels[row].foldHeight) {
//
//                _longCommentModels[row].foldHeight = height;
//            }
//        }
//    } else {
//        if ([(NSNumber *)_shortShouldUnfoldArr[row] boolValue]) {
//            if (!_shortCommentModels[row].unfoldHeight) {
//
//                _shortCommentModels[row].unfoldHeight = height;
//            }
//        } else {
//            if (!_shortCommentModels[row].foldHeight) {
//
//                _shortCommentModels[row].foldHeight = height;
//            }
//        }
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PZCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLKEY(PZCommentTableViewCell) forIndexPath:indexPath];
    cell.delegate = self;
    
    NSInteger row = indexPath.row;
    if (_longCommentModels.count && indexPath.section == 0) {
        [cell configWithCommentModel:_longCommentModels[row] should:_longShouldUnfoldArr[row].boolValue withCellWidth:SCREEN_WIDTH];
    } else {
        [cell configWithCommentModel:_shortCommentModels[row] should:_shortShouldUnfoldArr[row].boolValue withCellWidth:SCREEN_WIDTH];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel *numIndicatorLabel = [[UILabel alloc] init];
//    numIndicatorLabel.font = [UIFont systemFontOfSize:20];
//    numIndicatorLabel.textColor = [UIColor labelColor];
    
    PZCommentTableHeaderView *commentHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CELLKEY(PZCommentTableHeaderView)];
    if (_longCommentModels.count && section == 0) {
        [commentHeaderView configNum:_longCommentModels.count isLongComment:YES];
    } else {
        [commentHeaderView configNum:_shortCommentModels.count isLongComment:NO];
    }
    return commentHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.numberOfSections - 1) {
//        UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CommentFooterView"];
        
        UILabel *endLabel = [[UILabel alloc] init];
        endLabel.text = @"已显示全部评论";
        endLabel.font = [UIFont systemFontOfSize:20];
        endLabel.textColor = UIColor.lightGrayColor;
        endLabel.textAlignment = NSTextAlignmentCenter;
        endLabel.numberOfLines = 1;
        
//        [footerView addSubview:endLabel];
//        [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.top.offset(10);
//                    make.leading.offset(150);
//                    make.centerX.centerY.offset(0);
//        }];
        return endLabel;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.numberOfSections - 1? 30: 0.01;
}

-(NSInteger) numberOfSections {
    return _longCommentModels.count? 2: 1;
}

#pragma mark - cellDelegate
-(void) didClickLikeButton:(UIButton *) button {
    
}

-(void) didClickCommentButton:(UIButton *) button {
    
}

-(void) didClickUnfoldReplyLabelForCell:(PZCommentTableViewCell *) cell {
    NSIndexPath *indexPath = [self.commentTabelView indexPathForCell:cell];
    if (_longCommentModels.count && indexPath.section == 0) {
        BOOL isUnfolded = _longShouldUnfoldArr[indexPath.row].boolValue;
        BOOL newIsUnfolded = !isUnfolded;
//        BOOL newIsUnfolded = isUnfolded? NO: YES;
        _longShouldUnfoldArr[indexPath.row] = @(newIsUnfolded);
        [cell handleFoldLabelWith:newIsUnfolded];
    } else {
        BOOL isUnfolded = _shortShouldUnfoldArr[indexPath.row].boolValue;
        BOOL newIsUnfolded = !isUnfolded;
//        BOOL newIsUnfolded = isUnfolded? NO: YES;
        _shortShouldUnfoldArr[indexPath.row] = @(newIsUnfolded);
        [cell handleFoldLabelWith:newIsUnfolded];
    }
    [self.commentTabelView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
