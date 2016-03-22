% mytfunc_thermalstorage_Qrefhour
%                                                                2016/01/11
%--------------------------------------------------------------------------
% �~�M���׌v�Z�i���n��v�Z�p�j
%--------------------------------------------------------------------------

function [Qref_hour,Qref_hour_discharge] = mytfunc_thermalstorage_Qrefhour(Qref_hour,REFstorage,storageEffratio,refsetStorageSize,numOfRefs,refset_Capacity,refsetID,QrefrMax)

Qref_hour_discharge = zeros(8760,numOfRefs);

% ���M�{�Ǌ|��
for iREF = 1:numOfRefs
    if REFstorage(iREF) == -1  % �̔M�{�Ǌ|��
        
        % �ꎞ�Ԃ�����̍̔M�ő�ʁi�M������̗e�ʁj [kW]
        Qmax   = refset_Capacity(iREF,1);
        % �ő�~�M�ʁi�~�M���������������������̗��p�\�ʁj [MJ]
        Qlimit = storageEffratio(iREF) * refsetStorageSize(iREF);

        % ������ɐ؂�o��
        for dd = 1:365
            
            % �e���̎����ʕ��ׁi24���ԕ��j[kW]
            Qref_daily = Qref_hour(24*(dd-1)+1:24*dd,iREF);
            
            % �e���̎����ʂ̕��M�� [kW]
            Qref_discharge = zeros(24,1);
            
            if sum(Qref_daily) > 0  % ���ׂ������
                
                for hh = [13:19,12:-1:8,20:22]  % ���̏��ԂŒ~�M������̕��M���s��
                    
                    % �~�M������̕��M��[kW]
                    Qref_discharge(hh,1) = min(Qref_daily(hh), Qmax);
                    
                    if sum(Qref_discharge) > Qlimit*1000/3600
                        
                        % �I�[�o�[������������
                        Qref_discharge(hh,1) = Qref_discharge(hh,1) - (sum(Qref_discharge)-Qlimit*1000/3600);
                        
                        % �`�F�b�N
                        if (sum(Qref_discharge) - Qlimit*1000/3600) / Qlimit > 0.01
                            error('�~�M�ʂƕ��M�ʂ������܂���')
                        end
                        break
                    end
                end
                
            end
            
            % �Ǌ|���^�]���K�v�ȕ��� [kW]
            Qref_hour(24*(dd-1)+1:24*dd,iREF) = (Qref_daily - Qref_discharge);
            % �~�M������̕��M�� [kW]
            Qref_hour_discharge(24*(dd-1)+1:24*dd,iREF) = Qref_discharge;
            
        end
        
    end
end

% �~�M
for iREF = 1:numOfRefs
    if REFstorage(iREF) == 1  % �~�M
        
        % ���M����[kW]�����߂�i���K�v�~�M�ʂ����߂�j�B
        Qref_hour_storage = zeros(8760,1);
        for iREFdb = 1:numOfRefs
            if strcmp(refsetID(iREF),refsetID(iREFdb)) && REFstorage(iREFdb) == -1
                Qref_hour_storage = Qref_hour_discharge(:,iREFdb);
                break
            end
        end
        
        % ������ɐ؂�o��
        for dd = 2:365

            % �e���̎����ʕ��ׁi24���ԕ��A�A���O��22�����瓖��21���܂Łj [kW]
            Qref_r_daily = Qref_hour_storage(24*(dd-1)-1:24*dd-2);
            
            % �~�M���� [kW]
            Qref_s_daily = zeros(24,1);
            
            if sum(Qref_r_daily) > 0
                
                % �K�v�~�M���� [hour]
                T_storage = (sum(Qref_r_daily)+(refsetStorageSize(iREF)*0.03*1000/3600)) / QrefrMax(iREF);
                
                % �~�M��22�����痂��6���܂�
                if T_storage > 9
                    error('�K�v�~�M���Ԃ�9���Ԃ𒴂��܂����B')
                else
                    
                    % �e���̒~�M���� [kW]
                    Qref_s_daily(1:floor(T_storage)) = QrefrMax(iREF) * ones(floor(T_storage),1);
                    Qref_s_daily(floor(T_storage)+1) = QrefrMax(iREF) * (T_storage-floor(T_storage)) ;
                    
                end

            end
            
            % �~�M���� [kW]
            Qref_hour(24*(dd-1)-1:24*dd-2,iREF) = Qref_s_daily;
            
        end
        
    end
end













