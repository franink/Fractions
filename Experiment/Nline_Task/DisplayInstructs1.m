
Instruct = {};


Instruct{1} = {'In each trial in this section, a display containing a pair of numbers',
                'separated by a horizontal line will appear.',
                ' ',
                'Your job is to add the number above the line to the number below the line.'
                ' ',
                'On many trials, the first display will be replaced by a second display',
                'containing a white border and a single number.',  
                ' ',
                'When you see this number, your job is to decide if it is smaller or larger ',
                'than the sum of two numbers in the first display.',
                ' ',
                'Remember, a white border around the screen means',
                'that it is time to make your decision.' 
                ' ',
                'PRESS ANY BUTTON to go on to the next screen.'};

                       
Instruct{2} = {'You will have 2.5 seconds to decide.',
                ' ',
                'If you think the last number is SMALLER than the sum',
                'of the first two numbers you should press',
                small_txt,
                ' ',
                'If you think the last number is GREATER than the sum',
                'of the first two numbers you should press',
                large_txt,
                ' ',
                'Please press only once.',
                ' ',
                'After the practce phase, if you answer correctly,',
                'you will receive 1 point. We will keep track of the points',
                'and at the end you will recieve 5 cents per point',
                ' ',
                'Remember to answer FAST and ACCURATELY.'
                ' ',
                'Please PRESS ANY BUTTON to go on to the next screen.'};
            
Instruct{3} = {'For example, if you see a display containing 5 and 10',
                'followed by the number 17 which is GREATER',
                'than the sum of 5 and 10, you should press',
              large_txt,
              ' ',
              'On the other hand, if th first display is followed',
              'by a SMALLER number like 13 you should press',
              small_txt,
              ' ',
              'Please PRESS ANY BUTTON to go on to the next screen.'};            
   
Instruct{4} = {'Finally, on many trials, instead of getting a second display',
                'with a number for comparison you will see an X.',
                ' ',
                'This means you DO NOT need to do anything in this trial.',
                ' ',
               'If you have any questions please ask now',
               ' ',
              'Please PRESS ANY BUTTON to go on to the next sceen.'};
          
Instruct{5} = {'We are now ready to begin.',
              ' ',
              'In the following screens there will be 3 practice trials',
              ' ',
              'Please PRESS ANY BUTTON to begin the practice trials.'};
            

for ii = 1:length(Instruct);
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
