
Instruct = {};


Instruct{1} = {'In the following trials you will be asked to mark a',
               'number line to indicate the magnitude of a number.',
               ' ',
               'On each trial, the number line will span from 0 to 100.',
               'During the experiment, this task will be called: 0 to 100 task',
               ' '
               'All trials have two phases. During the first phase, you will see',
               'a number and think about where to place it on the number line',
               'without moving your eyes or the mouse.'
               ' ',
               'In the second phase you will move the cursor to mark the number line.'
               ' ',
               'After the number is presented, a RED dot will appear to signal',
               'that you should fixate your eyes on the dot and wait until it changes',
               'to GREEN. Only after the dot changes to GREEN, you should start moving'
               'the cursor to mark the number line.'
               ' ',
               'Please CLICK MOUSE to go on to the next screen.'};

                       
Instruct{2} = {'At the beginning of each trial you will see the number line',
                'in the middle of the screen. After some variable time an empty box',
                'will appear on top of the number line to indicate that a number will appear soon.',
                ' ',
                'Once you see the number, your job is to THINK about where you would place it',
        		'on the number line WITHOUT MOVING YOUR EYES. Numbers will be presented very briefly,',
                'so make sure you keep your eyes fixated on the box on top of the number line.',
                ' ',
                'After a brief presentation of the number, you should keep your eyes fixated',
            	'on the RED dot until it turns GREEN. Once the dot turns GREEN you can',
         		'activate the cursor by moving the trackball.', 
        		' ',
        		'If you move the trackball BEFORE the dot turns GREEN, you will lose',
        		'the point corresponding to that trial.',
        		' ',
        		'After the dot turns GREEN, you will only have 2 seconds to make a response,',
        		'so it is important to pay full attention to the dot. Also, since you will', 
        		'only have 2 seconds to respond, it is important that you take advantage of the waiting period',
        		'after the number appears to THINK about where you want to place the cursor.',
        		' ',
        		'If your mark on the number line is within 10% of the correct position', 
        		'you will earn a point for the trial.',
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};
            
Instruct{3} =  {'On some trials, once you start to move the cursor',
        		'you will see a black arrow. If you see the arrow', 
        		'you should place the cursor on top of the arrow but', 
        		'you SHOULD NOT click the mouse. If you click the mouse',
        		'you will lose the point for that trial.',
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};            
   
Instruct{4} = {'Please make your judgment promptly. Make your best guess',
               'rather than trying to calculate or measure exactly',
               ' ',
               'In the following screens you will see 4 practice trials,'
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
