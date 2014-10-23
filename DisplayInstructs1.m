
Instruct = {};

Instruct{1} = {'The following experiment has 2 sections. Each section is',
               'reasonably short. In total, the experiment should last',
               'approximately 45 minutes.',
               ' ',
               'At the beginning of each section you will receive',
               'instructions that are specific to that',
               'section of the experiment.'
               ' ',
               'It is important that you read these instructions carefully',
               'and make sure you understand them.',
               ' ',
               'Please CLICK MOUSE to go on to the next screen.'};

Instruct{2} = {'SECTION ONE',
                ' ',
                'In the following trials, two numbers will appear on the screen.',
                'Your job is to memorize both numbers.',
                ' ',
                'Once you think you are ready to continue please click the mouse.',
                ' ',
                'Please try to respond as fast as possible',
                'but make sure you remember both numbers.'
                ' ',
                'Please click only once even if the screen does not change',
                'inmediately after you click.',
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};
           
Instruct{3} = {'On some trials you will see an X after the presentation',
                'of the two numbers. This means that you DO NOT need to do',
                'anything in this trial.',
                ' ',
                'However, on other trials you will see a number line',
                'marked with 0 and 25 in the end points.',
                'If you see a number line, then your job is to place',
                'one of the numbers on the number line.',
                ' ',
                'You will see either the word TOP on top of the number line',
                'or BOTTOM on the bottom of the number line.',
                ' ',
                'If it says TOP, you should mark the line where the number',
                'on the top of the previous display should go.'
                ' ',
                'If it says BOTTOM, then you should mark the line where the number',
                'on the bottom of the previous display should go.'
                ' ',
                'Please CLICK MOUSE to go on to the next screen.'};
            
Instruct{4} = {'As an example, if on the first screen you saw 1 and 25',
                'and then you saw the word TOP, then you would try to mark',
                'the number line very close to the left endpoint.',
                ' ',
                'If on the other hand you saw the word BOTTOM,',
                'then you would try to mark the number line very close',
                'to the right end point.',
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
            
                % I am here and have not finished the instructions
                
                    
Instruct{6} = {'We are now ready to begin.',
              ' ',
              'Keep your right hand on the moouse button',
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
