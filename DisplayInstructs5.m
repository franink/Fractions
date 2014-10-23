Instruct = {};

Instruct{1} = {'END OF SECTION FOUR',
               ' ',
               'Please carefully read the following instructions',
               'for section five.'
               ' ',
               'CLICK MOUSE to see instructions'};

Instruct{2} = {'In these trials, you will see two numbers.',
               'Please type in the fraction between the two displayed numbers',
               'that is closest to their numeric midpoint.',
               ' ',
               'CLICK MOUSE to see continue'};

Instruct{3} = {'The midpoint of two numbers is the number that is closest to',
               'halfway between them. For example:',
               '     The midpoint of 4 and 6 is 5',
               '     The midpoint of 1/4 and 3/4 is 1/2'
               ' ',
               'CLICK MOUSE to see continue'};

Instruct{4} = {'In this experiment, you will answer in hundredths,',
               'so the answer 1/2 would be given as 50/100.',
               ' ',
               'Enter your answer using the number keys at the',
               'top of the keyboard.'
               ' ',
               'CLICK MOUSE to see continue'};

Instruct{5} = {'Press BACKSPACE if you type the wrong character',
               'Press ENTER to record your response',
               ' ',
               'Feel free to answer approximately, use your intuition or',
               'make an educated guess.'
               ' ',
               'Please CLICK MOUSE to start the experiment.'};




for ii = 1:length(Instruct)
    clearMouseInput;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    waitsecs(0.5);GetClicks(win,0);
end