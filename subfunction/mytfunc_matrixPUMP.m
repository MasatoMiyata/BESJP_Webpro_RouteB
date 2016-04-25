% mytfunc_matrixPUMP.m
%                                                                                by Masato Miyata 2011/10/15
%-----------------------------------------------------------------------------------------------------------
% �|���v���׃f�[�^�����ɁC���ׂ̏o���p�x�}�g���b�N�X���쐬����D
%-----------------------------------------------------------------------------------------------------------
% ����
%   MODE   : �v�Z���[�h�i���n��newHASP�C���ώZnewHASP�C�ȗ��@�j
%   Qps    : �|���v���ׁi���ԐώZor���ώZ�j[kW]
%   Qpsr   : �|���v��i�\�� [kW]
%   Tps    : �|���v�^�]���ԁi���ώZ�̂݁j[hour]
% �o��
%   Mxc    : ���׏o���p�x�}�g���b�N�X
%-----------------------------------------------------------------------------------------------------------

function [Mxc] = mytfunc_matrixPUMP(MODE,Qps,Qpsr,Tps,mxL)


switch MODE
    
    case {0,4}
        
        % ���n��f�[�^
        Mxc = zeros(8760,1);
        
        for dd = 1:365
            for hh = 1:24
                
                % 1��1��0������̎��Ԑ�
                num = 24*(dd-1)+hh;
                
                tmp = Qps(num,1)/Qpsr; % ���ח�
                
                if tmp > 0    
                    ix = mytfunc_countMX(tmp,mxL);
                    Mxc(num,1) = ix;
                end
                
            end
        end
        
    case {1}
        
        % �}�g���b�N�X
        Mxc = zeros(1,length(mxL)); % ��[�}�g���b�N�X
        
        % �����ʂɃ}�g���b�N�X�Ɋi�[���Ă���
        for dd = 1:365
            for hh = 1:24
                num = 24*(dd-1)+hh;
                
                tmp = Qps(num,1)/Qpsr; % ���ח�
                
                if tmp > 0
                    ix = mytfunc_countMX(tmp,mxL);
                    Mxc(1,ix) = Mxc(1,ix) + 1;
                end
                
            end
        end
        
    case {2,3}
        
        % �}�g���b�N�X
        Mxc = zeros(1,length(mxL)); % ��[�}�g���b�N�X
        
        Lpump = (Qps./Tps.*1000./3600)./Qpsr;
        Tpump = Tps;
        
        for dd = 1:365
            if isnan(Lpump(dd,1)) == 0 % �[������NaN�ɂȂ��Ă���l���΂�
                if Lpump(dd,1) > 0
                    % �o�����ԃ}�g���b�N�X���쐬
                    ix = mytfunc_countMX(Lpump(dd,1),mxL);
                    Mxc(1,ix) = Mxc(1,ix) + Tpump(dd,1);
                end
            end
        end
        
end

