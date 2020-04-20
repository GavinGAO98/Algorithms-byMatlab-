%%����һάΪ��
function [fGbest,XGPos] = MyGAPSO(fitness,Prcs,w,c1,c2,r1,r2,Pc,Pm,PopSize,D,loop,Xmin,Xmax)
    %%�������
        %fitness��Ӧ�Ⱥ���
        %Prcs��⾫�ȣ�������
        %w����Ȩ��
        %c1,c2ѧϰ���ӣ����ٳ�����
        %r1,r2��0��1����������
        %Pc�������
        %Pm�������
        %PopSize��Ⱥ��ģ��������4�ı����ſ��Է�ǰ���Ⱥ���ٸ�ĸ���
        %D�����ռ��ά�����Ա����ĸ����� 
        %loop��������
        %Xmin�Ա���ȡֵ��Χ���ޣ��Ǹ�������
        %Xmax�Ա���ȡֵ��Χ���ޣ��Ǹ�������
   %%�������
        %fGbest���һ�ε������ȫ�ּ�ֵ
        %XGPosȡ��ȫ�ּ�ֵʱ���Ա���
   
   
   %%(�Ŵ��㷨��ʼ�������룬�����볤len
     len = ceil(log2((Xmax-Xmin)/Prcs+1));
     Xd = (2^len-1)*(zeros(PopSize/2,1));               %Xd��PopSize/2����Ⱥ��ģ����ʮ������������
     Xb = dec2bin(Xd,len);                       %Xb�ǽ�m��Ⱦɫ���ת���ɶ����ƺ���ַ���������������PopSize/2,�������볤��ÿ�����������ַ���
   
   %%(��PSO�ķ�ʽ)��ʼ����Ⱥ����ʼ��������Ŀ�꺯��m�ļ�����ɣ�
   %%%%%%%%%%%%%%%%%    X���Ա��� 
    X = zeros(PopSize,D);       %����һ��PopSize��D�е�λ�þ��󣬾����ÿ��������X(i,:)�ǵ�i�����ӵ�λ����Ϣ,����Ϣ���ŵ���������ˢ��
    V = zeros(PopSize,D);       %����һ��PopSize��D�е��ٶȾ���,
    Vmax = 0.6*Xmax;           %Vmax ͨ��ѡΪ k��Xmax������ 0.1 �� k �� 1.0��ȡk=0.6
    
    for i=1:PopSize
        for j=1:D
            %%% X(i,:)=Xmin+(Xmax-Xmin)*rand ����ͬһ��i��ÿ����������������rand��1�����������ͬ�ģ��������
            X(i,j) = Xmin(j)+(Xmax(j)-Xmin(j))*rand;   %%������ɶ������ڵĳ�ʼλ��
            V(i,j) = -Vmax(j)+2*Vmax(j)*rand;          %%������ɶ������ڵĳ�ʼ�ٶ�
        end
    end
    
    %%%%%%%%%%%%%%%% ����һ�������¼��i�����ӣ���PopSize�����ӣ��ڵ�k��ѭ������loop��ѭ���������Ӧ��ֵ
    PerFit = zeros(PopSize,loop);
    %ǰһ����ȺPopSize/2������ÿ�ε�������弫ֵ�������Ӧ�ȣ�Indvbest���Ǹ�PopSize/2���󡣵�i��Ԫ���ǵ�i�����ӵ����ֵ
    Indvbest = zeros(PopSize/2,loop);      %��ʼ�����弫ֵ
    %PopSize/2�����Ӿ���loop�ε�����ȡ�ø��弫ֵ��λ��IndvPos���Ǹ�PopSize/2��D�о��󡣵�i���ǵ�i�����ӵ����ֵ��λ��
    IndvPos = zeros(PopSize/2,D,loop);   %��¼ÿ�ε�����һ����Ⱥ��Dά��������λ��
    
    Gbest = zeros(loop,1);      %��¼ÿ��ѭ�����ȫ�ּ�ֵ����Ⱥ�����Ӧ�ȣ�
    GPos = zeros(loop,D);       %��¼ÿ��ѭ�����ȡ��ȫ�ּ�ֵ���ڵ�λ��
    
    %%����loop��
    for k=1:loop
        
        %%������Ӧ��ֵ
        for i=1:PopSize
            PerFit(i,k) = fitness(X(i,:));  
        end
        
        %%%%%%%%%%%���㾫��Ҫ��ֱ������ѭ��
%         if max(PerFit(:,k)<err)
%            break;
%         end
        
        %%ɸѡ��Ӧ�ȸߵ�ǰһ����Ⱥ
        SppFltrX = zeros(PopSize/2,D);            %��¼ǰһ����Ⱥ��λ�ã�ʮ�����Ա���ֵ��
        SppV = zeros(PopSize/2,D);
        [FitSort,Index] = sort(PerFit(:,k),'descend');  %��ÿ�ε�������Ӧ�Ȱ��������з���FitSort��
        
        %%���¸��弫ֵ��ȫ�ּ�ֵ
        for t=1:PopSize/2
            SppFltrX(t,:) = X(Index(t),:);  %ȡÿ����Ӧ�ȸߵ�ǰһ����Ⱥ
            SppV(t,:) = V(Index(t),:);      %ȡÿ����Ӧ�ȸߵ�ǰһ����Ⱥ��Ӧ���ٶ�
            
            Indvbest(t,k) = FitSort(t);     %���弫ֵ����
            IndvPos(t,:,k) = SppFltrX(t,:);
        
        end

        %PopSize/2�����ӵ�ȫ�ּ�ֵGbest���Ǹ�����
        %PopSize/2�����ӣ�����loop�ε�����ȡ��ȫ�ּ�ֵ��λ��GPos���Ǹ�Dά������
        Gbest(k) = FitSort(1);    
        GPos(k,:) = SppFltrX(1,:);
        
        %%��PSO��ʽ���ǰһ�����ӣ���ߺ�����Ӽ�¼��SppFltrX��
        for t=1:PopSize/2                       %%��ÿ�����ӵ�������Ӧ������λ�ø�
%             Vtmp = SppV(t,:);              %��¼��i��������һ�ε�������ٶ�
%             Xtmp = SppFltrX(t,:);              %��¼��i��������һ�ε������λ��
            SppV(t,:) = w*SppV(t,:)+c1*r1*(IndvPos(t,:,k)-SppFltrX(t,:))+c2*r2*(GPos(k,:)-SppFltrX(t,:));
            SppFltrX(t,:) = SppFltrX(t,:)+SppV(t,:);
            
            %%��֤ÿ�ε�������ٶȺ�λ���ڽ�ռ���(�����и��õ��㷨˼�������)
            for j=1:D
                if SppV(t,j)>Vmax(j)
                    SppV(t,j) = Vmax(j);
                elseif SppV(t,j)<(-Vmax(j))
                    SppV(t,j) = -Vmax(j);
                end
                
                if SppFltrX(t,j)>Xmax(j)
                    SppFltrX(t,j) = Xmax(j);
                elseif SppFltrX(t,j)<Xmin(j)
                    SppFltrX(t,j) = Xmin(j);
                end
            end
        
        end
        
        %%�Ŵ�����
        
        %��ǰ����Ⱥ����
%         for t=1:PopSize/2                               %����m�������������������Xb�У�ʹ��randi()������������double������
%             Xb(t,:) = CodeChrom(Prcs,Xmin,Xmax,len,SppFltrX(t,:));    %��ʮ����ת�����ַ������ܸ�ֵ,��ʽ���Ʒ���ʾȥ���ַ���ת����ʱ�Ŀո�
%         end
        
        %�����������ȷ����ĸ��
        CmptChrom = zeros(PopSize/2,D);  %����������Ⱦɫ������
        Xtmp = SppFltrX;                    %�ݴ��������Ⱦɫ��
        
        for i=1:PopSize/2-1
            rCmpt1 = unifrnd(1,PopSize/2-i+1); %���������������������
            CmptIndex1 = round(rCmpt1);
            %%%%%%%%%%%%%%%%����һ��ѡ������Ĵ��Ƚϵ�Ⱦɫ���ݴ棬�������һ����ӻ�ȥ
            TmpChrom1 = Xtmp(CmptIndex1,:);   
            CmptFit1 = fitness(TmpChrom1);
            Xtmp(CmptIndex1,:) = [];            %����ѡ���ɾȥ�����ظ�����
            
            rCmpt2 = unifrnd(1,PopSize/2-i); %���������������������
            CmptIndex2 = round(rCmpt2);
            CmptFit2 = fitness(Xtmp(CmptIndex2,:));
            
            if(CmptFit1>CmptFit2)
               CmptChrom(i,:) = SppFltrX(CmptIndex1,:);%ÿ��ѡ������Ⱦɫ��Ƚ���Ӧ�ȣ���Ӧ��ֵ�����Ϊ����ĸ����
            else
               CmptChrom(i,:) = SppFltrX(CmptIndex2,:);
               Xtmp(CmptIndex2,:) = [];
               Xtmp(end+1,:) = TmpChrom1;      %���Ⱦɫ��2����Ӧ�ȴ���1����Ⱦɫ��1����
               
            end    
        end
        CmptChrom(end,:) = SppFltrX(PopSize/2,:);
        
        %���������ѡ����һ����Ⱥ����
        for t=1:PopSize/2                               %����m�������������������Xb�У�ʹ��randi()������������double������
            Xb(t,:) = dec2bin((CmptChrom(t,:)-Xmin)/(Xmax-Xmin)*(2^len-1),len);    %��ʮ����ת�����ַ������ܸ�ֵ,��ʽ���Ʒ���ʾȥ���ַ���ת����ʱ�Ŀո�
        end
        
        for n=1:PopSize/4
            PatChrom = Xb(2*n-1,:);      %��Ӧ��ֵ�����Ϊ����Ⱦɫ��         
            MatChrom = Xb(2*n,:);
            
            %%���棨���õ��㽻�����ӣ�
            rPc = rand;                   %�����������rPcС�ڽ������Pc������н���
            if(rPc<Pc)
                rCross = randi([1,len]);       %ȷ�������λ��,2����Ե�Ⱦɫ��ӵ�rCrossλ��ʼ����

                %%%%%�ַ����ض� 
                PatLastrC = PatChrom(rCross:len);     %��ȡ�������Ⱦɫ���rCrossλ��Ϊ����      
                MatLastrC = MatChrom(rCross:len);    

                %%%%%%%%%%%%��rCrossλ���н��棬strcat(str1,st2)��str1��str2ƴ����
                Xb(2*n-1,:) = strcat(PatChrom(1:rCross-1),MatLastrC);
                Xb(2*n,:) = strcat(MatChrom(1:rCross-1),PatLastrC);
                
            end
        end
        
        %%���죨���û���λ���죬�������һ��������߼���������б��죩
        rPm = rand;                     %�����������rPcС�ڽ������Pc������н���

        if(rPm<Pm)
            rNumMut = randi([1,len]);      %��1-n��ȷ������ı������ĸ���rNumMut
            rMut = randperm(len,rNumMut);  %rMut��rNumMutά����������¼��rNumMut����������λ��
                                         %randperm(len,t)���������ɡ�1��len����t����ͬ���������
            for t=1:PopSize/2
                for m=1:rNumMut
                    %%%%%%%%%%%%%%%%%%%%%%%�����ѡ�еĵ�rMut(m)λ����ȡ�����ַ��ͱ�������ASCII��������������ת���ַ���
                    Xb(t,rMut(m)) = num2str('1'-Xb(t,rMut(m)));
                end
            end
        end
        
        %%����
%         for t=1:PopSize/2
%             Xd(t) = DecodeChrom(Xmin,Xmax,len,Xb(t,:));
%         end
        
        %%��PSO��ߵ�ǰһ����Ⱥ���Ŵ���ߵĺ�һ����Ⱥ�ϲ������X(PopSize,D)��
        for t=1:PopSize/2
            X(t,:) = SppFltrX(t,:);
            X(t+PopSize/2,:) = DecodeChrom(Xmin,Xmax,len,Xb(t,:));   %%��һ�����
            
        end
    end
    
    %%���һ�ε��������Ӧ�Ⱥ�λ�ô�����Gbest(loop+1)��
    for i=1:PopSize
            PerFit(i,loop+1) = fitness(X(i,:));  
    end
    
    Gbest(1) = [];  %����ʼ��ʱ����������Ӧ��ֵ��λ��ȥ�����������Ž�͵�������һһ��Ӧ
    GPos(1,:) = []; 
    [Gbest(end+1),MaxIndex] = max(PerFit(:,loop+1));
    GPos(end+1,:) = X(MaxIndex,:);
    
    fGbest = Gbest(loop);
    XGPos = GPos(loop,:);
    
    %%��ͼ����
    %���������Ӧ��ֵ�͵�������������
   
        plot(Gbest,'-*');
        xlabel('Generations');
        ylabel('Best fitness');
        title('�����Ӧ��ֵ���ڵ��������ı仯ͼ');
        
    %�Ե�������Ϊ��������ͼ����loop���㣩�������Ž�λ�ñ仯���Ը�������Ϊ����ϵ������
%         Xaxis = linspace(1,loop,loop);
%         plot(Xaxis,GPos);
%         
    %���������������·��
    
end

function [Xd] = DecodeChrom(Xmin,Xmax,len,Xb)
    %%�������ã���һά����������Ⱦɫ�壬�Ӷ����Ʊ��ʮ����
    %%���������
        %Xmin�Ա���ȡֵ��Χ���ޣ��Ǹ�������(һάʱ�Ǹ���)
        %Xmax�Ա���ȡֵ��Χ���ޣ��Ǹ�������
        %len�����Ʊ���λ�����볤��
        %PopSize��len�о���Xb,  Xb������һ�Σ�ѡ�񡢽��桢���죩�Ŵ��������Ⱦɫ��Ķ����Ʊ���        
    %%���������Xd������Ӧ��ԭ�������ʮ����
    Xd = Xmin + (Xmax-Xmin)/(2^len-1)* bin2dec(Xb);
end
