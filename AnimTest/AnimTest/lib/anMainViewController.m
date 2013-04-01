//
//  anMainViewController.m
//  AnimTest
//
//  Created by Zak.
//  Copyright (c) 2013 Zak. All rights reserved.
//

#define RGBA(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

#import "anMainViewController.h"
#import "Anim.h"

@interface anMainViewController ()

@end

@implementation anMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[CRRecorder sharedRecorder] setOptions:0];
    [[CRRecorder sharedRecorder] start:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UILabel *label = [UILabel new];
    label.text = @"Anim";
    label.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:150];
    NSLog(@"%@",[UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
    label.textColor = RGBA(0xffffff, 1);
    label.shadowOffset = CGSizeMake(0, 5);
    label.shadowColor = RGBA(0x666666, 1);
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    
    label.y = (self.view.height/2) - (label.height/2) - 40;
    label.x = 0 - label.width;
    

    [Anim anim:@"slideRight" options:UIViewAnimationOptionCurveEaseOut animations:^(UIView *view) {
        view.x = 0 + self.view.width;
    }];
    
    [Anim anim:@"slideUp" options:UIViewAnimationOptionCurveEaseOut animations:^(UIView *view) {
        view.y = label.y + label.height - 10;
//        CGRect bounds = view.bounds;
//        bounds.origin.y -= label.y + label.height - 10;
//        view.bounds = bounds;
    }];
    
    [Anim anim:@"moveAround" options:UIViewAnimationOptionCurveEaseOut animations:^(UIView *view) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(120));
        view.transform = transform;
    }];
    
    [Anim anim:@"moveUp" options:UIViewAnimationOptionCurveEaseOut animations:^(UIView *view) {
//        view.y = 0;
        CGRect bounds = view.bounds;
        bounds.origin.y += -100;
        bounds.size.width += 50;
        bounds.size.height += -100;
        view.bounds = bounds;
    }];

    
    
    
    
    
    
    
    NSArray *bottomBars = [self bottomBars];
    [self.view addSubview:label];
    
    
    NSSet *timeline = [NSSet setWithObjects:
                       [Anim a:@"slideRight" vs:@[label] d:20] ,
                       @[ @.2 , [Anim a:@"slideUp" vs:bottomBars d:2] , @2 , [Anim a:@"moveAround" vs:bottomBars d:2] , [Anim a:@"moveUp" vs:bottomBars d:2] ] ,
                       nil];
    [Anim runTimelineSet:timeline completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Stopping screen recording");
            [[CRRecorder sharedRecorder] stop:nil];
            [[CRRecorder sharedRecorder] saveVideoToAlbumWithResultBlock:^(NSURL *URL) {
                NSLog(@"video saved");
            } failureBlock:^(NSError *error) {
                NSLog(@"Saving video FAILED! :( %@",error);
            }];
        });
    }];
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.titleLabel.text = @"restart";
//    [button sizeToFit];
//    [self.view addSubview:button];
    
}


- (NSArray *)bottomBars
{
    NSArray *bars = [self makeBars:5];
    for (UIView *bar in bars) {
        [self.view addSubview:bar];
    }
    return bars;
}

- (NSArray *)makeBars:(int)quantity
{
    int rightMargin = 15;

    NSMutableArray *bars = [NSMutableArray array];
    for (int i=0; i<quantity; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, self.view.height, 30, 200)];
        view.x = i == 0 ? view.x : ((UIView *)bars[i-1]).x + ((UIView *)bars[i-1]).width + rightMargin;
        view.backgroundColor = RGBA(0xffffff, .9);
        view.layer.shadowOffset = CGSizeMake(3, 1);
        view.layer.shadowOpacity = .3;
        view.layer.shadowRadius = .1;
        view.layer.shouldRasterize = YES;
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(15));
        view.transform = transform;
        [bars addObject:view];
//        [self.view addSubview:view];
    };
    return bars;
}

@end
