Instruct = {};

Instruct{1} = {'END OF SECTION THREE',
               ' ',
               'Please carefully read the following instructions',
               'for section four.'
               ' ',
               'CLICK MOUSE to see instructions'};


Instruct{2} = {'In the following trials you will indicate',
               'whether a fraction is greater or less than 3/5.',
               ' ',
               'If the fraction is SMALLER than 3/5',
               'Please press the z key: z',
               ' ',
               'Use your left index finger on the z key',
               ' ',
               'Press z now to advance to the next screen'};

Instruct{3} = {'If the fraction is LARGER than 3/5',
               'Please press the forward slash key: /',
               ' ',
               'Use your right index finger for the / key',
               ' ',
               'Press / now to advance to the next screen'};

Instruct{4} = {'Remember, on each trial, compare the fraction',
               'on the screen to 3/5.'
               ' ',
               'If the fraction is LESS than 3/5 press z',
               ' ',
               'If the fraction is MORE than 3/5 press /',
               ' ',
               'If you forget the answer keys or need help',
               'during the experiment, please ask the experimenter.'
               ' ',
               'Press z or / to continue.'};

Instruct{5} = {'We are now ready to begin.',
               ' ',
               'Position your index fingers on the z and / keys',
               'and get ready for the first fraction.',
               ' ',
               'Press z or / to begin the experiment'};


 %display screen one
 clearMouseInput;
 TextDisplay(Instruct{1}, win, color);
 Screen('Flip', win);
 waitsecs(0.5);GetClicks(win,0);

%clear keyboard, display screen two, wait for z to be pressed
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    while keyIsDown
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    end    
    TextDisplay(Instruct{2}, win, color);
    Screen('Flip', win);
    waitsecs(0.5);
    
    WaitForZ;
    
    %clear keyboard, display screen three, wait for z to be pressed
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    while keyIsDown
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    end    
    TextDisplay(Instruct{3}, win, color);
    Screen('Flip', win);
    waitsecs(0.5);
    
    WaitForSlash;
    
    %clear keyboard, display screen four, wait for z or / to be pressed
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    while keyIsDown
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    end    
    TextDisplay(Instruct{4}, win, color);
    Screen('Flip', win);
    waitsecs(0.5);
    
    WaitForZorSlash;
    
    %clear keyboard, display screen five, wait for z or / to be pressed
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    while keyIsDown
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    end    
    TextDisplay(Instruct{5}, win, color);
    Screen('Flip', win);
    waitsecs(0.5);
        
    WaitForZorSlash;