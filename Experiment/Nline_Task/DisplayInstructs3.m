
Instruct = {};

if LR == 0;
    hands_small = 'RED';
    hands_large = 'GREEN';
end;
if LR == 1;
    hands_small = 'GREEN';
    hands_large = 'RED';
end;

small_txt = sprintf('the %s button.', hands_small);
large_txt = sprintf('the %s button.', hands_large);

Instruct{1} = {'In each trial of this section, a display containing a pair of numbers',
                'separated by a horizontal line will appear.'
                ' ',
               'Your job is to treat the display as a fraction, and think about the value of the fraction.',
               ' ',
               'On many trials, the first display will be replaced by a second display',
               'containing a white border and a number line from 0 to 1 with a mark on it.',
                ' ',
                'When you see this second display, your job is to decide if the mark',
                'on the number line is smaller or larger than the value of the previous fraction.',
                ' ',
                'Remember, a white border around the screen means',
                'that it is time to make your decision.' 
                ' ',
                'PRESS ANY BUTTON to go on to the next screen.'};

Instruct{2} = {'If you think the mark on the number line is SMALLER',
                'than the value of the fraction: ',
                ' ',
                ['Press ' small_txt],
                ' ',
                'If you think the mark on the number line is LARGER',
                'than the value of the fraction: ',
                ' ',
                ['Press ' large_txt],
                ' ',
                'PRESS ANY BUTTON to go on to the next screen.'};

Instruct{3} = {'For example:',
               ' ',
               'If you see a display containing 5/10 followed by',
               'a line with a mark at position corresponding to 3/4',
                ' ',
                ' ',
              ['Press ' large_txt],
              ' ',
              ' ',
              'Because 3/4 is GREATER than 5/10',
              ' ',
              'PRESS ANY BUTTON to go on to the next screen.'};            

Instruct{4} = {'If you see a display containing 5/10 followed by',
               'a line with a mark at position corresponding to 7/20',
               ' ',
               ' ',
               ['Press ' small_txt],
              ' ',
              ' ',
              'Because 7/20 is SMALLER than 5/10',
              ' ',
              ' ',
              'PRESS ANY BUTTON to go on to the next screen.'};      
                    
Instruct{5} = {'Finally, on many trials, instead of getting a second display',
                'with a number for comparison you will see an X.',
                ' ',
                'This means you DO NOT need to do anything in this trial.',
                ' ',
                ' ',
               'If you have any questions please ask now.',
               ' ',
                ' ',
              'PRESS ANY BUTTON to go on to the next sceen.'};
          
 Instruct{6} = {'We will start with 3 trials of practice',
              ' ',
              ' ',
              'Remember to answer FAST and ACCURATELY.',
              'You have 2.5 seconds to make a response.',
              ' ',
              ' ',
              'PRESS ANY BUTTON to begin the practice trials.'};

                               

for ii = 1:length(Instruct);
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
end