//
//  LCourseCommentView.m
//  langge
//
//  Created by samlee on 2019/7/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseCommentView.h"
#import "LCourseCommontCell.h"
@interface  LCourseCommentView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);

@property(nonatomic,assign)int page;
@end

@implementation LCourseCommentView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerNib:[UINib nibWithNibName:@"LCourseCommontCell" bundle:nil] forCellReuseIdentifier:@"LCourseCommontCell"];
        self.estimatedRowHeight = 90;
        self.rowHeight = UITableViewAutomaticDimension;
        self.page = 1;
        self.backgroundColor = [UIColor whiteColor];
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
    [[APIManager getInstance] getCourseInfoWithcourseId:self.course_id class_hour_page:nil comment_page:[NSString stringWithFormat:@"%d",self.page] callback:^(BOOL success, id  _Nonnull result) {
        if (success) {
            LCourseDetailModel *detail = (LCourseDetailModel *)result;
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            if (self.page == 1) {
                [self.courseDetail.course_comment_list removeAllObjects];
            }else{
                if (detail.course_comment_list.count<10) {
                    [self.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            [self.courseDetail.course_comment_list addObjectsFromArray:detail.course_comment_list];
            
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
    return self.courseDetail.course_comment_list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCourseCommontCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCourseCommontCell"];
    cell.courseComment = self.courseDetail.course_comment_list[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"commonts"]];
    [view addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(10);
        make.top.equalTo(view).offset(15);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"已购课学员评论";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = RGB(51, 51, 51);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(45);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
        make.right.equalTo(view);
    }];
    return view;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    !self.listScrollViewScrollCallback ? : self.listScrollViewScrollCallback(scrollView);
}

- (UIScrollView *)listScrollView {
    return self;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.listScrollViewScrollCallback = callback;
}



@end
