function [ compResults ] = natComp( stim, win, color)
%Natural number comparison... two stims



correct = -1;

LNum = stim(1)
RNum = stim(2)
% 
% if LNum > RNum
%     correct = 0;
% end
% 
% if LNum < RNum
%     correct = 1;
% end

response = -1;

compResults = [LNum RNum correct response 0];

        DrawNatComp(LNum, RNum, win, color)
        Screen('Flip', win)
        
    KbReleaseWait;
    keyResp = 0;
     
    t_start = GetSecs;
    
    while ~keyResp
        
        [keyIsDown, secs, keyCode, deltaSecs]  = KbCheck;   
        
        keypress = find(keyCode==1, 1);
       
        if ~isempty(keypress);
            
            if keypress == 29 %they press z
                keyResp = 1;
                compResults(5) = 0;   
                compResults(6) = secs - t_start;
            end
            
            if keypress == 56 %they press /
                keyResp = 1;
                compResults(5) = 1;
                compResults(6) = secs - t_start;
            end
            
        end
    end
            
    
        
end

