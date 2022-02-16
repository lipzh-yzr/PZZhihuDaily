//
//  PZMainPageViewController.m
//  PZZhihuDaily
//
//  Created by lipzh7 on 2022/1/26.
//

#import "PZMainPageViewController.h"
#import "PZMacro.h"
#import "CWCarouselHeader.h"
#import "PZMainPageHeaderView.h"
#import "PZStoryTableViewCell.h"
#import "PZStoryTableHeaderView.h"
#import "PZTopStoryCollectionViewCell.h"
#import "PZHTTPManager.h"
#import "PZScreen.h"
#import "PZPageControl.h"
#import "MJRefresh.h"
#import "PZNewsViewController.h"
#import "PZRefreshFooter.h"
#import "PZMineViewController.h"

@interface PZMainPageViewController ()<CWCarouselDelegate,CWCarouselDatasource,UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate>
@property(nonatomic) PZMainPageHeaderView *headerView;
@property(nonatomic) CWCarousel *carousel;
@property(nonatomic) UITableView *storyTableView;
@property(nonatomic) NSMutableArray<PZMainPageModel *> *pagesArr;
@end

static NSString *carouselKey = @"carouselHeaderView";


@implementation PZMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.pz_themeBlock = ^(UIView * _Nullable view, PZTheme * _Nullable theme) {
        view.backgroundColor = theme.pz_bgColor;
    };
    
    self.navigationController.delegate = self;
    
    _headerView = [[PZMainPageHeaderView alloc] init];
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(STATUS_BAR_HEIGHT);
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    WEAKIFY(self);
    _headerView.avatarBlock = ^{
        PZMineViewController *mineVC = [[PZMineViewController alloc] init];
        
        [WEAK_SELF.navigationController pushViewController:mineVC animated:YES];
    };
    
    PZMainPageModel *mainPageModel = [[PZMainPageModel alloc] init];
    mainPageModel.stories = [[PZDBManager sharedManager] loadNews];
    [self.pagesArr addObject:mainPageModel];
    NSMutableArray *placeholderTopStories = @[].mutableCopy;
    for (int i = 0; i < 5; i++) {
        PZStoryModel *topStoryModel = [[PZStoryModel alloc] init];
        [placeholderTopStories addObject:topStoryModel];
    }
    mainPageModel.top_stories = placeholderTopStories.copy;
    
    _storyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_storyTableView];
    _storyTableView.delegate = self;
    _storyTableView.dataSource = self;
    [_storyTableView registerClass:[PZStoryTableViewCell class] forCellReuseIdentifier:CELLKEY(PZStoryTableViewCell)];
    [_storyTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:carouselKey];
    [_storyTableView registerClass:[PZStoryTableHeaderView class] forHeaderFooterViewReuseIdentifier:CELLKEY(PZStoryTableHeaderView)];
    [_storyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.leading.trailing.bottom.offset(0);
    }];
    _storyTableView.estimatedRowHeight = 80;
    if (@available(iOS 15.0, *)) {
        _storyTableView.sectionHeaderTopPadding = 0;
    }
//    _storyTableView.contentInset = UIEdgeInsetsMake(SCREEN_WIDTH, 0, 0, 0);
    
//    _storyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getBeforeNews)];
    
    _storyTableView.pz_refreshFooter = [PZRefreshFooter pz_refreshFooterWithTarget:self action:@selector(getBeforeNews)];
    
    _storyTableView.pz_refreshControl = [PZRefreshHeaderControl refreshControlWithTarget:self action:@selector(handleRefreshSuccess)];
    _storyTableView.alwaysBounceVertical = NO;
    _storyTableView.bounces = NO;
    
    [self getLatestNews];
}

