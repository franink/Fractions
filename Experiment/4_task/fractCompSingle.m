function [ compResults ] = fractCompSingle( compFract, win, color )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



correct = -1;
response = -1;
accuracy = -1

fractMag = compFract(1)/compFract(2);

if fractMag < 0.6;
    correct = 0;
end

if fractMag > 0.6;
    correct = 1;
end


compResults = {0.6 correct response 0 accuracy};

        fixation = ['X', 'X'];
        DrawCenteredFrac(fixation,win,color);
        Screen('Flip', win);
        
    KbReleaseWait;
    keyResp = 0;
     
    t_start = GetSecs;
    
    while ~keyResp
        
        [keyIsDown, secs, keyCode, deltaSecs]  = KbCheck;   
        
        keypress = find(keyCode==1, 1);
       
        if ~isempty(keypress);
            
            if keypress == 29 %they press z
                keyResp = 1;
                response = 0;
                compResults{3} = response;   
                compResults{4} = secs - t_start;
                compResults{5} = correct==response;
            end
            
            if keypress == 56 %they press /
                keyResp = 1;
                response = 1;
                compResults{3} = response;
                compResults{4} = secs - t_start;
                compResults{5} = correct==response;
            end
            
        end
    end
            
    
        
end

