
Instruct = {};


Instruct{1} = {'This experiment is about 20 minutes long, broken into two 9 minute sections.',
                %'This experiment is about 40 minutes long, broken into four 9 minute sections.',
               ' ',
               'During each section you will have to complete',
               '3 different tasks.' 
               ' ',
               'Read these instructions carefully',
               'and make sure you understand them.',
               ' ',
               'CLICK MOUSE to go on to the next screen.'};
Instruct{2} = {'Across all tasks, you will be paid for correct answers.',
               ' ',
               'When you answer correctly, you will receive 1 point.',
               ' ',
               'We will keep track of these points and you will recieve 5 cents per point'
               'at the end of the experiment, and $6 for each section ($12 total)',
               %'at the end of the experiment, and $6 for each section ($24 total)',
               ' ',
               ' ',
               'CLICK MOUSE to go on to the next screen.'};
                
Instruct{3} = {' ',
               ' ',
               %'fMRI studies are very expensive and difficult to conduct.',
               ' ',
               ' ',               
               'Please try your best.',
               ' ',
               ' ',               
               'CLICK MOUSE to go on to instructions for the first section.'};
            

for ii = 1:length(Instruct);
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