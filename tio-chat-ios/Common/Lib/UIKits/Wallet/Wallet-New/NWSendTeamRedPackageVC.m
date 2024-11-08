//
//  NWSendTeamRedPackageVC.m
//  tio-chat-ios
//
//  Created by 刘宇 on 2021/3/11.
//  Copyright © 2021 刘宇. All rights reserved.
//

#import "NWSendTeamRedPackageVC.h"
#import "WalletRedPackageRecordVC.h"
#import "WalletInputField.h"

#import "FrameAccessor.h"
#import "UIButton+Enlarge.h"
#import "UIControl+T_LimitClickCount.h"
#import "UIImage+TColor.h"
#import "MBProgressHUD+NJ.h"

#import "NWPay.h"

@interface NWSendTeamRedPackageVC () <UITableViewDelegate, UITextFieldDelegate>
@property (strong,  nonatomic) NSArray<UIButton *> *tabButtons;
@property (strong,  nonatomic) UIView *tabIndiractor;

/// 0:拼人品红包 1:普通红包
@property (assign,  nonatomic) NSInteger redType;
@property (weak,    nonatomic) UILabel *typeLabel;
@property (strong,  nonatomic) UIButton *typeButton;

/// "拼人品红包" "普通红包"
@property (weak,    nonatomic) UILabel *moenyInputLabel;
@property (strong,  nonatomic) UILabel *moneyLabel;

@property (strong,  nonatomic) UITextField *textField;
@property (strong,  nonatomic) UITextField *remarkField;
@property (strong,  nonatomic) UITextField *countField;
@property (strong,  nonatomic) UIButton *sendButton;
@property (assign,  nonatomic) NSInteger requestMoney;
@end

#define MAX_SEND_COUNT 100 // 红包最大发送数量

@implementation NWSendTeamRedPackageVC

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
        button.titleLabel.font = [UIFont systemFontOfSize:18];
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
//    
//    // tab
//    UIView *tabView = [UIView.alloc initWithFrame:CGRectMake((self.view.width - 232)*0.5, Height_NavBar, 232, 32)];
//    tabView.backgroundColor = [UIColor colorWithHex:0xFC5050];
//    tabView.layer.cornerRadius = 16;
//    tabView.layer.masksToBounds = YES;
//    [self.view addSubview:tabView];
    
