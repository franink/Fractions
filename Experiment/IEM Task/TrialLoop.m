function [p] = TrialLoop(p,t,r,stim,dimStim,end_ITI,end_Stim,start_t, win)
%Controls all stages of a single trial
% This includes ITI, Stim presentation and collection of response
% Returns results parameters in p struct

    left = [p.center(1), p.center(2)];

    xLoc = p.stimLocsX(t,r);
    yLoc = p.stimLocsY(t,r);
    
    if xLoc == 0
        if yLoc ~= 0
            yLoc = yLoc + (rand - 0.5);
        end
    else
        xLoc = xLoc + (rand - 0.5);
    end
    
    p.stimLocsX(t,r) = xLoc;
    p.stimsLocY(t,r) = yLoc;
    
    stimRect = [p.center(1) + p.radPix*(xLoc) - p.radPix, p.center(2) + p.radPix*(yLoc) - p.radPix,...
                p.center(1) + p.radPix*(xLoc) + p.radPix, p.center(2) + p.radPix*(yLoc) + p.radPix];
    %stimRect = round(stimRect + p.staggered*p.radPix/4.*[1 1 1 1]); % staggered is -1 for up/left, +1 for down/right

    Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, left, 0);
    Screen('DrawingFinished', win);
    Screen('Flip', win);
    WaitTill(start_t + p.ramp_up);
    p.ITI_StartReal(t,r) = GetSecs - start_t;
    WaitTill(end_ITI);

    frmCnt=1; %frame count
    p.stim_StartReal(t,r) = GetSecs - start_t;   % start a clock to get the stim onset time
    p.targOnTimeReal(t,r) = p.targOnTime(t,r) + p.stim_StartReal(t,r);
    % STIMULUS
    FlushEvents;
    
    %% Eye tracker section
        if p.eyetrack
            % Sending a 'TRIALID' message to mark the start of a trial in Data 
            % Viewer.  This is different than the start of recording message 
            % START that is logged when the trial recording begins. The viewer
            % will not parse any messages, events, or samples, that exist in 
            % the data file prior to this message. 
            Eyelink('Message', 'TRIALID %d', t);

            % This supplies the title at the bottom of the eyetracker display
            Eyelink('command', 'record_status_message "TRIAL %d"', t);
            
            Eyelink('Message', 'Stim Onset');
        end      
        %% End Eye tracker section  
    
    while frmCnt<=p.stimExpose % if we want multiple exposure durations, add that here
        if GetSecs >= end_Stim;
            break
        end
        %frmCnt
        if ~p.null(t)
            if p.dimStim(t,r) && p.stimDimSequ(t,r,frmCnt) % if stim is dimmed right now, draw a dimStim
                Screen('DrawTexture',win,dimStim(p.flickerSequ(1,frmCnt)),Screen('Rect',dimStim(p.flickerSequ(1,frmCnt))),stimRect);
            else % otherwise, draw a regular stim (both determined by flickerSequ)
                Screen('DrawTexture',win,stim(p.flickerSequ(1,frmCnt)),Screen('Rect',stim(p.flickerSequ(1,frmCnt))),stimRect);
            end
            
            % apperture around fixation
            Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, left, 0); %change fixation point
            
%             if ~p.dimStim(t) && p.stimSequ(t,frmCnt)>2
%                Screen('DrawTexture',w, stim(p.stimSequ(t,frmCnt)-2),Screen('Rect',stim(p.stimSequ(t,frmCnt))),stimRect);
%             else
%                Screen('DrawTexture',w, stim(p.stimSequ(t,frmCnt)),Screen('Rect',stim(p.stimSequ(t,frmCnt))),stimRect);
%             end

            Screen('DrawingFinished', win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
            Screen('Flip', win);

            % check response...
            
            [resp, timeStamp] = ReadKey('1'); % buttons need to be decided
%             [resp, timeStamp] = checkForResp(p.keys, p.escape); % checks both buttons...
            if~isempty(resp);
                if p.resp(t,r) == 0; %Prevent that participant clicks more than once
                    p.resp(t,r) = str2num(resp);
                    p.respTime(t,r) = (timeStamp - start_t) - p.stim_StartReal(t,r); %from stim onset in seconds
                    p.rt(t,r) = (timeStamp - start_t) - p.targOnTimeReal(t,r); %from stim dims time
                    p.respFrame(t,r) = frmCnt; %from stim onset in frames
                end
            end
        else
            resp = NaN;
            p.resp(t,r) = NaN;
            p.respTime(t,r) = NaN; %from stim onset in seconds
            p.rt(t,r) = NaN; %from stim dims time
            p.respFrame(t,r) = NaN; %from stim onset in frames
            p.hit(t,r) = NaN;
            p.miss(t,r) = NaN;
            p.falseAlarm(t,r) = NaN;
            p.correctRejection(t,r) = NaN;
            
        end
        frmCnt = frmCnt + 1;
    end
    
    WaitTill(end_Stim);
    p.stim_EndReal(t,r) = GetSecs - start_t;
    
    %% eye track section
    if p.eyetrack
        Eyelink('Message', 'Stim End');
    end
    %% end eye track section
    
    % clear out screen
    Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, left); %draw fixation point
    Screen('Flip',win);
    
     % hits:
    if  p.dimStim(t,r) && p.resp(t,r) == 1
        if p.rt(t,r) <= p.responseWindow
            p.hits = p.hits+1;
            p.hit(t,r) = 1;
        else
            p.misses = p.misses+1;
            p.miss(t,r) = 1;
        end

    % misses:
    elseif p.dimStim(t,r) && p.resp(t,r) == 0
        p.misses = p.misses+1;
        p.miss(t,r) = 1;

    % false alarms
    elseif ~p.dimStim(t,r) && p.resp(t,r) == 1
        p.falseAlarms = p.falseAlarms+1;
        p.falseAlarm(t,r) = 1;

    % correct rejections
    elseif ~p.dimStim(t,r) && p.resp(t,r) == 0
        p.correctRejections = p.correctRejections+1;
        p.correctRejection(t,r) = 1;

    end 
    %end trial loop

end

