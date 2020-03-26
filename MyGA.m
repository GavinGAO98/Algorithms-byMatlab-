%%%%%����һά����Ϊ��
%%%%%��Ҫʱ�ɽ�ÿ��������Ϊ����
%%%%%�����������error����С����������
%%%%%ʹ��GA�㷨ʱ���Ա������������ɢ����������ȡ����Prcs=0.001

function [GXd,Gbest] = MyGA(fitness,Prcs,m,Pc,Pm,Cir,Xmin,Xmax)
    %%�������
        %fitness��Ӧ�Ⱥ���
        %Prcs��⾫�ȣ�������
        %m��Ⱥ��ģ
        %Pc�������
        %Pm�������
        %Cir��������
        %Xmin�Ա���ȡֵ��Χ���ޣ��Ǹ�������
        %Xmax�Ա���ȡֵ��Χ���ޣ��Ǹ�������

    %%�������ֵ
        %GXd��Ӧ�Ⱥ���ȡ���ֵʱ����Ⱦɫ��ı���
        %Gbest�����Ӧ��ֵ
    
    %%����
    len = ceil(log2((Xmax-Xmin)/Prcs+1));     %��������Ʊ���λ��len�����볤��.���ݹ�ʽ��(Xmax-Xmin)/����+1<2^len
    
    %%��Ⱥ��ʼ��
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Ϊʹת���ɶ����ƺ���������������볤������ǰ�����2^(n-1),�ҳ�ʼ��һ��Ҫ��ones��
    Xd = (2^len-1)*(ones(m,1));               %Xd��m����Ⱥ��ģ����ʮ������������
    Xb = dec2bin(Xd);                       %Xb�ǽ�m��Ⱦɫ���ת���ɶ����ƺ���ַ���������������m,�������볤��ÿ�����������ַ���
    XdGen = (2^len-1)*ones(m,1);              %XGen���ڴ洢ÿ�ε������Ⱦɫ��
    XbGen = dec2bin(XdGen);
    
    for i=1:m                               %����m�������������������Xb�У�ʹ��randi()������������double������
        Xb(i,:) = num2str(randi([0,1],1,len),'%0d');    %��ʮ����ת�����ַ������ܸ�ֵ,��ʽ���Ʒ���ʾȥ���ַ���ת����ʱ�Ŀո�
    end
    
    XdDcode = zeros(m,Cir+1);           %����һ������XdDcode����¼m���У��������еĵ�i�����Ӿ�������Cir���У��κ��Ӧ��ʮ�����Ա���
    PerFit = zeros(m,Cir+1);            %����һ������PerFit����¼m���У��������еĵ�i�����Ӿ�������Cir���У��κ��������Ӧ��
    
    for j=1:Cir                    %������Cir��
    
        %%������Ӧ��ֵ
        
        for i=1:m
            PerFit(i,j) = fitness(DecodeChrom(Xmin,Xmax,len,Xb(i,:)));
        end
    
        %%���ƣ�ѡ�񣩣�Ŀ�ģ���̭��Ӧ����С��Ⱦɫ�壩
        %%���̶�ѡ��
        pSel = zeros(m,1);                 %����mάѡ�����������pSel
        qAcc = zeros(m,1);                 %����mά���۸���������qAcc
        FitSum = sum(PerFit(:,j));         %FitSum����Ⱥ������Ⱦɫ�������֮��
        qTmp = 0;                          %����һ��Ⱦɫ�����Ӧ�ȸ����ݴ����
        
        for i=1:m
            pSel(i) = PerFit(i,j)/ FitSum;
            qAcc(i) = pSel(i)+qTmp;
            qTmp = qAcc(i);                
        end

        iSel = zeros(m,1);                 %��¼�����̶ķ�ÿ��ѡ�еģ�m���У�Ⱦɫ����
