//
//  NWSendSingleRedPackageVC.m
//  tio-chat-ios
//
//  Created by 刘宇 on 2021/3/11.
//  Copyright © 2021 刘宇. All rights reserved.
//

#import "NWSendP2PRedPackageVC.h"
#import "WalletInputField.h"

#import "UIButton+Enlarge.h"
#import "FrameAccessor.h"
#import "UIImage+TColor.h"
#import "UIControl+T_LimitClickCount.h"
#import "MBProgressHUD+NJ.h"

#import "WalletRedPackageRecordVC.h"
#import "NWPay.h"

@interface NWSendP2PRedPackageVC ()
@property (strong,  nonatomic) UILabel *moneyLabel;
@property (strong,  nonatomic) UILabel *toLabel;
@property (strong,  nonatomic) TIOUser *user;
@property (copy,    nonatomic) NSString *sessionId;
@property (strong,  nonatomic) UITextField *textField;
@property (strong,  nonatomic) UITextField *remarkField;
@property (strong,  nonatomic) UIButton *sendButton;

@property (assign,  nonatomic) NSInteger requestMoney;
@end

@implementation NWSendP2PRedPackageVC

- (instancetype)initWithFriend:(TIOUser *)user sessionId:(nonnull NSString *)sessionId
{
    self = [super init];
    if (self) {
        self.user = user;
        self.sessionId = sessionId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
    
    UIView *topBg = [UIView.alloc initWithFrame:CGRectMake(0, 0, self.view.width, Height_NavBar)];
    topBg.backgroundColor = [UIColor colorWithHex:0xF94335];
    [self.view addSubview:topBg];
 
    self.navigationBar.backgroundColor = UIColor.clearColor;
    [self.view bringSubviewToFront:self.navigationBar];
     
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
        [button setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
        [button setTitle:@"发红包" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button verticalLayoutWithInsetsStyle:ButtonStyleLeft Spacing:-40];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    })];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"红包记录" style:UIBarButtonItemStylePlain target:self action:@selector(toRedRecordVC:)];
    
//    UIImageView *topBg1 = [UIImageView.alloc initWithFrame:CGRectMake(0, Height_NavBar, self.view.width, FlexWidth(104))];
//    topBg1.image = [UIImage imageNamed:@"bg_red"];
//    [self.view addSubview:topBg1];
    
    // 发送给“XXX”
//    self.toLabel = [UILabel.alloc initWithFrame:CGRectMake(0, Height_NavBar+12, 91, 27)];
//    self.toLabel.backgroundColor = [UIColor colorWithHex:0xFF7878];
//    self.toLabel.layer.cornerRadius = 4;
//    self.toLabel.layer.masksToBounds = YES;
//    [self.view addSubview:self.toLabel];
//    [self sendToUser:self.user.nick];
    
    UIView *cardView = ({
        UIView *bgView = [UIView.alloc initWithFrame:CGRectMake(16, Height_NavBar+22, self.view.width - 32, 44)];
        bgView.backgroundColor = UIColor.whiteColor;
        bgView.layer.cornerRadius = 4;
        bgView.layer.masksToBounds = YES;
        // 金额
        UILabel *label1 = [UILabel.alloc initWithFrame:CGRectZero];
        label1.textColor = [UIColor colorWithHex:0x333333];
        label1.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        label1.text = @"金额";
        [label1 sizeToFit];
        label1.left = 20;
        label1.centerY = 22;
        [bgView addSubview:label1];
        
        WalletInputField *moneyTF = [WalletInputField.alloc initWithFrame:CGRectMake(0, 0, bgView.width * 0.6, 60)];
        moneyTF.centerY = label1.centerY;
        moneyTF.right = bgView.width - 20;
        moneyTF.textAlignment = NSTextAlignmentRight;
        moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
        moneyTF.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        moneyTF.textColor = [UIColor colorWithHex:0x333333];
        moneyTF.rightViewMode = UITextFieldViewModeAlways;
        moneyTF.rightView = ({
            UILabel *unitLabel = [UILabel.alloc initWithFrame:CGRectMake(0, 0, 30, 60)];
            unitLabel.text = @"元";
            unitLabel.textColor = [UIColor colorWithHex:0x333333];
            unitLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
            unitLabel.textAlignment = NSTextAlignmentRight;
            unitLabel;
        });
        moneyTF.w_deleteBlock = ^(NSString * _Nonnull text) {
            NSLog(@"删除后的text %@",text);
        };
        [moneyTF addTarget:self action:@selector(textfieldEditing:) forControlEvents:UIControlEventEditingChanged];
        [bgView addSubview:moneyTF];
        [moneyTF becomeFirstResponder];
        self.textField = moneyTF;
        
        
        bgView;
    });
    [self.view addSubview:cardView];
    
    UIView *cardBView = ({
        UIView *bgView = [UIView.alloc initWithFrame:CGRectMake(16, Height_NavBar+97, self.view.width - 32, 70)];
        bgView.backgroundColor = UIColor.whiteColor;
        bgView.layer.cornerRadius = 4;
        bgView.layer.masksToBounds = YES;
        
        UITextField *wishTF = [UITextField.alloc initWithFrame:CGRectMake(0, 0, bgView.width-40, 70)];
        wishTF.left = 20;
        wishTF.right = bgView.width - 20;
        wishTF.textAlignment = NSTextAlignmentLeft;
        wishTF.placeholder = @"恭喜发财，吉祥如意";
        wishTF.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        wishTF.textColor = [UIColor colorWithHex:0x333333];
        [wishTF addTarget:self action:@selector(remarkTextfieldEditing:) forControlEvents:UIControlEventEditingChanged];
        [bgView addSubview:wishTF];
        self.remarkField = wishTF;
        
        bgView;
    });
    [self.view addSubview:cardBView];
    
    
    // 单个红包金额不能超过
    UILabel *tipLabel = [UILabel.alloc initWithFrame:CGRectZero];
    tipLabel.textColor = [UIColor colorWithHex:0xF9AD55];
    tipLabel.font = [UIFont systemFontOfSize:12];
