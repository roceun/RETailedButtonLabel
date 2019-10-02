//
//  ViewController.m
//  RETailedButtonLabel
//
//  Created by ROCEUN on 28/09/2019.
//  Copyright © 2019 ROCEUN. All rights reserved.
//

#import "REViewController.h"
#import "RETailedButtonLabel.h"

@interface REViewController ()

@end

@implementation REViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	RETailedButtonLabel *tailedButtonLabel = [[RETailedButtonLabel alloc] initWithFrame:CGRectMake(16, 100, self.view.bounds.size.width - 32.f, 0)];
	tailedButtonLabel.lineMargin = 2.f;
	tailedButtonLabel.buttonMargin = 4.f;
	[self.view addSubview:tailedButtonLabel];
	
	UILabel *label = [[UILabel alloc] init];
	label.attributedText = [[NSAttributedString alloc] initWithString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz123456789"];
	label.numberOfLines = 0;
	tailedButtonLabel.label = label;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor yellowColor];
	tailedButtonLabel.tailedButton = button;
	
	[tailedButtonLabel sizeToFit];
}

@end
