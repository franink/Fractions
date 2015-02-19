Instruct = {};

pts_txt = sprintf('You have earned %d practice points in this section', block_p_points);
block_pts_txt = sprintf('In total, you have earned %d practice points', p_points);

Instruct{1} = {'END OF PRACTICE',
               ' ',
               pts_txt,
               ' ',
               block_pts_txt,
               ' ',
               'If you have any questions please ask now',
               ' ',
               'The first trial of the experiment will appear',
               'after approximately 10 seconds after you press the button',
               ' ',
               'Please CLICK MOUSE when you are ready to begin the experiment'};


for ii = 1:length(Instruct)
    %This is the code if we want to use mouse instead of keyboard
    clearMouseInput;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);GetClicks(win,0);
end

% for ii = 1:length(Instruct)
%     KbReleaseWait;
%     keyResp = 0;
%     TextDisplay(Instruct{ii}, win, color);
%     Screen('Flip', win);
%     WaitSecs(0.5);
%     WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
% end
    


