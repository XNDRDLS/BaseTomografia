clear
clc
close all


%Define o modelo do objeto a ser usado
Obj=zeros(1000,1000);
Obj(350:650,250:750)=1;

Metal=1000*ones(15);

Objm=Obj;
Objm(400:414,300:314)=Obj(400:414,300:314)+Metal;


%Mostra o objeto
montage(Obj)
title("Objeto")

%Calcula a transformada de radon do objeto
teta=0:0.1:180;
dteta=180/length(teta);
teta(end)=[];
[R,xp]= radon(Obj,teta);

[Rm,xpm] = radon(Objm,teta);


%Mostra a transformada de radon como heatmap
figure
imagesc(teta,xp,R)
xlabel("\theta (graus)")
ylabel("Sinal")
title('Sinograma do objeto')
set(gca,"XTick",0:20:180)
colormap(hot)
colorbar

figure
imagesc(teta,xpm,Rm)
xlabel("\theta (graus)")
ylabel("Sinal")
title('Sinograma do objeto metálico')
set(gca,"XTick",0:20:180)
colormap(hot)
colorbar



figure
t = tiledlayout(2,3);
t.TileSpacing = 'compact';
t.Padding = 'compact';

nexttile

%Objeto 0 graus
montage(Obj)
title("\theta=0°")
nexttile

%Objeto 45 graus
montage(imrotate(Obj,45));
title("\theta=45°")
nexttile

%Objeto 90 graus
montage(imrotate(Obj,90));
title("\theta=90°")
nexttile

%Sinograma 0 graus
plot(R(:,1))
axis([0 size(R,1) 0 1.1*max(max(R))])
nexttile

%Sinograma 45 graus
plot(R(:,round(1+45/dteta)))
axis([0 size(R,1) 0 1.1*max(max(R))])
nexttile

%Sinograma 90 graus
plot(R(:,round(1+90/dteta)))
axis([0 size(R,1) 0 1.1*max(max(R))])



I=iradon(R,teta);
Im=iradon(Rm,teta);

figure
montage(I)
title('Tranformada inversa de Radon do Objeto')
figure
montage(Im)
title('Tranformada inversa de Radon do Objeto Metálico')


bkp=repmat(R(:,1),1,size(R,2));

angs=4;
for i=1:angs
    bkp=bkp+imrotate(repmat(R(:,round(i*size(R,1)/angs)),1,size(R,2)),round(i*size(R,1)/angs)*180/size(R,1),'crop');
end
figure
bkp=imrotate(bkp,90);
montage(bkp,'DisplayRange',[0 round(max(max(bkp)))])
title('Back Projection em 3 ângulos')

figure
fbkp=iradon(R,teta);
montage(fbkp)
title('Filtered Back Projection do Objeto')

