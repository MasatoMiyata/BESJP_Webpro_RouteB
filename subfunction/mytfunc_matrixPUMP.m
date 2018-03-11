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

function [Mxc,Tdc] = mytfunc_matrixPUMP(MODE,Qps,Qpsr,Tps,mxL)

% ���ʉ^�]���ԁiMODE=4�j
Tdc = zeros(365,1);

switch MODE
    
    case {0}
        
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
        
    case {2,3,4}
        
        switch MODE
            case {2,3}
                Mxc = zeros(1,length(mxL)); % �}�g���b�N�X
            case {4}
                Mxc = zeros(365,1);
        end
        
        Lpump = (Qps./Tps.*1000./3600)./Qpsr; % ���ח���
        Tpump = Tps;
        
        for dd = 1:365
            if isnan(Lpump(dd,1)) == 0 % �[������NaN�ɂȂ��Ă���l���΂�
                if Lpump(dd,1) > 0
                    % �o�����ԃ}�g���b�N�X���쐬
                    ix = mytfunc_countMX(Lpump(dd,1),mxL);
                    switch MODE
                        case {2,3}
                            Mxc(1,ix) = Mxc(1,ix) + Tpump(dd,1);
                        case {4}
                            Mxc(dd,1) = ix;
                            Tdc(dd,1) = Tpump(dd,1);
                    end
                end
            end
        end

end

