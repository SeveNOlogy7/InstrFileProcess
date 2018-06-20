function [ cfg ] = setPlotCfg( cfg )
%SETPLOTCFG 此处显示有关此函数的摘要
%   此处显示详细说明
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

