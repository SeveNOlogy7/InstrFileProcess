function [Fig] = setPlotByCfg( Fig,cfg )
%SET_GCABYCFG
%   Ŀǰֻ����������plot���ɵ���ͼ
%   ������readϵ�к������Ƶ�plotͼ��Ҳ���������л��Ƶ�
%   ֮ǰ���ú�������set_gcaByCfg
%   ���������ͼ�ζ��������ɺ����

[ cfg ] = setPlotCfg( cfg );    % ��������ȱʧ����������ΪĬ������

if ~isfield(cfg,'LineStyles')
    cfg.LineStyles = {'-','--',':','-.'};
end

setGcaByCfg(Fig,cfg );

Axeses = get(Fig,'Children');% ��ȡfigure�µ�����axes��Line���Ӵ�������subfigure
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
legend('boxoff');   % ͼ������ʾ��

end

