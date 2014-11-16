function trialResponse = FCompSlow(fract, win, color, time)

%plots a line starting at x1, finishing at x2, and ac ursor in 'probe' location
%only appears if the trial has catch = 1

ppc_adjust = 23/38;


%set variables
correct =-1;
response = -1;
RT = -1;
Acc = -1;
points = 0;
time_fix = 0;


trialResponse = {correct response RT Acc points};

fractMag = fract(1)/fract(2);
probeMag = fract(4)/fract(5);

if probeMag > fractMag;
    correct = 1;
end;
if probeMag < fractMag;
    correct = 0;
end;

trialResponse{1} = correct;

DrawCenteredFrac(probeMag,win, color)
Screen('Flip', win);

t_start = GetSecs;
time = time+t_start;
    KbReleaseWait;
    [key, secs] = WaitTill(time, {'1' '2' '3' '4' '6' '7' '8' '9'}, 0); %wait seconds even if there is a press
    if~isempty(key);
        trialResponse{2} = key;
        trialResponse{3} = secs - t_start;
        left = {'1' '2' '3' '4'};
        right = {'6' '7' '8' '9'};
        if ismember(key, left);
            response = 0;
        end
        if ismember(key, right);
            response = 1;
        end
        trialResponse{4} = correct==response;
        if trialResponse{4} == 1;
            trialResponse{5} = trialResponse{5} + 1;
        end
    end


end
