function trialResponse = FractDotRGSlow_Abs(fract, win, color, end_decision, ctch, points, LR)

% Version for real experiment in absolute time (unlike practice trials)

% rng shuffle
%set variables to -1 to catch missing trials and errors
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.05; %Allows code to exit to keep experiment on time
Num_probe = -1;
Denom_probe = -1;
probeMag = -1;

%Initialize log
trialResponse = {Num_probe Denom_probe probeMag correct response RT Acc points};


if ctch;
    Num_probe = fract(4);
    Denom_probe = fract(5);
    fractMag = fract(1)/fract(2);
    probeMag = fract(4)/fract(5);
    
    %Decide what is correct response
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
    
    %Draw frame
    winRect = Screen('Rect', win);
    Screen('FrameRect', win, [255 255 255 255], winRect, 30);
    
    %Put Image on screen
    ima=imread([pwd '/Stimuli/_Orig16/' num2str(fract(4)*3) '_' num2str(fract(5)*3) '_c' num2str(ceil(rand()*4)) '_FirstNumber' , '.bmp']);
    Screen('PutImage', win, ima); % put image on screen
    Screen('Flip',win); % now visible on screen

    
    t_start = GetSecs;
    KbReleaseWait;
        time = end_decision-time_fix;
        [key, secs] = WaitTill(time, {'1' '2' '3' '4' '6' '7' '8' '9'});
        if~isempty(key);
            trialResponse{5} = str2double(key);
            trialResponse{6} = secs - t_start;
            %Let participants know their response was recorded by flipping
            %the screen
            t_remain = time - secs;
            Screen('Flip', win);
            WaitSecs(0.05);
            
            Screen('PutImage', win, ima); % put image on screen
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
            trialResponse{7} = correct==response;
            if trialResponse{7} == 1;
                trialResponse{8} = trialResponse{8} + 1;
            end
        end
   
end

end
