//
//  LPGeometry.h
//
//
//  Created by Lipeng on 15/11/15.
//  Copyright (c) 2015年 Li Peng. All rights reserved.
//

CG_INLINE CGRect
CGViewGetFrame(UIView *view)
{
    return view.frame;
}

CG_INLINE CGRect
CGViewGetBounds(UIView *view)
{
    return view.bounds;
}

CG_INLINE CGFloat
CGViewGetWidth(UIView *view)
{
    return CGRectGetWidth(view.bounds);
}

CG_INLINE CGFloat
CGViewGetHeight(UIView *view)
{
    return CGRectGetHeight(view.bounds);
}

CG_INLINE CGFloat
CGViewGetX1(UIView *view)
{
    return CGRectGetMinX(view.frame);
}

CG_INLINE CGFloat
CGViewGetY1(UIView *view)
{
    return CGRectGetMinY(view.frame);
}

CG_INLINE CGFloat
CGViewGetX2(UIView *view)
{
    return CGRectGetMaxX(view.frame);
}

CG_INLINE CGFloat
CGViewGetY2(UIView *view)
{
    return CGRectGetMaxY(view.frame);
}

CG_INLINE CGSize
CGViewGetSize(UIView *view)
{
    return view.frame.size;
}

CG_INLINE CGPoint
CGViewGetXY1(UIView *view)
{
    return view.frame.origin;
}

CG_INLINE CGPoint
CGViewGetXY2(UIView *view)
{
    return CGPointMake(CGViewGetX2(view), CGViewGetY2(view));
}

CG_INLINE void
CGViewTransX(UIView *view, CGFloat x)
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

CG_INLINE void
CGViewTransY(UIView *view, CGFloat y)
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

CG_INLINE void
CGViewTransXY(UIView *view, CGFloat x, CGFloat y)
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    view.frame = frame;
}

CG_INLINE void
CGViewTransY1ToMidOfFrame(UIView *view, CGRect frame)
{
    CGViewTransY(view, LP_Float_2(CGRectGetHeight(frame)-CGViewGetHeight(view)));
}

CG_INLINE void
CGViewTransY1ToMidOfView(UIView *view, UIView *mview)
{
    CGViewTransY(view, LP_Float_2(CGViewGetHeight(mview)-CGViewGetHeight(view)));
}

CG_INLINE void
CGViewTransX1ToMidOfFrame(UIView *view, CGRect frame)
{
    CGViewTransX(view, LP_Float_2(CGRectGetWidth(frame)-CGViewGetWidth(view)));
}

CG_INLINE void
CGViewTransX1ToMidOfView(UIView *view, UIView *mview)
{
    CGViewTransX(view, LP_Float_2(CGViewGetWidth(mview)-CGViewGetWidth(view)));
}
CG_INLINE void
CGViewTransXYToMidOfView(UIView *view, UIView *mview)
{
    CGViewTransX(view, LP_Float_2(CGViewGetWidth(mview)-CGViewGetWidth(view)));
    CGViewTransY(view, LP_Float_2(CGViewGetHeight(mview)-CGViewGetHeight(view)));
}

CG_INLINE void
CGViewTransXYOfView(UIView *view, UIView *mview, CGFloat x, CGFloat y)
{
    CGSize size=CGViewGetSize(mview);
    if (x<0){
        x=size.width-CGViewGetWidth(view)+x;
    }
    if (y<0){
        y=size.height-CGViewGetHeight(view)+y;
    }
    CGViewTransX(view,x);
    CGViewTransY(view,y);
}

CG_INLINE void
CGViewTransDY(UIView *view, CGFloat dy)
{
    CGRect frame = view.frame;
    frame.origin.y += dy;
    view.frame = frame;
}

CG_INLINE void
CGViewTransDX(UIView *view, CGFloat dx)
{
    CGRect frame = view.frame;
    frame.origin.x += dx;
    view.frame = frame;
}

CG_INLINE void
CGViewChangeHeight(UIView *view, CGFloat height)
{
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

CG_INLINE void
CGViewChangeDHeight(UIView *view, CGFloat dheight)
{
    CGRect frame = view.frame;
    frame.size.height += dheight;
    view.frame = frame;
}

CG_INLINE void
CGViewChangeWidth(UIView *view, CGFloat width)
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}
CG_INLINE void
CGViewChangeSize(UIView *view, CGFloat width, CGFloat height)
{
    CGRect frame = view.frame;
    frame.size.width = width;
    frame.size.height = height;
    view.frame = frame;
}

CG_INLINE void
CGViewChangeDWidth(UIView *view, CGFloat dwidth)
{
    CGRect frame = view.frame;
    frame.size.width += dwidth;
    view.frame = frame;
}

CG_INLINE void
CGViewChangeFrame(UIView *view, CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    view.frame = CGRectMake(x,y,width,height);
}

CG_INLINE CGFloat
CGViewGetContentHeight(UIScrollView *scrollView)
{
    return scrollView.contentSize.height;
}
