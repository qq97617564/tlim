//
//  TTeamCell.m
//  tio-chat-ios
//
//  Created by 刘宇 on 2020/1/14.
//  Copyright © 2020 刘宇. All rights reserved.
//

#import "TTeamCell.h"
#import "UIImage+TColor.h"
#import "UIImageView+Web.h"
#import "FrameAccessor.h"

@interface TTeamCell ()

@property (nonatomic, weak) UILabel *managerIcon;

@end

@implementation TTeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    UIImageView *avatarView = ({
        UIImageView *imageView = [UIImageView.alloc init];
        
        imageView;
    });
    [self.contentView addSubview:avatarView];
    _avaterView = avatarView;
    
    UILabel *nickLabel = ({
        UILabel *label = [UILabel.alloc init];
        label.textColor = [UIColor colorWithHex:0x333333];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        
        label;
    });
    [self.contentView addSubview:nickLabel];
    _nickLabel = nickLabel;
    
    UILabel *managerIcon = ({
        UILabel *imageView = [UILabel.alloc initWithFrame:CGRectMake(0, 0, 32, 16)];
        imageView.textColor = [UIColor whiteColor];
        imageView.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
        imageView.backgroundColor = [UIColor colorWithHex:0x0087FC];
        imageView.layer.cornerRadius = 4;
        imageView.textAlignment = NSTextAlignmentCenter;
        imageView.layer.masksToBounds = true;
//        imageView.image = [UIImage imageNamed:@"groupOwner"];
        
        imageView;
    });
    [self.contentView addSubview:managerIcon];
    _managerIcon = managerIcon;
    
    UILabel *countLabel = ({
        UILabel *label = [UILabel.alloc init];
        label.textColor = [UIColor colorWithHex:0x9199A4];
        label.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightBold];
        label.textAlignment = NSTextAlignmentLeft;
        
        label;
    });
    [self.contentView addSubview:countLabel];
    _countLabel = countLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.avaterView.frame = CGRectMake(16, (self.contentView.height - 44) * 0.5, 44, 44);
    
    self.nickLabel.frame = CGRectMake(72, self.avaterView.top + 2, self.contentView.width - 72 - 16, 22);
    
    if (_role != TIOTeamUserRoleMember) {
        self.managerIcon.left = 72;
        self.managerIcon.top = self.nickLabel.bottom + 3;
        self.managerIcon.height = 16;
        self.countLabel.left = self.managerIcon.right + 4;
        self.countLabel.bottom = self.managerIcon.bottom;
    } else {
        self.countLabel.left = self.nickLabel.left;
        self.countLabel.top = self.nickLabel.bottom+4;
    }
}

- (void)setRole:(TIOTeamUserRole)role
{
    _role = role;
    
    if (role == TIOTeamUserRoleOwner) {
        self.managerIcon.backgroundColor = [UIColor colorWithHex:0x0087FC];
        self.managerIcon.text = @"群主";
        self.managerIcon.width = 32;
        self.managerIcon.hidden = NO;
    } else if (role == TIOTeamUserRoleManager) {
        self.managerIcon.backgroundColor = [UIColor colorWithHex:0x0087FC];
        self.managerIcon.text = @"管理员";
        self.managerIcon.width = 42;
        self.managerIcon.hidden = NO;
    } else {
        self.managerIcon.hidden = YES;
    }

}

- (void)setAvatarUrl:(NSString *)url
{
    // TODO: 需要添加占位图
    [self.avaterView tio_imageUrl:url placeHolderImageName:@"avatar_placeholder" radius:4];
}

//- (void)addSubview:(UIView *)view
//{
//    if ([view isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
//        return;
//    }
//    
//    [super addSubview:view];
//}

@end
