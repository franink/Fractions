Instruct = {};

if pracResp == 0
    feedback = sprintf('You did not press the button');
else
    feedback = sprintf('You responded correctly');
end

Instruct{1} = {'END OF PRACTICE',
               ' ',
               feedback,
               ' ',
               ' ',
               ' ',
               'If you have any questions please ask now',
               ' ',
               'The first trial of the experiment will appear',
               'after approximately 15 seconds after the scanner starts',
               ' ',
               'Please PRESS BUTTON when you are ready to begin the experiment'};


% for ii = 1:length(Instruct)
%     %This is the code if we want to use mouse instead of keyboard
%     clearMouseInput;
%     TextDisplay(Instruct{ii}, win, p.textColor);
%     Screen('Flip', win);
%     WaitSecs(0.5);GetClicks(win,0);
% end

for ii = 1:length(Instruct)
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, p.textColor);
    Screen('Flip', win);
    WaitSecs(0.5);
    %WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
    WaitTill({'1'});
end
    


