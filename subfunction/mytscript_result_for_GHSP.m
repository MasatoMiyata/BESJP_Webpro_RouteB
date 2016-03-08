% mytscript_result_for_GSHP.m
%                                                  2016/02/04 by Masato Miyata
%------------------------------------------------------------------------------
% �ȃG�l����[�gB�F�n�Ռ��ʂ�csv�t�@�C���ɕۑ�����B
%------------------------------------------------------------------------------

% �o�͂���t�@�C����
if isempty(strfind(INPUTFILENAME,'/'))
    eval(['resfilenameD = ''calcREShourly_QforGound_',INPUTFILENAME(1:end-4),'_',datestr(now,30),'.csv'';'])
else
    tmp = strfind(INPUTFILENAME,'/');
    eval(['resfilenameD = ''calcREShourly_QforGound_',INPUTFILENAME(tmp(end)+1:end-4),'_',datestr(now,30),'.csv'';'])
end

% �n�Ղɓ��������M [W] �𔲂��o��
HeatforGround = zeros(8760,1);
for iREF = 1:numOfRefs
    for iREFSUB = 1:refsetRnum(iREF)
        
        if refHeatSourceType(iREF,iREFSUB) == 3  % �n���M�̏ꍇ

            for hh = 1:8760
                if LtREF(hh,iREF) > 0 && REFtype(iREF) == 1  % ��[
                    HeatforGround(hh,1) = HeatforGround(hh,1) + ( (Q_refsys_hour(hh,iREF,iREFSUB)*1000) + (E_refsys_hour(hh,iREF,iREFSUB)*1000000./9760) );
                    
                elseif LtREF(hh,iREF) > 0 && REFtype(iREF) == 2  % �g�[
                    HeatforGround(hh,1) = HeatforGround(hh,1) + (-1) * ( (Q_refsys_hour(hh,iREF,iREFSUB)*1000) - (E_refsys_hour(hh,iREF,iREFSUB)*1000000./9760) );
                    
                end
            end
            
        end
    end
end


% ���ʊi�[�p�ϐ�
rfc = {};
rfc = [rfc;'�n�Ղւ̓����M��[W]'];
rfc = mytfunc_oneLinecCell(rfc,HeatforGround);

% �o��
fid = fopen(resfilenameD,'w+');
for i=1:size(rfc,1)
    fprintf(fid,'%s\r\n',rfc{i});
end
fclose(fid);