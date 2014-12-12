
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

Instruct{1} = {'In this section, a fraction will appear on the screen.',
                ' ',
                'Each fraction will have a value between 0 and 1.',
                ' ',
               'Your job is to to think about the value of this fraction',
               ' ',
               'On some trials, after 2 seconds you will see',
                'a set of empty WHITE dots, and filled BLUE dots.',
                ' ',
                'If you see these dots, your job is to decide',
                'if the fraction of BLUE to TOTAL dots is smaller',
                'or greater than the value of the fraction presented.'
                ' ',
                'A white frame around the screen will remind you',
                'that is time to answer.' 
                ' ',
                'Please PRESS ANY BUTTON to go on to the next screen.'};

Instruct{2} = {'You will have 2.5 seconds to decide.',
                ' ',
                'If you think fraction of filled dots is SMALLER than',
                'the value of the fraction you should press',
                small_txt,
                ' ',
                'If you think fraction of filled dots is GREATER than', 
                'the value of the fraction you should press',
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

Instruct{3} = {'For example, if you see a fraction like 5/10',
              'and then the fraction of filled dots corresponds',
              'to a fraction with GREATER value like 3/4',
              'you should press',
              large_txt
              ' ',
              'On the other hand, if the fraction of filled dots',
              'corresponds to a fraction with SMALLER value like 7/20 you should press',
              small_txt,
              ' ',
              'Please PRESS ANY BUTTON to begin the experiment.'};            
                    
Instruct{4} = {'On some trials, instead of seeing a set of dots for comparison',
                'you will see an X. This means you DO NOT need',
                'to do anything in this trial.',
                ' ',
               'If you have any questions please ask now',
               ' ',
              'Please PRESS ANY BUTTON to go on to the next screen.'};
          
Instruct{5} = {'We are now ready to begin.',
              ' ',
              'In the following screens there will be 3 practice trials',
              ' ',
              'Please PRESS ANY BUTTON to begin the practice trials.'};
                               

for ii = 1:length(Instruct);
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
end