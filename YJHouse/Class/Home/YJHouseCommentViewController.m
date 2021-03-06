//
//  YJHouseCommentViewController.m
//  YJHouse
//
//  Created by 刘金凯 on 2017/8/14.
//  Copyright © 2017年 刘金凯. All rights reserved.
//

#import "YJHouseCommentViewController.h"
#import "IQKeyboardManager.h"
#import "YJHouseCommentCell.h"
#import "InputView.h"
#import "YJHouseCommentModel.h"
#import "YJHouseCommentSectionHeaderView.h"
#import "KLCPopup.h"
#import "YJCommentReportViewController.h"
#import "YJHouseDetailViewController.h"
#import "WDLoginViewController.h"
#import "YJLoginTipsView.h"
static NSString * const kCellId = @"YJHouseCommentCell";
static NSString * const kYJHeaderId = @"header";
@interface YJHouseCommentViewController ()<UITableViewDelegate,UITableViewDataSource,InputViewDelegate,YJSectionHeaderActionDelegate,YJLoginTipsViewShowDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *commentAry;
@property (nonatomic, strong) InputView *inputView;
@property (nonatomic, strong) YJHouseCommentModel *selectModel;
@property (nonatomic,strong) KLCPopup *popupManager;
//键盘高度
@property (nonatomic, assign) CGFloat keyboardHeight;
//蒙罩
@property (nonatomic, strong) UIView *layView;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,assign) NSInteger selectSelection;
@property (nonatomic,assign) NSInteger selectRow;

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *dislikeBtn;
@property (nonatomic,strong) YJLoginTipsView *loginTipsView;

@end

@implementation YJHouseCommentViewController

