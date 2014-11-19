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
    
    DrawCenteredNum_Abs(num2str(probeSum),win, color);
    
    t_start = GetSecs;
    KbReleaseWait;
    time = end_decision-time_fix;
    [key, secs] = WaitTill(time, {'1' '2' '3' '4' '6' '7' '8' '9'}, 0); %wait seconds even if there is a press
    if~isempty(key);
        trialResponse{4} = str2double(key);
        trialResponse{5} = secs - t_start;
        left = {'1' '2' '3' '4'};
        right = {'6' '7' '8' '9'};
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
