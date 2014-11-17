function trialResponse = FCompSlow_Abs(fract, win, color, end_decision, ctch, points, LR)

%plots a line starting at x1, finishing at x2, and ac ursor in 'probe' location
%only appears if the trial has catch = 1

ppc_adjust = 23/38;


%set variables
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.05;
Num_probe = -1;
Denom_probe = -1;
probeMag = -1;


trialResponse = {Num_probe Denom_probe probeMag correct response RT Acc points};


if ctch;
    Num_probe = fract(4);
    Denom_probe = fract(5);
    fractMag = fract(1)/fract(2);
    probeMag = fract(4)/fract(5);
    
    if LR == 0; %This is for counterbalncing hand response
        if probeMag > fractMag;
            correct = 1;
        end;
        if probeMag < fractMag;
            correct = 0;
        end;           
    end;
    
    if LR == 1;
        if probeMag > fractMag;
            correct = 0;
        end;
        if probeMag < fractMag;
            correct = 1;
        end;
    end;
    
    
    trialResponse{1} = Num_probe;
    trialResponse{2} = Denom_probe;
    trialResponse{3} = probeMag;
    trialResponse{4} = correct;
    
    probe_num = fract(4);
    probe_denom = fract(5);
    probe = [probe_num probe_denom];

    DrawCenteredFrac(probe,win, color);
    Screen('Flip', win);
    
    t_start = GetSecs;
        KbReleaseWait;
        [key, secs] = WaitTill((end_decision-time_fix), {'1' '2' '3' '4' '6' '7' '8' '9'}, 0); %wait seconds even if there is a press
        if~isempty(key);
            trialResponse{5} = str2double(key);
            trialResponse{6} = secs - t_start;
            left = {'1' '2' '3' '4'};
            right = {'6' '7' '8' '9'};
            if ismember(key, left);
                response = 0;
            end
            if ismember(key, right);
                response = 1;
            end
            trialResponse{7} = correct==response;
            if trialResponse{7} == 1;
                trialResponse{8} = trialResponse{8} + 1;
            end
        end

end

end