- (YJLoginTipsView *)loginTipsView {
    if (!_loginTipsView) {
        _loginTipsView = [[YJLoginTipsView alloc] init];
        _loginTipsView.delegate = self;
    }
    return _loginTipsView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"所有评论"];
    [self setRightBarButtonItem];
    [self loadCommentList];
    [self registerTableView];
    [self registerRefresh];
    [self configInputView];
}
- (void)setRightBarButtonItem {
    if (!ISEMPTY(self.total_score)) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setNavigationBarItem:button];
        [button addTarget:self action:@selector(enterHouseDetail) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"房源详情" forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(78);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self.navigationBar).with.offset(10);
            make.trailing.equalTo(self.navigationBar).with.offset(-10);
        }];
    }
}
- (void)enterHouseDetail {
    YJHouseDetailViewController *vc = [[YJHouseDetailViewController alloc] init];
    vc.site_id = self.site_id;
    vc.house_id = self.house_id;
    if ([self.isZufang intValue] ==2) {
        vc.type = type_zufang;
    } else {
        vc.type = type_maifang;
    }
    PushController(vc);
}
- (void)configInputView {
    self.inputView = [[InputView alloc]initWithFrame:CGRectMake(0, APP_SCREEN_HEIGHT-55, APP_SCREEN_WIDTH, 55)];
    self.inputView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1];
    self.inputView.delegate = self;
    [self.view addSubview:self.inputView];
    //添加屏幕的蒙罩
    self.layView = [[UIView alloc]initWithFrame:self.view.frame];
    self.layView.backgroundColor = [UIColor blackColor];
    self.layView.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLayView)];
    [self.layView addGestureRecognizer:tap];
    [self.view insertSubview:self.layView belowSubview:self.inputView];
}
- (void)registerRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.curPage = 0;
        [weakSelf loadCommentList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.curPage ++;
        [weakSelf loadCommentList];
    }];
}
- (void)tapLayView{
    [self.inputView.inputTextView resignFirstResponder];
    self.layView.hidden = YES;
    self.inputView.frame = CGRectMake(0, APP_SCREEN_HEIGHT-55, APP_SCREEN_WIDTH, 55);
}
//输入框的高度发生变化
- (void)textViewHeightDidChange:(CGFloat)height{
    self.inputView.height = height + 20;
    self.inputView.bottom = APP_SCREEN_HEIGHT - self.keyboardHeight;
}
//键盘将要隐藏的时候
- (void)keyboardWillHide:(InputView *)inputView keyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve{
    self.layView.hidden = YES;
    if (self.inputView.inputTextView.text.length>0) {
        self.inputView.label.hidden = YES;
    } else {
        self.inputView.label.hidden = NO;
    }
    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        CGRect rect = self.inputView.frame;
        self.inputView.frame = CGRectMake(0, APP_SCREEN_HEIGHT-rect.size.height, APP_SCREEN_WIDTH, rect.size.height);
    } completion:^(BOOL finished) {
    }];
}
- (void)keyboardWillShow:(InputView *)inputView keyboardHeight:(CGFloat)keyboardHeight animationDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve {
    //获取键盘的高度
    self.keyboardHeight = keyboardHeight;
    self.layView.alpha = 0.6;
    self.layView.hidden = NO;
    //动画弹出键盘和输入框
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        //输入框紧贴键盘
        self.inputView.bottom = APP_SCREEN_HEIGHT - keyboardHeight;
    } completion:^(BOOL finished) {
    }];
}
//点击屏幕，键盘消失
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.inputView.inputTextView resignFirstResponder];
//    self.layView.hidden = YES;
//    self.inputView.frame = CGRectMake(0, APP_SCREEN_HEIGHT-55, APP_SCREEN_WIDTH, 55);
//}
- (void)publishButtonDidClick {
    if (self.inputView.inputTextView.text.length) {
        if ([LJKHelper thirdLoginSuccess]) {
            if ([self.inputView.label.text containsString:@"添加一条评论~"]) {
                [self commentForHouse:self.inputView.inputTextView.text];
            } else {
                [self replayToSB:self.inputView.inputTextView.text];
            }
        } else {
            [self.inputView.inputTextView resignFirstResponder];
            self.popupManager = [KLCPopup popupWithContentView:self.loginTipsView];
            self.popupManager.shouldDismissOnBackgroundTouch = NO;
            [self.popupManager show];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
- (void)registerTableView {
    [self.tableView registerNib:[UINib nibWithNibName:kCellId bundle:nil] forCellReuseIdentifier:kCellId];
    [self.tableView registerClass:[YJHouseCommentSectionHeaderView class] forHeaderFooterViewReuseIdentifier:kYJHeaderId];
    self.commentAry = [@[] mutableCopy];
    self.curPage = 0;
}
- (void)loadCommentList {
    [SVProgressHUD show];
    NSDictionary *params = @{@"site":self.site_id,@"tid":self.house_id,@"page":@(self.curPage),@"limit":@"20",@"auth_key":[LJKHelper getAuth_key]};
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/get-comment",Server_url] parameters:params method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject)) {
            if (self.curPage == 0) {
                [self.tableView.mj_header endRefreshing];
                [self.commentAry removeAllObjects];
            }
            for (int i=0; i<[responseObject count]; i++) {
                NSMutableArray *mAry = [@[] mutableCopy];
                for (int j=0; j<[responseObject[i] count]; j++) {
                    YJHouseCommentModel *model = [MTLJSONAdapter modelOfClass:[YJHouseCommentModel class] fromJSONDictionary:responseObject[i][j] error:nil];
                    if (j!=0) {
                        if (!ISEMPTY(model.to)) {
                            NSString *user = [[model.to componentsSeparatedByString:@"回复"] lastObject];
                            if ([user isEqualToString:model.username]||[user isEqualToString:responseObject[i][0][@"username"]]) {
                                model.comment = [NSString stringWithFormat:@"%@:%@",model.username,model.comment];
                            } else {
                                NSMutableString *str = [NSMutableString stringWithFormat:@"%@:%@",model.to,model.comment];
                                model.comment = str;
                            }
                        }
                        model.height = [LJKHelper textHeightFromTextString:model.comment width:APP_SCREEN_WIDTH - 105.0 fontSize:12];
                    } else {
                        model.height = [LJKHelper textHeightFromTextString:model.comment width:APP_SCREEN_WIDTH - 95.0 fontSize:15];
                        model.avatar =[NSString stringWithFormat:@"https://www.youjar.top%@",responseObject[i][0][@"avatar"]];
                    }
                    [mAry addObject:model];
                }
                [self.commentAry addObject:mAry];
            }
            if ([responseObject count] <20) {
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
        } else {
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            [SVProgressHUD dismiss];
        }
    } error:^(NSError *error) {
        [YJApplicationUtil alertHud:@"评论列表错误" afterDelay:1];
        [SVProgressHUD dismiss];
    }];
}
- (void)commentForHouse:(NSString *)content {
    [SVProgressHUD show];
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/comment",Server_url] parameters:@{@"site":self.site_id,@"tid":self.house_id,@"comment":content,@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"result"])) {
            [self.inputView.inputView resignFirstResponder];
            self.inputView.inputTextView.text = @"";
            self.inputView.label.alpha = 1;
            self.inputView.label.text = @"   添加一条评论~";
            [SVProgressHUD dismiss];
            [self.inputView.inputTextView resignFirstResponder];
            self.layView.hidden = YES;
            self.inputView.frame = CGRectMake(0, APP_SCREEN_HEIGHT-55, APP_SCREEN_WIDTH, 55);
            NSMutableArray *ary = [@[] mutableCopy];
            YJHouseCommentModel *model = [[YJHouseCommentModel alloc] init];
            [ary addObject:model];
            model.comment = content;
            model.good = 0;
            model.bad = 0;
            model.avatar = [LJKHelper getUserHeaderUrl];
            model.time = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
            model.height = [LJKHelper textHeightFromTextString:content width:APP_SCREEN_WIDTH - 95 fontSize:15];
            model.username = [LJKHelper getUserName];
            [self.commentAry insertObject:ary atIndex:0];
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        [self.inputView.inputView resignFirstResponder];
        self.inputView.inputTextView.text = @"";
        self.inputView.label.alpha = 1;
        self.inputView.label.text = @"   添加一条评论~";
        [SVProgressHUD dismiss];
        [self.inputView.inputTextView resignFirstResponder];
        self.layView.hidden = YES;
        self.inputView.frame = CGRectMake(0, APP_SCREEN_HEIGHT-55, APP_SCREEN_WIDTH, 55);
        NSMutableArray *ary = [@[] mutableCopy];
        YJHouseCommentModel *model = [[YJHouseCommentModel alloc] init];
        [ary addObject:model];
        model.comment = content;
        model.good = 0;
        model.bad = 0;
        model.avatar = [LJKHelper getUserHeaderUrl];
        model.time = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
        model.height = [LJKHelper textHeightFromTextString:content width:APP_SCREEN_WIDTH - 95 fontSize:15];
        model.username = [LJKHelper getUserName];
        [self.commentAry insertObject:ary atIndex:0];
        [self.tableView reloadData];
    }];
}
- (void)replayToSB:(NSString *)content {
    [SVProgressHUD show];
    [[NetworkTool sharedTool] requestWithURLString:[NSString stringWithFormat:@"%@/user/comment",Server_url] parameters:@{@"site":self.site_id,@"tid":self.house_id,@"to_user_id":self.selectModel.user_id,@"to_comment_id":self.selectModel.commentID,@"comment":content,@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"result"])) {
            [SVProgressHUD dismiss];
            [self.inputView.inputView resignFirstResponder];
            self.inputView.inputTextView.text = @"";
            self.inputView.label.alpha = 1;
            self.inputView.label.text = @"   添加一条评论~";
            [SVProgressHUD dismiss];
            [self.inputView.inputTextView resignFirstResponder];
            self.layView.hidden = YES;
            self.inputView.frame = CGRectMake(0, APP_SCREEN_HEIGHT-55, APP_SCREEN_WIDTH, 55);
            YJHouseCommentModel *model = [[YJHouseCommentModel alloc] init];
            YJHouseCommentModel *sectionModel = self.commentAry[self.selectSelection][0];
            if ([self.selectModel.username isEqualToString:sectionModel.username]) {
                model.comment = [NSString stringWithFormat:@"%@:%@",[LJKHelper getUserName],content];
            } else {
                model.comment = [NSString stringWithFormat:@"%@回复%@:%@",[LJKHelper getUserName],self.selectModel.username,content];
            }
            model.height = [LJKHelper textHeightFromTextString:model.comment width:APP_SCREEN_WIDTH - 105 fontSize:12];
            [self.commentAry[self.selectSelection] addObject:model];
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        [self.inputView.inputView resignFirstResponder];
        self.inputView.inputTextView.text = @"";
        self.inputView.label.alpha = 1;
        self.inputView.label.text = @"   添加一条评论~";
        [SVProgressHUD dismiss];
        [self.inputView.inputTextView resignFirstResponder];
        self.layView.hidden = YES;
        self.inputView.frame = CGRectMake(0, APP_SCREEN_HEIGHT-55, APP_SCREEN_WIDTH, 55);
        YJHouseCommentModel *model = [[YJHouseCommentModel alloc] init];
        YJHouseCommentModel *sectionModel = self.commentAry[self.selectSelection][0];
        if ([self.selectModel.username isEqualToString:sectionModel.username]) {
            model.comment = [NSString stringWithFormat:@"%@:%@",[LJKHelper getUserName],content];
        } else {
            model.comment = [NSString stringWithFormat:@"%@回复%@:%@",[LJKHelper getUserName],self.selectModel.username,content];
        }
        model.height = [LJKHelper textHeightFromTextString:model.comment width:APP_SCREEN_WIDTH - 105 fontSize:12];
        [self.commentAry[self.selectSelection] addObject:model];
        [self.tableView reloadData];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commentAry.count ? self.commentAry.count : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentAry.count ? [self.commentAry[section] count] - 1 : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.commentAry.count) {
        return APP_SCREEN_HEIGHT - 120;
    } else {
        YJHouseCommentModel *model = self.commentAry[indexPath.section][indexPath.row+1];
        return model.height+8;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.commentAry.count) {
        return;
    }
    if ([LJKHelper thirdLoginSuccess]) {
        self.selectModel = self.commentAry[indexPath.section][indexPath.row+1];
        if (!ISEMPTY(self.selectModel.commentID)) {
            self.selectSelection = indexPath.section;
            self.popupManager = [KLCPopup popupWithContentView:self.menuView];
            YJHouseCommentModel *secModel = self.commentAry[indexPath.section][0];
            [self.likeBtn setTitle:[NSString stringWithFormat:@"顶 (%@)",secModel.good] forState:UIControlStateNormal];
            [self.dislikeBtn setTitle:[NSString stringWithFormat:@"踩 (%@)",secModel.bad] forState:UIControlStateNormal];
            [self.popupManager show];
        }
    } else {
        [self.inputView.inputTextView resignFirstResponder];
        self.popupManager = [KLCPopup popupWithContentView:self.loginTipsView];
        self.popupManager.shouldDismissOnBackgroundTouch = NO;
        [self.popupManager show];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.commentAry.count) {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH / 3.0, (APP_SCREEN_HEIGHT - 160 - (APP_SCREEN_WIDTH / 3.0)) / 2.0 , APP_SCREEN_WIDTH / 3.0, APP_SCREEN_WIDTH / 3.0)];
        img.image = [UIImage imageNamed:@"icon_comment_placeholder"];
        [cell addSubview:img];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (APP_SCREEN_HEIGHT - 160 - (APP_SCREEN_WIDTH / 3.0)) / 2.0 + (APP_SCREEN_WIDTH / 3.0), APP_SCREEN_WIDTH, 50)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"还没有评论\n快来抢沙发吧";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor ex_colorFromHexRGB:@"8A8A8A"];
        [cell addSubview:label];
        return cell;
    } else {
        YJHouseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[YJHouseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YJHouseCommentModel *model = self.commentAry[indexPath.section][indexPath.row+1];
        [cell showDataWithModel:model];
        return cell;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.commentAry.count) {
        return nil;
    } else {
        YJHouseCommentSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYJHeaderId];
        header.delegate = self;
        [header showDataWithModel:self.commentAry[section][0]];
        header.section = section;
        return header;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    static NSString * identy = @"headFoot";
    UITableViewHeaderFooterView * hf = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    hf.contentView.backgroundColor = [UIColor clearColor];
    if (!hf) {
        hf = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identy];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(13, 23, self.view.frame.size.width - 26, 1)];
        view.backgroundColor = [UIColor ex_colorFromHexRGB:@"D7D7D7"];
        [hf addSubview:view];
    }
    return self.commentAry.count ? hf :nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!self.commentAry.count) {
        return 0.01;
    } else {
        YJHouseCommentModel *model = self.commentAry[section][0];
        return model.height + 80 +20;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.commentAry.count ? 24.0 :0.01;
}
- (void)sectionHeaderAction:(NSInteger)section {
    if ([LJKHelper thirdLoginSuccess]) {
        self.selectSelection = section;
        self.selectModel = self.commentAry[section][0];
        if (ISEMPTY(self.selectModel.commentID)) {
            return;
        }
        self.popupManager = [KLCPopup popupWithContentView:self.menuView];
        [self.likeBtn setTitle:[NSString stringWithFormat:@"顶 (%@)",self.selectModel.good] forState:UIControlStateNormal];
        [self.dislikeBtn setTitle:[NSString stringWithFormat:@"踩 (%@)",self.selectModel.bad] forState:UIControlStateNormal];
        [self.popupManager show];
    } else {
        [self.inputView.inputTextView resignFirstResponder];
        self.popupManager = [KLCPopup popupWithContentView:self.loginTipsView];
        self.popupManager.shouldDismissOnBackgroundTouch = NO;
        [self.popupManager show];
    }
}
#pragma mark - YJLoginTipsViewDelegate
- (void)cancelLoginTipsAction {
    [self.popupManager dismiss:YES];
}
- (void)gotoLoginAction {
    [self.popupManager dismiss:NO];
    WDLoginViewController *vc = [[WDLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)commentLikeAction:(UIButton *)sender section:(NSInteger)section{
    self.selectModel = self.commentAry[section][0];
    if (ISEMPTY(self.selectModel.commentID)||[self.selectModel.eva boolValue]) {
        return;
    }
    [[NetworkTool sharedTool]requestWithURLString:[NSString stringWithFormat:@"%@/user/evaluate-comment",Server_url] parameters:@{@"id":self.selectModel.commentID,@"eva":@"1",@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
        if (!ISEMPTY(responseObject[@"error"])) {
            [YJApplicationUtil alertHud:responseObject[@"error"] afterDelay:1];
            return ;
        }
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            self.selectModel.good = [NSString stringWithFormat:@"%d",[self.selectModel.good intValue]+1];
            self.selectModel.eva = @(1);
            [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } error:^(NSError *error) {
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self.inputView.label.text containsString:@"添加一条评论~"]) {
        self.inputView.inputTextView.text = @"";
        self.inputView.label.text = @"   添加一条评论~";
    }
}

- (IBAction)menuAction:(id)sender {
    [self.popupManager dismiss:NO];
    UIButton *btn = sender;
    switch (btn.tag) {
        case 1:
        {
            [self.inputView.inputTextView becomeFirstResponder];
            self.inputView.label.text = [NSString stringWithFormat:@"   回复%@",self.selectModel.username];
        }
            break;
        case 2:
        {
            self.selectModel = self.commentAry[self.selectSelection][0];
            if (ISEMPTY(self.selectModel.commentID)||[self.selectModel.eva boolValue]) {
                [self.popupManager dismiss:NO];
                return;
            }
            [[NetworkTool sharedTool]requestWithURLString:[NSString stringWithFormat:@"%@/user/evaluate-comment",Server_url] parameters:@{@"id":self.selectModel.commentID,@"eva":@"1",@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
                if (!ISEMPTY(responseObject[@"error"])) {
                    [YJApplicationUtil alertHud:responseObject[@"error"] afterDelay:1];
                    [self.popupManager dismiss:NO];
                    return ;
                }
                if ([responseObject[@"result"] isEqualToString:@"success"]) {
                    [self.likeBtn setTitle:[NSString stringWithFormat:@"顶 (%d)",[self.selectModel.good intValue]+1] forState:UIControlStateNormal];
                    [self.popupManager dismiss:NO];
                    self.selectModel.good = [NSString stringWithFormat:@"%d",[self.selectModel.good intValue]+1];
                    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:self.selectSelection] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            } error:^(NSError *error) {
            }];
        }
            break;
        case 3:
        {
            self.selectModel = self.commentAry[self.selectSelection][0];
            if (ISEMPTY(self.selectModel.commentID) || [[self.selectModel.eva stringValue] isEqualToString:@"0"] || [self.selectModel.eva boolValue]) {
                [self.popupManager dismiss:NO];
                return;
            }
            [[NetworkTool sharedTool]requestWithURLString:[NSString stringWithFormat:@"%@/user/evaluate-comment",Server_url] parameters:@{@"id":self.selectModel.commentID,@"eva":@"0",@"auth_key":[LJKHelper getAuth_key]} method:POST callBack:^(id responseObject) {
                if (!ISEMPTY(responseObject[@"error"])) {
                    [YJApplicationUtil alertHud:responseObject[@"error"] afterDelay:1];
                    [self.popupManager dismiss:NO];
                    return ;
                }
                if ([responseObject[@"result"] isEqualToString:@"success"]) {
                        [self.dislikeBtn setTitle:[NSString stringWithFormat:@"踩 (%d)",[self.selectModel.bad intValue]+1] forState:UIControlStateNormal];
                    self.selectModel.bad = [NSString stringWithFormat:@"%d",[self.selectModel.bad intValue]+1];
                    self.selectModel.eva = @(0);
                    [self.popupManager dismiss:NO];
                    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:self.selectSelection] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            } error:^(NSError *error) {
            }];
        }
            break;
        case 4:
        {
            YJCommentReportViewController *vc = [[YJCommentReportViewController alloc] init];
            vc.comment = self.selectModel.comment;
            vc.commentID = self.selectModel.commentID;
            vc.house_id = self.house_id;
            vc.site_id = self.site_id;
            PushController(vc);
        }
            break;
            
        default:
            break;
    }

}

@end
