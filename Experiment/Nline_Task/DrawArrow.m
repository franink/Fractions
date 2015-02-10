function [] = DrawArrow(xpos, y, win, ppc_adjust)
%Draws a small arrow at xpos to indicate where to click
% y is the position of numberline so arrow will be slightly below

ytop = y + 15;
ybot = ytop + 15;
xleft = xpos - 4;
xright = xpos + 4;
yarrow = ytop + 8;

Screen('DrawLine',win,[0,0,0,0],xpos,ytop,xpos,ybot,round(5*ppc_adjust));
Screen('DrawLine',win,[0,0,0,0],xleft,yarrow,xpos-1,ytop+1,round(5*ppc_adjust));
Screen('DrawLine',win,[0,0,0,0],xright,yarrow,xpos+1,ytop+1,round(5*ppc_adjust));

end

