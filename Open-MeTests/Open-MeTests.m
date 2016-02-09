//
//  Open-MeTests.m
//  Open-Me
//
//  Created by Ken M. Haggerty on 2/9/16.
//  Copyright (c) 2016 Flatiron School. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"
#import "KIF.h"
#import "FISViewController.h"

SpecBegin(FISViewController)

describe(@"FISViewController", ^{
    
    __block FISViewController *viewController;
    __block NSArray *buttons;
    
    beforeAll(^{
        
        buttons = @[@[@"1", @"2", @"3", @"/"], @[@"4", @"5", @"6", @"x"], @[@"7", @"8", @"9", @"-"], @[@"0", @".", @"=", @"+"]];
        
    });
    
    beforeEach(^{
        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        viewController = [main instantiateViewControllerWithIdentifier:@"viewController"];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = viewController;
        
        [viewController.view setNeedsUpdateConstraints];
        [viewController.view layoutIfNeeded];
        
    });
    
    describe(@"auto layout", ^{
        
        it(@"text field side margins should be 20 points", ^{
            UITextField *textField = (UITextField *)[tester waitForViewWithAccessibilityLabel:@"displayTextField"];
            CGRect textFieldRect = [textField.superview convertRect:textField.frame toView:viewController.view];
            
            expect(textFieldRect.origin.x).to.equal(20);
            expect(textFieldRect.origin.x+textFieldRect.size.width).to.equal(viewController.view.bounds.size.width-20);
        });
        
        it(@"text field top margin should be 30 points", ^{
            UITextField *textField = (UITextField *)[tester waitForViewWithAccessibilityLabel:@"displayTextField"];
            CGRect textFieldRect = [textField.superview convertRect:textField.frame toView:viewController.view];
            
            expect(textFieldRect.origin.y).to.equal(30);
        });
        
        it(@"buttons should occupy bottom half of screen", ^{
            UIView *topView = (UITextField *)[tester waitForViewWithAccessibilityLabel:@"topContainerView"];
            CGRect topViewRect = [topView.superview convertRect:topView.frame toView:viewController.view];
            
            expect(topViewRect.origin.x).to.equal(0);
            expect(topViewRect.origin.y).to.equal(0);
            expect(topViewRect.size.width).to.equal(viewController.view.bounds.size.width);
            expect(topViewRect.size.height).to.equal(viewController.view.bounds.size.height*0.5f);
        });
        
        it(@"buttons should have equal widths", ^{
            CGFloat width = [tester waitForViewWithAccessibilityLabel:buttons[0][0]].frame.size.width;
            NSArray *row;
            UIButton *button;
            for (int i = 0 ; i < buttons.count; i++)
            {
                row = buttons[i];
                for (int j = 0; j < row.count; j++)
                {
                    button = (UIButton *)[tester waitForViewWithAccessibilityLabel:buttons[i][j]];
                    expect(button.frame.size.width).to.beCloseToWithin(width, 1);
                }
            }
        });
        
        it(@"buttons should have equal heights", ^{
            CGFloat height = [tester waitForViewWithAccessibilityLabel:buttons[0][0]].frame.size.height;
            NSArray *row;
            UIButton *button;
            for (int i = 0 ; i < buttons.count; i++)
            {
                row = buttons[i];
                for (int j = 0; j < row.count; j++)
                {
                    button = (UIButton *)[tester waitForViewWithAccessibilityLabel:buttons[i][j]];
                    expect(button.frame.size.height).to.equal(height);
                }
            }
        });
        
        it(@"buttons should be horizontally adjacent", ^{
            NSArray *row;
            UIButton *button;
            CGRect buttonRect;
            CGFloat rightEdge = 0;
            for (int i = 0 ; i < buttons.count; i++)
            {
                row = buttons[i];
                for (int j = 0; j < row.count; j++)
                {
                    button = (UIButton *)[tester waitForViewWithAccessibilityLabel:buttons[i][j]];
                    buttonRect = [button.superview convertRect:button.frame toView:viewController.view];
                    
                    if (j > 0)
                    {
                        expect(buttonRect.origin.x).to.beCloseToWithin(rightEdge, 1);
                    }
                    
                    rightEdge = buttonRect.origin.x+buttonRect.size.width;
                }
            }
        });
        
        it(@"buttons should be vertically adjacent", ^{
            NSArray *row;
            UIButton *button;
            CGRect buttonRect;
            NSMutableArray *bottomEdges = [NSMutableArray array];
            for (int i = 0 ; i < buttons.count; i++)
            {
                row = buttons[i];
                for (int j = 0; j < row.count; j++)
                {
                    button = (UIButton *)[tester waitForViewWithAccessibilityLabel:buttons[i][j]];
                    buttonRect = [button.superview convertRect:button.frame toView:viewController.view];
                    
                    if (i > 0)
                    {
                        expect(buttonRect.origin.y).to.equal(((NSNumber *)bottomEdges[j]).floatValue);
                        
                        [bottomEdges replaceObjectAtIndex:j withObject:[NSNumber numberWithFloat:buttonRect.origin.y+buttonRect.size.height]];
                    }
                    else
                    {
                        [bottomEdges addObject:[NSNumber numberWithFloat:buttonRect.origin.y+buttonRect.size.height]];
                    }
                }
            }
        });
        
    });
    
});

SpecEnd
