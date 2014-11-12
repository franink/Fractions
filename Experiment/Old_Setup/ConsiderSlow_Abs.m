function [ compResults ] = ConsiderSlow_Abs(Fract, win, color, task, end_cons)
%Consider the numbers on the screen and when ready to move on press 'z' or '/' 
%logs the fraction used, RT task is iether 'keyb' or 'mouse' and tells the program what needs to log

fractMag = Fract(1)/Fract(2);
correct = fractMag;
RT = -1;

compResults = {Fract(1) Fract(2) correct RT}; %I still need to think about what I will log and if I can put names

time_fix = 0.05;
%time_on = time - time_fix;
time_left = 1;

DrawCenteredFrac(Fract,win, color)
Screen('Flip', win);
t_start = GetSecs;

if strcmp(task,'keyb')
    KbReleaseWait;
    [key, secs] = WaitTill(end_cons-time_fix, {'z' '/'}, 0); %wait seconds even if there is a press
    if ~isempty(key);
        compResults{4} = secs - t_start;
    end
    
    % Decide if I will use a fixation during time left. Tight now I think it is better to keep stim all the time
    
%     t_start = GetSecs;
%     t_end = t_start + time_on;
%     while ~keyResp
% 
%         [keyIsDown, secs, keyCode, deltaSecs]  = KbCheck;   
%         keypress = find(keyCode==1, 1);
%         if ~isempty(keypress) || GetSecs >= t_end;
%             if GetSecs >= t_end;
%                 compResults{4} = 0;
%                 time_left = 0;
%                 keyResp = 1;
%             else
%                 compResults{4} = secs - t_start; %Make sure I know what position goes fo what pieces of data
%                 keyResp = 1;
%             end
%         end
%     end
%     fix_on = time_fix + time_left*(time_on - compResults{4});
%     DrawCenteredNum('X',win,color,fix_on);
%     Screen('Flip', win);
end

if strcmp(task,'mouse')
    clearMouseInput;
    mouseResp = 0;
    while ~mouseResp
        [xPos, yPos, click] = GetMouse(win);
        if ~isempty(click) || GetSecs >= end_cons - time_fix;
            if GetSecs >= end_cons - time_fix;
                compResults{4} = 0;
                %time_left = 0; Only if fixation after stim is used
                mouseResp = 1;
            else
                click = sum(click);
                if click == 1;
                    compResults{4} = GetSecs - t_start;
                    mouseResp = 1;
                end
            end
        end
    end

    %This is if I want fixation to be included
    % fix_on = time_fix + time_left*(time_on - compResults{4}); 
    %DrawCenteredNum('X',win,color,fix_on);
    %Screen('Flip', win); 
end

end