//    UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    pinButton.frame = CGRectMake(0, 0, tabView.width * 0.45, tabView.height-2);
//    pinButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [pinButton setTitleColor:[UIColor colorWithHex:0xFFBEBE] forState:UIControlStateNormal];
//    [pinButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
//    [pinButton setTitle:@"拼人品红包" forState:UIControlStateNormal];
//    [pinButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    pinButton.selected = YES;
//    [tabView addSubview:pinButton];
//    
//    UIButton *normalButton = [UIButton buttonWithType: UIButtonTypeCustom];
//    normalButton.frame = CGRectMake(tabView.width * 0.55, 0, tabView.width * 0.45, tabView.height-2);
//    normalButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [normalButton setTitleColor:[UIColor colorWithHex:0xFFBEBE] forState:UIControlStateNormal];
//    [normalButton setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
//    [normalButton setTitle:@"普通红包" forState:UIControlStateNormal];
//    [normalButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [tabView addSubview:normalButton];
//    
//    self.tabButtons = @[pinButton, normalButton];
//    
//    self.tabIndiractor = [UIView.alloc initWithFrame:CGRectMake(0, 0, 52, 1)];
//    self.tabIndiractor.backgroundColor = UIColor.whiteColor;
//    self.tabIndiractor.bottom = tabView.height - 4;
//    self.tabIndiractor.centerX = pinButton.centerX;
//    [tabView addSubview:self.tabIndiractor];
    
    //
    UIView *CardAView = [UIView.alloc initWithFrame:CGRectMake(16, Height_NavBar+22, self.view.width-32, 44)];
    CardAView.backgroundColor = UIColor.whiteColor;
    CardAView.layer.cornerRadius = 4;
    CardAView.layer.masksToBounds = YES;
    [self.view addSubview:CardAView];
    
    UILabel *labelA = [UILabel.alloc initWithFrame:CGRectMake(25, CardAView.bottom+4, 120, 17)];
    labelA.text = [NSString stringWithFormat:@"本群共%zd人",self.team?self.team.memberNumber:2];
    labelA.textAlignment = NSTextAlignmentLeft;
    labelA.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    labelA.textColor = [UIColor colorWithHex:0x5B636F];
    [self.view addSubview:labelA];
    
    UIView *CardBView = [UIView.alloc initWithFrame:CGRectMake(16, Height_NavBar+103, self.view.width-32, 44)];
    CardBView.backgroundColor = UIColor.whiteColor;
    CardBView.layer.cornerRadius = 4;
    CardBView.layer.masksToBounds = YES;
    [self.view addSubview:CardBView];

    UILabel *labelB = [UILabel.alloc initWithFrame:CGRectMake(25, CardBView.bottom+4, 120, 17)];
    labelB.text = [NSString stringWithFormat:@"当前为%@,",self.redType == 0 ? @"拼手气红包":@"普通红包"];
    labelB.textAlignment = NSTextAlignmentLeft;
    labelB.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    labelB.textColor = [UIColor colorWithHex:0x5B636F];
    [self.view addSubview:labelB];
    [labelB sizeToFit];
    self.typeLabel = labelB;
    
    UIButton *pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pinButton.frame = CGRectMake(0, 0, 90, 20);
    pinButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [pinButton setTitleColor:[UIColor colorWithHex:0x1988DA] forState:UIControlStateNormal];
    [pinButton setTitle:@"改为普通红包" forState:UIControlStateNormal];
    [pinButton addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pinButton];
    [pinButton sizeToFit];
    pinButton.left = labelB.right+5;
    pinButton.centerY = labelB.centerY;
    self.typeButton = pinButton;
    
    UIView *CardCView = [UIView.alloc initWithFrame:CGRectMake(16, Height_NavBar+190, self.view.width-32, 70)];
    CardCView.backgroundColor = UIColor.whiteColor;
    CardCView.layer.cornerRadius = 4;
    CardCView.layer.masksToBounds = YES;
    [self.view addSubview:CardCView];
    // 金额
    UILabel *firstLabel = [UILabel.alloc initWithFrame:CGRectMake(16, 0, 120, 40)];
    firstLabel.text = @"总金额";
    firstLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    firstLabel.textColor = [UIColor colorWithHex:0x333333];
    [CardBView addSubview:firstLabel];
    self.moenyInputLabel = firstLabel;
    self.moenyInputLabel.attributedText = ({
        NSMutableAttributedString *aString = [NSMutableAttributedString.alloc init];
        NSDictionary *attr1 = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333], NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightBold]};
        NSTextAttachment *attch = [NSTextAttachment.alloc init];
        attch.image = [UIImage imageNamed:@"wallet_pin_send"];
        attch.bounds = CGRectMake(0, -2.5, 18, 18);
        [aString appendAttributedString:[NSAttributedString.alloc initWithString:@"总金额 " attributes:attr1]];
        [aString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle.alloc init];
        style.alignment = NSTextAlignmentLeft;
        [aString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightBold]} range:NSMakeRange(0, aString.length)];
        [aString addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, aString.length)];
        
        aString;
    });
    
    WalletInputField *moneyTF = [WalletInputField.alloc initWithFrame:CGRectMake(firstLabel.right, 0, CardBView.width-firstLabel.right - 40, 40)];
    moneyTF.textAlignment = NSTextAlignmentRight;
    moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    moneyTF.placeholder = @"0.00";
    moneyTF.w_deleteBlock = ^(NSString * _Nonnull text) {
        
    };
    [moneyTF addTarget:self action:@selector(textfieldEditing:) forControlEvents:UIControlEventEditingChanged];
    [CardBView addSubview:moneyTF];
    self.textField = moneyTF;
    
    UILabel *firstUnitLabel = [UILabel.alloc initWithFrame:CGRectMake(moneyTF.right, 0, 20, 44)];
    firstUnitLabel.text = @"元";
    firstUnitLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    firstUnitLabel.textColor = [UIColor colorWithHex:0x333333];
    firstUnitLabel.textAlignment = NSTextAlignmentRight;
    [CardBView addSubview:firstUnitLabel];
    // 个数
    {
        UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(16, 0, 120, 44)];
        label.text = @"红包个数";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        label.textColor = [UIColor colorWithHex:0x333333];
        [CardAView addSubview:label];
        UITextField *textfield = [UITextField.alloc initWithFrame:CGRectMake(label.right, 0, CardAView.width-label.right - 40, 44)];
        textfield.placeholder = @"填写个数";
