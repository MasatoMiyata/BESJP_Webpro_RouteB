% �^�]���Ԃ̘a�W�����Ƃ�
%------------------------------------------------------
% ���́F
%  start  �e�n���ɑ�����@��^���̉^�]�J�n���ԁi365�~�n�����j
%  stop   �e�n���ɑ�����@��^���̉^�]�J�n���ԁi365�~�n�����j
% �o�́F
%  systemOpeTime : 24���Ԃ̉^�]���ԁi365�~24�j
%------------------------------------------------------

function systemOpeTime = mytfunc_calcOpeTime(start,stop)

% �ڑ�����Ă���V�X�e���̐�
numsys = size(start,2);

systemOpeTime = zeros(365,24);

for dd = 1:365
    
    % ���ʊi�[�p
    tmp = zeros(numsys,24);
    
    for i=1:numsys
        
        if start(dd,1) == 0 && stop(dd,i) == 0
            tmp(i,:) = zeros(1,24);

        elseif start(dd,i) < stop(dd,i)  % �����ׂ��Ȃ��ꍇ
            for hh = 1:24
                if hh > start(dd,i) && hh <= stop(dd,i)
                    tmp(i,hh) = 1;
                end
            end
        else   % �����ׂ��ꍇ
            for hh = 1:24
                if hh > start(dd,i) || hh <= stop(dd,i)
                    tmp(i,hh) = 1;
                end
            end
        end
        
    end
    
    % �a�W�����Ƃ�
    sumtmp = sum(tmp,1);
    
    for hh=1:24
        if sumtmp(hh) > 0
            systemOpeTime(dd,hh) = 1;
        end
    end
    
end

