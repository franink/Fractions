    KbReleaseWait;
    keyResp = 0;
     
    
    while ~keyResp
        
        [keyIsDown, secs, keyCode, deltaSecs]  = KbCheck;   
        
        keypress = find(keyCode==1, 1);
       
        if ~isempty(keypress);
            
            if keypress == 29 %they press z
                keyResp = 1;
            end   
            if keypress == 56 %they press z
                keyResp = 1;
            end
        end
    end