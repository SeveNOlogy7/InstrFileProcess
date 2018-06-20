function [ cfg ] = setPlotCfg( cfg )
%SETPLOTCFG �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if ~isfield(cfg,'LineWidth')
    cfg.LineWidth = 2;
end
if ~isfield(cfg,'LabelFontSize')
    cfg.LabelFontSize = 23;
end
if ~isfield(cfg,'AxisFontSize')
    cfg.AxisFontSize = 23;
end
if ~isfield(cfg,'AxixFontWeight')
    cfg.AxisFontWeight = 'bold';
end
if ~isfield(cfg,'AnnoFontSize')
    cfg.AnnoFontSize = 23;
end
if ~isfield(cfg,'AxixBox')
    cfg.AxisBox = 'on';
end
if ~isfield(cfg,'FontName')
    cfg.FontName = 'Times New Roman';
end
if ~isfield(cfg,'LabelFontSizeMultiplier')
    cfg.LabelFontSizeMultiplier = cfg.LabelFontSize/cfg.AxisFontSize;
end
if ~isfield(cfg,'TitleFontSizeMultiplier')
    cfg.TitleFontSizeMultiplier = cfg.LabelFontSizeMultiplier*1.2;
end
end

