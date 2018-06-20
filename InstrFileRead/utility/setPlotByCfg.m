function [Fig] = setPlotByCfg( Fig,cfg )
%SET_GCABYCFG
%   目前只适用于设置plot生成的线图
%   可以是read系列函数绘制的plot图，也可以是自行绘制的
%   之前曾用函数名：set_gcaByCfg
%   最好在所有图形对象插入完成后调用

[ cfg ] = setPlotCfg( cfg );    % 检查配置项，缺失的配置项设为默认配置

if ~isfield(cfg,'LineStyles')
    cfg.LineStyles = {'-','--',':','-.'};
end

setGcaByCfg(Fig,cfg );

Axeses = get(Fig,'Children');% 获取figure下的所有axes的Line，从此适用于subfigure
for ii = 1:length (Axeses)
    if isa(Axeses(ii),'matlab.graphics.axis.Axes')
        if isa(get(Axeses(ii),'Children'),'matlab.graphics.chart.primitive.Line')
            Lines = get(Axeses(ii),'Children');
            for jj = 1:length(Lines)
                set(Lines(jj),'LineStyle',cfg.LineStyles{mod(jj-1,length(cfg.LineStyles))+1});
            end
            set(Lines,'LineWidth',cfg.LineWidth);
        end
    end
end
legend('boxoff');   % 图例不显示框

end

