% AirConditioningComprehensiveTest
%--------------------------------------------------------------------------
% �󒲂̑����e�X�g
%--------------------------------------------------------------------------
% ���s�F
%�@results = runtests('testAirConditioningComprehensive.m');
%--------------------------------------------------------------------------

function tests = testAirConditioningComprehensive

global expSolutionALL

%% ���Ғl�̓ǂݍ���
res = textread('./test/AirConditioningComprehensiveTest/Results.csv','%s','delimiter','\n','whitespace','');

for i=1:length(res)
    conma = strfind(res{i},',');
    for j = 1:length(conma)
        if j == 1
            resall{i,j} = res{i}(1:conma(j)-1);
        elseif j == length(conma)
            resall{i,j}   = res{i}(conma(j-1)+1:conma(j)-1);
            resall{i,j+1} = res{i}(conma(j)+1:end);
        else
            resall{i,j} = res{i}(conma(j-1)+1:conma(j)-1);
        end
    end
end

expSolutionALL = str2double(resall(2:end,6:7));

    tests = functiontests(localfunctions);

end

function testCase01(testCase)

global expSolutionALL

% ���s
y = ECS_routeB_AC_run('./test/AirConditioningComprehensiveTest/testmodel_Case01.xml','OFF','4','Read','0');

actSolution = [y(1), y(17)];
expSolution = expSolutionALL(1,:);

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.0001)

end

function testCase02(testCase)

global expSolutionALL

% ���s
y = ECS_routeB_AC_run('./test/AirConditioningComprehensiveTest/testmodel_Case02.xml','OFF','4','Read','0');

actSolution = [y(1), y(17)];
expSolution = expSolutionALL(2,:);

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.0001)

end

function testCase03(testCase)

global expSolutionALL

% ���s
y = ECS_routeB_AC_run('./test/AirConditioningComprehensiveTest/testmodel_Case03.xml','OFF','4','Read','0');

actSolution = [y(1), y(17)];
expSolution = expSolutionALL(3,:);

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.0001)

end

function testCase04(testCase)

global expSolutionALL

% ���s
y = ECS_routeB_AC_run('./test/AirConditioningComprehensiveTest/testmodel_Case04.xml','OFF','4','Read','0');

actSolution = [y(1), y(17)];
expSolution = expSolutionALL(4,:);

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.0001)

end

function testCase05(testCase)

global expSolutionALL

% ���s
y = ECS_routeB_AC_run('./test/AirConditioningComprehensiveTest/testmodel_Case05.xml','OFF','4','Read','0');

actSolution = [y(1), y(17)];
expSolution = expSolutionALL(5,:);

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.0001)

end

function testCase06(testCase)

global expSolutionALL

% ���s
y = ECS_routeB_AC_run('./test/AirConditioningComprehensiveTest/testmodel_Case06.xml','OFF','4','Read','0');

actSolution = [y(1), y(17)];
expSolution = expSolutionALL(6,:);

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.0001)

end

function testCase07(testCase)

global expSolutionALL

% ���s
y = ECS_routeB_AC_run('./test/AirConditioningComprehensiveTest/testmodel_Case07.xml','OFF','4','Read','0');

actSolution = [y(1), y(17)];
expSolution = expSolutionALL(7,:);

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.0001)

end

function testCase08(testCase)

global expSolutionALL

% ���s
y = ECS_routeB_AC_run('./test/AirConditioningComprehensiveTest/testmodel_Case08.xml','OFF','4','Read','0');

actSolution = [y(1), y(17)];
expSolution = expSolutionALL(8,:);

% ����
verifyEqual(testCase,actSolution,expSolution,'RelTol',0.0001)

end
