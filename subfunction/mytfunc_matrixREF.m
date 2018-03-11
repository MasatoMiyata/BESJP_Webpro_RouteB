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

function [Mx,Tx] = mytfunc_matrixREF(MODE,Qref_c,Qrefr_c,Tref,OAdata,mxT,mxL)

Tx = zeros(365,1);

switch MODE
    
    case {0}
        
        % ���n��f�[�^
        Mx = zeros(8760,2);  % ���ח���, �O�C����
        
        for dd = 1:365
            for hh = 1:24
                num = 24*(dd-1)+hh;
                
                Lref = Qref_c(num,1)/Qrefr_c; % ���ח�
                
                if Lref > 0.001 && isnan(Lref) == 0
                    
                    noa = mytfunc_countMX(OAdata(num,1),mxT);
                    ix  = mytfunc_countMX(Lref,mxL);
                    Mx(num,1) = ix;
                    Mx(num,2) = noa;
                    
                end
                
            end
        end
        
    case {1}
        
        % �}�g���b�N�X
        Mx = zeros(length(mxT),length(mxL)); % �O�C���~���ח�
        
        for dd = 1:365
            for hh = 1:24
                num = 24*(dd-1)+hh;
                
                Lref = Qref_c(num,1)/Qrefr_c; % ���ח�
                
                if Lref > 0.001 && isnan(Lref) == 0
                    
                    noa = mytfunc_countMX(OAdata(dd,1),mxT);
                    ix  = mytfunc_countMX(Lref,mxL);
                    Mx(noa,ix) = Mx(noa,ix) + 1;
                    
                end
            end
        end
        
    case {2,3,4}
        
        % �}�g���b�N�X
        switch MODE
            case {2,3}
                Mx = zeros(length(mxT),length(mxL)); % �O�C���~���ח�
            case {4}
                Mx = zeros(365,2);
        end
        
        % ���ח��Z�o [-]
        Lref = (Qref_c./Tref.*1000./3600)./Qrefr_c;
        
        for dd = 1:365
            
            if isnan(Lref(dd,1))
                Lref(dd,1) = 0;
            end
            
            if Lref(dd,1)>0
                
                noa = mytfunc_countMX(OAdata(dd,1),mxT);
                ix  = mytfunc_countMX(Lref(dd,1),mxL);
                
                switch MODE
                    case {2,3}
                        Mx(noa,ix) = Mx(noa,ix) + Tref(dd,1);
                    case {4}
                        Mx(dd,1) = ix;
                        Mx(dd,2) = noa;
                        Tx(dd,1) = Tref(dd,1);
                end
                
            end
            
        end
end