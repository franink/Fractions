function [displacement] = JitterCursor()
%Returns a random number between +/- rangemin to rangemax in percent format

    rangemin = 20;
    rangemax = 40;
%     rangemin = 60;
%     rangemax = 90;
    plusminus = [1 -1];
    posneg = plusminus(round(rand(1)+1));
    displacement = randi([rangemin,rangemax])/100 * posneg;

end

