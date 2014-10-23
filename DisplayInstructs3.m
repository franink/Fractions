
Instruct = {};

Instruct{1} = {'END OF SECTION ONE',
               ' ',
               'Please carefully read the following instructions',
               'for section two.'
               ' ',
               'CLICK MOUSE to see instructions'};

Instruct{2} = {'In the following trials you will be asked to mark a',
               'number line to indicate the magnitude of a fraction.',
               ' ',
               'On each trial, the numberline will span from 0 to 1.',
               ' ',
               'Please CLICK MOUSE to go on to the next screen.'};

Instruct{3} = {'On some trials you will see an X after the presentation',
                'of the fraction. This means that you DO NOT need to do',
                'anything in this trial.',
                ' ',
                'However, on other trials you will see a number line',
                'marked with 0 and 1 in the end points.',
                'If you see a number line, then your job is to mark',
                'where that fraction should go on the number line.',
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};

Instruct{4} =  {'As an example, if on the first screen you saw 1/2',
                'you would try to place your mark approximately in the',
                'center of the numberline.',
               ' ',
               'Please CLICK MOUSE to go on to the next screen.'};

Instruct{5} = {'You will have 3 seconds to think about the numbers before',
                'moving to the number line screen, and you will also',
                'have 3 seconds to place the mark on the number line.',
                ' ',
                'You will control a vertical line with',
                'with the mouse.',
                'Move the vertical line to the position that corresponds',
                'to the fraction and click to enter your response.',
                ' ',
                'Please remember to answer as FAST as possible.',
                'Make your best guess rather than trying to calculate',
                'or measure exactly',
                ' ',
                'If your answers are within 10% of the correct answer',
                'you will receive 1 point. We will keep track of the points',
                'and the top 5 participants will receive an extra bonus',
                ' ',
                'Remember that it is better to answer imprecisely than',
                'to not answer at all.'
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};

Instruct{6} = {'We are now ready to begin.',
                ' ',
                'Keep your right hand on the moouse button',
                ' ',
                'CLICK MOUSE to begin the experiment.'};
                               

for ii = 1:length(Instruct)
    clearMouseInput;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);GetClicks(win,0);
end