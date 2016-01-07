//
//  SGProgressView.m
//  SGNavigationProgress
//
//  Created by Ben on 19/03/2014.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import "SGProgressView.h"

@interface SGProgressView ()
@property (nonatomic, strong) UIView *progressBar;
@end

@implementation SGProgressView

- (void)setProgress:(float)progress {
	_progress = (progress < 0) ? 0 :
				(progress > 1) ? 1 :
				progress;

	CGRect slice, remainder;
	CGRectDivide(self.bounds, &slice, &remainder, CGRectGetWidth(self.bounds) * _progress, CGRectMinXEdge);

	if (!CGRectEqualToRect(self.progressBar.frame, slice)) {
		self.progressBar.frame = slice;
	}
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.frame = frame;
		self.clipsToBounds = YES;
        self.backgroundColor = [self colorWithHexString:@"B6B6B6" alpha:1.0];
        self.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
		self.progressBar = [[UIView alloc] init];
        self.progressBar.backgroundColor = [self colorWithHexString:@"E91E63" alpha:1.0];
		self.progress = 0;
		[self addSubview:self.progressBar];
	}
	return self;
}

- (void)setFrame:(CGRect)frame
{
	// 0.5 pt doesn't work well with autoresizingMask.
    frame.origin.y = frame.origin.y + 2;
    frame.size.height = 2;
	[super setFrame:frame];

	__weak typeof(self)weakSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^{
		weakSelf.progress = weakSelf.progress;
	});
}

- (void)setTintColor:(UIColor *)tintColor
{
	[super setTintColor:tintColor];
	self.progressBar.backgroundColor = tintColor;
}


#pragma mark - Private

- (id)colorWithHexString:(NSString *)hex alpha:(CGFloat)a {
    NSScanner *colorScanner = [NSScanner scannerWithString:hex];
    unsigned int color;
    if (![colorScanner scanHexInt:&color]) return nil;
    CGFloat r = ((color & 0xFF0000) >> 16)/255.0f;
    CGFloat g = ((color & 0x00FF00) >> 8) /255.0f;
    CGFloat b =  (color & 0x0000FF) /255.0f;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}


@end
