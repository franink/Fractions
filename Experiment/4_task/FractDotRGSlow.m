function block_p_points = FractLineRGSlow(fract, win, color, time, points)

% Version for practice (relative time unlike real trials)

%set variables to -1 to catch errors and missing data
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.01;
%time_on = time - time_fix;

%initialize log
%trialResponse = {correct response RT Acc p_points};

fractMag = fract(1)/fract(2);
probeMag = fract(4)/fract(5);

%Decide what is correct response
if probeMag > fractMag;
    correct = 1;
end;
if probeMag < fractMag;
    correct = 0;
end;

HideCursor;

%Draw frame
winRect = Screen('Rect', win);
Screen('FrameRect', win, [255 255 255 255], winRect, 30);

%Put Image on screen
path = fileparts(mfilename('fullpath'));
ima=imread([path '/Stimuli/_Orig16/' num2str(fract(4)*3) '_' num2str(fract(5)*3) '_c' num2str(ceil(rand()*4)) '_FirstNumber' , '.bmp']);
Screen('PutImage', win, ima); % put image on screen
Screen('Flip',win); % now visible on screen

tot_time = time - time_fix;
t_start = GetSecs;
time = time+t_start;
KbReleaseWait;
[key, secs] = WaitTill(time, {'3' '4'});
if~isempty(key);
    %trialResponse{2} = key;
    %trialResponse{3} = secs - t_start;
    
    %Let participants know that their answer was reocrded by flipping
    %the screen
    t_remain = tot_time - (secs - t_start);
    Screen('Flip', win);
    WaitSecs(0.05);
    
    Screen('PutImage', win, ima); % put image on screen
    Screen('Flip', win);
    WaitSecs(t_remain);
    
    left = {'4'};
    right = {'3'};
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