%         XdGen = (2^len-1)*eye(m,1);              %XdTmp�����ݴ�ѡ����Ⱦɫ��
%         XbGen = dec2bin(XdGen);

        for i=1:m
            rSel = rand;                   %���������
            qAddRand = [qAcc;rSel];        %������������qAcc����ɸ����������qAddRand��������
            qAddRand = sort(qAddRand);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����Ԫ�������������������ڵ���������ѡ���Ⱦɫ����
            iSel(i) = find(qAddRand == rSel);
            XbGen(i,:) = Xb(iSel(i),:);    %��ѡ���������Ӧ�ȸߵ�Ⱦɫ�帳����һ��
            
        end

        %%���棨���õ��㽻�����ӣ�
        rPc = rand;                   %�����������rPcС�ڽ������Pc������н���
        if(rPc<Pc)
            for k=1:m/2                        %������� 
                rCross = randi([1,len]);       %ȷ�������λ��,2����Ե�Ⱦɫ��ӵ�rCrossλ��ʼ����
                   
                   %%%%%�ַ����ض� 
                   PatLastrC = XbGen(2*k-1,rCross:len);     %��ȡ�������Ⱦɫ���rCrossλ��Ϊ����      
                   MatLastrC = XbGen(2*k,rCross:len);    

                   %%%%%%%%%%%%��rCrossλ���н��棬strcat(str1,st2)��str1��str2ƴ����
                   XbGen(2*k-1,:) = strcat(XbGen(2*k-1,1:rCross-1),MatLastrC);
                   XbGen(2*k,:) = strcat(XbGen(2*k,1:rCross-1),PatLastrC);
            end
        end

        %%���죨���û���λ���죬�������һ��������߼���������б��죩
        rPm = rand;                     %�����������rPcС�ڽ������Pc������н���

        if(rPm<Pm)
            for i=1:m
                rNumMut = randi([1,len]);      %��1-n��ȷ������ı������ĸ���rNumMut
                rMut = randperm(len,rNumMut);  %rMut��rNumMutά����������¼��rNumMut����������λ��
                                             %randperm(len,t)���������ɡ�1��len����t����ͬ���������

                for t=1:rNumMut
                    %%%%%%%%%%%%%%%%%%%%%%%�����ѡ�еĵ�rMut(t)λ����ȡ�����ַ��ͱ�������ASCII��������������ת���ַ���
                    XbGen(i,rMut(t)) = num2str('1'-XbGen(i,rMut(t)));
                end
            end
        end
        
              
        %%��¼ÿ�β�����ģ������ģ��Ա�������Ӧ��ֵ�����ڻ�ͼ
        for i=1:m 
            Xb(i,:) = XbGen(i,:);          %���ϴε������Ⱦɫ���ݴ�
            XdDcode(i,j+1) = DecodeChrom(Xmin,Xmax,len,XbGen(i,:));    %��j��ѭ����i��Ⱦɫ������ʮ�����Ա���XdDcode(i,j)
            PerFit(i,j+1) = fitness(XdDcode(i,j+1));       
        end
        
        %%�ж��Ƿ����㾫��Ҫ�������������ǰ����
%         if max(PerFit(:,j))<error
%            break; 
%         end    
    end
    
    %%ѭ���⻭ͼ
    
    
    %%ѭ�������
    Gbest = max(PerFit(:,Cir+1));     
    [GbestRow,GbestCol] = find(PerFit == Gbest,1,'last');    %�ҵ�������Ӧ������Ⱦɫ���ھ����е�λ��
    GXd = XdDcode(GbestRow,GbestCol);
end

function [Xd] = DecodeChrom(Xmin,Xmax,n,Xb)
    %%�������ã���һά����������Ⱦɫ�壬�Ӷ����Ʊ��ʮ����
    %%���������
        %Xmin�Ա���ȡֵ��Χ���ޣ��Ǹ�������(һάʱ�Ǹ���)
        %Xmax�Ա���ȡֵ��Χ���ޣ��Ǹ�������
        %n�����Ʊ���λ�����볤��
        %m��n�о���Xb,  Xb������һ�Σ�ѡ�񡢽��桢���죩�Ŵ��������Ⱦɫ��Ķ����Ʊ���        
    %%���������������Ӧ��ԭ�������ʮ����Xd
    Xd = Xmin + (Xmax-Xmin)/2^n* bin2dec(Xb);
end