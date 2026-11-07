#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static NSArray<NSString *> *BlockTitles(void) {
    static NSArray *a;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        a = @[@"我的道具", @"道具商城", @"会员中心", @"网页登录", @"分享邀请", @"域名配置"];
    });
    return a;
}

static BOOL Hit(NSString *t) {
    if (![t isKindOfClass:[NSString class]] || t.length == 0) return NO;
    for (NSString *b in BlockTitles()) {
        if ([t containsString:b]) return YES;
    }
    return NO;
}

static id IvarOf(id obj, const char *name) {
    Ivar iv = class_getInstanceVariable([obj class], name);
    return iv ? object_getIvar(obj, iv) : nil;
}

%hook FTProfileTableViewHeader
- (void)layoutSubviews {
    %orig;
    UIView *coin = IvarOf(self, "_ucoinCardView");
    UIView *member = IvarOf(self, "_membershipCardView");
    if ([coin isKindOfClass:[UIView class]]) { coin.hidden = YES; coin.alpha = 0; }
    if ([member isKindOfClass:[UIView class]]) { member.hidden = YES; member.alpha = 0; }
}
%end

%hook WKMeItemCell
- (void)layoutSubviews {
    %orig;
    UILabel *lbl = IvarOf(self, "_titleLbl");
    if ([lbl isKindOfClass:[UILabel class]] && Hit(lbl.text)) {
        self.hidden = YES;
        self.alpha = 0;
        self.userInteractionEnabled = NO;
        CGRect f = self.frame;
        f.size.height = 0;
        self.frame = f;
    }
}
%end

%hook UITableViewCell
- (void)layoutSubviews {
    %orig;
    UILabel *tl = self.textLabel;
    if ([tl isKindOfClass:[UILabel class]] && Hit(tl.text)) {
        self.hidden = YES;
        self.alpha = 0;
        self.userInteractionEnabled = NO;
        CGRect f = self.frame;
        f.size.height = 0;
        self.frame = f;
    }
}
%end

%hook FAVipActivateView
- (void)didMoveToWindow {
    %orig;
    self.hidden = YES;
    self.alpha = 0;
}
%end

%hook FAVipTipsAlertView
- (void)didMoveToWindow {
    %orig;
    self.hidden = YES;
    self.alpha = 0;
}
%end

%hook WKLoginView
- (void)layoutSubviews {
    %orig;
    UIImageView *iv = IvarOf(self, "_iconView");
    if ([iv isKindOfClass:[UIImageView class]]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"milo_logo" ofType:@"png"];
        UIImage *logo = path ? [UIImage imageWithContentsOfFile:path] : nil;
        if (logo) iv.image = logo;
    }
}
%end

%hook WKLoginVC
- (void)viewWillAppear:(BOOL)animated {
    %orig;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;
}
%end
