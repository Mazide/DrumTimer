//
//  ViewController.m
//  Timer
//
//  Created by Nikita Demidov on 09.02.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "ViewController.h"
#import "DrumTimerView.h"


@interface ViewController ()

@property (nonatomic) NSTimer* timer;
@property (nonatomic) IBOutlet DrumTimerView* timerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.timerView setTimerInterval:61];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(tik) userInfo:nil repeats:YES];
    
}

- (void)tik{
    [self.timerView tik];
}




@end
