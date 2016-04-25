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

function [Mxc,Mxh] = mytfunc_matrixAHU(MODE,Qa_c,Qar_c,Ta_c,Qa_h,Qar_h,Ta_h,AHUCHmode,WIN,MID,SUM,mxL)


switch MODE

    case {0,1,4}
        
        switch MODE
            case {0,4}
                % ���n��f�[�^
                Mxc = zeros(8760,1);
                Mxh = zeros(8760,1);
            case {1}
                % �}�g���b�N�X
                Mxc = zeros(1,length(mxL)); % ��[�}�g���b�N�X
                Mxh = zeros(1,length(mxL)); % �g�[�}�g���b�N�X
        end
        
        if AHUCHmode == 1  % ��g�����^�]�L
            
            % �����ʂɃ}�g���b�N�X�Ɋi�[���Ă���
            for dd = 1:365
                for hh = 1:24
                    num = 24*(dd-1)+hh;
                    
                    if Qa_c(num,1) > 0  % ��[����
                        
                        ix = mytfunc_countMX(Qa_c(num,1)/Qar_c,mxL);
                        
                        switch MODE
                            case {0,4}
                                Mxc(num,1) = ix;
                            case {1}
                                Mxc(1,ix) = Mxc(1,ix) + 1;
                        end
                        
                    elseif Qa_c(num,1) < 0  % �g�[����
                        
                        ix = mytfunc_countMX((-1)*Qa_c(num,1)/Qar_h,mxL);
                        
                        switch MODE
                            case {0,4}
                                Mxh(num,1) = ix;
                            case {1}
                                Mxh(1,ix) = Mxh(1,ix) + 1;
                        end
                        
                    end
                end
            end
            
        elseif AHUCHmode == 0   % ��g�ؑցi�G�߂��Ɓj
            
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
                            
                            switch MODE
                                case {0,4}
                                    Mxc(num,1) = ix;
                                case {1}
                                    Mxc(1,ix) = Mxc(1,ix) + 1;
                            end
                            
                        elseif Qa_c(num,1) ~= 0 && iSEASON == 1  % �g�[����
                            
                            ix = mytfunc_countMX((-1)*Qa_c(num,1)/Qar_h,mxL);
                            
                            switch MODE
                                case {0,4}
                                    Mxh(num,1) = ix;
                                case {1}
                                    Mxh(1,ix) = Mxh(1,ix) + 1;
                            end
                        end
                    end
                end
            end
            
        else
            error('��ǎ��^�l�ǎ��̐ݒ肪�s���ł�')
        end
        

    case {2,3}
        
        % �}�g���b�N�X
        Mxc = zeros(1,length(mxL)); % ��[�}�g���b�N�X
        Mxh = zeros(1,length(mxL)); % �g�[�}�g���b�N�X
        
        for ich = 1:2
            
            if ich == 1 % ��[��
                
                % 2013/06/06�C��(��[��i�\�͂ƒg�[��i�\�͂ŏꍇ����)
                for dd = 1:length(Qa_c)
                    if Qa_c(dd) >= 0
                        La(dd,1) = (Qa_c(dd,1)./Ta_c(dd,1).*1000./3600)./Qar_c;  % ���ח� [-]
                    else
                        La(dd,1) = (Qa_c(dd,1)./Ta_c(dd,1).*1000./3600)./Qar_h;  % ���ח� [-]
                    end
                end
                Ta = Ta_c;
                
            elseif ich == 2 % �g�[��
                
                % 2013/06/06�C��(��[��i�\�͂ƒg�[��i�\�͂ŏꍇ����)
                for dd = 1:length(Qa_h)
                    if Qa_h(dd) <= 0
                        La(dd,1) = (Qa_h(dd,1)./Ta_h(dd,1).*1000./3600)./Qar_h;  % ���ח� [-]
                    else
                        La(dd,1) = (Qa_h(dd,1)./Ta_h(dd,1).*1000./3600)./Qar_c;  % ���ח� [-]
                    end
                end
                Ta = Ta_h;
                
            end
            
            if (Qar_c > 0) || (Qar_h > 0)  % ��i�\�́��O�@���@AHU or FCU �������
                
                if AHUCHmode == 1  % ��g�����^�]�L
                    
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
                    
                elseif AHUCHmode == 0   % ��g�ؑցi�G�߂��Ɓj
                    
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
        end
end



end



