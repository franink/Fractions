
Instruct = {};


Instruct{1} = {%'This experiment is about 20 minutes long, broken into two 10 minute sections.',
               'This experiment is about 20 minutes long, broken into four 5 minute sections.',
               ' ',
               'Read these instructions carefully and make sure you understand them.',
               ' ',
               'PRESS BUTTON to go on to the next screen.'};
           
Instruct{2} = {'Across all tasks, you will be paid for correct answers????.',
               ' ',
               'When you answer correctly, you will receive 1 point.',
               ' ',
               'We will keep track of these points and you will receive 5 cents per point????'
               'at the end of the experiment, plus $6 for each section????',
               ' ',
               ' ',
               'PRESS BUTTON to go on to the next screen.'};
                
Instruct{3} = {' ',
               ' ',
               'fMRI studies are very expensive and difficult to conduct.',
               ' ',
               ' ',               
               'Please try your best.',
               ' ',
               ' ',               
               'PRESS BUTTON to go on to instructions for the first section.'};
            

for ii = 1:length(Instruct);
    %This is the code if we want to use mouse instead of keyboard
%     clearMouseInput;
%     TextDisplay(Instruct{ii}, win, color);
%     Screen('Flip', win);
%     WaitSecs(0.5);GetClicks(win,0);

    
%     %This is the code if we want to use keyboard instead of mouse to move
%     %screen
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    %WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
    WaitTill({'1'});
end