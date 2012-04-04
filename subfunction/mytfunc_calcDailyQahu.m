% mytfunc_calcDailyQahu.m
%                                       by Masato Miyata 2012/03/02
%------------------------------------------------------------------
% ���ώZ�󒲕��ׂ̎Z�o
%------------------------------------------------------------------
function [Qahu_c,Qahu_h,Qahu_CEC] = mytfunc_calcDailyQahu(AHUsystemT,...
    Tahu_c,Tahu_h,QroomAHUc,QroomAHUh,qoaAHU,qoaAHU_CEC,ahuOAcut)


if Tahu_c==0 && Tahu_h==0
    
    % �O�C���ׂ����̏ꍇ(������C��[���ׂɓ���Ă���)
    if ahuOAcut == 0
        Qahu_c = qoaAHU.*AHUsystemT.*3600/1000; % �ώZ�l [MJ/day]
    elseif ahuOAcut == 1 % �O�C�J�b�g����
        if AHUsystemT>1 % �󒲎��Ԃ�1���Ԗ����̂Ƃ��͗�O����
            Qahu_c = qoaAHU.*(AHUsystemT-1).*3600/1000; % �ώZ�l [MJ/day]
        else
            Qahu_c = qoaAHU.*AHUsystemT.*3600/1000; % �ώZ�l [MJ/day]
        end
    end
    
    Qahu_h = 0;
    
else
    
    % ��[���� [MJ/day]
    if Tahu_c > 0
        if ahuOAcut == 1 && Tahu_c > 1
            Qahu_c = QroomAHUc + qoaAHU.*(Tahu_c-1).*3600/1000; % �ώZ�l [MJ/day]
        else
            Qahu_c = QroomAHUc + qoaAHU.*Tahu_c.*3600/1000; % �ώZ�l [MJ/day]
        end
    else
        Qahu_c = 0;
    end
    
    % �g�[���� [MJ/day]
    if Tahu_h > 0
        if ahuOAcut == 1 && Tahu_h > 1
            Qahu_h = QroomAHUh + qoaAHU.*(Tahu_h-1).*3600/1000; % �ώZ�l [MJ/day]
        else
            Qahu_h = QroomAHUh + qoaAHU.*Tahu_h.*3600/1000; % �ώZ�l [MJ/day]
        end
    else
        Qahu_h = 0;
    end
    
end

% ���z�󒲕��� [MJ/day]
Qahu_CEC = abs(QroomAHUc) + abs(QroomAHUh) + abs(qoaAHU_CEC.*AHUsystemT.*3600/1000);