//    tipLabel.text = @"单个红包金额为0.01~200元";
    [tipLabel sizeToFit];
    tipLabel.top = cardBView.bottom + 12;
    tipLabel.centerX = cardBView.centerX;
    [self.view addSubview:tipLabel];
    
    self.moneyLabel = [UILabel.alloc initWithFrame:CGRectMake(16, tipLabel.bottom + 18, self.view.width-32, 55)];
    [self.view addSubview:self.moneyLabel];
    [self setMoney:@"0.00"];
    
    // 发送button
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.viewSize = CGSizeMake(self.view.width - 70, 48);
    sendButton.top = cardBView.bottom+125;
    sendButton.centerX = cardBView.centerX;
    [sendButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHex:0xF55252]] imageWithCornerRadius:4 size:sendButton.viewSize]
                          forState:UIControlStateHighlighted];
    [sendButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHex:0xFF5E5E]] imageWithCornerRadius:4 size:sendButton.viewSize]
                          forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHex:0xFF908F]] imageWithCornerRadius:4 size:sendButton.viewSize]
                          forState:UIControlStateDisabled];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [sendButton setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    [sendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.acceptEventInterval = 0.5;
    [self.view addSubview:sendButton];
    self.sendButton = sendButton;
    self.sendButton.enabled = NO;
}

- (void)remarkTextfieldEditing:(UITextField *)textfield
{
    NSInteger kMaxLength = 15;
    NSString *toBeString = textfield.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textfield markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textfield.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textfield.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}

- (void)textfieldEditing:(UITextField *)textfield
{
    NSLog(@"money = %@",textfield.text);
    
    self.sendButton.enabled = self.textField.text.length>0;
    
    if (textfield.text.floatValue == 0) {
        [self setMoney:@"0.00"];
        return;
    }
    
    if ([self isDecimalNum:textfield.text]) {
        CGFloat fMoney = textfield.text.floatValue;
        [self setMoney:[NSString stringWithFormat:@"%.2f",fMoney]];
        
    } else {
        [self setMoney:[textfield.text stringByAppendingString:@".00"]];
    }
}

- (void)toRedRecordVC:(id)sender
{
    [self.navigationController pushViewController:[WalletRedPackageRecordVC.alloc init] animated:YES];
}

- (BOOL)isDecimalNum:(NSString *)text
{
    int i = 0;
    BOOL flag = NO;
    while (i < text.length)
    {
        NSString * stringSet = [text substringWithRange:NSMakeRange(i, 1)];
        
        if ([stringSet isEqualToString:@"."]) {
            flag = YES;
        }
        
        i++;
    }
    
    return flag;
}

#pragma mark - actions

- (void)confirmClicked:(id)sender
{
    if (self.textField.text.length == 0) {
        return;
    }
    
    // 转成分 0.01元 => 100分
    NSInteger amount = self.textField.text.floatValue * 100;
    self.requestMoney = amount;
    
    NSString *remark = self.remarkField.text.length?self.remarkField.text:self.remarkField.placeholder;
    
    /// 初始化红包
    [MBProgressHUD showLoading:@"" toView:self.view];
    CBWeakSelf
    [TIOChat.shareSDK.walletManager initRedPackageWithAmount:amount mode:1 chatlinkid:self.sessionId num:1 singleAmount:amount remark:remark completion:^(id _Nullable responObject, NSError * _Nullable error) {
        CBStrongSelfElseReturn
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        /// 吊起支付框
        
        /// 预下单，获取token
        NWPay *pay = NWPay.shareInstance;
        pay.code = NWBusinessCodeNormalRed;
        pay.currentViewController = self;
        pay.amount = amount;
        pay.redId = responObject;

        [pay evoke:^(NSDictionary * _Nullable result, NWBusinessCode businessCode, NSError * _Nullable error) {
            if (error) {
                [MBProgressHUD showError:error.localizedDescription toView:self.view];
            } else {
                
                NSString *msg = result[@"ordererrormsg"];
                if (msg.length) {
                    [MBProgressHUD showError:msg toView:self.view];
                } else {
                    [MBProgressHUD showLoading:@"" toView:self.view];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self queryRedResult:responObject rerqid:result[@"id"]];
                    });
                }
            }
        }];
    }];
    
}

