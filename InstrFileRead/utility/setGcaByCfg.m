function [ Fig ] = setGcaByCfg( Fig,cfg )
% setGcaByCfg 设置当前绘图坐标轴属性

figure(Fig);

% 设置绘图格式
Axeses = get(Fig,'Children');% 改为修改figure下的所有axes，从此适用于subfigure
for ii = 1:length (Axeses)
    if isa(Axeses(ii),'matlab.graphics.axis.Axes')
        set(Axeses(ii),'FontSize',cfg.AxisFontSize,...
            'FontWeight',cfg.AxisFontWeight,...
            'FontName',cfg.FontName,...
            'LabelFontSizeMultiplier',cfg.LabelFontSizeMultiplier,...
            'Box',cfg.AxisBox);
    end
end

end

