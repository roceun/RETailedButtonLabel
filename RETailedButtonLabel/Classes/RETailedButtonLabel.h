//
//  RETailedButtonLabel.h
//  RETailedButtonLabel
//
//  Created by ROCEUN on 28/09/2019.
//  Copyright © 2019 ROCEUN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (CutText)

- (void)cutAttributedTextWithWidth;

@end

//MARK: - 

@interface RETailedButtonLabel : UIView

@property (nullable, nonatomic, strong) UILabel *label;
@property (nullable, nonatomic, strong) UIButton *tailedButton;

@property (nonatomic, assign) CGFloat lineMargin;
@property (nonatomic, assign) CGFloat buttonMargin;

- (void)makeView;

@end

NS_ASSUME_NONNULL_END
