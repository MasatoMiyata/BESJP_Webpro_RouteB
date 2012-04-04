function [Tps_c,pumpTime_Start,pumpTime_Stop] =...
    mytfunc_PUMPOpeTIME(Qps_c,AHUsystemName,PUMPahuSet,ahuTime_start,ahuTime_stop)

for dd = 1:365
    
    tmpStart = [];
    tmpStop  = [];
    
    %         if Qps_c(dd,1) > 0    % DEBUG(�N��2���|���v�𓮂���)
    
    for i = 1:length(PUMPahuSet)
        for j = 1:length(AHUsystemName)
            if strcmp(PUMPahuSet(i),AHUsystemName(j))
                break
            end
        end
        if ahuTime_start(dd,j)==0 && ahuTime_stop(dd,j)==0
            tmpStart = [tmpStart,ahuTime_start(dd,j)];  % DEBUG(�N��2���|���v�𓮂���)
            tmpStop  = [tmpStop,ahuTime_stop(dd,j)];    % DEBUG(�N��2���|���v�𓮂���)
        else
            tmpStart = [tmpStart,ahuTime_start(dd,j)];
            tmpStop  = [tmpStop,ahuTime_stop(dd,j)];
        end
    end
    
    pumpTime_Start(dd,1) = min(tmpStart);
    pumpTime_Stop(dd,1)  = max(tmpStop);
    
    if max(tmpStop) >= min(tmpStart)
        Tps_c(dd,1) = max(tmpStop)-min(tmpStart);
    else
        Tps_c(dd,1) = min(tmpStart)+(24-max(tmpStop));
    end
    
    % DEBUG(�N��2���|���v�𓮂���)
    %         else
    %             Tps_c(dd,1) = 0;
    %             pumpTime_Start(dd,1) = 0;
    %             pumpTime_Stop(dd,1) = 0;
    %         end
    
end
end