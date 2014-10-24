
Instruct = {};

Instruct{1} = {'The following experiment has 2 sections. Each section is',
               'reasonably short. In total, the experiment should last',
               'approximately 45 minutes.',
               ' ',
               'At the beginning of each section you will receive',
               'instructions specific to that section.' 
               ' ',
               'Read these instructions carefully',
               'and make sure you understand them.',
               ' ',
               'Please CLICK MOUSE to go on to the next screen.'};

Instruct{2} = {'SECTION ONE',
                ' ',
                'In this section, two numbers will appear on the screen.',
                'Your job is to memorize both numbers.',
                ' ',
                'On some trials, after 2 seconds you will see an X.',
                'This means you DO NOT need to do anything in this trial.',
                ' ',
                'On other trials, after the 2 seconds you will see a number line',
                'marked with 0 and 25 in the end points.',
                ' ',
                'If you see a number line, then your job is to place',
                'one of the numbers on the number line.',
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};
           
Instruct{3} = {'You will see either the word TOP on top of the number line',
                'or BOTTOM on the bottom of the number line.',
                ' ',
                'If it says TOP, you should mark the line where the number',
                'on the top from the previous display should go.'
                ' ',
                'If it says BOTTOM, then you should mark the line where the number',
                'on the bottom from the previous display should go.'
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};
            
Instruct{4} = {'For example, if first you saw 1 and 24',
                'and then you saw the word TOP, you would try to mark',
                'the number line close to the left endpoint.',
                ' ',
                'If you saw the word BOTTOM,',
                'you would try to mark the number line close',
                'to the right endpoint.',
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};
           
Instruct{5} = {'You will have 3 seconds to place the mark on the number line.',
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
            
                % I am here and have not finished the instructions
                
                    
Instruct{6} = {'We are now ready to begin.',
              ' ',
              'In the following screens there will be 3 practice trials',
              ' ',
              'Please CLICK MOUSE to begin the experiment.'};
            



for ii = 1:length(Instruct)
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
%     WaitTill({'z', '/'});
end