#pragma mark - private

- (void)queryRedResult:(NSString *)rid rerqid:(NSString *)rerqid
{
    CBWeakSelf
    [TIOChat.shareSDK.walletManager queryPayResultForRed:rid reqid:rerqid completion:^(NSDictionary * _Nullable responObject, NSError * _Nullable error) {
        CBStrongSelfElseReturn
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
        } else {
            [MBProgressHUD showSuccess:@"红包已发送" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)setMoney:(NSString *)num
{
    NSDictionary *attr1 = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333], NSFontAttributeName:[UIFont systemFontOfSize:48 weight:UIFontWeightSemibold]};
    NSDictionary *attr2 = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333], NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:48]};//DINAlternate-Bold //DINCondensed-Bold
    
    self.moneyLabel.attributedText = ({
        NSMutableAttributedString *aString = [NSMutableAttributedString.alloc init];
        [aString appendAttributedString:[NSAttributedString.alloc initWithString:@"¥ " attributes:attr1]];
        [aString appendAttributedString:[NSAttributedString.alloc initWithString:num attributes:attr2]];
        
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle.alloc init];
        style.alignment = NSTextAlignmentCenter;
        [aString addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, aString.length)];
        
        aString;
    });
}

- (void)sendToUser:(NSString *)user
{
    if (user.length>16) {
        user = [[user substringToIndex:16] stringByAppendingString:@"..."];
    }
    
    NSDictionary *attr1 = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFC7C7], NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSDictionary *attr2 = @{NSForegroundColorAttributeName:UIColor.whiteColor, NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    self.toLabel.attributedText = ({
        NSMutableAttributedString *aString = [NSMutableAttributedString.alloc init];
        
        NSTextAttachment *attch = [NSTextAttachment.alloc init];
        attch.image = [UIImage imageNamed:@"wallet_sendto"];
        attch.bounds = CGRectMake(0, -5, 18, 18);
        [aString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
        [aString appendAttributedString:[NSAttributedString.alloc initWithString:@"发给 " attributes:attr1]];
        [aString appendAttributedString:[NSAttributedString.alloc initWithString:user attributes:attr2]];
        
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle.alloc init];
        style.alignment = NSTextAlignmentCenter;
        [aString addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, aString.length)];
        
        aString;
    });
    
    [self.toLabel sizeToFit];
    self.toLabel.width += 14;
    self.toLabel.height = 27;
    self.toLabel.centerX = self.view.middleX;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
