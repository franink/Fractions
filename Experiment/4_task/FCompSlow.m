function block_p_points = FCompSlow(fract, win, color, time, points)

% Version for practice (relative time unlike real trials)
%Draws a probe fraction, waits for a response or for time and logs
%responses and stim used
%only appears if the trial has catch = 1

ppc_adjust = 23/38;


%set variables to -1 to check if something is wrong and catch missing data
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.01;

%initialize result log
%trialResponse = {correct response RT Acc p_points};

fractMag = fract(1)/fract(2);
probeMag = fract(4)/fract(5);

%Decide what is a correct response
if probeMag > fractMag;
    correct = 1;
end;
if probeMag < fractMag;
    correct = 0;
end;

%trialResponse{1} = correct;

%Draw the fraction probe
probe_num = fract(4);
probe_denom = fract(5);
probe = [probe_num probe_denom];

DrawCenteredFrac(probe,win, color);
Screen('Flip', win);

tot_time = time - time_fix;
t_start = GetSecs;
time = time+t_start;
    KbReleaseWait;
    [key, secs] = WaitTill(time, {'1' '2' '3' '4' '6' '7' '8' '9'}); 
    if~isempty(key);
        %trialResponse{2} = key;
        %trialResponse{3} = secs - t_start;
        %Let participants know that their answer was reocrded by flipping
        %the screen
        t_remain = tot_time - (secs - t_start);
        Screen('Flip', win);
        DrawCenteredFrac(probe,win, color);
        Screen('Flip', win);
        WaitSecs(t_remain);
        left = {'1' '2' '3' '4'};
        right = {'6' '7' '8' '9'};
        if ismember(key, left);
            response = 0;
        end
        if ismember(key, right);
            response = 1;
        end
        %trialResponse{4} = correct==response;
        if correct == response;
            block_p_points = points + 1;
        else
            block_p_points = points;
        end
    else
        block_p_points = points;
    end


end
