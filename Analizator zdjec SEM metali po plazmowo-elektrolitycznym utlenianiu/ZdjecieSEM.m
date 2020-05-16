%UWAGA: pliki Test1, Test2 itd... zawieraja przyklady, a TestyJednostkowe
%zawieraja testy zapobiegajace tworzeniu bledow przy dalszej pracy nad
%programem


classdef ZdjecieSEM < handle
   properties (Access = private)
      zdjecie;
      nazwa;
      wysokosc;
      szerokosc;
      typKoloru;
      powierzchniePorow;
      obwodyPorow;
      sumaObwodowPorow;
      sumaSrednicPorow;
      powierzchniaPorow;
      iloscPorow;
      powierzchniaObrazu;
      srednicePorow;
      polaPowKwadratow;
      polaPowTrojkatow;
      sumaPolTrojkatow;
      sumaPolKwadratow;
      odleglosciPorow;
   end
   properties (Access = public)
       rysowaneFigury = "Kwadraty";
       rysujPolaczenia = 0;
   end
   methods
       
    function obj = ZdjecieSEM(zdjecie)
        if nargin == 1
            obj.nazwa = zdjecie;
            obj.zdjecie = imread(zdjecie);
            info = imfinfo(zdjecie);
            obj.wysokosc = info.Height;
            obj.szerokosc = info.Width;
            obj.typKoloru = info.ColorType;
            obj.powierzchniaObrazu = obj.pokazWysokosc()*obj.pokazSzerokosc();
        end
        
        %konstruktor klasy, umozliwia inicjalizacje jej:
        %a = ZdjecieSEM('img.jpg');
    end
    
    function zmienZdjecie(obj, zdjecie)
        obj.nazwa = zdjecie;
        obj.zdjecie = imread(zdjecie);
        info = imfinfo(zdjecie);
        obj.wysokosc = info.Height;
        obj.szerokosc = info.Width;
        obj.typKoloru = info.ColorType;
        obj.powierzchniaObrazu = obj.pokazWysokosc()*obj.pokazSzerokosc();
        
        %funkcja zamienia zdjecie, na ktorym operuje klasa
        %przyklad w Test12
    end
    
    function utnijOpis(obj)
        try
            zdjBuf = im2bw(obj.zdjecie, 0.01);
            wysokoscOpisu = 0;
            while zdjBuf(obj.pokazWysokosc()-wysokoscOpisu, 1) == 0 ||...
                  zdjBuf(obj.pokazWysokosc()-wysokoscOpisu, obj.pokazSzerokosc()-1) == 0
                wysokoscOpisu = wysokoscOpisu + 1;
            end
            obj.zdjecie = imcrop(obj.zdjecie,[0 0 obj.szerokosc obj.wysokosc-wysokoscOpisu]);
            obj.wysokosc = obj.pokazWysokosc()-wysokoscOpisu;
            obj.powierzchniaObrazu = obj.pokazWysokosc()*obj.pokazSzerokosc();
        catch ME
            
        end
        %ucina opis zdjecia umieszczony na dole o danej wysokosci
        %w pikselach, domyslnie dla wartosci 130 dziala dobrze
        %przyklad w Test17
    end
    
    function zamienNaSzare(obj)
        if obj.typKoloru ~= "grayscale"
            obj.zdjecie = rgb2gray(obj.zdjecie);
            obj.typKoloru = "grayscale";
        else
            disp("Obraz jest juz szary!");
        end
        
        %funkcja automatycznie, bez kontroli zamienia obraz na szary,
        %przyklad:
        %a = ZdjecieSEM('img.jpg');
        %a.zamienNaSzare();
    end
    
    function zamienNaSzareManualnie(obj, a, b, c)
        if obj.typKoloru ~= "grayscale"
            obj.zdjecie = a * obj.zdjecie(:,:,1) + b * obj.zdjecie(:,:,2) + c * obj.zdjecie(:,:,3);
            obj.typKoloru = "grayscale";
        else
            disp("Obraz jest juz szary!");
        end
        
        %funkcja manualnie zamienia obraz na szary, parametr a oznacza
        %czulosc na kolor czerwony, parametr b na zielony, c na niebieski
        %najlepiej wychodzi gdy parametry te sa miedzy 0 a 1
        %przyklad w Test11
    end
    
    function zamienNaBinarne(obj)
        obj.zdjecie = im2bw(obj.zdjecie);
        obj.typKoloru = "binary";
        %zamienia obraz na binarny, przyklad w Test10
    end
    
    function zamienNaBitPlane(obj, a, b)
        zdj = double(obj.zdjecie);
        obj.zdjecie = mod(floor(zdj/a),b);
        obj.typKoloru = "binary";
        
        %zamienia zdjecie na BitPlane, podobne do binarnego ale moze byc
        %kolorowe, parametry a i b moduluja czulosc algorytmu
        %przyklad w Test9
    end
    
    function zamienSzaryNaInd(obj, a)
        if obj.typKoloru == "grayscale"
            [X, map] = gray2ind(obj.zdjecie, a);
            disp("Ilosc kolorow = " + size(map));         
            disp("Kolory w RGB = ");
            disp(map);
            obj.zdjecie = X;
        else
            disp("Obraz musi byc szary!")
        end
        %zamienia obraz szary na typ ind oraz wyswietla ile odcieni RGB
        %jest uzyte i pokazuje ich tablice
        %parametr a wymusza ilosc odcieni szarosci uzytych przy konwersji
        %przyklad w Test8
    end
    
    function zamienNaDouble(obj)
        obj.zdjecie = im2double(obj.zdjecie);
        
        %zamienia zdjecie kolorowe lub szare na tablice wartosci od 0 do 1
        %(zamiast od 0 do 255, przydatne do niektorych innych dzialan),
        %przyklad w Test7
    end
    
    function rysujZdjecie(obj)
         imshow(obj.zdjecie);
         
        %rysuje zdjecie, przyklad:
        %a = ZdjecieSEM('img.jpg');
        %a.rysujZdjecieSkalowane();
    end
    
    function rysujZdjecieSkalowane(obj)
         imagesc(obj.zdjecie);
         
        %rysuje zdjecie ze skala ilosci pikselow, przyklad:
        %a = ZdjecieSEM('img.jpg');
        %a.rysujZdjecieSkalowane();
    end
    
    function rysujZdjecieSkalowaneCzerwone(obj)
         imagesc(obj.zdjecie(:,:,1));
                  
        %rysuje tylko czerwona czesc obrazu RGB, przyklad:
        %a = ZdjecieSEM('img.jpg');
        %a.rysujZdjecieSkalowaneCzerwone();
    end
    
    function rysujZdjecieSkalowaneZielone(obj)
         imagesc(obj.zdjecie(:,:,2));
         
        %rysuje tylko zielona czesc obrazu RGB, przyklad:
        %a = ZdjecieSEM('img.jpg');
        %a.rysujZdjecieSkalowaneZielone();
    end   
    
    function rysujZdjecieSkalowaneNiebieskie(obj)
         imagesc(obj.zdjecie(:,:,3));
         
        %rysuje tylko niebieska czesc obrazu RGB, przyklad:
        %a = ZdjecieSEM('img.jpg');
        %a.rysujZdjecieSkalowaneNiebieskie();
    end
    
    function sledzPory(obj)
        obj.zdjecie=max(obj.zdjecie,[],3);
        bw=imclose(obj.zdjecie<60,strel('disk',5));
        RP=regionprops(bw,'Centroid', 'EquivDiameter');
        N=numel(RP);
        C=zeros(N,2);
        D=zeros(N,1);
        for i=1:N, C(i,:)=RP(i).Centroid; end
        for i=1:N, D(i,:)=RP(i).EquivDiameter; end
        figure
        imshow(obj.pokazZdjecie())
        hold on
        plotData = [];
        h = zoom; % get handle to zoom utility
        set(h,'ActionPostCallback',@zoomCallBack);
        set(h,'Enable','on');
        function zoomCallBack(~, evd)      
            ax = axis(evd.Axes); % get axis size  
            cla(gca);
            imshow(obj.pokazZdjecie());
            for i = 1:N
                if obj.rysowaneFigury == "Kwadraty"
                    plotData(i) = plot(C(i,1),C(i,2),'rs','MarkerSize',D(i)*700/(ax(4)-ax(3)));
                else
                    plotData(i) = plot(C(i,1),C(i,2),'r^','MarkerSize',D(i)*700/(ax(4)-ax(3)));
                end
            end
        end
        
        %funkcja rysuje kwadraty wokol porow, nalezy zaczac powiekszac lub
        %zmnieszac zdjecie by zaczela to robic, mozna manipulwac ostroscia
        %zeby zwiekszyc jej skutecznosc
    end
    
    function sledzPoryBinarnie(obj)
    f = uifigure;
    pasekProgresu = uiprogressdlg(f, 'Title','Liczenie granic porow i rysowanie figur...'...
                       ,'Message','Prosze czekac...');

        obj.zdjecie=max(obj.zdjecie,[],3);
        bw=imclose(obj.zdjecie<60,strel('disk',5));
        RP=regionprops(bw,'Centroid', 'EquivDiameter', 'PixelList');
        wysBuf = obj.pokazWysokosc();
        szerBuf = obj.pokazSzerokosc();
        N=numel(RP);
        
        C=zeros(N,2);
        D=zeros(N,1);
        
        for i=1:N, D(i,:)=RP(i).EquivDiameter; end
        
        najwiekszaSrednica = round(max(D));
        
        for i=1:N, C(i,:)=RP(i).Centroid+najwiekszaSrednica; end
         obj.wysokosc = obj.pokazWysokosc()+najwiekszaSrednica*2+1;
         obj.szerokosc = obj.pokazSzerokosc()+najwiekszaSrednica*2+1;
         bwbuf = zeros(obj.pokazWysokosc(), obj.pokazSzerokosc());
         try
             for h=najwiekszaSrednica+1:obj.pokazWysokosc()
                 for w=najwiekszaSrednica+1:obj.pokazSzerokosc()
                     if h>2*najwiekszaSrednica+1 && w>2*najwiekszaSrednica+1
                         bwbuf(h-najwiekszaSrednica-1,w-najwiekszaSrednica-1) =...
                         bw(h-2*najwiekszaSrednica-1, w-2*najwiekszaSrednica-1);
                     end
                 end
             end
         catch ME
            obj.wysokosc = wysBuf;
            obj.szerokosc = szerBuf;
         end
         bw = bwbuf;
         for i=1:N, RP(i).PixelList = RP(i).PixelList+najwiekszaSrednica; end
         bwkopia = bw;
         for i=1:N
            jbuf = floor(D(i)/2);
                if obj.rysowaneFigury == "Kwadraty"
                    while obj.sprawdzGraniceKwadratow(bwkopia, C, i, jbuf, RP) == false
                        jbuf = jbuf+1;
                    end
                else
                    while obj.sprawdzGraniceTrojkatow(bwkopia, C, i, jbuf, RP) == false
                        jbuf = jbuf+1;
                    end 
                end
            if obj.rysowaneFigury == "Kwadraty"
                bw = obj.rysujKwadraty(bw, C, i, jbuf, true);
            else
                bw = obj.rysujTrojkaty(bw, C, i, jbuf, true);
            end

            pasekProgresu.Value = i/N; 
        end
        close(f);
        close(pasekProgresu);
        imshow(bw);
        obj.wysokosc = wysBuf;
        obj.szerokosc = szerBuf;
        
        %funkcja wpisuje pory w kwadraty
    end
    
    function rysujMaksymalneFigury(obj, czyHistogram)
    f = uifigure;
    pasekProgresu = uiprogressdlg(f, 'Title','Analiza parametrow porow...'...
                       ,'Message','Prosze czekac...');

        obj.zdjecie=max(obj.zdjecie,[],3);
        bw=imclose(obj.zdjecie<60,strel('disk',5));
        RP=regionprops(bw,'Centroid', 'EquivDiameter', 'PixelList');
        wysBuf = obj.pokazWysokosc();
        szerBuf = obj.pokazSzerokosc();
        N=numel(RP);
        C=zeros(N,2);
        D=zeros(N,1);
        jbufTab=zeros(N,1);
        obj.odleglosciPorow = {0};
        
        for i=1:N, D(i,:)=round(RP(i).EquivDiameter); end
        medianaSrednic = median(D);
        mnoznik = zeros(N,1);
        for i=1:N
