//
//  RETailedButtonLabel.m
//  RETailedButtonLabel
//
//  Created by ROCEUN on 28/09/2019.
//  Copyright © 2019 ROCEUN. All rights reserved.
//

#import "RETailedButtonLabel.h"


@interface RETailedButtonLabel () {
	UIView *_contentView;
}

@end

@implementation RETailedButtonLabel

- (void)dealloc
{
	self.label = nil;
	self.tailedButton = nil;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [self makeView];
	return _contentView.frame.size;
}

- (CGSize)intrinsicContentSize
{
    return _contentView.frame.size;
}

- (void)layoutSubviews
{
    if (_contentView.frame.size.width != self.frame.size.width) {
        [self makeView];
        [self invalidateIntrinsicContentSize];
    }
}

//MARK: - Public methods

- (void)makeView
{
	[_contentView removeFromSuperview];
	_contentView = nil;

	if (_label.text.length == 0) {
		return;
	}
	
	_contentView = [[UIView alloc] init];
	[self addSubview:_contentView];
	
	UILabel *lineLabel = [[UILabel alloc] init];
	lineLabel.attributedText = _label.attributedText;
	lineLabel.numberOfLines = 1;
	[lineLabel sizeToFit];
	
	const CGFloat textHeight = lineLabel.frame.size.height;
	CGSize size = self.frame.size;
	NSUInteger index = 0;
	NSUInteger currentLine = 0;
	
	if (textHeight > 0) {
		[_contentView addSubview:lineLabel];
		
		if (_label.numberOfLines != 1 && lineLabel.frame.size.width > size.width) {
			while(1) {
				CGRect frame = lineLabel.frame;
				frame.origin.y = (textHeight + _lineMargin) * currentLine;
				frame.size.width = size.width;
				lineLabel.frame = frame;
				[lineLabel cutAttributedTextWithWidth];
				
				index += lineLabel.attributedText.length;
				if (_label.numberOfLines == currentLine + 1 ||
					index >= _label.attributedText.length) {
					break;
				}
				
				currentLine++;
				
				lineLabel = [[UILabel alloc] init];
				lineLabel.attributedText = [_label.attributedText attributedSubstringFromRange:NSMakeRange(index, _label.attributedText.length - index)];
				lineLabel.numberOfLines = 1;
				[lineLabel sizeToFit];
				[_contentView addSubview:lineLabel];
			}
		}
		[lineLabel sizeToFit];
		
		if (_tailedButton) {
			[_contentView addSubview:_tailedButton];
			
			const CGFloat buttonSize = textHeight + _lineMargin;
			
			CGFloat offsetX = lineLabel.frame.origin.x + lineLabel.frame.size.width + _buttonMargin;
			CGFloat offsetY = lineLabel.frame.origin.y + (lineLabel.frame.size.height / 2.f) - (buttonSize / 2.f);
			if (size.width - offsetX < buttonSize) {
				if (_label.numberOfLines == currentLine + 1) {
					CGRect frame = lineLabel.frame;
					frame.size.width = size.width - buttonSize - _buttonMargin;
					lineLabel.frame = frame;
					
					offsetX = lineLabel.frame.origin.x + lineLabel.frame.size.width + _buttonMargin;
				} else {
					offsetX = 0;
					offsetY += buttonSize;
				}
			}
			_tailedButton.frame = CGRectMake(offsetX, offsetY, buttonSize, buttonSize);
		}
		
		if (lineLabel.frame.origin.y == 0) {
			size.width = CGRectGetMaxX(lineLabel.frame) + CGRectGetWidth(_tailedButton.frame);
		}
		size.height = CGRectGetMaxY((_tailedButton ?: lineLabel).frame);
		
		CGRect frame = _contentView.frame;
		frame.size = size;
		_contentView.frame = frame;
		
		[self sendSubviewToBack:_contentView];
	}
}

@end


//MARK: -

@implementation UILabel (CutText)

- (void)cutAttributedTextWithWidth
{
	NSAttributedString *str = self.attributedText;
	if (str.length == 0)
		return;
	
	CGFloat width = CGRectGetWidth(self.frame), textWidth;

    NSInteger max = [str length];
	textWidth = self.frame.size.width;
    
	UILabel *label = [[UILabel alloc] init];
    if (width <= textWidth) {
        NSInteger newMax = max * width / textWidth;
        for (max = newMax; max <= [str length]; max++) {
			label.attributedText = [str attributedSubstringFromRange:NSMakeRange(0, max)];
			[label sizeToFit];
			textWidth = label.frame.size.width;

            if (width < textWidth) {
                max--;
                break;
            }
        }

        if (newMax > max) {
            do {
                label.attributedText = [str attributedSubstringFromRange:NSMakeRange(0, max)];
				[label sizeToFit];
				textWidth = label.frame.size.width;
            } while (width <= textWidth && max-- >= 0);
        }
    }

    max = MAX(0, MIN(max, str.length));

	self.attributedText = [str attributedSubstringFromRange:NSMakeRange(0, max)];
}

@end
