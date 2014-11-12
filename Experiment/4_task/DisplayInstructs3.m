
Instruct = {};

Instruct{1} = {'END OF SECTION ONE',
               ' ',
               'Please carefully read the following instructions',
               'for section two.'
               ' ',
               'CLICK MOUSE to see instructions'};

Instruct{2} = {'In this section you will be asked to mark a',
               'number line to indicate the magnitude of a fraction.',
               ' ',
               'On some trials, after 2 seconds you will see an X.',
                'This means you DO NOT need to do anything in this trial.',
                ' ',
                'On other trials, after the 2 seconds you will see a number line',
                'marked with 0 and 1 in the end points.',
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};

Instruct{3} =  {'As an example, if on the first screen you saw 1/2',
                'you would try to place your mark approximately in the',
                'center of the numberline.',
               ' ',
               'Please CLICK MOUSE to go on to the next screen.'};

Instruct{4} = {'You will have 3 seconds to place the mark on the number line.',
                ' ',
                'You will control a vertical line with the mouse.',
                'Move the vertical line to your desired position',
                'and click to enter your response.',
                ' ',
                'Please click only once.',
                ' ',
                'If your answers are within 10% of the correct answer',
                'you will receive 1 point. We will keep track of the points',
                'and the top 5 participants will receive an extra bonus',
                ' ',
                'Remember to answer as FAST as possible. It is better to',
                'answer imprecisely than to not answer at all.'
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};

Instruct{5} = {'We are now ready to begin.',
                ' ',
                'In the following screens there will be 3 practice trials',
                ' ',
                'CLICK MOUSE to begin the experiment.'};
                               

for ii = 1:length(Instruct)
    clearMouseInput;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);GetClicks(win,0);
end