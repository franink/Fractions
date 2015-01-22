function block_p_points = SumSlow(fract, win, color, time, points)

% Version for practice (relative time unlike real trials)
%Draws a probe sum result, waits for a response or for time and logs
%responses and stim used
%only appears if the trial has catch = 1

ppc_adjust = 23/38;


%set variables
fractSum = -1;
probeSum = -1;
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.01;



%trialResponse = {fractSum probeSum correct response RT Acc points};

fractSum = fract(1) + fract(2);
probeSum = fract(4);

if probeSum > fractSum;
    correct = 1;
end;
if probeSum < fractSum;
    correct = 0;
end;

%trialResponse{1} = fractSum;
%trialResponse{2} = probeSum;
%trialResponse{3} = correct;

winRect = Screen('Rect', win);
Screen('FrameRect', win, [255 255 255 255], winRect, 30);
Screen('Flip', win, 0, 1);
DrawCenteredNum_Abs(num2str(probeSum),win, color);


tot_time = time - time_fix;
t_start = GetSecs;
time = time+t_start;
    KbReleaseWait;
    [key, secs] = WaitTill(time, {'3' '4'});
    if~isempty(key);
        %trialResponse{4} = key;
        %trialResponse{5} = secs - t_start;
        t_remain = tot_time - (secs - t_start);
        Screen('Flip', win);
        WaitSecs(0.05);
        DrawCenteredNum(num2str(probeSum),win, color, t_remain);
        left = {'4'};
        right = {'3'};
        if ismember(key, left);
            response = 0;
        end
        if ismember(key, right);
            response = 1;
        end
        %trialResponse{6} = correct==response;
        if correct ==response;
            block_p_points = points + 1;
        else
            block_p_points = points;
        end
    else
        block_p_points = points;
    end


end
