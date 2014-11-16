function trialResponse = SumSlow(fract, win, color, time, points)

%plots a line starting at x1, finishing at x2, and ac ursor in 'probe' location
%only appears if the trial has catch = 1

ppc_adjust = 23/38;


%set variables
fractSum = -1;
probeSum = -1;
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0;



trialResponse = {fractSum probeSum correct response RT Acc points};

fractSum = fract(1) + fract(2);
probeSum = fract(4);

if probeSum > fractSum;
    correct = 1;
end;
if probeSum < fractSum;
    correct = 0;
end;

trialResponse{1} = fractSum;
trialResponse{2} = probeSum;
trialResponse{3} = correct;


DrawCenteredNum_Abs(num2str(probeSum),win, color);

t_start = GetSecs;
time = time+t_start;
    KbReleaseWait;
    [key, secs] = WaitTill(time, {'1' '2' '3' '4' '6' '7' '8' '9'}, 0); %wait seconds even if there is a press
    if~isempty(key);
        trialResponse{4} = key;
        trialResponse{5} = secs - t_start;
        left = {'1' '2' '3' '4'};
        right = {'6' '7' '8' '9'};
        if ismember(key, left);
            response = 0;
        end
        if ismember(key, right);
            response = 1;
        end
        trialResponse{6} = correct==response;
        if trialResponse{6} == 1;
            trialResponse{7} = trialResponse{7} + 1;
        end
    end


end
