% mytfunc_AHUOpeTimeSplit.m
%                                                by Masato Miyata 20120302
%-------------------------------------------------------------------------
% 日別空調運転時間を冷房運転時間と暖房運転時間に振り分ける
%-------------------------------------------------------------------------

function [Tahu_c,Tahu_h] = ...
    mytfunc_AHUOpeTimeSplit(QroomAHUc,QroomAHUh,AHUsystemT)

if AHUsystemT == 0
    % 日空調時間が0であれば、冷暖房空調時間は0とする。
    Tahu_c = 0;
    Tahu_h = 0;
else
    
    if QroomAHUc==0 && QroomAHUh==0
        % 外調機を想定
        Tahu_c = AHUsystemT;    % 外調機の場合は「冷房側」に運転時間を押しつける。
        Tahu_h = 0;
        
    elseif QroomAHUc == 0
        Tahu_c = 0;
        Tahu_h = AHUsystemT;
        
    elseif QroomAHUh == 0
        Tahu_c = AHUsystemT;
        Tahu_h = 0;
        
    else
        
        if abs(QroomAHUc) <= abs(QroomAHUh)
            % 暖房負荷の方が大きい場合
            Tahu_c = ceil(abs(QroomAHUc)./(abs(QroomAHUc)+abs(QroomAHUh)).*AHUsystemT);
            Tahu_h = AHUsystemT - Tahu_c;
        else
            % 冷房負荷の方が大きい場合
            Tahu_h = ceil(abs(QroomAHUh)./(abs(QroomAHUc)+abs(QroomAHUh)).*AHUsystemT);
            Tahu_c = AHUsystemT - Tahu_h;
        end
        
    end
end


