function [ M,Fig ] = readOscilloscope( filePaths, cfg)
%READOSCILLOSCOPE ����ʾ��������ͼ by CJH
%   example��
%       cfg.xFactor = 1000;     % ���������������
%       cfg.xBias = 100;        % �������ƽ������
%       readOscilloscope('C:\Documents\Research\Experiment\F8-DSR\0409\cjh-0409-2000.csv',cfg);

% ������TDS 7154 �ͺŵĵ�ͨ��csv�ļ�
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
        I_max = max([I_max;temp(:,4)]); % �����ֵ
        M = [M,temp(:,3),temp(:,4)];
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
        M(:,4) = smooth(M(:,4),cfg.smooth);   % ����ƽ��ƽ����
    end
    M(:,4) = M(:,4)/max(M(:,4));
    if isfield(cfg,'plot') && cfg.plot == 1
        Fig = figure();
        plot(M(:,3)*cfg.xFactor - cfg.xBias,M(:,4),'LineWidth',cfg.LineWidth);
    end
end
if cfg.plot == 1
    hold off;
    setGcaByCfg(Fig,cfg);   % ���û�ͼ��ʽ
end
end