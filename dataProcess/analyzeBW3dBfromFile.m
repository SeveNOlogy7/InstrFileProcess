function [ BWs ] = analyzeBW3dBfromFile( filePath, cfg,varargin )
%ANALYZEBW3DBFROMFILE ��ȡ�����ļ����������ͨ�����׿�

if ~isfield(cfg,'dspTrace')
    cfg.dspTrace = {'A','B','C','D','E','F','G'};
end
if ~isempty(varargin) && strcmp(class(varargin{1}),'double')
    BWs = varargin{1};
else
    BWs = [];
end

if ~isfield(cfg,'smooth')
    cfg.smooth = 0;
end

if strcmp(filePath, '')
    [FileName,PathName,~] = uigetfile('*.csv');
    if FileName == 0
        return
    end
    filePath = [PathName,FileName];
end

[M,txt,~] = xlsread(filePath);
% ����Ҫ���Ƶ�Trace
[r,~] = find(strcmp(txt,'[TRACE DATA]'));
M = M(r-2:end,:);

for ii= 1:length(cfg.dspTrace)
    switch cfg.dspTrace{ii}
        case 'A'
            idx = 1;
        case 'B'
            idx = 2;
        case 'C'
            idx = 3;
        case 'D'
            idx = 4;
        case 'E'
            idx = 5;
        case 'F'
            idx = 6;
        case 'G'
            idx = 7;
        otherwise
            continue;
    end
    temp = M(1:end,2*idx-1:2*idx);
    temp = temp(~isnan(temp));
    temp = reshape(temp,length(temp)/2,2);
    if cfg.smooth ~= 0
        temp(:,2) = smooth(temp(:,2),cfg.smooth);
    end
    BWs = [BWs,analyzeBW3dB(temp)];
end

end
