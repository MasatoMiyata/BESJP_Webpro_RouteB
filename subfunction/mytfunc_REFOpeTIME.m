function [Tref,refsystemOpeTime] =...
    mytfunc_REFOpeTIME(Qref,PUMPsystemName,REFpumpSet,pumpsystemOpeTime)

% �|���v������
pumpID = [];
for i = 1:length(REFpumpSet)
    for j = 1:length(PUMPsystemName)
        if strcmp(REFpumpSet(i),PUMPsystemName(j))
            pumpID = [pumpID,j];
        end
    end
end

% �e���̔M���^�]����
Tref = zeros(365,1);
% �M���̉^�]���ԃ}�g���b�N�X
refsystemOpeTime = zeros(365,24);

for dd = 1:365
    
    %     tmpStart = [];
    %     tmpStop  = [];
    
    if Qref(dd,1) > 0
        
        % �^�]���ԃ}�g���b�N�X
        tmp = zeros(1,1,24);
        
        for iPUMP = 1:length(pumpID)
            % �^�]���ԃ}�g���b�N�X�ɁApumpsystemOpeTime�i�^�]�Ȃ�1�A��~�Ȃ�0�j�𑫂����ށB
            tmp = tmp + pumpsystemOpeTime(pumpID(iPUMP),dd,:);
        end
        
        for hh = 1:24
            if tmp(1,1,hh) > 0
                refsystemOpeTime(dd,hh) = 1;
            end
        end
        
        % �e���̔M���^�]����
        Tref(dd,1) = sum(refsystemOpeTime(dd,:));
        
        
        %         for iPUMP = 1:length(pumpID)
        %             j = pumpID(iPUMP);
        %             if pumpTime_Start(dd,j)==0 && pumpTime_Stop(dd,j)==0
        %             else
        %                 tmpStart = [tmpStart,pumpTime_Start(dd,j)];
        %                 tmpStop  = [tmpStop,pumpTime_Stop(dd,j)];
        %             end
        %         end
        %
        %         refTime_Start(dd,1) = min(tmpStart);
        %         refTime_Stop(dd,1)  = max(tmpStop);
        %
        %         if max(tmpStop) >= min(tmpStart)
        %             Tref(dd,1) = max(tmpStop)-min(tmpStart);
        %         else
        %             Tref(dd,1) = min(tmpStart)+(24-max(tmpStop));
        %         end
        %
        %     else
        %         Tref(dd,1) = 0;
        %         refTime_Start(dd,1) = 0;
        %         refTime_Stop(dd,1) = 0;
        %     end
        
    end
end
