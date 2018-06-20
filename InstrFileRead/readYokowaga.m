function [ M,Fig ] = readYokowaga(filePath, cfg,varargin)
%READYOKOWAGA ���ƹ���ͼ by CJH
%   How to Use��
%       cfg.dspTrace = {'A','B','C','D','E','F','G'};
%       cfg.smooth = 1;         %����Ϊ����1��ֵ��ƽ��Ч��
%       cfg.LineWidth = 2;      %�����߿��ο�setPlotCfg(cfg)��������������ʹ�����ж����Ĭ��ֵ
%       cfg.export = 1;         %����Ϊ1��MΪƽ���������
%       readYokowaga( '',cfg);  %�Զ���UI���棬ѡȡ����csv�����ļ�����Ч��readYokowaga( [],cfg);
%       readYokowaga('C:\Documents\Research\Experiment\F8-DSR\CJH0407_1.CSV',cfg);
%       readYokowaga('C:\Documents\Research\Experiment\F8-DSR\CJH0409_1.CSV',cfg);
%       readYokowaga(~,~,Fig);  %����Fig�����������е�ͼ���ϵ��ӹ���ͼ

% �������������ͺţ��ɼ��⡢�����⣩��all_trace.csv�ļ��Ķ�ȡ��ʶ��
cfg = setPlotCfg(cfg);          % ��ȡĬ�ϵĻ�ͼ���ã����Ḳ�����������õ�����ֵ
%% ������ò�������δ����ֵ����ΪĬ�ϲ�������������õĺϷ���
if ~isfield(cfg,'dspTrace')     % ����Ҫ���Ƶ�ͨ�����
    cfg.dspTrace = {'A','B','C','D','E','F','G'};
end
if ~isfield(cfg,'smooth')       % �����Ƿ����ƽ������Ŀǰ��ƽ���㷨�ɱ��������ޣ�
    cfg.smooth = 0;
end
if ~isfield(cfg,'export')       % ��Ϊ1���������MΪ���������ݣ�����Ϊԭʼ����
    cfg.export = 0;
end
% Ԥ����������ļ�·��
if isempty(filePath) % ����ļ�·��Ϊ��(����''��[])
    [FileName,PathName,~] = uigetfile('*.csv'); % ��UI�����������
    if FileName == 0
        return
    end
    filePath = [PathName,FileName];
end
% ����ɱ������ Fig
if ~isempty(varargin) && isa(varargin{1},'matlab.ui.Figure')
    Fig = varargin{1};          % �����һ���ɱ����ΪFigure��������Fig����
end
% ����cfg.plot����
if exist('Fig','var')           % ����Ѵ���Figure����
    cfg.plot = 1;               % ����cfg.plotΪ1����ͼ
    Fig = figure(Fig);hold on;  % �ڵ�ǰFigure�����ϻ�ͼ
elseif ~isfield(cfg,'plot')     % δ����Figure������δ����cfg.plot����
    cfg.plot = 1;               % Ĭ������cfg.plotΪ1����ͼ
    Fig = figure();hold on;     % ���µ�Figure����
elseif cfg.plot == 1            % δ����Figure����������cfg.plotΪ1
    Fig = figure();hold on;     % ���µ�Figure����
else
    Fig = [];                   % ��������cfg.plotΪ0���򲻻�ͼ
end
% ��ȡcsv�ļ�
[M,txt,~] = xlsread(filePath);
% ����Ҫ���Ƶ�Trace
[r,~] = find(strcmp(txt,'[TRACE DATA]'));   % �����ļ��ṹ����ȡ�������ݵ�������
M = M(r-2:end,:);               % ���ԭʼ��csv����
if cfg.export == 1
    % ����Ҫ�������������ݣ�����Ϊ�������M�ĳ����½����棬������ͨ����һ��
    M_temp = nan(size(M,1),2*length(cfg.dspTrace));
end
%% ���λ��Ƹ�ͨ��
strings = {'A','B','C','D','E','F','G'};
for ii= 1:length(cfg.dspTrace)
    idx = find(strcmp(strings,cfg.dspTrace{ii}));   % �õ�Ҫ���Ƶ�ͨ����Ӧ��������
    temp = M(1:end,2*idx-1:2*idx);          % ��ȡ��ǰͨ��������
    temp = temp(~isnan(temp));              % �޳���Ч���ݣ���ͬͨ�������ݳ��ȿ��ܲ�ͬ��
    temp = reshape(temp,length(temp)/2,2);
    if cfg.smooth ~= 0
        % �ź�ƽ���㷨����Ҫ���źŽ���ƽ�����ɱ��������޵�ƽ��ֵ��
        % ����histogram��������ޣ�����ƽ��ֵ��
        [N,edges] = histcounts(temp(:,2),35);
        f = findExtMax(N);       % ���й����źŵ������histogramΪ˫��ṹ(������+�źŷ�)
        f = f(N(f)>(length(temp)/100));
        Noise_lim = min(edges(f));
        %���-210ֵ�����������������-210ֱ��ƽ���ᵼ��ʧ�棩
        %�滻��Ϊ�����޵Ĵ�С����ƽ������
        idx_not_210 = temp(:,2) ~= -210;    
        temp(~idx_not_210,2) = Noise_lim;   % ��min(temp(idx_not_210,2))����
        %ƽ������,���ָ�ԭΪ-210��ֵ
        temp(:,2) = smooth(temp(:,2),cfg.smooth);	
        temp(~idx_not_210,2) = -210;                
    end
    if cfg.plot == 1
        plot(temp(:,1),temp(:,2),'LineWidth',cfg.LineWidth);
    end
    if cfg.export == 1  % ��������������
        M_temp(1:size(temp,1),2*ii-1:2*ii) = temp;
    end
end
if cfg.export == 1
    M = M_temp; % ��������������
end
if cfg.plot == 1
    hold off;
    setGcaByCfg(Fig,cfg);   % ���û�ͼ��ʽ
end
end
