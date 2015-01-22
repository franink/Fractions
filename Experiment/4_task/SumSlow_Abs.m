function trialResponse = SumSlow_Abs(fract, win, color, end_decision, ctch, points, LR)

% Version for real experiment in absolute time (unlike practice trials)
%Draws a probe sum result, waits for a response or for time and logs
%responses and stim used
%only appears if the trial has catch = 1

ppc_adjust = 23/38;


%set variables to -1 to catch missing data and errors
fractSum = -1;
probeSum = -1;
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.05; % Allow code to exit and keep on time

%Initialize log
trialResponse = {fractSum probeSum correct response RT Acc points};


if ctch;

    fractSum = fract(1) + fract(2);
    probeSum = fract(4);
    
    %Decide what is correct response
    if LR == 0; %This is for counterbalncing hand response
        if probeSum > fractSum;
            correct = 1;
        end;
        if probeSum < fractSum;
            correct = 0;
        end;           
    end;
    
    if LR == 1;
        if probeSum > fractSum;
            correct = 0;
        end;
        if probeSum < fractSum;
            correct = 1;
        end;
    end;
    
    trialResponse{1} = fractSum;
    trialResponse{2} = probeSum;
    trialResponse{3} = correct;
    
    %Draw frame
    winRect = Screen('Rect', win);
    Screen('FrameRect', win, [255 255 255 255], winRect, 30);
    Screen('Flip', win, 0, 1);
    
    DrawCenteredNum_Abs(num2str(probeSum),win, color);
    
    t_start = GetSecs;
    KbReleaseWait;
    time = end_decision-time_fix;
    [key, secs] = WaitTill(time, {'3' '4'});
    if~isempty(key);
        trialResponse{4} = str2double(key);
        trialResponse{5} = secs - t_start;
        %Let participants know their response was recorded by flipping
        %the screen
        t_remain = time - secs;
        Screen('Flip', win);
        WaitSecs(0.05);
        DrawCenteredNum(num2str(probeSum),win, color,t_remain);
        left = {'4'};
        right = {'3'};
        if ismember(key, left);
            response = 0;
        end;
        if ismember(key, right);
            response = 1;
        end;
        trialResponse{6} = correct==response;
        if trialResponse{6} == 1;
            trialResponse{7} = trialResponse{7} + 1;
        end;
    end;

end

end
