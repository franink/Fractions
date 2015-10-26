
Instruct = {};

Instruct{1} = {'In the following trials you will be asked to mark a',
               'line labeled with "xx" on each end point.',
               ' ',
               'During the experiment, this task will be called: Word task.',
               ' ',
               'The procedures of this task are very similar to the previous tasks',
               'EXCEPT for the following differences.',
               ' ',
               'During the first phase, instead of a number you will',
               'see a 2-letter word. You should read it and hold it in memory.',
               'Remember to NOT move your EYES or the MOUSE while the dot is RED.',
               ' ',
               'During the second phase, if the SAME word appears below the line,',
               'you will mark the line just above the word by clicking the mouse.',
               ' ',
               'If a DIFFERENT word appears below the line you should NOT click to mark the line.',
               ' ',
               'Please PRESS BUTTON to go on to the next screen.'};
 
Instruct{2} = {'In the following screens you will see 4 practice trials.',
               ' ',
               'Please PRESS BUTTON to begin the practice trials.'};


for ii = 1:length(Instruct)
%     %This is the code if we want to use mouse instead of keyboard
%     clearMouseInput;
%     TextDisplay(Instruct{ii}, win, color);
%     Screen('Flip', win);
%     WaitSecs(0.5);GetClicks(win,0);
    %This is the code if we want to use keyboard instead of mouse to move
    %screen
    %clear keyboard, display screen four, wait for z or / to be pressed
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
end