% 運転時間の和集合をとる
%------------------------------------------------------
% 入力：
%  start  各系統に属する機器／室の運転開始時間（365×系統数）
%  stop   各系統に属する機器／室の運転開始時間（365×系統数）
% 出力：
%  systemOpeTime : 24時間の運転時間（365×24）
%------------------------------------------------------

function systemOpeTime = mytfunc_calcOpeTime(start,stop)

% 接続されているシステムの数
numsys = size(start,2);

systemOpeTime = zeros(365,24);

for dd = 1:365
    
    % 結果格納用
    tmp = zeros(numsys,24);
    
    for i=1:numsys
        
        if start(dd,i) == 0 && stop(dd,i) == 0
            tmp(i,:) = zeros(1,24);

        elseif start(dd,i) < stop(dd,i)  % 日を跨がない場合
            for hh = 1:24
                if hh > start(dd,i) && hh <= stop(dd,i)
                    tmp(i,hh) = 1;
                end
            end
        else   % 日を跨ぐ場合
            for hh = 1:24
                if hh > start(dd,i) || hh <= stop(dd,i)
                    tmp(i,hh) = 1;
                end
            end
        end
        
    end
    
    % 和集合をとる
    sumtmp = sum(tmp,1);
    
    for hh=1:24
        if sumtmp(hh) > 0
            systemOpeTime(dd,hh) = 1;
        end
    end
    
end

