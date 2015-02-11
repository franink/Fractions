Instruct = {};

pts_txt = sprintf('You have earned %d practice points in this section', block_p_points);
block_pts_txt = sprintf('In total, you have earned %d practice points', p_points);

Instruct{1} = {'REST BREAK',
               ' ',
               pts_txt,
               ' ',
               block_pts_txt,
               ' ',
               'If you have any questions please ask now',
               ' ',
               'Please CLICK MOUSE when you are ready to continue'};
           
Instruct{2} = {'Now you will see another 3 practice trials',
                'before the start of the experiment',
               ' ',
               'Please CLICK MOUSE when you are ready to continue'};


for ii = 1:length(Instruct)
    %This is the code if we want to use mouse instead of keyboard
    clearMouseInput;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);GetClicks(win,0);
%     %This is the code if we want to use keyboard instead of mouse to move
%     %screen
%     %clear keyboard, display screen four, wait for z or / to be pressed
%     KbReleaseWait;
%     keyResp = 0;
%     TextDisplay(Instruct{ii}, win, color);
%     Screen('Flip', win);
%     WaitSecs(0.5);
%     WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
end
    