%             if D(i) < medianaSrednic
%                 mnoznik(i) = 1;
%             else
%                 %mnoznik(i) = round(sqrt(D(i)/medianaSrednic));
%                 mnoznik(i) = round(D(i)/medianaSrednic);
%                 %mnoznik(i) = 1;
%             end
            mnoznik(i) = sqrt(D(i));
        end
        if obj.pokazWysokosc() > obj.pokazSzerokosc()
            wiekszyBok = obj.pokazWysokosc();  
        else
            wiekszyBok = obj.pokazSzerokosc(); 
        end

        
        for i=1:N, C(i,:)=RP(i).Centroid+wiekszyBok; end
         obj.wysokosc = obj.pokazWysokosc()+wiekszyBok*2+1;
         obj.szerokosc = obj.pokazSzerokosc()+wiekszyBok*2+1;
         bwbuf = zeros(obj.pokazWysokosc(), obj.pokazSzerokosc());
         try
             for h=wiekszyBok+1:obj.pokazWysokosc()
                 for w=wiekszyBok+1:obj.pokazSzerokosc()
                     if h>2*wiekszyBok+1 && w>2*wiekszyBok+1
                         bwbuf(h-wiekszyBok-1,w-wiekszyBok-1) =...
                         bw(h-2*wiekszyBok-1, w-2*wiekszyBok-1);
                     end
                 end
             end
         catch ME
            obj.wysokosc = wysBuf;
            obj.szerokosc = szerBuf;
         end
         bw = bwbuf;
         for i=1:N, RP(i).PixelList = RP(i).PixelList+wiekszyBok-1; end
         bwkopia = bw;
        for i=1:N
            jbuf = floor(D(i)/2);
                if obj.rysowaneFigury == "Kwadraty"
                    while obj.sprawdzGraniceKwadratow(bwkopia, C, i, jbuf, RP) == false
                        jbuf = jbuf+1;
                    end
                else
                    while obj.sprawdzGraniceTrojkatow(bwkopia, C, i, jbuf, RP) == false
                        jbuf = jbuf+1;
                    end 
                end
            jbufTab(i) = jbuf;
            if obj.rysowaneFigury == "Kwadraty"
                bw = obj.rysujKwadraty(bw, C, i, jbuf, false);
            else
                bw = obj.rysujTrojkaty(bw, C, i, jbuf, false);
            end
            if obj.rysujPolaczenia == 0
                pasekProgresu.Value = i/N/2;
            else
                pasekProgresu.Value = i/N/3;
            end
        end
        booleanTab = zeros(N,1);
    while ismember(0, booleanTab)
        for i=1:N
            if booleanTab(i) == 0
                for j=1:mnoznik(i)
                        if obj.rysowaneFigury == "Kwadraty"
                            if obj.sprawdzDostepnePoleKwadratu(bw, C, i, jbufTab(i)) == false
                                jbufTab(i) = jbufTab(i)+1;
                            else
                                booleanTab(i) = 1;
                                if obj.rysujPolaczenia == 0
                                    pasekProgresu.Value = 0.5 + sum(booleanTab(:) == 1)/N/2;
                                else
                                    pasekProgresu.Value = 0.33 + sum(booleanTab(:) == 1)/N/3;
                                end
                            end
                        else
                            if obj.sprawdzDostepnePolaTrojkata(bw, C, i, jbufTab(i)) == false
                                jbufTab(i) = jbufTab(i)+1;
                            else
                                booleanTab(i) = 1;
                                if obj.rysujPolaczenia == 0
                                    pasekProgresu.Value = 0.5 + sum(booleanTab(:) == 1)/N/2;
                                else
                                    pasekProgresu.Value = 0.33 + sum(booleanTab(:) == 1)/N/3;
                                end
                            end
                        end

                        if obj.rysowaneFigury == "Kwadraty"
                            bw = obj.rysujKwadraty(bw, C, i, jbufTab(i), false);
                        else
                            bw = obj.rysujTrojkaty(bw, C, i, jbufTab(i), false);
                        end

                        if booleanTab(i) == 1
                            break;
                        end
                end
            end
        end
    end
        for i=1:N
            if obj.rysowaneFigury == "Kwadraty"
                bwbuf = obj.rysujKwadraty(bwbuf, C, i, jbufTab(i), false);
            else
                bwbuf = obj.rysujTrojkaty(bwbuf, C, i, jbufTab(i), false);
            end
        end
        
        if obj.rysujPolaczenia == 1
            for i = 1:N
                for j = 1:N
                    bwbuf = rysujLinieLaczaceSasiadow(obj, bwbuf, C, i, j, RP);
                    pasekProgresu.Value = 0.66 + i/N/3;
                end
            end
        end
          for i=1:N
              if obj.rysowaneFigury == "Kwadraty"
                  bwbuf = obj.rysujKwadraty(bwbuf, C, i, jbufTab(i), true);
              else
                  bwbuf = obj.rysujTrojkaty(bwbuf, C, i, jbufTab(i), true);
              end
          end
        close(f);
        close(pasekProgresu);
        if czyHistogram == true
            for i=1:N
                a = 2*jbufTab(i);
                b = jbufTab(i);
                obj.polaPowKwadratow(i) = a*a;
                obj.polaPowTrojkatow(i) = b*b*sqrt(3)/4;
            end
        else
            imshow(bwbuf);
        end
        obj.wysokosc = wysBuf;
        obj.szerokosc = szerBuf;
        
        %funkcja wpisuje pory w najwieksze mozliwe kwadraty lub trojkaty
        %conajwyzej stykajace sie z innymi
    end
    
    function zmienKolorystyke(obj, kolor)
        colormap(kolor);
        
        %zmienia kolorystyke przy rysowaniu szarego zdjecia,
        %'koloruje' je ale tylko przy wyswietlaniu funkcja rysujZdjecie()
        %i rysujZdjecieSkalowane()
        %mozliwe kolory:
        %"jet", "spring", "HSV", "Hot", "Cool",
        %"Summer", "Autumn", "Winter", "Gray", "Bone", 
        %"Copper, "Pink", "Lines"
        %"Gray" powraca do normalnego wyswietlania szarych obrazow
    end
    
    function zwielokrotnijZawartoscNiebieskiego(obj, a)
        obj.zdjecie = double(obj.zdjecie);                
        obj.zdjecie(:,:,3) = a*obj.zdjecie(:,:,3);  
        obj.zdjecie = uint8(obj.zdjecie); 
        
        %zwielokrotnia zawartosc koloru niebieskiego w kolorowym obrazie RGB,
        %jesli a bedzie wieksze od 1 to te wartosc zwiekszy, a jak bedzie
        %mniejsze od 1 to zmniejszy,
        %przyklad w Test6
    end
    
    function zwielokrotnijZawartoscZielonego(obj, a)
        obj.zdjecie = double(obj.zdjecie);                
        obj.zdjecie(:,:,2) = a*obj.zdjecie(:,:,2);  
        obj.zdjecie = uint8(obj.zdjecie); 
        
        %zwielokrotnia zawartosc koloru zielonego w kolorowym obrazie RGB,
        %jesli a bedzie wieksze od 1 to te wartosc zwiekszy, a jak bedzie
        %mniejsze od 1 to zmniejszy,
        %przyklad w Test6
    end
    
    function zwielokrotnijZawartoscCzerwonego(obj, a)
        obj.zdjecie = double(obj.zdjecie);                
        obj.zdjecie(:,:,1) = a*obj.zdjecie(:,:,1);  
        obj.zdjecie = uint8(obj.zdjecie); 
        
        %zwielokrotnia zawartosc koloru czerwonego w kolorowym obrazie RGB,
        %jesli a bedzie wieksze od 1 to te wartosc zwiekszy, a jak bedzie
        %mniejsze od 1 to zmniejszy,
        %przyklad w Test6
    end
    
    function wypiszInformacje(obj)
        disp(imfinfo(obj.nazwa));
    end
    
    function pokazKolorPikselu(obj, x, y)
        disp("Kolor pikselu = " + obj.zdjecie(x,y,:));
        
        %pokazuje udzial czerwonego, zielonego i niebieskiego koloru w
        %pojedynczym pikselu, jesli obraz jest szary daje skale szarosci
    end
    
    function zapiszZdjecie(obj, nazwa, format)
        imwrite(obj.zdjecie, nazwa, format);
        
        %zapisuje aktualnie edytowane zdjecie, przyklad w Test5
    end
    
    function rysujHistogram(obj)
        imhist(obj.zdjecie);
        ylabel('Ilosc pikseli o danym odcieniu');
        
        %rysuje histogram zdjecia szarego lub binarnego,
        %jesli zdjecie jest kolorowe nalezy przed uzyc funkcji
        %zamienNaSzare() lub zamienNaBinarne()
        %przyklad:
        %a = ZdjecieSEM('220V2minI0006.png');
        %a.rysujHistogramKontrastowy();
    end
    
    function rysujHistogramKontrastowy(obj)
        imhist(histeq(obj.zdjecie));
        ylabel('Ilosc pikseli o danym odcieniu');
        
        %rysuje histogram kontrastowy zdjecia szarego lub binarnego,
        %jesli zdjecie jest kolorowe nalezy przed uzyc funkcji
        %zamienNaSzare() lub zamienNaBinarne()
        %przyklad:
        %a = ZdjecieSEM('img.jpg');
        %a.zamienNaSzare();
        %a.rysujHistogramKontrastowy();
    end
    
    function wyostrzZdjecie(obj, a, b)
        obj.zdjecie = imadjust(obj.zdjecie, [a,b],[]);
        
        %funkcja wyostrza zdjecie, b powinna byc wieksze od a, wartosci te
        %powinny byc w zakresie od 0 do 1, im wieksza roznica miedz a i b,
        %tym wieksze wyostrzenie
        %przyklad - Test5
    end
    
    function wyroznijPola(obj, a, b)
     f = uifigure;
     pasekProgresu = uiprogressdlg(f, 'Title','Analizowanie obrazu...'...
                       ,'Message','Prosze czekac...');
        obj.zamienNaDouble();
        for i=1:obj.wysokosc
           for j=1:obj.szerokosc
              if obj.zdjecie(i,j,:) > a 
                 obj.zdjecie(i,j,:) = b; 
              end
           end
           pasekProgresu.Value = i/obj.wysokosc; 
        end
        close(f);
        close(pasekProgresu);
        %funkcja zamienia w obrazie szarym zamienionym na double
        %funkcja zamienNaDouble wartosci jasniejsze od par. a
        %na wartosci zadane, gdzie 0 to kolor czarny, 1 - bialy, 0.5 szary
        %etc
        %przyklad - Test4
    end
    
    function zaznaczPola(obj, a, b)
        f = uifigure;
        pasekProgresu = uiprogressdlg(f, 'Title','Analizowanie obrazu...'...
                       ,'Message','Prosze czekac...');
        obj.zamienNaDouble();
        for i=1:obj.wysokosc
           for j=1:obj.szerokosc
           if b < a
               disp("Drugi parametr musi byc wiekszy od pierwszego!");
               break;
           end
              if obj.zdjecie(i,j,:) > a && obj.zdjecie(i,j,:) < b
                 obj.zdjecie(i,j,:) = 1; 
              end
           end
           pasekProgresu.Value = i/obj.wysokosc; 
        end
        close(f);
        close(pasekProgresu);
        
        %funkcja zaznacza w zdjeciu szarym zamienionym na double funckja
        %zamienNaDouble obszary o zadanym odcieniu
        %bialym konturem, by funkcja dzialala b musi byc wieksze od a,
        %przykladowe wartosci b i a to 0.53 i 0.56
        %przyklad - Test3
    end
    
    
    
    
    function podzielNaObszary(obj, a, b, c, d, e)
        f = uifigure;
        pasekProgresu = uiprogressdlg(f, 'Title','Analizowanie obrazu...'...
                       ,'Message','Prosze czekac...');
                   
        gmag = imgradient(obj.zdjecie);

        L = watershed(gmag);
        Lrgb = label2rgb(L);
        pasekProgresu.Value = 0.2;
        se = strel('disk',5);
        Io = imopen(obj.zdjecie,se);

        Ie = imerode(obj.zdjecie,se);
        Iobr = imreconstruct(Ie,obj.zdjecie);

        Ioc = imclose(Io,se);
        pasekProgresu.Value = 0.4;
        
        Iobrd = imdilate(Iobr,se);
        Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
        Iobrcbr = imcomplement(Iobrcbr);
        pasekProgresu.Value = 0.6;

        fgm = imregionalmax(Iobrcbr);

        I2 = labeloverlay(obj.zdjecie,fgm);

        se2 = strel(ones(5,5));
        fgm2 = imclose(fgm,se2);
        fgm3 = imerode(fgm2,se2);
        fgm4 = bwareaopen(fgm3,3);
        I3 = labeloverlay(obj.zdjecie,fgm4);
        pasekProgresu.Value = 0.8;

        bw = imbinarize(Iobrcbr);

        D = bwdist(bw);
        DL = watershed(D);
        bgm = DL == 0;

        gmag2 = imimposemin(gmag, bgm | fgm4);
        L = watershed(gmag2);
        labels = imdilate(L==0,ones(d,e)) + 2*bgm;
        pasekProgresu.Value = 0.99;
        I4 = labeloverlay(obj.zdjecie,labels);
        obj.zdjecie = I4;
        close(f);
        close(pasekProgresu);
        
        %funkcja dzieli obraz na podobszary
        %parametry d i e odpowiadaja za grubosc linii dzielacych
        %parametry a, b i c odpowiadaja za wyczulenie na ksztalty w obrazie
        %przyklad - Test2
    end
    
    function powierzchnie = obliczPowierzchniePorow(obj, a)
        if obj.typKoloru == "binary"
            [mserRegions, mserConnComp] = detectMSERFeatures(obj.zdjecie, ...
            'RegionAreaRange',[10 10000],...
            'ThresholdDelta',20,'MaxAreaVariation',1);
            mserStats = regionprops(mserConnComp, 'Area');
            obj.powierzchniePorow = [mserStats.Area]*a*a/10000;
            obj.powierzchniaPorow = sum(obj.pokazPowierzchniePorow());
            powierzchnie = obj.powierzchniePorow;
        else
            disp("Obraz musi byc binarny!")
        end
        
        %funkcja wypisujaca pola wystepujacych porow oraz srednice porow
        %parametr a to stosunek ile mikrometrow ma 100 pikseli, w przykladzie
        %100 pikseli to 100000um
        %przyklad w Test13
    end
    
    function obliczObwodyPorow(obj, a)
        if obj.typKoloru == "binary"
            [mserRegions, mserConnComp] = detectMSERFeatures(obj.zdjecie, ...
            'RegionAreaRange',[10 10000],...
            'ThresholdDelta',20,'MaxAreaVariation',1);
            mserStats = regionprops(mserConnComp,'Perimeter');
            obj.obwodyPorow = [mserStats.Perimeter]*a/100;
            obj.sumaObwodowPorow = sum(obj.pokazObwodyPorow());
        else
            disp("Obraz musi byc binarny!")
        end
        
        %funkcja wypisujaca pola wystepujacych porow oraz srednice porow
        %parametr a to stosunek ile mikrometrow ma 100 pikseli, w przykladzie
        %100 pikseli to 100000um
        %przyklad w Test14
    end
    
    function obliczSrednicePorow(obj)
        if obj.powierzchniePorow ~= 0
            obj.srednicePorow = sqrt(4/3.14*(obj.powierzchniePorow));
            obj.sumaSrednicPorow = sum(obj.pokazSrednicePorow());
        else
           disp('Nalezy najpierw obliczyc powierzchnie porow!') 
        end
        
        %funkcja wypisujaca srednice wystepujacych porow,
        %trzeba najpierw obliczyc pola powierzchnii porow funkcja
        %obliczPowierzchniePorow()
        %parametr a to stosunek ile metrow ma 100 pikseli, w przykladzie
        %100 pikseli to 100000um
        %przyklad w Test15
    end
    
    function obliczIloscPorow(obj)
        if obj.typKoloru == "binary"
            [mserRegions, mserConnComp] = detectMSERFeatures(obj.zdjecie, ...
            'RegionAreaRange',[10 10000],...
            'ThresholdDelta',20,'MaxAreaVariation',1);
        
            mserStats = regionprops(mserConnComp, 'Area');
            obj.iloscPorow = max(size([mserStats.Area]));
        else
            disp("Obraz musi byc binarny!")
        end
        
        %funkcja zliczajaca ilosc porow, obraz musi byc binarny
        %przyklad w Test16
    end
    
    function obliczPolaObszarow(obj, a)
            obj.polaPowTrojkatow = obj.pokazPowierzchnieObszarowTrojkatow()*a*a/10000;
            obj.polaPowKwadratow = obj.pokazPowierzchnieObszarowKwadratow()*a*a/10000;
            obj.sumaPolTrojkatow = sum(obj.pokazPowierzchnieObszarowTrojkatow());
            obj.sumaPolKwadratow = sum(obj.pokazPowierzchnieObszarowKwadratow());
    end
    
    function parametryKwadratowPorow = podajParametryKwadratowPorow(obj, centra,...
            y, b)
            hDodane = centra(y,2)+b;
            hOdjete = centra(y,2)-b;
            wDodane = centra(y,1)+b;
            wOdjete = centra(y,1)-b;
            parametryKwadratowPorow = [hDodane, hOdjete, wDodane, wOdjete];
                
                %Funkcja zwraca koordynaty potrzebne do wyznaczenia rogow
                %kwadratu, w ktory wpisany jest por
    end
    
    function parametryTrojkatowPorow = podajParametryTrojkatowPorow(obj, centra,...
            y, b)
            wGornyY = round(centra(y,2)-b*2/3);
            wGornyX = round(centra(y,1));
            wLewyY = round(centra(y,2)+round(b/3));
            wLewyX = round(centra(y,1)+round(b/sqrt(3)));
            wPrawyY = round(centra(y,2)+round(b/3));
            wPrawyX = round(centra(y,1)-round(b/sqrt(3)));
            parametryTrojkatowPorow = [wGornyY, wGornyX, wLewyY, wLewyX,...
                                       wPrawyY, wPrawyX];
                
                %Funkcja zwraca koordynaty potrzebne do wyznaczenia
                %wierzcholkow trojkata, w ktory wpisany jest por
    end
    
    function zdj =  rysujKwadraty(obj, zdjecie, centra, i, j, czyGrubo)
            for x = 0:j*2
                par = obj.podajParametryKwadratowPorow(centra,i,j);
                hDodane = par(1);
                hOdjete = par(2);
                wDodane = par(3);
                wOdjete = par(4);

                zdjecie(round(hDodane-x),round(wDodane)) = 1;
                zdjecie(round(hOdjete+x),round(wOdjete)) = 1;
                zdjecie(round(hDodane),round(wOdjete+x)) = 1;
                zdjecie(round(hOdjete),round(wDodane-x)) = 1;
                if czyGrubo == true
                    zdjecie(round(hDodane-x),round(wDodane-1)) = 1;
                    zdjecie(round(hOdjete+x),round(wOdjete+1)) = 1;
                    zdjecie(round(hDodane-1),round(wOdjete+x)) = 1;
                    zdjecie(round(hOdjete+1),round(wDodane-x)) = 1;
                end
            end
            zdj = zdjecie;
            %Funkcja wpisuje dany por (obszar zdjecia) w kwadrat, j = bok
    end
    
    function zdj =  rysujTrojkaty(obj, zdjecie, centra, i, j, czyGrubo)
            for x = 0:j*2
                par = obj.podajParametryTrojkatowPorow(centra,i,j);
                wGornyY = par(1);
                wGornyX = par(2);
                wLewyY = par(3);
                wLewyX = par(4);
                wPrawyY = par(5);
                wPrawyX = par(6);

                zdjecie(wGornyY+round(x/2),round(wGornyX-(x/sqrt(3))/2)) = 1;
                zdjecie(wGornyY+round(x/2),round(wGornyX+(x/sqrt(3))/2)) = 1;
                zdjecie(wLewyY,round(wLewyX-x/sqrt(3))) = 1;
                zdjecie(wPrawyY,round(wPrawyX+x/sqrt(3))) = 1;
                if czyGrubo == true
                    zdjecie(wGornyY+round(x/2)-1,round(wGornyX-(x/sqrt(3))/2)) = 1;
                    zdjecie(wGornyY+round(x/2)-1,round(wGornyX+(x/sqrt(3))/2)) = 1;
                    zdjecie(wLewyY+1,round(wLewyX-x/sqrt(3))) = 1;
                    zdjecie(wPrawyY+1,round(wPrawyX+x/sqrt(3))) = 1;
                end
            end
            zdj = zdjecie;
            %Funkcja wpisuje dany por (obszar zdjecia) w kwadrat
    end
    
    function zdj = rysujLinieLaczaceSasiadow(obj, zdjecie, centra, i, j, RP)
        if i ~= j
            ileBialych = 0;
            
            y1 = centra(i, 1);
            x1 = centra(i, 2);
            y1buf = centra(i, 1);
            x1buf = centra(i, 2);
            y2 = centra(j, 1);
            x2 = centra(j, 2);
            
            yTick = abs(y1-y2);
            xTick = abs(x1-x2);
            odleglosc = sqrt(xTick^2 + yTick^2);
            
              while yTick > 1 || xTick > 1
                  yTick = yTick/1.1;
                  xTick = xTick/1.1;
              end
            
              if x1 > x2
                 xTick = -xTick;
              end
                 
              if y1 > y2
                 yTick = -yTick;
              end
              if abs(yTick/xTick)>0.15 && abs(xTick/yTick)>0.15
               while sqrt((x1-x2)^2+(y1-y2)^2) > 1
                    x1 = x1 + xTick;
                    y1 = y1 + yTick;                
                    isHere1 = max(ismember([round(x1),round(y1)], [round(RP(i).PixelList(:))]));
                    isHere2 = max(ismember([round(x1),round(y1)], [round(RP(j).PixelList(:))]));

                     if zdjecie(round(x1), round(y1)) == 1 && isHere1 == 0 && isHere2 == 0
                         ileBialych = ileBialych + 1;
                         if ileBialych > 2
                             zdj = zdjecie;
                             return;
                         end
                     end
                end           
                while sqrt((x1buf-x2)^2+(y1buf-y2)^2) > 1
                     x1buf = x1buf + xTick;
                     y1buf = y1buf + yTick;
                     zdjecie(round(x1buf), round(y1buf)) = 1;
                     zdjecie(round(x1buf-1), round(y1buf-1)) = 1;
                end
                obj.odleglosciPorow = cat(1,obj.odleglosciPorow,odleglosc);
              end

        end
        zdj = zdjecie;
        
        %Funkcja oblicza odleglosci sasiednich obszarow porow i rysuje
        %polaczenia
    end
    
    function spr = sprawdzGraniceTrojkatow(obj, zdjecie, centra, i, j, RP)
            buf = true;
            for x = 0:j*2
                par = obj.podajParametryTrojkatowPorow(centra,i,j);
                wGornyY = par(1);
                wGornyX = par(2);
                wLewyY = par(3);
                wLewyX = par(4);
                wPrawyY = par(5);
                wPrawyX = par(6);

                isHere1 = min(ismember([round(wGornyY+round(x/2)),round(wGornyX-(x/sqrt(3))/2)], [round(RP(i).PixelList(:))]));
                isHere2 = min(ismember([wGornyY+round(x/2),round(wGornyX+(x/sqrt(3))/2)], [round(RP(i).PixelList(:))]));
                isHere3 = min(ismember([wLewyY,round(wLewyX-x/sqrt(3))], [round(RP(i).PixelList(:))]));
                isHere4 = min(ismember([wPrawyY,round(wPrawyX+x/sqrt(3))], [round(RP(i).PixelList(:))]));

                 if  zdjecie(round(wGornyY+round(x/2)),round(wGornyX-(x/sqrt(3))/2)) == 1 && isHere1 &&...
                     zdjecie(round(wGornyY+round(x/2))-1,round(wGornyX-(x/sqrt(3))/2)+1) == 1 ||...
                     zdjecie(round(wGornyY+round(x/2)),round(wGornyX+(x/sqrt(3))/2)) == 1 && isHere2 &&...
                     zdjecie(round(wGornyY+round(x/2)-1),round(wGornyX+(x/sqrt(3))/2)-1) == 1 || ...
                     zdjecie(round(wLewyY),round(wLewyX-x/sqrt(3))) == 1 && isHere3 &&...
                     zdjecie(round(wLewyY),round(wLewyX-x/sqrt(3))+1) == 1 || ...
                     zdjecie(round(wPrawyY),round(wPrawyX+x/sqrt(3))) == 1 && isHere4 &&...
                     zdjecie(round(wPrawyY),round(wPrawyX+x/sqrt(3))-1) == 1
                    
                    buf = false;
                 end
            end
            spr = buf;
            %Funkcja sprawdza czy dana dlugosc optymalnie wpisuje por w
            %trojkat
    end
    
    function spr = sprawdzGraniceKwadratow(obj, zdjecie, centra, i, j, RP)
            buf = true;
            for x = 1:j*2
                par = obj.podajParametryKwadratowPorow(centra,i,j);
                hDodane = par(1);
                hOdjete = par(2);
                wDodane = par(3);
                wOdjete = par(4);

                isHere1 = min(ismember([round(hDodane-x),round(wDodane)], [round(RP(i).PixelList(:))]));
                isHere2 = min(ismember([round(hOdjete+x),round(wOdjete)], [round(RP(i).PixelList(:))]));
                isHere3 = min(ismember([round(hDodane),round(wOdjete+x)], [round(RP(i).PixelList(:))]));
                isHere4 = min(ismember([round(hOdjete),round(wDodane-x)], [round(RP(i).PixelList(:))]));

                 if  zdjecie(round(hDodane-x),round(wDodane)) == 1 && isHere1 &&...
                     zdjecie(round(hDodane-x+1),round(wDodane)) == 1 ||...
                     zdjecie(round(hOdjete+x),round(wOdjete)) == 1 && isHere2 &&...
                     zdjecie(round(hOdjete+x-1),round(wOdjete)) == 1 || ...
                     zdjecie(round(hDodane),round(wOdjete+x)) == 1 && isHere3 &&...
                     zdjecie(round(hDodane),round(wOdjete+x-1)) == 1 || ...
                     zdjecie(round(hOdjete),round(wDodane-x)) == 1 && isHere4 &&...
                     zdjecie(round(hOdjete),round(wDodane-x+1)) == 1
                    
                    buf = false;
                 end
            end
            spr = buf;
            %Funkcja sprawdza czy dana dlugosc optymalnie wpisuje por w
            %kwadrat
    end
    
    function spr = sprawdzDostepnePoleKwadratu(obj, zdjecie, centra, i, j)
            buf = true;
            for x = 0:j*2
                par = obj.podajParametryKwadratowPorow(centra,i,j);
                hDodane = par(1);
                hOdjete = par(2);
                wDodane = par(3);
                wOdjete = par(4);
                
                 if  (zdjecie(round(hDodane-x-1),round(wDodane)) ~= 1 &&...
                     zdjecie(round(hOdjete+x+1),round(wOdjete)) ~= 1 &&...
                     zdjecie(round(hDodane),round(wOdjete+x+1)) ~= 1 &&...
                     zdjecie(round(hOdjete),round(wDodane-x-1)) ~= 1)
                 
                    buf = false;
                 end
            end
            spr = buf;
            %Funkcja sprawdza czy dana dlugosc optymalnie wpisuje por w
            %kwadrat
    end
    
    function spr = sprawdzDostepnePolaTrojkata(obj, zdjecie, centra, i, j)
            buf = true;
            for x = 1:j*2
                par = obj.podajParametryTrojkatowPorow(centra,i,j);
                wGornyY = par(1);
                wGornyX = par(2);
                wLewyY = par(3);
                wLewyX = par(4);
                wPrawyY = par(5);
                wPrawyX = par(6);

                 if  (zdjecie(round(wGornyY-x/2-1),round(wGornyX-(x/sqrt(3))/2)-1) ~= 1 &&...
                     zdjecie(round(wGornyY-x/2-1),round(wGornyX+(x/sqrt(3))/2)+1) ~= 1 &&...
                     zdjecie(round(wGornyY-1),round(wGornyX)) ~= 1 &&...
                     zdjecie(round(wLewyY),round(wLewyX-x/sqrt(3)/2)+1) ~= 1 &&...
                     zdjecie(round(wPrawyY),round(wPrawyX+x/sqrt(3)/2)+1) ~= 1) ||...
                     (zdjecie(round(wGornyY-x/2-1),round(wGornyX-(x/sqrt(3))/2)-2) ~= 1 &&...
                     zdjecie(round(wGornyY-x/2-1),round(wGornyX+(x/sqrt(3))/2)+2) ~= 1 &&...
                     zdjecie(round(wGornyY-2),round(wGornyX)) ~= 1 &&...
                     zdjecie(round(wLewyY-1),round(wLewyX-x/sqrt(3)/2)+2) ~= 1 &&...
                     zdjecie(round(wPrawyY+1),round(wPrawyX+x/sqrt(3)/2)+2) ~= 1) ||...
                     (zdjecie(round(wLewyY-1),round(wLewyX-x/sqrt(3)/2)-1) ~= 1 &&...
                     zdjecie(round(wPrawyY+1),round(wPrawyX+x/sqrt(3)/2)+1) ~= 1)
                    
                    buf = false;
                 end
            end
            spr = buf;
            %Funkcja sprawdza czy dana dlugosc optymalnie wpisuje por w
            %trojkat
    end
    
    %Funkcje zwracajace parametry klasy ZdjecieSEM tzw. gettery
    %przyklady w Test18
    function nazwa = pokazNazwe(obj) 
        nazwa = obj.nazwa;
    end
    
    function zdjecie = pokazZdjecie(obj) 
        zdjecie = obj.zdjecie;
    end
    
    function wysokosc = pokazWysokosc(obj) 
        wysokosc = obj.wysokosc;
    end
    
    function szerokosc = pokazSzerokosc(obj) 
        szerokosc = obj.szerokosc;
    end
    
    function typKoloru = pokazTypKoloru(obj) 
        typKoloru = obj.typKoloru;
    end
    
    function powierzchniePorow = pokazPowierzchniePorow(obj) 
        if obj.powierzchniePorow~=0
            powierzchniePorow = obj.powierzchniePorow;
        else
            disp("Powierzchnie porow nie zostaly jeszcze obliczone!");
        end
    end
    
    function obwodyPorow = pokazObwodyPorow(obj) 
        if obj.obwodyPorow~=0
            obwodyPorow = obj.obwodyPorow;
        else
            disp("Obwody porow nie zostaly jeszcze obliczone!");
        end
    end

