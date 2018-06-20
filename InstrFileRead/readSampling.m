function [ M,Fig ] = readSampling( filePaths, cfg )
%READSAMPLING ���Ʋ���ʾ��������ͼ by CJH
%   example��
%       cfg.xFactor = 1000;     % ���������������
%       cfg.xBias = 100;        % �������ƽ������
%       readSampling('C:\Documents\Research\Experiment\F8-DSR\0409\cjh-0409-2000.csv',cfg);

% �����˲���ʾ�����ĵ�ͨ��csv�ļ�
Fig = [];
cfg = setPlotCfg(cfg);
if ~isfield(cfg,'xFactor')
    cfg.xFactor = 1;
end
if ~isfield(cfg,'xBias')
    cfg.xBias = 0;
end
if ~isfield(cfg,'plot')
    cfg.plot = 1;
end
if ~isfield(cfg,'smooth')
    cfg.smooth = 0;
end
% �����˿�·��
if isempty(filePaths)    % �����·�����UI�����������
    [FileName,PathName,~] = uigetfile('*.csv'); % ���Կ���ʹ��multiselectģʽ
    if FileName == 0
        return
    end
    filePaths = [PathName,FileName];
end
if iscell(filePaths)
    % �����˶����ͨ��csv�ļ�·��
    % ���������������ͬ���Ĳ��������²�����
    M = [];
    I_max = 0;
    for ii = 1:length(filePaths)
        [temp,~,~] = xlsread(filePaths{ii});
        I_max = max([I_max;temp(:,2)]); % �����ֵ
        M = [M,temp(:,1),temp(:,2)];
    end
    for ii = 1:length(filePaths)
        if cfg.smooth ~= 0
            M(:,2*ii) = smooth(M(:,2*ii),cfg.smooth);   % ����ƽ��ƽ����
        end
        M(:,2*ii) = M(:,2*ii)/I_max;    % ��һ��
    end    
    if cfg.plot == 1
        Fig = figure();hold on;
        for ii = 1:length(filePaths)
            plot(M(:,2*ii-1)*cfg.xFactor - cfg.xBias,M(:,2*ii),'LineWidth',cfg.LineWidth);
        end
        hold off;
    end    
else
    % �����˵��ļ�·��
    [M,~,~] = xlsread(filePaths);
    if cfg.smooth ~= 0
        M(:,2) = smooth(M(:,2),cfg.smooth);   % ����ƽ��ƽ����
    end
    M(:,2) = M(:,2)/max(M(:,2));
    if isfield(cfg,'plot') && cfg.plot == 1
        Fig = figure();
        plot(M(:,1)*cfg.xFactor - cfg.xBias,M(:,2),'LineWidth',cfg.LineWidth);
    end
end
if cfg.plot == 1
    setGcaByCfg(Fig,cfg);   % ���û�ͼ��ʽ
end
end