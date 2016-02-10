//
//  DrumTimerView.m
//  Timer
//
//  Created by Nikita Demidov on 09.02.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "DrumTimerView.h"
#import "SingleNumberView.h"

@interface DrumTimerView()

@property (weak, nonatomic) IBOutlet UIView* mainView;

@property (weak, nonatomic) IBOutlet SingleNumberView* secondsFirstRunkView;
@property (weak, nonatomic) IBOutlet SingleNumberView* secondsSecondRunkView;
@property (weak, nonatomic) IBOutlet SingleNumberView* minutsFirstRunkView;
@property (weak, nonatomic) IBOutlet SingleNumberView* minutsSecondRunkView;

@property (nonatomic) NSTimeInterval currentTimerInterval;

@end

@implementation DrumTimerView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setup];
    }
    return self;
}

- (void)setup{
    
    NSString* drumTimerViewNibName = NSStringFromClass([DrumTimerView class]);
    [[NSBundle mainBundle] loadNibNamed:drumTimerViewNibName owner:self options:nil];
    [self addSubview:self.mainView];

    self.currentTimerInterval = 0;
    [self setTimerInterval:self.currentTimerInterval];
}

#pragma mark - public

- (void)setTimerInterval:(NSTimeInterval)timerInterval{
    
    if (timerInterval < 0) return;
    
    self.currentTimerInterval = (NSInteger)timerInterval;
    
    NSInteger secondsInMinuts = 60;
    NSInteger countInRunk = 10;
    
    NSInteger seconds = (NSInteger)timerInterval % secondsInMinuts;
    NSInteger minuts = (NSInteger)timerInterval / secondsInMinuts;
    
    NSInteger secondsFirstRunk = seconds % countInRunk;
    NSInteger secondsSecondRunk = seconds / countInRunk;
    
    NSInteger minutsFirstRunk = minuts % countInRunk;
    NSInteger minutsSecondRunk = minuts / countInRunk;
    
    [self.secondsFirstRunkView setValue:secondsFirstRunk];
    [self.secondsSecondRunkView setValue:secondsSecondRunk];
    
    [self.minutsFirstRunkView setValue:minutsFirstRunk];
    [self.minutsSecondRunkView setValue:minutsSecondRunk];
}

-(void)tik{

    if (self.currentTimerInterval <= 0) return;
    
    self.currentTimerInterval--;
    [self setTimerInterval:self.currentTimerInterval];
}


@end
