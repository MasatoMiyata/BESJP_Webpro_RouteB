% mytfunc_matrixAHU.m
%                                                                                by Masato Miyata 2012/03/27
%-----------------------------------------------------------------------------------------------------------
% �󒲕��׃f�[�^�����ɁC���ׂ̏o���p�x�}�g���b�N�X���쐬����D
%-----------------------------------------------------------------------------------------------------------
% ����
%   MODE   : �v�Z���[�h�i���n��newHASP�C���ώZnewHASP�C�ȗ��@�j
%   Qa_c   : ��[���ׁi���ԐώZor���ώZ�j[kW]
%   Qar_c  : ��[��i�\�� [kW]
%   Ta_c   : ��[�^�]���ԁi���ώZ�̂݁j[hour]
%   Qa_h   : �g�[���ׁi���ԐώZor���ώZ�j[kW]
%   Qar_h  : �g�[��i�\�� [kW]
%   Ta_h   : �g�[�^�]���ԁi���ώZ�̂݁j[kW]
% �o��
%   Mxc : ���׏o���p�x�}�g���b�N�X�i��M�j
%   Mxh : ���׏o���p�x�}�g���b�N�X�i���M�j
%-----------------------------------------------------------------------------------------------------------

function [Mxc,Mxh] = mytfunc_matrixAHU(MODE,Qa_c,Qar_c,Ta_c,Qa_h,Qar_h,Ta_h,PIPE,WIN,MID,SUM,mxL)

% �}�g���b�N�X
Mxc = zeros(1,length(mxL)); % ��[�}�g���b�N�X
Mxh = zeros(1,length(mxL)); % �g�[�}�g���b�N�X

switch MODE
    
    case {1}
        
        if PIPE == 4
            
            % �����ʂɃ}�g���b�N�X�Ɋi�[���Ă���
            for dd = 1:365
                for hh = 1:24
                    num = 24*(dd-1)+hh;
                    
                    if Qa_c(num,1) > 0  % ��[����
                        
                        ix = mytfunc_countMX(Qa_c(num,1)/Qar_c,mxL);
                        Mxc(1,ix) = Mxc(1,ix) + 1;
                        
                    elseif Qa_c(num,1) < 0  % �g�[����
                        
                        ix = mytfunc_countMX((-1)*Qa_c(num,1)/Qar_h,mxL);
                        Mxh(1,ix) = Mxh(1,ix) + 1;
                        
                    end
                end
            end
            
        elseif PIPE == 2
            
            % �G�ߕʁA�����ʂɃ}�g���b�N�X�Ɋi�[���Ă���
            for iSEASON = 1:3
                
                if iSEASON == 1
                    seasonspan = WIN;
                elseif iSEASON == 2
                    seasonspan = MID;
                elseif iSEASON == 3
                    seasonspan = SUM;
                else
                    error('�V�[�Y���ԍ����s���ł�')
                end
                
                for dd = seasonspan
                    for hh = 1:24
                        num = 24*(dd-1)+hh;
                        
                        if Qa_c(num,1) ~= 0 && (iSEASON == 2 || iSEASON == 3) % ��[����
                            
                            ix = mytfunc_countMX(Qa_c(num,1)/Qar_c,mxL);
                            Mxc(1,ix) = Mxc(1,ix) + 1;
                            
                        elseif Qa_c(num,1) ~= 0 && iSEASON == 1  % �g�[����
                            
                            ix = mytfunc_countMX((-1)*Qa_c(num,1)/Qar_h,mxL);
                            Mxh(1,ix) = Mxh(1,ix) + 1;
                            
                        end
                    end
                end
            end
            
        else
            error('��ǎ��^�l�ǎ��̐ݒ肪�s���ł�')
        end
        
    case {2,3}
        
        if PIPE == 4  % 4�ǎ�
            
            for iCH = 1:2
                
                if iCH == 1 % ��[��
                    La = (Qa_c./Ta_c.*1000./3600)./Qar_c;  % ���ח� [-]
                    Ta = Ta_c;
                elseif iCH == 2 % �g�[��
                    La = (Qa_h./Ta_h.*1000./3600)./Qar_h;  % ���ח� [-]
                    Ta = Ta_h;
                end
                
                if Qar_c > 0 % ��i�\�́��O�@���@AHU or FCU �������
                    for dd = 1:365
                        if isnan(La(dd,1)) == 0 % �[������NaN�ɂȂ��Ă���l���΂�
                            
                            if La(dd,1) > 0 % ��[���ׂł����
                                ix = mytfunc_countMX(La(dd,1),mxL);
                                Mxc(1,ix) = Mxc(1,ix) + Ta(dd,1);
                                    
                            elseif La(dd,1) < 0 % �g�[���ׂł����
                                ix = mytfunc_countMX((-1)*La(dd,1),mxL);
                                Mxh(1,ix) = Mxh(1,ix) + Ta(dd,1);

                            end
                        end
                    end
                end
            end
            
        elseif PIPE == 2 % 2�ǎ�
            
            for iCH = 1:2
                if iCH == 1 % ��[��
                    La = (Qa_c./Ta_c.*1000./3600)./Qar_c;  % ���ח� [-]
                    Ta = Ta_c;
                elseif iCH == 2 % �g�[��
                    La = (Qa_h./Ta_h.*1000./3600)./Qar_h;  % ���ח� [-]
                    Ta = Ta_h;
                end
                
                if Qar_c > 0 % ��i�\�́��O�@���@AHU or FCU �������
                    
                    for iSEASON = 1:3
                        
                        if iSEASON == 1
                            seasonspan = WIN;
                        elseif iSEASON == 2
                            seasonspan = MID;
                        elseif iSEASON == 3
                            seasonspan = SUM;
                        else
                            error('�V�[�Y���ԍ����s���ł�')
                        end
                        
                        for dd = seasonspan
                            if isnan(La(dd,1)) == 0 % �[������NaN�ɂȂ��Ă���l���΂�
                                if La(dd,1) ~= 0  && (iSEASON == 2 || iSEASON == 3) % ��[���Ԃł����
                                ix = mytfunc_countMX(La(dd,1),mxL);
                                Mxc(1,ix) = Mxc(1,ix) + Ta(dd,1);
                                    
                                elseif La(dd,1) ~= 0 && iSEASON == 1  % �g�[���Ԃł����
                                ix = mytfunc_countMX((-1)*La(dd,1),mxL);
                                Mxh(1,ix) = Mxh(1,ix) + Ta(dd,1);
                                end
                            end
                        end
                    end
                end
            end

        else
            error('��ǎ��^�l�ǎ��̐ݒ肪�s���ł�')
        end
        
end



