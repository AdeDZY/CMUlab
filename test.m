function []=test(caseNo)
    f1 = strcat('F:\CMUlab\trainData\case',num2str(caseNo),'\step2breath.wav');
    f2 = strcat('F:\CMUlab\trainData\case',num2str(caseNo),'\step2push.wav');
    f3 = strcat('F:\CMUlab\trainData\case',num2str(caseNo),'\step2both.wav');
    f4 = strcat('F:\CMUlab\trainData\case',num2str(caseNo),'\step1.wav');
    f5 = strcat('F:\CMUlab\trainData\case',num2str(caseNo),'\step4.wav');
    dInhale = wavread(f1);
    dPush = wavread(f2);
    dOrigin = wavread(f3);
    dInhale = dInhale(:,1);
    dPush = dPush(:,1);
    dOrigin = dOrigin(:,1);
    
    dStep1 = wavread(f4);
    dStep1 = dStep1(:,1);
    dStep4 = wavread(f5);
    dStep4 = dStep4(:,1);
    step1HasBreath = 1 - silenceBreath(dStep1)
    step2and3Success = InhalePush(dInhale,dPush,dOrigin)
    step4HasBreath = 1 - silenceBreath(dStep4)
end