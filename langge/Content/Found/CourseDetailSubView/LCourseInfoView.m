//
//  LCourseInfoView.m
//  langge
//
//  Created by samlee on 2019/7/23.
//  Copyright © 2019 yang. All rights reserved.
//

#import "LCourseInfoView.h"

@interface LCourseInfoView ()<UIWebViewDelegate>
@property (nonatomic, strong) void(^listScrollViewScrollCallback)(UIScrollView *scrollView);
@end

@implementation LCourseInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    !self.listScrollViewScrollCallback ? : self.listScrollViewScrollCallback(scrollView);
}

- (UIScrollView *)listScrollView {
    return self.scrollView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.listScrollViewScrollCallback = callback;
}

-(void)setCourseDetail:(LCourseDetailModel *)courseDetail{
    _courseDetail = courseDetail;
    [self loadHTMLString:courseDetail.course_info.content baseURL:nil];

}

@end
