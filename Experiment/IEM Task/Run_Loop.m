function [p] = Run_Loop(filename, win, p)
%Controls the loop for each run of IEM task
%   returns p struct with all data, saves partial data if something fails

try
        
    DisplayInstructsPractice;
    
    %any practice we decide to do goes here
    
    DisplayInstructs4; %End of practice ask question and get ready to start this name can change if I don't have anythin else to show
    
    p.start_Exp =datestr(now); % for record purpose
    
    
    for r= 1:p.runs
        %% check this section
        % generate checkerboards we use...
        p.stimContrast = 1;
        p.targetContrast = p.stimContrast - p.stimContrastChange;
        c = make_checkerboard(p.radPix,p.sfPix,p.stimContrast);
        stim(1)=Screen('MakeTexture', win, c{1});
        stim(2)=Screen('MakeTexture', win, 127*ones(size(c{2})));
        stim(3)=Screen('MakeTexture', win, c{2});
        T = make_checkerboard(p.radPix,p.sfPix,p.targetContrast);
        dimStim(1)=Screen('MakeTexture', win, T{1});
        dimStim(2)=stim(2);
        dimStim(3)=Screen('MakeTexture', win, T{2});
        
        % generate a distribution for choosing the target time
        nStims = (p.stimExpose/p.refreshRate)*(p.flickerFreq ); % nStims = # periods to show (# of stim1/stim2 or targ1/targ2 alternations)
        p.targX = p.minTargFrame:p.minTargSep:p.maxTargFrame;   % this will be used to select when to show target(s)
        for ii=1:p.nTrials
            tmp = randperm(length(p.targX));
            %p.targFrame(ii,:) = sort(p.targX(tmp(1:p.nTargs)))*(p.flickerFreq*2)-(p.flickerFreq*2)+1;
            p.targFrame(ii,:) = sort(p.targX(tmp(1:p.nTargs)))*(p.flickerFrames) - p.flickerFrames+1;
            p.targOnTime(ii,:) = p.targFrame(ii,:).*(1/p.refreshRate);
            p.targMaxRespTime(ii,:) = (p.targFrame(ii,:).*(1/p.refreshRate))+p.responseWindow;
        end
        
        % pick the stimulus sequence for every trial (the exact grating to be shown)
        for i=1:p.nTrials
            p.flickerSequ = repmat([ones(1,round(p.flickerFrames/2)) 2*ones(1,round(p.flickerFrames/2))],1,round(p.stimExpose/p.flickerFrames));
            p.stimSequ(1,:)=p.flickerSequ;
            p.flickerSequ = repmat([ones(1,round(p.flickerFrames/2)) 2*ones(1,round(p.flickerFrames/2)) 3*ones(1,round(p.flickerFrames/2)) 2*ones(1,round(p.flickerFrames/2))],1,(0.5)*round(p.stimExpose/p.flickerFrames));
            p.stimDimSequ(i,:) = zeros(1,size(p.flickerSequ,2));
            % mark the tarket spots with low contrast stims
            for j=1:p.nTargs
                p.stimDimSequ(i,p.targFrame(i,j):p.targFrame(i,j)+2*p.flickerFrames-1) = 1;
                %p.stimSequ(i,p.targFrame(i,j):p.targFrame(i,j)+2*p.flickerFrames-1)=p.stimSequ(i,p.targFrame(i,j):p.targFrame(i,j)+2*p.flickerFrames-1)+2;
                % +2 above --> change to "target"
            end
        end
        %% end of section to be checked
        % wait for scanner trigger '5'
        DrawCenteredNum('Waiting for experimenter', win, p, 0.3);
        WaitTill('9');
        DrawCenteredNum('Waiting for scanner', win, p, 0.3);
        WaitTill('5'); %Use this only if used in a scanner that sends 5
        
        % Send trigger to scanner
        s = serial('/dev/tty.usbmodem12341', 'BaudRate', 57600);
        fopen(s);
        fprintf(s, '[t]');
        fclose(s);
        
        start_t = GetSecs;
        
        p.startRun(r) = start_t;
        WaitTill(start_t + p.ramp_up);
        
        for t = 1:p.nTrials
            
            end_ITI = p.StimOnset(t,r) + start_t;
            end_Stim = p.StimEnd(t,r) + start_t;
            
            p = TrialLoop(p,center,t,r,stim, dimStim, end_ITI, end_Stim, start_t); %This loop draws a fixation and draws a stim
            
        end
        
        p.endRun(r) = GetSecs;
        p.durRun(r) = p.endRun(r) - p.startRun(r);
        
        DisplayInstructs3; %Rest break (Again Number of file might change once I figure how many instructions I need
    end
    
    p.endExp = datestr(now);
    
    catch
    ple
    ShowCursor;
    sca
    save([filename '_catch']);
    save(filename, 'p');
    ListenChar(1);

end