#pragma mark - private
-(void) handleRefreshSuccess {
    [_storyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - network

-(void) getLatestNews {
    [[PZHTTPManager defaultManager] getLatestStoriesWithSuccess:^(PZMainPageModel * _Nonnull mainPageModel) {
        if (self.pagesArr.count) {
            [self.pagesArr removeObjectAtIndex:0];
        }
//            [self.pagesArr addObject:mainPageModel];
        [self.pagesArr insertObject:mainPageModel atIndex:0];
        [self.storyTableView reloadData];
        
        [self.headerView configWithDate:[self getNextDate:NO]];
        
        [[PZDBManager sharedManager] updateNewsWith:mainPageModel.stories];
        
        } error:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}

-(void) getBeforeNews {
    [[PZHTTPManager defaultManager] getBeforeStoriesWithDate:[self getNextDate:NO] Success:^(PZMainPageModel * _Nonnull mainPageModel) {
            [self.pagesArr addObject:mainPageModel];
        [self.storyTableView reloadData];
        [self.storyTableView.pz_refreshFooter endRefreshing];
        } error:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}

- (NSMutableArray<PZMainPageModel *> *)pagesArr {
    if (!_pagesArr) {
        _pagesArr = @[].mutableCopy;
    }
    return _pagesArr;
}

- (CWCarousel *)carousel {
    if (!_carousel) {
        _carousel = [[CWCarousel alloc] initWithFrame:CGRectZero delegate:self datasource:self flowLayout:[[CWFlowLayout alloc] initWithStyle:CWCarouselStyle_Normal]];
        [_carousel registerViewClass:[PZTopStoryCollectionViewCell class] identifier:CELLKEY(PZTopStoryCollectionViewCell)];
        _carousel.isAuto = YES;
        _carousel.autoTimInterval = 2;
        
        PZPageControl *pageControl = [[PZPageControl alloc] init];
        pageControl.currentDotColor = [UIColor whiteColor];
        pageControl.otherDotColor = [UIColor grayColor];
        pageControl.currentDotWidth = 25;
        pageControl.otherDotWidth = 10;
        pageControl.dotHeight = 10;
        pageControl.cornerRadius = 5;
        pageControl.spacing = 10;
        
        _carousel.customPageControl = pageControl;
    }
    return _carousel;
}

- (NSString *) getNextDate:(BOOL) forDisplay {
    NSDate *nextDate = [_pagesArr.lastObject.formattedDate dateByAddingTimeInterval: -24 * 60 * 60];
//    NSDate *nextDate = _pagesArr.lastObject.formattedDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [formatter setDateFormat: forDisplay? @"MM 月 dd 日" :@"yyyyMMdd"];
    return [formatter stringFromDate:nextDate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - carousel
- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index {
    PZNewsViewController *newsController = [[PZNewsViewController alloc] initWithStoryModel:_pagesArr[0].top_stories[index]];
    [self.navigationController pushViewController:newsController animated:YES];
}

- (void)CWCarousel:(CWCarousel *)carousel addPageControl:(UIView *)pageControl isDefault:(BOOL)isDefault {
    if (isDefault) {
        return;
    } else {
        [carousel addSubview:pageControl];

        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.bottom.offset(-10);
            make.height.mas_equalTo(30);
            make.width.mas_lessThanOrEqualTo(200);
        }];
//        [pageControl invalidateIntrinsicContentSize];
    }
}

- (NSInteger)numbersForCarousel {
    return _pagesArr[0].top_stories.count;
}

- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index {
    PZTopStoryCollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:CELLKEY(PZTopStoryCollectionViewCell) forIndexPath:indexPath];
    [cell configWithStoryModel:_pagesArr[0].top_stories[index]];
    return cell;
}

#pragma mark - tableView cell

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _pagesArr.count? _pagesArr.count: 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pagesArr[section].stories.count? _pagesArr[section].stories.count: 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (_pagesArr[section].stories[row].height) {
        return _pagesArr[section].stories[row].height;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PZStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLKEY(PZStoryTableViewCell) forIndexPath:indexPath];
    PZStoryModel *storyModel = _pagesArr[indexPath.section].stories[indexPath.row];
    [cell configWithStoryModel:storyModel];
    if (!tableView.isDragging && !tableView.isDecelerating) {
        [cell setImageWithUrl:storyModel.image];
    } else {
        cell.coverView.image = [UIImage imageNamed:@"placeholder"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (!_pagesArr[section].stories[row].height) {
        _pagesArr[section].stories[row].height = cell.bounds.size.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PZNewsViewController *newsController = [[PZNewsViewController alloc] initWithStoryModel:_pagesArr[indexPath.section].stories[indexPath.row]];
    [self.navigationController pushViewController:newsController animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImages];
    } else {
        
    }
}

-(void) loadImages {
   NSArray *cells = [_storyTableView visibleCells];
    for (PZStoryTableViewCell *cell in cells) {
        NSIndexPath *indexPath = [_storyTableView indexPathForCell:cell];
        PZStoryModel *storyModel = _pagesArr[indexPath.section].stories[indexPath.row];
        [cell setImageWithUrl:storyModel.image];
    }
}


#pragma mark - tableView Header

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UITableViewHeaderFooterView *carouselHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:carouselKey];
        if (!self.carousel.superview) {
            [carouselHeader addSubview:self.carousel];
            [_carousel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.offset(0);
            }];
        } else {
            
            [self.carousel freshCarousel];
        }
        return carouselHeader;
    } else {
        PZStoryTableHeaderView *tableSectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CELLKEY(PZStoryTableHeaderView)];
        [tableSectionView configWithDate:[self getNextDate:YES]];
        return tableSectionView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SCREEN_WIDTH;
    } else {
        
        return 30;
    }
}

#pragma mark - navController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isSelf = [viewController isKindOfClass:self.class];
    BOOL isNews = [viewController isKindOfClass:PZNewsViewController.class];
    
    [navigationController setNavigationBarHidden:isSelf || isNews animated:animated];
}

@end
