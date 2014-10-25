function [ compResults ] = Consider(Fract, win, color, task)
%Consider the numbers on the screen and when ready to move on press 'z' or '/' 
%logs the fraction used, RT task is iether 'keyb' or 'mouse' and tells the program what needs to log

fractMag = Fract(1)/Fract(2);
correct = fractMag
compResults = {Fract(1) Fract(2) correct 0}; %I still need to think about what I will log and if I can put names

        DrawCenteredFrac(Fract,win, color)
        Screen('Flip', win);

    if strcmp(task,'keyb')
        KbReleaseWait;
        keyResp = 0;
        t_start = GetSecs;
        while ~keyResp
            
            [keyIsDown, secs, keyCode, deltaSecs]  = KbCheck;   
            keypress = find(keyCode==1, 1);
            if ~isempty(keypress);
                compResults{4} = secs - t_start; %Make sure I know what position goes fo what pieces of data
                keyResp = 1;
            end
        end
    end

    if strcmp(task,'mouse')
        tic;
        GetClicks(win,0);
        compResults{4} = toc;
    end

end
