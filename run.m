% XML�쐬����G�l���M�[�v�Z�܂ł���C�Ɏ��s����X�N���v�g
clear
clc
tic

addpath('./subfunction')
addpath('./XMLfileMake')

xmlfilename = 'csv2xml_config.xml';
region = 'IVb';

% XML�쐬
copyfile(xmlfilename,'./XMLfileMake/csv2xml_config.xml')
mytfunc_csv2xml_run('output.xml',region);

% �v�Z���s
RES = ECS_routeB_run('output.xml');


% for j = 1:8
%     
%     if j == 1
%         region = 'Ia';
%     elseif j == 2
%         region = 'Ib';
%     elseif j == 3
%         region = 'II';
%     elseif j == 4
%         region = 'III';
%     elseif j == 5
%         region = 'IVa';
%     elseif j == 6
%         region = 'IVb';
%     elseif j == 7
%         region = 'V';
%     elseif j == 8
%         region = 'VI';
%     end
%     
%     
%     for i = 1:3
%         
%         if i == 1
%             if j <= 2
%                 xmlfilename = 'csv2xml_config_�K�X1��_resion1.xml';
%             elseif j <= 4
%                 xmlfilename = 'csv2xml_config_�K�X1��_resion3.xml';
%             else
%                 xmlfilename = 'csv2xml_config_�K�X1��.xml';
%             end
%         elseif i == 2
%             if j <= 2
%                 xmlfilename = 'csv2xml_config_�K�X2��_resion1.xml';
%             elseif j <= 4
%                 xmlfilename = 'csv2xml_config_�K�X2��_resion3.xml';
%             else
%                 xmlfilename = 'csv2xml_config_�K�X2��.xml';
%             end
%         elseif i == 3
%             if j <= 2
%                 xmlfilename = 'csv2xml_config_�K�X3��_resion1.xml';
%             elseif j <= 4
%                 xmlfilename = 'csv2xml_config_�K�X3��_resion3.xml';
%             else
%                 xmlfilename = 'csv2xml_config_�K�X3��.xml';
%             end
%         elseif i == 4
%             if j <= 2
%                 xmlfilename = 'csv2xml_config_�Ζ�1��_resion1.xml';
%             elseif j <= 4
%                 xmlfilename = 'csv2xml_config_�Ζ�1��_resion3.xml';
%             else
%                 xmlfilename = 'csv2xml_config_�Ζ�1��.xml';
%             end
%         elseif i == 5
%             if j <= 2
%                 xmlfilename = 'csv2xml_config_�Ζ�2��_resion1.xml';
%             elseif j <= 4
%                 xmlfilename = 'csv2xml_config_�Ζ�2��_resion3.xml';
%             else
%                 xmlfilename = 'csv2xml_config_�Ζ�2��.xml';
%             end
%         elseif i == 6
%             if j <= 2
%                 xmlfilename = 'csv2xml_config_�Ζ�3��_resion1.xml';
%             elseif j <= 4
%                 xmlfilename = 'csv2xml_config_�Ζ�3��_resion3.xml';
%             else
%                 xmlfilename = 'csv2xml_config_�Ζ�3��.xml';
%             end
%         end
%         
%         % XML�쐬
%         copyfile(xmlfilename,'./XMLfileMake/csv2xml_config.xml')
%         mytfunc_csv2xml_run('output.xml',region);
%         
%         % �v�Z���s
%         RES = ECS_routeB_run('output.xml');
%         
%     end
%     
% end

rmpath('./subfunction')
rmpath('./XMLfileMake')

