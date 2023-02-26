
a=xlsread('monthly_in_situ_co2_mlo.xls');% load data
yr=a(:,1);mo=a(:,2);,CO2=a(:,9);
tm=datenum(yr,mo,15);% Turn into MATLAB time
i=find(CO2>0);% omit bad data
tm=tm(i);CO2=CO2(i);yr=yr(i);
YR=yr(1):yr(end);
n=length(YR);

t1=1:32;% divide data in to first half and second half
t2=33:n;
N1=t1(end)-t1(1)+1;
N2=t2(end)-t2(1)+1;
Y1=mean(YR(t1));
Y2=mean(YR(t2));
for iord=0:5; % run loop to increase order of polynomial to remove trends
    figure(iord+1)
    subplot(3,1,1)
    plot(tm,CO2);% Plot raw CO2 Data
    datetick('x',10,'keepticks')
    co2=detrend(CO2,iord);%Remove trend using iord polynomial
    subplot(3,1,2)
    plot(tm,co2)% plot detrended data;
    for iy=1958:2022; % find annaul change in CO2 data from detrended data
        ii=iy-1957;
        i=find(yr==iy);
        del_co2(ii)=max(co2(i))-min(co2(i));
        size(i)
    end

    subplot(3,1,3);
    plot(YR,del_co2); %plot annual change in CO2 concentration. 
    n=length(del_co2);  
    
    del_co21=mean(del_co2(t1));% Take mean of first half of record
    del_co22=mean(del_co2(t2));% Take mean of second half of record
    % Calculate 95% confidence limits on the mean
    std1=std(del_co2(t1)); 
    std2=std(del_co2(t2));
    sterr1=std1/sqrt(N1);
    sterr2=std2/sqrt(N2);
    cl1_95=tinv(.975,N1)*sterr1;
    cl2_95=tinv(.975,N2)*sterr2;
    % Plot mean data with error bars

plot(YR,del_co2);
hold on
scatter(Y1,del_co21,20,'ko','filled');
scatter(Y2,del_co22,20,'ko','filled');
plot([Y1 Y1],[del_co21-cl1_95, del_co21+cl1_95],'k')
plot([Y2 Y2],[del_co22-cl2_95, del_co22+cl2_95],'k')
bar_overlap(iord+1)=[del_co22-cl2_95-del_co21+cl1_95]
figure(10)
scatter(.1,del_co21,20,'ko','filled');
hold on
scatter(.9,del_co22,20,'ko','filled');
plot([0.1 0.1 ],[del_co21-cl1_95, del_co21+cl1_95],'k')
plot([.9 .9],[del_co22-cl2_95, del_co22+cl2_95],'k')
set(gca,'xlim',[0 1])
grid on
pause
close
end




