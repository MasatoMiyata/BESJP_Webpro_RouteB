function [Tps_c,pumpsystemOpeTime] =...
    mytfunc_PUMPOpeTIME(Qps_c,AHUsystemName,PUMPahuSet,AHUsystemOpeTime)

% for dd = 1:365

% �e���̃|���v�^�]����
Tps_c = zeros(365,1);
% �|���v�̉^�]���ԃ}�g���b�N�X
pumpsystemOpeTime = zeros(365,24);

if isempty(PUMPahuSet) == 0
    
%     tmpStart = [];
%     tmpStop  = [];
    
    %         if Qps_c(dd,1) > 0    % DEBUG(�N��2���|���v�𓮂���)
    
    % �^�]���ԃ}�g���b�N�X
    tmp = zeros(1,365,24);
    
    for i = 1:length(PUMPahuSet)
        
        for j = 1:length(AHUsystemName)
            if strcmp(PUMPahuSet(i),AHUsystemName(j))
                break
            end
        end
        
        % �^�]���ԃ}�g���b�N�X�ɁAAHUsystemOpeTime�i�^�]�Ȃ�1�A��~�Ȃ�0�j�𑫂����ށB
        tmp = tmp + AHUsystemOpeTime(j,:,:);
        
        %             if ahuTime_start(dd,j)==0 && ahuTime_stop(dd,j)==0
        %                 tmpStart = [tmpStart,ahuTime_start(dd,j)];  % DEBUG(�N��2���|���v�𓮂���)
        %                 tmpStop  = [tmpStop,ahuTime_stop(dd,j)];    % DEBUG(�N��2���|���v�𓮂���)
        %             else
        %                 tmpStart = [tmpStart,ahuTime_start(dd,j)];
        %                 tmpStop  = [tmpStop,ahuTime_stop(dd,j)];
        %             end
    end
    
    for dd =1:365
        for hh = 1:24
            if tmp(1,dd,hh) > 0
                pumpsystemOpeTime(dd,hh) = 1;
            end
        end
    end
    
    % �e���̃|���v�^�]����
    Tps_c(:,1) = sum(pumpsystemOpeTime,2);
    
    
    %     pumpTime_Start(dd,1) = min(tmpStart);
    %     pumpTime_Stop(dd,1)  = max(tmpStop);
    %
    %     if max(tmpStop) >= min(tmpStart)
    %         Tps_c(dd,1) = max(tmpStop)-min(tmpStart);
    %     else
    %         Tps_c(dd,1) = min(tmpStart)+(24-max(tmpStop));
    %     end
    
    % DEBUG(�N��2���|���v�𓮂���)
    %         else
    %             Tps_c(dd,1) = 0;
    %             pumpTime_Start(dd,1) = 0;
    %             pumpTime_Stop(dd,1) = 0;
    %         end
else
    %     Tps_c(,1)          = 0;
    %     pumpTime_Start(dd,1) = 0;
    %     pumpTime_Stop(dd,1)  = 0;    
end

% end
