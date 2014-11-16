function [ compResults ] = ConsiderSlow(Fract, win, color, task, time)
%Consider the numbers on the screen and when ready to move on press 'z' or '/' 
%logs the fraction used, RT task is iether 'keyb' or 'mouse' and tells the program what needs to log

fractMag = Fract(1)/Fract(2);
correct = fractMag;
compResults = {Fract(1) Fract(2) correct}; %I still need to think about what I will log and if I can put names

time_fix = 0.0;
time_on = time - time_fix;
time_left = 1;

DrawCenteredFrac(Fract,win, color)
Screen('Flip', win);

if strcmp(task,'keyb')
    KbReleaseWait;
    keyResp = 0;
    t_start = GetSecs;
    t_end = t_start + time_on;
    while ~keyResp

        [keyIsDown, secs, keyCode, deltaSecs]  = KbCheck;   
        keypress = find(keyCode==1, 1);
        if ~isempty(keypress) || GetSecs >= t_end;
            if GetSecs >= t_end;
                RT = 0;
                time_left = 0;
                keyResp = 1;
            else
                RT = secs - t_start; %Make sure I know what position goes fo what pieces of data
                %keyResp = 1;
            end
        end
    end
%     fix_on = time_fix + time_left*(time_on - compResults{4});
%     DrawCenteredNum('X',win,color,fix_on);
%     Screen('Flip', win);
end

if strcmp(task,'mouse')
    t_start = GetSecs;
    t_end = t_start + time_on;
    mouseResp = 0;
    while ~mouseResp
        [xPos, yPos, click] = GetMouse(win);
        if ~isempty(click) || GetSecs >= t_end;
            if GetSecs >= t_end;
                RT = 0;
                time_left = 0;
                mouseResp = 1;
            else
                click = sum(click);
                if click == 1;
                    RT = GetSecs - t_start;
                    %mouseResp = 1;
                end
            end
        end
    end
%     fix_on = time_fix + time_left*(time_on - compResults{4});
%     DrawCenteredNum('X',win,color,fix_on);
%     Screen('Flip', win); 
end

end
