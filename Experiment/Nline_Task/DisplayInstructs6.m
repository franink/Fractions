
Instruct = {};

Instruct{1} = {'In the following trials you will be asked to mark a',
               'line labeled with "xx" on each end point.',
               ' ',
               'During the experiment, this task will be called: Word task.',
               ' ',
               'All trials have two phases. During the first phase, you will see a 2-letter word.',
               'You should read it and hold it in memory without moving your eyes or the mouse.',
               ' ',
               'During the second phase, if the same word appears below the line,',
               'you will mark the line just above the word.'
               ' ',
               'After the word is presented, a RED dot will signal that you should',
               'fixate your eyes on the dot and wait until it changes to GREEN. Only after the dot',
               'changes to GREEN, you should click the mouse and start',
               'moving the cursor to mark the line.',
               ' ',
               'Please CLICK MOUSE to go on to the next screen.'};
 
Instruct{2} = {'The beginning of each trial is similar to the previous tasks.',
                'At the beginning of each trial you will see the line in the middle of the screen.',
                'After some variable time an empty box will appear above the line',
                'to indicate that a word will appear soon.'

                ' ',
                'Once you see the word you should read it and hold it in memory.',
                'Remember NOT TO MOVE YOUR EYES. Words will be presented very briefly',
                'so make sure you keep your eyes fixated on the box on top of the line.',
                ' ',
        		'After a brief presentation of the word, you should keep your eyes fixated',
                'on the RED dot until it turns GREEN. Once the dot turns GREEN you can',
         		'activate the cursor by clicking the mouse. At the same time, the word will appear',
                'below the line. You should then move the trackball to mark the line just above the word.',
                'If you move the trackball BEFORE the dot turns GREEN,',
                'you will lose the point corresponding to that trial.',
                ' ',
                'After the dot turns GREEN, you will only have 2 seconds to mark the line,',
                'so it is important to pay full attention to the dot.'
                ' ',
        		'If your mark on the line is within 10% of the correct position signaled by the word',
        		'just below the line, you will earn a point for the trial.',
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};
 
Instruct{3} =  {'On some trials, you will see a different word below the line.',
                ' ',
                'If the word is different from the one presented in the first phase,',
                'you should place the cursor above the word but you SHOULD NOT click the mouse.', 
        		' ',
                'If you click the mouse, you will lose the point for that trial.',
                ' ',
               'Please CLICK MOUSE to go on to the next screen.'};
 
Instruct{4} = {'Please make your judgment promptly. Your mark should be near the middle of the word,',
                'but need not be positioned exactly.'
               ' ',
               'In the following screens you will see 4 practice trials.',
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