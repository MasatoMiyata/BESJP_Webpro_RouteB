% mytfunc_AHUOpeTimeSplit.m
%                                                by Masato Miyata 20120302
%-------------------------------------------------------------------------
% ���ʋ󒲉^�]���Ԃ��[�^�]���Ԃƒg�[�^�]���ԂɐU�蕪����
%-------------------------------------------------------------------------

function [Tahu_c,Tahu_h] = ...
    mytfunc_AHUOpeTimeSplit(QroomAHUc,QroomAHUh,AHUsystemT)

if AHUsystemT == 0
    % ���󒲎��Ԃ�0�ł���΁A��g�[�󒲎��Ԃ�0�Ƃ���B
    Tahu_c = 0;
    Tahu_h = 0;
else
    
    if QroomAHUc==0 && QroomAHUh==0
        % �O���@��z��
        Tahu_c = AHUsystemT;    % �O���@�̏ꍇ�́u��[���v�ɉ^�]���Ԃ���������B
        Tahu_h = 0;
        
    elseif QroomAHUc == 0
        Tahu_c = 0;
        Tahu_h = AHUsystemT;
        
    elseif QroomAHUh == 0
        Tahu_c = AHUsystemT;
        Tahu_h = 0;
        
    else
        
        if abs(QroomAHUc) <= abs(QroomAHUh)
            % �g�[���ׂ̕����傫���ꍇ
            Tahu_c = ceil(abs(QroomAHUc)./(abs(QroomAHUc)+abs(QroomAHUh)).*AHUsystemT);
            Tahu_h = AHUsystemT - Tahu_c;
        else
            % ��[���ׂ̕����傫���ꍇ
            Tahu_h = ceil(abs(QroomAHUh)./(abs(QroomAHUc)+abs(QroomAHUh)).*AHUsystemT);
            Tahu_c = AHUsystemT - Tahu_h;
        end
        
    end
end


