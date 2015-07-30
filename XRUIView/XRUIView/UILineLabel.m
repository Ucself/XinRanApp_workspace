//
//  UILineLabel.m
//  XinRanApp
//
//  Created by tianbo on 14-12-31.
//  Copyright (c) 2014年 deshan.com. All rights reserved.
//

#import "UILineLabel.h"

@implementation UILineLabel



- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:self.font,
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize fontSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height)
                                                    options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:attributes
                                                    context:nil].size;
    

    UIColor *color = self.textColor;
    CGFloat red, green, black, alpha;
    [color getRed:&red green:&green blue:&black alpha:&alpha];
     CGContextSetRGBStrokeColor(ctx, red, green, black, 1.0f); // Format : RGBA
     
     // Line Width : make thinner or bigger if you want
     CGContextSetLineWidth(ctx, 1.0f);
     
     // Calculate the starting point (left) and target (right)
     CGPoint l = CGPointMake(0, self.frame.size.height/2.0 + 0.9);
    
     CGPoint r = CGPointMake(fontSize.width, self.frame.size.height/2.0 + 0.9);
    
     // Add Move Command to point the draw cursor to the starting point
     CGContextMoveToPoint(ctx, l.x, l.y);
     
     // Add Command to draw a Line
     CGContextAddLineToPoint(ctx, r.x, r.y);
     
     
     // Actually draw the line.
     CGContextStrokePath(ctx);
     
     // should be nothing, but who knows...
     [super drawRect:rect];
}


@end
