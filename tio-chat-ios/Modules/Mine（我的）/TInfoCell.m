//
//  TInfoCell.m
//  tio-chat-ios
//
//  Created by 刘宇 on 2020/2/24.
//  Copyright © 2020 刘宇. All rights reserved.
//

#import "TInfoCell.h"
#import "FrameAccessor.h"
#import "UIImageView+Web.h"

@interface TInfoCell ()
@property (nonatomic, weak) UIImageView *indiractor;
@property (nonatomic, strong) UIImageView *avatarView;

@end

@implementation TInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        
        self.detailTextLabel.textColor = [UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1.0];
        self.detailTextLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        
        self.avatarView = [UIImageView.alloc initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.avatarView.hidden = YES;
        self.avatarView.layer.cornerRadius = 6;
        self.avatarView.layer.masksToBounds = true;
        [self.contentView addSubview:self.avatarView];
        
        UIImageView *indiractor = [UIImageView.alloc initWithFrame:CGRectZero];
        indiractor.image = [UIImage imageNamed:@"inner"];
        [self.contentView addSubview:indiractor];
        self.indiractor = indiractor;
    }
    
    return self;
}
-(UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 48, 30)];
        _switchBtn.onTintColor = [UIColor colorWithHexString:@"#0087FC"];
        _switchBtn.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _switchBtn.tintColor = [UIColor colorWithHexString:@"#E8EBF0"];
        _switchBtn.hidden = true;
        [self.contentView addSubview:_switchBtn];
    }
    return _switchBtn;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    [self.detailTextLabel sizeToFit];
    
    if (self.detailTextLabel.width > self.contentView.width * 0.6) {
        self.detailTextLabel.width = self.contentView.width * 0.6;
    }
    
    self.textLabel.left = 16;
    self.textLabel.centerY = self.contentView.middleY;
    
    if (self.hasIndiractor) {
        self.indiractor.hidden = NO;
        [self.indiractor sizeToFit];
        self.indiractor.right = self.contentView.width - 16;
        self.indiractor.centerY = self.contentView.middleY;
        
        self.detailTextLabel.right = self.indiractor.left;
        self.detailTextLabel.centerY = self.contentView.middleY;
        
        self.avatarView.right = self.indiractor.left - 6;
        self.avatarView.centerY = self.contentView.middleY;
    } else {
        self.indiractor.hidden = YES;
        self.detailTextLabel.right = self.contentView.width - 16;
        self.detailTextLabel.centerY = self.contentView.middleY;
        
        self.avatarView.right = self.contentView.width - 16;
        self.avatarView.centerY = self.contentView.middleY;
    }
    if (self.isSwitch) {
        self.switchBtn.hidden = NO;

        self.switchBtn.right = self.contentView.width - 16;
        self.switchBtn.centerY = self.contentView.middleY;
        
        self.detailTextLabel.right = self.switchBtn.left-5;
        self.detailTextLabel.centerY = self.contentView.middleY;
        
        self.avatarView.right = self.switchBtn.left - 6;
        self.avatarView.centerY = self.contentView.middleY;
    } else {
        self.switchBtn.hidden = true;
    }
}

///// 去除group时的cell分割线
//- (void)addSubview:(UIView *)view
//{
//    if ([view isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
//        return;
//    }
//    
//    [super addSubview:view];
//}
- (void)setAvatar:(NSString *)avatar
{
    if (avatar.length)
    {
        self.avatarView.hidden = NO;
        [self.avatarView tio_imageUrl:avatar placeHolderImageName:@"avatar_placeholder" radius:0];
    }
    else
    {
        self.avatarView.hidden = YES;
    }
}

@end
