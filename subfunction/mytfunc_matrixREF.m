% mytfunc_matrixREF.m
%                                                                                by Masato Miyata 2012/03/27
%-----------------------------------------------------------------------------------------------------------
% �M�����׃f�[�^�����ɁC���ׂ̏o���p�x�}�g���b�N�X���쐬����D
%-----------------------------------------------------------------------------------------------------------
% ����
%   MODE   : �v�Z���[�h�i���n��newHASP�C���ώZnewHASP�C�ȗ��@�j
%   Qps    : �|���v���ׁi���ԐώZor���ώZ�j[kW]
%   Qpsr   : �|���v��i�\�� [kW]
%   Tps    : �|���v�^�]���ԁi���ώZ�̂݁j[hour]
% �o��
%   Mx     : ���׏o���p�x�}�g���b�N�X
%-----------------------------------------------------------------------------------------------------------

function [Mx] = mytfunc_matrixREF(MODE,Qref_c,Qrefr_c,Tref,OAdata,mxT,mxL)

% �}�g���b�N�X
Mx = zeros(length(mxT),length(mxL)); % �O�C���~���ח�

switch MODE
    
    case {1}
        
        for dd = 1:365
            for hh = 1:24
                num = 24*(dd-1)+hh;
                
                Lref = Qref_c(num,1)/Qrefr_c; % ���ח�
                
                if Lref > 0.01 && isnan(Lref) == 0
                    
                    noa = mytfunc_countMX(OAdata(dd,1),mxT);
                    ix  = mytfunc_countMX(Lref,mxL);
                    Mx(noa,ix) = Mx(noa,ix) + 1;
                    
                end
            end
        end
        
    case {2,3}
        
        % ���ח��Z�o [-]
        Lref = (Qref_c./Tref.*1000./3600)./Qrefr_c;
        
        for dd = 1:365
            
            if isnan(Lref(dd,1))
                Lref(dd,1) = 0;
            end
            
            if Lref(dd,1)>0
                
                noa = mytfunc_countMX(OAdata(dd,1),mxT);
                ix  = mytfunc_countMX(Lref(dd,1),mxL);
                Mx(noa,ix) = Mx(noa,ix) + Tref(dd,1);
                
            end
            
        end
end