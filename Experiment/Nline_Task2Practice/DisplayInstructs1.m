
Instruct = {};


Instruct{1} = {'In the following trials you will be asked to decide whether',
               'a mark on a number line is to the right or the left',
               'of the correct placement for a given number',
               ' ',
               'On each trial, the number line will span from 0 to 100.',
               ' '
               'All trials have two phases. During the first phase, you will see',
               'a number, after that, a RED DOT will appear on the screen.',
               'You should use this time to think about where you would',
               'place the number on the number line WITHOUT moving your EYES.'
               ' ',
               'It is important for you to remember to THINK about the number',
               'while you wait for a white dot.',
               ' ',
               'The second phase starts when the DOT turns WHITE.',
               'As soon as it turns WHITE you will see a mark',
               'on the number line for a very brief period of time.',
               'Your job then is to decide if the mark is to the right or the left',
               'from the place you thought the mark should have been placed.',
               'Remember to keep your eyes fixated on the dot on the middle of the screen',
               'You will have 1.5 secodns to answer so be ready to answer quickly',
               'If you answer on time you will see the dot change color',
               'If you answer correctly the dot will turn GOLD',
               'If you answer incorrectly the dot will turn BLUE',
               ' ',
               'Please PRESS BUTTON to go on to the next screen.'};

                       
Instruct{2} = {'In order to do the task correctly you need to follow these instructions:',
                ' ',
                'While the dot is RED, keep your eyes fixated on the red dot, and',
                'THINK about the position of the number, but DO NOT move your EYES.',
                'We will be monitoring your eyes with a camera.',
                ' ',
                'As soon as the dot turns WHITE, decide whether the mark is to the left',
                'or the right from where the number should be placed and press the appropiate button.'
                'Press with your left hand if you think the mark is to the LEFT of the correct position.',
                'Press with the right hand if you think the mark is to the RIGHT of the correct position.',
                ' ',
                'In some trials, after the RED dot, no mark will appear.',
                'If this happens, you do not have to do anything. Just wait for the next number.',
                ' ',
                'If you follow these instructions AND respond correctly in time',
                'you will earn a point for the trial.'
                ' ',
                'Please PRESS BUTTON to go on to the next screen.'};
            
Instruct{3} =  {'In the following screens you will see 4 practice trials,'
               ' ',
               'Please PRESS BUTTON to begin the practice trials.'};
          
for ii = 1:length(Instruct)
    %This is the code if we want to use mouse instead of keyboard
%     clearMouseInput;
%     TextDisplay(Instruct{ii}, win, color);
%     Screen('Flip', win);
%     WaitSecs(0.5);GetClicks(win,0);
%     %This is the code if we want to use keyboard instead of mouse to move
%     %screen
%     %clear keyboard, display screen four, wait for button to be pressed
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
end
