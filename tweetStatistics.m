close all
clear all

% count how many tweets in the file (lines).
if (isunix) 
    [~, numstr] = system( ['wc -l ', 'tweets.txt'] );
    twNumber=str2double(numstr);
elseif (ispc) 
    if exist('countlines.pl','file')~=2
        fid=fopen('countlines.pl','w');
        fprintf(fid,'%s\n%s','while (<>) {};','print $.,"\n";');
        fclose(fid);
    end
    twNumber=str2double( perl('countlines.pl', 'tweets.txt') );
end

wordspool = [];
uniquepertw = [];

% open tweets file and read line by line (tweet by tweet)
fid = fopen('.\tweet_input\tweets.txt');

% count number of unique words for each tw
for n = 1:twNumber
    C = textscan(fid, '%s', 1, 'delimiter', '\n');
    str = C{:};      
    if isempty(str{1,1}) == 0
        currentmsg = str{1,1};
        currentmsgscan = textscan(currentmsg,'%s');
        currentmsgstr = currentmsgscan{:};    
        [i,j,k] = unique(currentmsgstr);
        freq = hist(k,(1:numel(j))')';
        uniquenumber = length(freq);
        uniquepertw = [uniquepertw; uniquenumber];       
        wordspool = [wordspool;currentmsgstr];  
    end   
end

for q = 1 : length(uniquepertw)
    medunique(q) = mean(uniquepertw(1:q));
end

% count number of unique words for all tws
[ii,jj,kk]=unique(wordspool);
freq=hist(kk,(1:numel(jj))')';
D = [ii num2cell(freq)];
uniqueintotal = 0; 
for p = 1: length(freq)
     if freq(p) == 1
         uniqueintotal = uniqueintotal + 1;
     end
 end
uniqueintotal;

% show results of features 1 and 2 on screen directly;
% [ii num2cell(freq)]
% medunique
% uniquepertw

% save ft1 and ft2
if exist('.\tweet_output','dir')== 0
mkdir('.\tweet_output')
end

A = freq;
B = ii;
C2 = [B, arrayfun(@num2str, [A], 'UniformOutput', false)]'; % <- note the transpose
f = fopen('.\tweet_output\ft1.txt', 'w');
fprintf(f, '%s\t%s\n', C2{:}); % 
fclose(f);


% update median number
medunique = medunique'
save('.\tweet_output\ft2.txt','medunique','-ASCII');

fclose(fid);