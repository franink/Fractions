
Instruct = {};


Instruct{1} = {'In the following trials you will be asked to',
               'press a button everytime you detect a change in the contrast',
               'of the circle with a checkerboard pattern.'
               ' ',
               'Each trial begins with a dot in the middle of the screen',
               'and you should keep you eyes fixated on the dot during',
               'the whole run of the experiment.',
               ' '
               'After some variable time, a flickering round checkerboard',
               'will appear. Your job is to monitor this checkerboard in order',
               'to detect a change in contrast. It is important to emphasize',
               'that you should ALWAYS KEEP YOUR EYES FIXATED ON THE CENTRAL DOT.'
               ' ',
               'If you detect a change of contrast press the button'
               'You will only have 1 second to press the button.'
               ' ',
               'Please PRESS BUTTON to go on to the next screen.'};

                       
Instruct{2} = {'In order to do the task correctly you need to follow these instructions:',
                ' ',
                'ALWAYS keep your eyes fixated on the dot in the middle of the screen',
                'We will be monitoring your eyes with a camera',
                ' ',
                'Press the button quickly if you detect a change in the contrast of the',
                'flickering checkerboard. You will only have 1 second to press the button',
                ' ',
                'Please PRESS BUTTON to go on to the next screen.'};
            
Instruct{3} =  {'In the following screen you will see an example of',
                'how a change in contrast looks like,'
               ' ',
               'Press the button when you detect the change in contrast',
               ' ',
               ' ',
               'Please PRESS BUTTON to begin the practice trial.'};
          
for ii = 1:length(Instruct)
    %This is the code if we want to use mouse instead of keyboard
%     clearMouseInput;
%     TextDisplay(Instruct{ii}, win, color);
%     Screen('Flip', win);
%     WaitSecs(0.5);GetClicks(win,0);

    %This is the code if we want to use keyboard instead of mouse to move
    %screen
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, p.textColor);
    Screen('Flip', win);
    WaitSecs(0.5);
    WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
    %WaitTill({'1'});
end
