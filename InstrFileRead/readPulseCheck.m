function [  M,Fig ] = readPulseCheck( filePaths, cfg, varargin )
%READPULSECHECK ����PulseCheck������ǵ�����ؼ�
%       �ο�readOscilloscope����������Fig���������ӻ�ͼ
%       ���ļ���ͼʱ������cfg.align = 1�����Զ���zero level

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
if ~isempty(varargin) && strcmp(class(varargin{1}),'matlab.ui.Figure')
    Fig = varargin{1};
end
if exist('Fig','var')
    cfg.plot = 1;
    Fig = figure(Fig);hold on;
elseif ~isfield(cfg,'plot')
    cfg.plot = 1;
    Fig = figure();hold on;
elseif cfg.plot == 1
    Fig = figure();hold on;
else
    Fig = [];
end
% �����˿�·��
if isempty(filePaths)    % �����·�����UI�����������
    [FileName,PathName,~] = uigetfile('*.csv'); % ���Կ���ʹ��multiselectģʽ
    if FileName == 0
        return
    end
    filePaths = [PathName,FileName];
end
% �����˶��·��(cell)
if iscell(filePaths) && length(filePaths)>1
    if ~isfield(cfg,'align')
        cfg.align = 1;
    end
else
    cfg.align = 0;
end

if iscell(filePaths)
    % �����˶����ͨ��txt�ļ�·��
    % ���������������ͬ���Ĳ��������²�����
    M = [];
    I_max = 0;
    for ii = 1:length(filePaths)
        [time,acf] = importAC(filePaths{ii});
        I_max = max([I_max;acf]); % �����ֵ
        M = [M,time,acf];
    end
    
    for ii = 1:length(filePaths)
        if cfg.smooth ~= 0
            M(:,2*ii) = smooth(M(:,2*ii),cfg.smooth);   % ����ƽ��ƽ����
        end
        M(:,2*ii) = M(:,2*ii)/I_max;    % ��һ��
    end
    if cfg.align == 1
        acf_range = 2*(1:length(filePaths));
        I_min = min(M(:,acf_range));    % ����Сֵ����ͬ������zero level���ܲ�ͬ
        M(:,acf_range) = M(:,acf_range)-repmat(I_min,length(acf),1);
    end
    if cfg.plot == 1
        for ii = 1:length(filePaths)
            plot(M(:,2*ii-1)*cfg.xFactor - cfg.xBias,M(:,2*ii),'LineWidth',cfg.LineWidth);
        end
        hold off;
    end
    
else
    [time,acf] = importAC(filePaths);
    acf = acf/max(acf);
    if cfg.smooth ~= 0
        acf = smooth(acf,cfg.smooth);   % ����ƽ��ƽ����
    end
    M = [time,acf];
    if isfield(cfg,'plot') && cfg.plot == 1
        plot(time*cfg.xFactor - cfg.xBias,acf,'LineWidth',cfg.LineWidth);
    end
end
if cfg.plot == 1
    setGcaByCfg(Fig,cfg);   % ���û�ͼ��ʽ
end
end