//        textfield.placeholder = [NSString stringWithFormat:@"本群共%zd人",self.team?self.team.memberNumber:2];
        textfield.textAlignment = NSTextAlignmentRight;
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.delegate = self;
        [textfield addTarget:self action:@selector(textfieldEditing:) forControlEvents:UIControlEventEditingChanged];
        [CardAView addSubview:textfield];
        self.countField = textfield;
        UILabel *unitLabel = [UILabel.alloc initWithFrame:CGRectMake(textfield.right, 0, 20, 44)];
        unitLabel.text = @"个";
        unitLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        unitLabel.textColor = [UIColor colorWithHex:0x333333];
        unitLabel.textAlignment = NSTextAlignmentRight;
        [CardAView addSubview:unitLabel];
    }
    
    // 祝福语
    {
//        UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(16, 0, 120, 70)];
//        label.text = @"祝福语";
//        label.textAlignment = NSTextAlignmentLeft;
//        label.font = [UIFont systemFontOfSize:16];
//        label.textColor = [UIColor colorWithHex:0x333333];
//        [CardCView addSubview:label];
        UITextField *textfield = [UITextField.alloc initWithFrame:CGRectMake(16, 0, CardCView.width-32, 70)];
        textfield.placeholder = @"恭喜发财，吉祥如意";
        textfield.textAlignment = NSTextAlignmentLeft;
        [textfield addTarget:self action:@selector(remarkTextfieldEditing:) forControlEvents:UIControlEventEditingChanged];
        [CardCView addSubview:textfield];
        self.remarkField = textfield;
    }
    
    // 单个红包金额不能超过
    UILabel *tipLabel = [UILabel.alloc initWithFrame:CGRectZero];
    tipLabel.textColor = [UIColor colorWithHex:0xF9AD55];
    tipLabel.font = [UIFont systemFontOfSize:12];
//    tipLabel.text = @"单个红包金额为0.01~100元";
    [tipLabel sizeToFit];
    tipLabel.top = CardCView.bottom + 5;
    tipLabel.centerX = CardCView.centerX;
    [self.view addSubview:tipLabel];
    
    // 显示输入的大的总金额
    self.moneyLabel = [UILabel.alloc initWithFrame:CGRectMake(16, tipLabel.bottom + 18, self.view.width-32, 55)];
    [self.view addSubview:self.moneyLabel];
    [self setMoney:@"0.00"];
    
    // 发送button
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.viewSize = CGSizeMake(self.view.width - 70, 48);
    sendButton.top = CardCView.bottom+135;
    sendButton.centerX = CardCView.centerX;
    [sendButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHex:0xF55252]] imageWithCornerRadius:6 size:sendButton.viewSize]
                          forState:UIControlStateHighlighted];
    [sendButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHex:0xFF5E5E]] imageWithCornerRadius:6 size:sendButton.viewSize]
                          forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHex:0xFF908F]] imageWithCornerRadius:6 size:sendButton.viewSize]
                          forState:UIControlStateDisabled];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [sendButton setTitle:@"塞钱进红包" forState:UIControlStateNormal];
    [sendButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.acceptEventInterval = 0.5;
    [self.view addSubview:sendButton];
    self.sendButton = sendButton;
    self.sendButton.enabled = NO;
    
    [self.tabButtons[0] sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)tabButtonClicked:(UIButton *)button
{
    self.redType = self.redType == 0 ? 1 : 0;

    
    
    /// 更新总金额
    [self textfieldEditing:self.textField];
    
    if (self.redType == 0) {
        self.typeLabel.text = @"当前为拼手气红包,";
        [self.typeButton setTitle:@"改为普通红包" forState:UIControlStateNormal];
        NSDictionary *attr1 = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333], NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightBold]};
        [self.typeLabel sizeToFit];
        [self.typeButton sizeToFit];
        self.moenyInputLabel.attributedText = ({
            NSMutableAttributedString *aString = [NSMutableAttributedString.alloc init];
            
            NSTextAttachment *attch = [NSTextAttachment.alloc init];
            attch.image = [UIImage imageNamed:@"wallet_pin_send"];
            attch.bounds = CGRectMake(0, -2.5, 18, 18);
            [aString appendAttributedString:[NSAttributedString.alloc initWithString:@"总金额 " attributes:attr1]];
            [aString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attch]];
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle.alloc init];
            style.alignment = NSTextAlignmentLeft;
            [aString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightBold]} range:NSMakeRange(0, aString.length)];
            [aString addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, aString.length)];
            
            aString;
        });
        
        self.textField.placeholder = @"0.00";
    } else {
        self.typeLabel.text = @"当前为普通红包,";
        [self.typeButton setTitle:@"改为拼手气红包" forState:UIControlStateNormal];
        [self.typeLabel sizeToFit];
        [self.typeButton sizeToFit];
        self.moenyInputLabel.text = @"单个金额";
        self.textField.placeholder = @"0.00";
    }
    
}

