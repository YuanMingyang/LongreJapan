//
//  LCourseListView.m
//  langge
//
//  Created by samlee on 2019/7/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseListView.h"
#import "LCourseListCell.h"
#import <MJRefresh.h>

@interface LCourseListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);
@property(nonatomic,assign)int page;
@end

@implementation LCourseListView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self registerNib:[UINib nibWithNibName:@"LCourseListCell" bundle:nil] forCellReuseIdentifier:@"LCourseListCell"];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.page = 1;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return self;
}
-(void)loadNewData{
    self.page = 1;
    [self loadData];
}
-(void)loadMoreData{
    self.page++;
    [self loadData];
}
-(void)loadData{
    [[APIManager getInstance] getCourseInfoWithcourseId:self.course_id class_hour_page:[NSString stringWithFormat:@"%d",self.page] comment_page:nil callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            LCourseDetailModel *detail = (LCourseDetailModel *)result;
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            if (self.page == 1) {
                [self.courseDetail.course_class_hour_list removeAllObjects];
            }else{
                if (detail.course_class_hour_list.count<10) {
                    [self.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            [self.courseDetail.course_class_hour_list addObjectsFromArray:detail.course_class_hour_list];
            if (self.page == 1) {
                LCourseClassHourModel *classHour = self.courseDetail.course_class_hour_list.firstObject;
                classHour.is_select = @"1";
                
                self.selectClassHour(classHour);
            }
            [self reloadData];
        }else{
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:result];
        }
    }];
}


-(void)setCourseDetail:(LCourseDetailModel *)courseDetail{
    _courseDetail = courseDetail;
    
    [self reloadData];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseDetail.course_class_hour_list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCourseListCell"];
    cell.classHour = self.courseDetail.course_class_hour_list[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LCourseClassHourModel *currentClassHour = self.courseDetail.course_class_hour_list[indexPath.row];
    if ([currentClassHour.is_select isEqualToString:@"1"]) {
        return;
    }    
    if ([currentClassHour.is_preview isEqualToString:@"0"]) {
        //跳转到咨询页面
        self.selectClassHour(currentClassHour);
        return;
    }
    
    
    for (LCourseClassHourModel *classHour in self.courseDetail.course_class_hour_list) {
        classHour.is_select = @"0";
    }
    
    currentClassHour.is_select = @"1";
    //切换视频
    [self reloadData];
    self.selectClassHour(currentClassHour);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.listScrollViewScrollCallback ? : self.listScrollViewScrollCallback(scrollView);
}
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.listScrollViewScrollCallback = callback;
}
- (UIScrollView *)listScrollView {
    return self;
}
@end
