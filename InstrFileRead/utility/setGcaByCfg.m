function [ Fig ] = setGcaByCfg( Fig,cfg )
% setGcaByCfg ���õ�ǰ��ͼ����������

figure(Fig);

% ���û�ͼ��ʽ
Axeses = get(Fig,'Children');% ��Ϊ�޸�figure�µ�����axes���Ӵ�������subfigure
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