- (void)toRedRecordVC:(id)sender
{
    [self.navigationController pushViewController:[WalletRedPackageRecordVC.alloc init] animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - actions

- (void)confirmClicked:(id)sender
{
    if (self.textField.text.length == 0) {
        return;
    }
    
    if (self.countField.text.integerValue < 1) {
        return;
    }
    
    // 转成分 0.01元 => 100分
    NSInteger amount = self.textField.text.floatValue * 100;
    
    if (amount < self.countField.text.integerValue * 0.01 * 100 && self.redType == 0) {
        [MBProgressHUD showInfo:@"这点儿红包不够他们分的" toView:self.view];
        return;
    }
    
    /// 单笔金额
    NSInteger singleAmount = amount;
    
    if (self.redType == 1) {
        // 普通红包 总金额重新计算：单笔金额 * 红包个数
        amount = amount * self.countField.text.integerValue;
    }
    
    self.requestMoney = amount;
    
    NSString *remark = self.remarkField.text.length?self.remarkField.text:self.remarkField.placeholder;
    
    /// 初始化红包
    [MBProgressHUD showLoading:@"" toView:self.view];
    CBWeakSelf
    [TIOChat.shareSDK.walletManager initRedPackageWithAmount:amount mode:self.redType==0?2:1 chatlinkid:self.sessionId num:self.countField.text.integerValue singleAmount:singleAmount remark:remark completion:^(id _Nullable responObject, NSError * _Nullable error) {
        CBStrongSelfElseReturn
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
        } else {
            /// 吊起支付框
            
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
        }
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
    NSDictionary *attr2 = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0x333333], NSFontAttributeName:[UIFont fontWithName:@"DINAlternate-Bold" size:48 ]};//DINAlternate-Bold //DINCondensed-Bold
    
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
    self.sendButton.enabled = self.textField.text.length>0 && self.countField.text.integerValue>=1;
    
//    if (textfield == self.countField) {
//        if (self.countField.text.integerValue > 100) {
//            [MBProgressHUD showInfo:@"最多发100个红包" toView:self.view];
//            return;
//        }
//    }
    
    if (self.textField.text.floatValue == 0) {
        [self setMoney:@"0.00"];
        return;
    }
    
    if (self.redType == 0) {
        /// 拼人品红包
        /// 判断是不是0.开头
        if ([self isDecimalNum:self.textField.text]) {
            [self setMoney:self.textField.text];
        } else {
            [self setMoney:[self.textField.text stringByAppendingString:@".00"]];
        }
    } else {
        /// 普通红包
        NSInteger redCount = self.countField.text.integerValue;
        if (redCount == 0) {
            [self setMoney:@"0.00"];
        } else {
            if (self.textField.text.floatValue > 0) {
                [self setMoney:[NSString stringWithFormat:@"%.2f",self.textField.text.floatValue * redCount]];
            }
        }
    }
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.remarkField) {
        return str.length < 15;
    }
    if (textField == self.countField) {
        if (str.integerValue > MAX_SEND_COUNT) {
            [MBProgressHUD showInfo:[NSString stringWithFormat:@"最多发%d个红包",MAX_SEND_COUNT] toView:self.view];
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _typeButton.left = _typeLabel.right+5;
    _typeButton.centerY = _typeLabel.centerY;

}
@end
