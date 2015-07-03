function [p] = TrialLoop(p,t,r,stim,dimStim,end_ITI,end_Stim,start_t, win, c)
%Controls all stages of a single trial
% This includes ITI, Stim presentation and collection of response
% Returns results parameters in p struct

    left = [p.center(1), p.center(2)];

    xLoc = p.stimLocsX(t,r);
    yLoc = p.stimLocsY(t,r);

    stimRect = [p.center(1) + p.radPix*(xLoc) - p.radPix, p.center(2) + p.radPix*(yLoc) - p.radPix,...
                p.center(1) + p.radPix*(xLoc) + p.radPix, p.center(2) + p.radPix*(yLoc) + p.radPix];
    %stimRect = round(stimRect + p.staggered*p.radPix/4.*[1 1 1 1]); % staggered is -1 for up/left, +1 for down/right

    Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, left, 0);
    Screen('DrawingFinished', win);
    Screen('Flip', win);
    p.ITI_StartReal(t,r) = GetSecs - start_t;
    WaitTill(end_ITI);

    frmCnt=1; %frame count
    p.stim_StartReal(t,r) = GetSecs - start_t;   % start a clock to get the stim onset time
    p.targOnTimeReal(t,r) = p.targOnTime(t,r) + start_t;
    % STIMULUS
    FlushEvents;
    
    
    while frmCnt<=p.stimExpose % if we want multiple exposure durations, add that here

        if GetSecs >= end_Stim;
            break
        end
        
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
            
            [resp, timeStamp] = WaitTill({'1','2'}) % buttons need to be decided
%             [resp, timeStamp] = checkForResp(p.keys, p.escape); % checks both buttons...
            if~isempty(resp);
                p.resp(t,r) = resp;
                p.respTime(t,r) = timeStamp; %from stim onset in seconds
                p.rt(t,r) = timeStamp - p.targOnTimeReal(t,r); %from stim dims time
                p.respFrame(t,r) = frmCnt; %from stim onset in frames
            end
            
        end
        frmCnt = frmCnt + 1;
    end
    
    WaitTill(end_Stim);
    p.stim_EndReal(t,r) = GetSecs - start_t;
    
    % clear out screen
    Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, left); %draw fixation point
    Screen('Flip',win);
    
%% Have not checked the code for hits, etc...
     % hits:
    if  p.dimStim(t,r) && ~isempty(resp)
        p.hits = p.hits+1;
        %p.rt(t) = (p.actualRespFrm(t).d(1) - p.targetOnset(t)) * 1/p.fps;
    % misses:
    elseif p.dimStim(t,r) && isempty(resp)
        p.misses = p.misses+1;
        %p.rt(t) = -1; p.rt stays as NaN (for nanmean)
    % false alarms
    elseif ~p.dimStim(t,r) && ~isempty(resp)
        p.falseAlarms = p.falseAlarms+1;
        %p.rt(t) = p.actualRespFrm(t).d(1) * 1/p.fps;
    % correct rejections
    elseif ~p.dimStim(t,r) && isempty(resp)
        p.correctRejections = p.correctRejections+1;
        %p.rt(t) = -1;
    end 
    %% End of section that need to fix
    %end trial loop

end

