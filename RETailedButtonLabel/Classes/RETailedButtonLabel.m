//
//  RETailedButtonLabel.m
//  RETailedButtonLabel
//
//  Created by ROCEUN on 28/09/2019.
//  Copyright © 2019 ROCEUN. All rights reserved.
//

#import "RETailedButtonLabel.h"


@interface RETailedButtonLabel ()

@property (nonatomic, assign) CGSize maxSize;

@end

@implementation RETailedButtonLabel

- (void)dealloc
{
	self.label = nil;
	self.tailedButton = nil;
}

- (CGSize)sizeThatFits:(CGSize)size
{
	return _maxSize;
}

//MARK: - Public methods

- (void)makeView
{
	[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	if (_label.text.length == 0) {
		self.maxSize = CGSizeMake(self.bounds.size.width, 0);
		return;
	}
	
	UILabel *lineLabel = [[UILabel alloc] init];
	lineLabel.attributedText = _label.attributedText;
	lineLabel.numberOfLines = 1;
	[lineLabel sizeToFit];
	
	const CGFloat textHeight = lineLabel.frame.size.height;
	CGSize size = self.bounds.size;
	NSUInteger index = 0;
	NSUInteger currentLine = 0;
	
	if (textHeight > 0) {
		[self addSubview:lineLabel];
		
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
				[self addSubview:lineLabel];
			}
		}
		
		if (_tailedButton) {
			[self addSubview:_tailedButton];
			
			const CGFloat buttonSize = textHeight + _lineMargin;
			
			[lineLabel sizeToFit];
			CGFloat offsetX = lineLabel.frame.origin.x + lineLabel.frame.size.width + _buttonMargin;
			CGFloat offsetY = lineLabel.frame.origin.y - (_lineMargin / 2);
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
		
		size.height = CGRectGetMaxY((_tailedButton ?: lineLabel).frame);
		self.maxSize = size;
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
	CGSize maximumLabelSize = CGSizeMake(CGFLOAT_MAX, self.frame.size.height);

    NSInteger max = [str length];
    textWidth = [str boundingRectWithSize:maximumLabelSize
                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                  context:nil].size.width;
    
    if (width <= textWidth) {
        NSInteger newMax = max * width / textWidth;
        for (max = newMax; max <= [str length]; max++) {
            textWidth = [[str attributedSubstringFromRange:NSMakeRange(0, max)] boundingRectWithSize:maximumLabelSize
                                                                                   options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                                   context:nil].size.width;

            if (width < textWidth) {
                max--;
                break;
            }
        }

        if (newMax > max) {
            do {
                textWidth = [[str attributedSubstringFromRange:NSMakeRange(0, max)] boundingRectWithSize:maximumLabelSize
                                                                                       options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                                       context:nil].size.width;
            } while (width <= textWidth && max-- >= 0);
        }
    }

    max = MAX(0, MIN(max, str.length));

	self.attributedText = [str attributedSubstringFromRange:NSMakeRange(0, max)];
}

@end
