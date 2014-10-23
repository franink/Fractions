Instruct = {};

Instruct{1} = {'END OF SECTION ONE',
               ' ',
               'Please carefully read the following instructions',
               'for section two.'
               ' ',
               'Please Press z or / to go on to the instructions.'};

Instruct{2} = {'In the following trials you will indicate',
               'whether a fraction is greater or less than 3/5.',
               ' ',
               'At the begining of each trial you will see a fraction in the center of the screen.',
               ' ',
               'The fraction will be shown on the screen until you press z or /.'
               ' ',
               'Once you press z or / the fraction will dissappear';
               'so make sure you have thought about the magnitude',
               'of the fraction before pressing the keys.',
               ' ',
               'While we want you to think about the fraction please try to be as fast as possible.'
               ' ',
               'Please Press z or / to go on to the first set of instructions.'};

Instruct{3} = {'After you press z or / the fraction will be replaced by two Xs',
                'As soon as you see the Xs on the screen please decide if the previous fraction',
                'is greater or less than 3/5.',
                ' ',
                'If the fraction is SMALLER than 3/5',
                'Please press the z key: z.',
                ' ',
                'Use your left index finger on the z key.',
                ' ',
                'Press z or / now to advance to the next screen'};

Instruct{4} =  {'If the fraction is LARGER than 3/5',
               'Please press the forward slash key: /.',
               ' ',
               'Use your right index finger for the / key.',
               ' ',
               'Press z or / now to advance to the next screen'};

Instruct{5} = {'Remember, on each trial, compare the fraction',
               'on the screen to 3/5.'
               ' ',
               'If the fraction is LESS than 3/5 press z.',
               ' ',
               'If the fraction is MORE than 3/5 press /.',
               ' ',
               'If you forget the answer keys or need help',
               'during the experiment, please ask the experimenter.'
               ' ',
               'Press z or / to continue.'};

Instruct{6} = {'We are now ready to begin.',
               ' ',
               'Position your index fingers on the z and / keys',
               'and get ready for the first fraction.',
               ' ',
               'Press z or / to begin the experiment'};
                               



for ii = 1:length(Instruct)
    %clear keyboard, display screen four, wait for z or / to be pressed
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    WaitSecs(0.5);
    WaitTill({'z', '/'});
%     while ~keyResp
%         [~, secs, keyCode, ~]  = KbCheck;   
%         keypress = find(keyCode==1, 1);
%         if ~isempty(keypress);
%             if keypress == 29 %they press z
%                     keyResp = 1;
%                     response = 0;
%             end
% 
%             if keypress == 56 %they press /
%                     keyResp = 1;
%                     response = 1;
%             end
%         end
%     end 
    
    
end
