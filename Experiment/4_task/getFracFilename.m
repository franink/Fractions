function [ filenameMAT ] = GetFracFileName()
%GetFilename prompts the user/subject to enter subj number ID then creates
%a new, unique filename includin the number, date, value of randstream
%used, etc.

% get a unique data file name
expInfo.program = 'Frac_';
expInfo.subjectID = [];

while(length(expInfo.subjectID)~=5)
    expInfo.subjectID =input('Enter subject ID (5 digits) : ','s');
end

expInfo.subjectID = upper(expInfo.subjectID);
expInfo.date = datestr(now,'mmmddyy');
filenameMAT = [expInfo.program expInfo.subjectID '-' expInfo.date 'a.mat'];

ii = 1;

while exist([filenameMAT])
    filenameMAT = [expInfo.program expInfo.subjectID expInfo.date char(97+ii) '.mat'];
    ii = ii+1;
end

end