%       polaPowKwadratow;
%       polaPowTrojkatow;
    function polaPowKwadratow = pokazPowierzchnieObszarowKwadratow(obj) 
            polaPowKwadratow = obj.polaPowKwadratow;
    end
    
    function polaPowTrojkatow = pokazPowierzchnieObszarowTrojkatow(obj) 
            polaPowTrojkatow = obj.polaPowTrojkatow;
    end
    
    function iloscPorow = pokazIloscPorow(obj) 
        if obj.iloscPorow~=0
            iloscPorow = obj.iloscPorow;
        else
            disp("Ilosc porow jeszcze nie zostala obliczona!");
        end
    end
    
    function srednicePorow = pokazSrednicePorow(obj) 
        if obj.srednicePorow~=0
            srednicePorow = obj.srednicePorow;
        else
            disp("Srednice porow jeszcze nie zostaly obliczone!");
        end
    end
    
    function powierzchniaObrazu = pokazPowierzchnieObrazu(obj) 
        if obj.powierzchniaObrazu~=0
            powierzchniaObrazu = obj.powierzchniaObrazu;
        else
            disp("Powierzchnia obrazu nie zostala jeszcze obliczona!");
        end
    end
    
    function sumaObwodowPorow = pokazSumeObwodowPorow(obj) 
        if obj.sumaObwodowPorow~=0
            sumaObwodowPorow = obj.sumaObwodowPorow;
        else
            disp("Suma obwodow porow nie zostala jeszcze obliczona!");
        end
    end
    
    function sumaSrednicPorow = pokazSumeSrednicPorow(obj) 
        if obj.sumaSrednicPorow~=0
            sumaSrednicPorow = obj.sumaSrednicPorow;
        else
            disp("Suma srednic porow nie zostala jeszcze obliczona!");
        end
    end
