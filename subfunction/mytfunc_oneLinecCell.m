% mytfunc_oneLinecCell.m
%                                                  2012/01/04 by Masato Miyata
%------------------------------------------------------------------------------
% MATLAB�ϐ���csv�t�@�C���ɕۑ����邽�߂�1���C���̃Z���s��ɂ���֐�
%------------------------------------------------------------------------------

function y = mytfunc_oneLinecCell(CONTENTS,TARGET)

for i = 1:size(TARGET,1)
    
    tmp = '';
    
    for j = 1:size(TARGET,2)
        
        if j == 1
            if isnumeric(TARGET)
                tmp = strcat(tmp,num2str(TARGET(i,j)));
            else
                tmp = strcat(tmp,TARGET{i,j});
            end
        else
            if isnumeric(TARGET)
                tmp = strcat(tmp,',',num2str(TARGET(i,j)));
            else
                tmp = strcat(tmp,',',TARGET{i,j});
            end
        end
        
        tmpadd{i,1} = tmp;
        
    end
end

y = [CONTENTS;tmpadd];
