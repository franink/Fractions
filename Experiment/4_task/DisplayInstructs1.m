
Instruct = {};

Instruct{1} = {'The following experiment has 4 sections. Each section is',
               'reasonably short. In total, the experiment should last',
               'approximately 70 minutes.',
               ' ',
               'At the beginning of each section you will receive',
               'instructions specific to that section.' 
               ' ',
               'Read these instructions carefully',
               'and make sure you understand them.',
               ' ',
               'Please PRESS ANY BUTTON to go on to the next screen.'};

Instruct{2} = {'In this section, two numbers will appear on the screen.',
                'Your job is to add both numbers and memorize the result.',
                ' ',
                'On some trials, after 2 seconds you will see an X.',
                'This means you DO NOT need to do anything in this trial.',
                ' ',
                'On other trials, after the 2 seconds you will see',
                'another number in he middle of the screen.',
                ' ',
                'If you see a number, then your job is to decide',
                'if the number shown is smaller or greater than',
                'the sum you memorized.'
                ' ',
                'Please PRESS ANY BUTTON to go on to the next screen.'};
                       
Instruct{3} = {'You will have 2.5 seconds to decide.',
                ' ',
                'If you think the last number is SMALLER than the sum',
                'of the first two numbers you should press a button',
                'with your LEFT hand.'
                ' ',
                'If you think the last number is GREATER than the sum',
                'of the first two numbers you should press a button',
                'with your RIGHT hand.'
                ' ',
                'Please press only once.',
                ' ',
                'If you answer correctly',
                'you will receive 1 point. We will keep track of the points',
                'and the top 5 participants will receive an extra $10 bonus',
                ' ',
                'Remember to answer FAST and ACCURATELY.'
                ' ',
                'Please PRESS ANY BUTTON to go on to the next screen.'};
   
                    
Instruct{4} = {'We are now ready to begin.',
              ' ',
              'In the following screens there will be 3 practice trials',
              ' ',
              'Please CLICK MOUSE to begin the experiment.'};
            

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
