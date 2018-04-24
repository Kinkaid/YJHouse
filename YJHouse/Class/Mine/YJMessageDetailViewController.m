//
//  YJMessageDetailViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/5/22.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJMessageDetailViewController.h"
#import "YJMessageDetailViewCell.h"
#import "YJMsgModel.h"
#import "YJHouseCommentViewController.h"
#define kCellIdentifier @"YJMessageDetailViewCell"
@interface YJMessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource,YJRequestTimeoutDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *msgAry;
@end

@implementation YJMessageDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"消息列表"];
    [YJRequestTimeoutUtil shareInstance].delegate = self;
    [YJGIFAnimationView showInView:self.view frame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self registerTableView];
    [self registerRefresh];
    [self loadMsgData];
}

- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    self.page = 0;
    self.msgAry = [@[] mutableCopy];
}

- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        [weakSelf loadMsgData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf loadMsgData];
    }];
}
- (void)requestTimeoutAction {
    if (self.isVisible) {
        [self loadMsgData];
    }
}
-(NSDictionary *)parseJSONStringToNSDictionary:(id)JSONString {
    if ([JSONString isKindOfClass:[NSDictionary class]]) {
        return JSONString;
    } else {
        NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        return responseJSON;
    }
}

- (void)loadMsgData {
    __weak typeof(self)weakSelf = self;
    NSDictionary *params = @{@"page":@(self.page),@"type":self.type,@"auth_key":[LJKHelper getAuth_key]};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/get-message-list",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject)) {
            if (weakSelf.page == 0) {
                [YJGIFAnimationView hideInView:self.view];
                [weakSelf.msgAry removeAllObjects];
                [weakSelf.tableView.mj_header endRefreshing];
                NSArray *ary = responseObject[@"result"];
//                if (![ary count]) {
//                    self.noSearchResultView.hidden = NO;
//                }
                if ([self.type intValue] == 1) {
                    if (!ISEMPTY(responseObject[@"result"])) {
                        [LJKHelper saveLastRequestMsgTime:responseObject[@"result"][0][@"time"]];
                    } else {
                        [LJKHelper saveLastRequestMsgTime:[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]]];
                    }
                }
            }
            NSArray *ary =responseObject[@"result"];
            for (int i=0; i<[ary count]; i++) {
                YJMsgModel *model = [[YJMsgModel alloc] init];
                if ([self.type intValue] == 8) {
                    NSDictionary *contentDic = [self parseJSONStringToNSDictionary:ary[i][@"content"]];
                    model.content = [NSString stringWithFormat:@"原评论:%@\n\n    %@回复你:%@",contentDic[@"orign_comment"],contentDic[@"from_user"],contentDic[@"reply_comment"]];
                    model.site = ary[i][@"site"];
                    model.tid = ary[i][@"tid"];
                    model.isZufang = ary[i][@"class"];
                    model.total_score = ary[i][@"total_score"];
                    model.tags = ary[i][@"tags"];
                } else if ([self.type intValue] == 5 ||[self.type intValue] == 4) {
                    model.content = [NSString stringWithFormat:@"%@",ary[i][@"reply"]];
                } else {
                    model.content = [NSString stringWithFormat:@"%@",ary[i][@"content"]];
                }
                model.type = self.type;
                model.time =ary[i][@"time"];
                [weakSelf.msgAry addObject:model];
            }
            if (ary.count<20) {
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.tableView reloadData];
        }
    } error:^(NSError *error) {
        [YJGIFAnimationView hideInView:self.view];
        [YJApplicationUtil alertHud:@"请求发生错误" afterDelay:1];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJMsgModel *model = self.msgAry[indexPath.section];
    return 38 + [LJKHelper textHeightFromTextString:model.content width:APP_SCREEN_WIDTH - 20 fontSize:13] + 16;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.msgAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJMessageDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[YJMessageDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showDataWithModel:self.msgAry[indexPath.section]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.type intValue] == 8) {
        YJMsgModel *model = self.msgAry[indexPath.section];
        YJHouseCommentViewController *vc = [[YJHouseCommentViewController alloc] init];
        vc.house_id = model.tid;
        vc.site_id = model.site;
        vc.tags = model.tags;
        vc.total_score = model.total_score;
        vc.isZufang = model.isZufang;
        PushController(vc);
    }
}
@end
