// Copyright (c) 2010 Trevor Squires. All Rights Reserved.
// See License.txt for full license.

#import "JPAckResultCell.h"
#import "JPAckResultTableView.h"
#import "JPAckResultRep.h"
#import "SDFoundation.h"

@interface JPAckResultCell ()
- (NSRect)drawingRectForBounds:(NSRect)theRect honestly:(BOOL)honestly;
- (void)drawFillWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
@end

@implementation JPAckResultCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  [self drawFillWithFrame:cellFrame inView:controlView];
  [super drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawFillWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  NSColor* fill = nil;
  NSRect lcrect = [self drawingRectForBounds:cellFrame honestly:YES];

  if (contentColumn && resultType == JPResultTypeFilename)
  {
    NSRect paddingRect;
    SDDivideRect(lcrect, &paddingRect, &lcrect, RESULT_ROW_PADDING, NSMinYEdge);
    [[(JPAckResultTableView*)controlView backgroundColor] set];
    NSRectFill(paddingRect);

    fill = [NSColor colorWithCalibratedWhite:0.90 alpha:1.0];
  }
  else if (!contentColumn && resultType != JPResultTypeContextBreak)
    fill = [NSColor colorWithCalibratedWhite:0.90 alpha:1.0];
  else if ([self isHighlighted])
    fill = [NSColor colorWithCalibratedRed:(190.0/255.0) green:(220.0/255.0) blue:1.0 alpha:1.0];
  else if (resultType == JPResultTypeError)
    fill = [NSColor colorWithCalibratedRed:0.93 green:0.4 blue:0.4 alpha:1.0];
  else if (alternate)
    fill = [NSColor colorWithCalibratedRed:0.93 green:0.93 blue:1.0 alpha:1.0];

  if (fill)
  {
    [fill set];
    NSRectFill(lcrect);
  }

}

- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
  return nil;
}

- (NSBackgroundStyle)interiorBackgroundStyle
{
  return NSBackgroundStyleLight;
}

- (NSRect)drawingRectForBounds:(NSRect)theRect
{
  return [self drawingRectForBounds:theRect honestly:NO];
}

- (NSRect)drawingRectForBounds:(NSRect)theRect honestly:(BOOL)honestly
{
  NSRect drect = [super drawingRectForBounds:theRect];

  if (honestly) return drect;

  if(resultType == JPResultTypeFilename)
    SDDivideRect(drect, nil, &drect, RESULT_ROW_PADDING, NSMinYEdge);

  return NSInsetRect(drect, RESULT_CONTENT_INTERIOR_PADDING, RESULT_TEXT_YINSET);
}


-(void)configureType:(JPAckResultType)resultType_ alternate:(BOOL)alternate_ contentColumn:(BOOL)contentColumn_
{
  resultType = resultType_;
  alternate = alternate_;
  contentColumn = contentColumn_;
  
  if (resultType == JPResultTypeMatchingLine || resultType == JPResultTypeFilename || resultType == JPResultTypeError)
    [self setTextColor:[NSColor controlTextColor]];
  else
    [self setTextColor:[NSColor disabledControlTextColor]];
}

@end