%       sumaPolTrojkatow
%       sumaPolKwadratow;
    function sumaPolTrojkatow = pokazSumePolTrojkatow(obj) 
        sumaPolTrojkatow = obj.sumaPolTrojkatow;
    end
    
    function sumaPolKwadratow = pokazSumePolKwadratow(obj) 
        sumaPolKwadratow = obj.sumaPolKwadratow;
    end
    
    function stosunek = pokazStosunekPolKwadratyObraz(obj, a)
        stosunek = obj.pokazSumePolKwadratow()/...
                   (obj.pokazWysokosc()*obj.pokazSzerokosc()*a*a/10000-...
                   obj.pokazSumePolKwadratow());
                   disp("Kwadraty = " + obj.pokazSumePolKwadratow());
                   disp("Obraz = " + obj.pokazWysokosc()*obj.pokazSzerokosc()*a*a/10000);
                   disp("Obraz bez kwadratow = " + (obj.pokazWysokosc()*obj.pokazSzerokosc()*a*a/10000-...
                   obj.pokazSumePolKwadratow()));
    end
    
        function odleglosci = pokazOdleglosciObszarow(obj, a)
            buf = cell2mat(obj.odleglosciPorow);
            odleglosci = buf*a/100;
    end
    
    function stosunek = pokazStosunekPolTrojkatyObraz(obj, a)
        stosunek = obj.pokazSumePolTrojkatow()/...
                   (obj.pokazWysokosc()*obj.pokazSzerokosc()*a*a/10000-...
                   obj.pokazSumePolTrojkatow());
              	   disp("Trojkaty = " + obj.pokazSumePolTrojkatow());
                   disp("Obraz = " + obj.pokazWysokosc()*obj.pokazSzerokosc()*a*a/10000);
                   disp("Obraz bez trojkatow = " + (obj.pokazWysokosc()*obj.pokazSzerokosc()*a*a/10000-...
                   obj.pokazSumePolTrojkatow()));
    end
    
   end
end
