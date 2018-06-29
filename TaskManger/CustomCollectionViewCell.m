//
//  CustomCollectionViewCell.m
//  TaskManger
//
//  Created by Victor Macintosh on 29/06/2018.
//  Copyright © 2018 Victor Semenchuk. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewCell ()

- (void)setupViews;

@end

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        _titleLabel.textColor = UIColor.blackColor;
    }
    return _titleLabel;
}

- (void)setupViews {
    
    self.backgroundColor = UIColor.whiteColor;
    
    CGFloat margin = 16.0;
    
    [self addSubview:self.titleLabel];
    [NSLayoutConstraint activateConstraints:@[
                                              [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:margin],
                                              [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:margin],
                                              [self.titleLabel.heightAnchor constraintEqualToConstant:20.0],
                                              [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
                                              ]];
    
}

@end
