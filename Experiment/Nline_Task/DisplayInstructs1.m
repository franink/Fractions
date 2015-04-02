
Instruct = {};


Instruct{1} = {'In the following trials you will be asked to mark a',
               'number line to indicate the magnitude of a number.',
               ' ',
               'On each trial, the number line will span from 0 to 100.',
               'During the experiment, this task will be called: 0 to 100 task',
               ' '
               'All trials have two phases. During the first phase, you will see',
               'a number and think about where to place it on the number line',
               'WITHOUT moving your EYES or the MOUSE.'
               ' ',
               'It is important for you to remember to THINK about the number',
               'while you wait for the green dot.',
               ' ',
               'In the second phase you will move the cursor and click to mark the number line.',
               'Remember that as soon as the dot turns green you will need to click the mouse',
               'to activate the cursor, and you need to click again once you have decided',
               'where to mark the number line.'
               ' ',
               'Please CLICK MOUSE to go on to the next screen.'};

                       
Instruct{2} = {'In order to do the task correctly you need to follow these instructions:',
                ' ',
                'While the dot is RED, keep your eyes fixated on the red dot, and',
                'THINK about the position of the number, but DO NOT move your EYES',
                'or the MOUSE. We will be monitoring your eyes with a camera',
                'and your mouse movements.',
                ' ',
                'As soon as the dot turns GREEN, click the mouse to activate the cursor',
                'and move to the position where you would like to mark the number line.',
                ' ',
                'If there is a black arrow below the line DO NOT click the mouse to mark the line.',
                'If there is NO black arrow, then click the mouse to mark the line.',
                ' ',
                'If you follow these instructions AND you mark the number line',
                'within 5% of the correct position and before the 3 second period ends,',
                'you will earn a point for the trial.'
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};
            
Instruct{3} =  {'In the following screens you will see 4 practice trials,'
               ' ',
               'Please CLICK MOUSE to begin the practice trials.'};
          
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
