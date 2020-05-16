classdef AnalizatorZdjecSemGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        RysujhistogramMenu              matlab.ui.container.Menu
        RysujhistogramodcieniMenu       matlab.ui.container.Menu
        RysujhistogramkontrastowyMenu   matlab.ui.container.Menu
        RysujhistogrampolpowporowMenu   matlab.ui.container.Menu
        RysujhistogramsrednicporowMenu  matlab.ui.container.Menu
        RysujhistogramobwodowporowMenu  matlab.ui.container.Menu
        RysujhistogrampolobszarowporowMenu  matlab.ui.container.Menu
        ObszarywpostacitrojkatowrownobocznychMenu  matlab.ui.container.Menu
        ObszarywpostacikwadratowMenu    matlab.ui.container.Menu
        RysujhistogramodlegloscisasiednichobszarowporowMenu  matlab.ui.container.Menu
        ImageAxes                       matlab.ui.control.UIAxes
        LoadButton                      matlab.ui.control.Button
        UtnijopisButton                 matlab.ui.control.Button
        ZamiennaszareButton             matlab.ui.control.Button
        ZamiennabinarneButton           matlab.ui.control.Button
        ZamiennabitplaneButton          matlab.ui.control.Button
        RysujzielonaczesczdjeciaButton  matlab.ui.control.Button
        RysujczerwonaczesczdjeciaButton  matlab.ui.control.Button
        RysujniebieskaczesczdjeciaButton  matlab.ui.control.Button
        WyroznijporyButton              matlab.ui.control.Button
        ZaznaczporyButton               matlab.ui.control.Button
        PodzielnaobszaryButton          matlab.ui.control.Button
        IIoscumna100pikseliEditFieldLabel  matlab.ui.control.Label
        IIoscumna100pikseliEditField    matlab.ui.control.NumericEditField
        DropDown                        matlab.ui.control.DropDown
        TypkolorowaniaszaregoLabel      matlab.ui.control.Label
        RysujfigurynaporachButton       matlab.ui.control.Button
        RysujfigurybinarnieButton       matlab.ui.control.Button
        ParametrASliderLabel            matlab.ui.control.Label
        ParametrASlider                 matlab.ui.control.Slider
        ParametrBSliderLabel            matlab.ui.control.Label
        ParametrBSlider                 matlab.ui.control.Slider
        OstroscABLabel                  matlab.ui.control.Label
        ZatwierdzButton                 matlab.ui.control.Button
        AnulujButton                    matlab.ui.control.Button
        UdzialkolorowLabel              matlab.ui.control.Label
        CzewronySliderLabel             matlab.ui.control.Label
        CzewronySlider                  matlab.ui.control.Slider
        NiebieskiSliderLabel            matlab.ui.control.Label
        NiebieskiSlider                 matlab.ui.control.Slider
        ZielonySliderLabel              matlab.ui.control.Label
        ZielonySlider                   matlab.ui.control.Slider
        ZatwierdzButton_2               matlab.ui.control.Button
        AnulujButton_2                  matlab.ui.control.Button
        Label                           matlab.ui.control.Label
        OdswiezButton                   matlab.ui.control.Button
        ParASliderLabel                 matlab.ui.control.Label
        ParASlider                      matlab.ui.control.Slider
        ParBSliderLabel                 matlab.ui.control.Label
        ParBSlider                      matlab.ui.control.Slider
        ParCSliderLabel                 matlab.ui.control.Label
        ParCSlider                      matlab.ui.control.Slider
        ZamiennaszareLabel              matlab.ui.control.Label
        manualnieLabel                  matlab.ui.control.Label
        ZatwierdzButton_3               matlab.ui.control.Button
        AnulujButton_3                  matlab.ui.control.Button
        Switch                          matlab.ui.control.ToggleSwitch
        RysujobszaryporowButton         matlab.ui.control.Button
        RysujpolaczeniasasiednichobszarowCheckBox  matlab.ui.control.CheckBox
    end

    
    properties (Access = public)
        zdjecieSem;
        czyUcieto = false;
        mNaStoPikseli = 0;
        typKolorowania = "gray";
        parA = 0.2;
        parB = 0.8;
        udzialZielonego = 1;
        udzialCzerwonego = 1;
        udzialNiebieskiego = 1;
    end
    
    properties (Access = private)
        zoomHandler; % Description
    end
    
    methods (Access = private)
        
        function zmienZdjece(app,imagefile)
                try
                    app.zdjecieSem = ZdjecieSEM(imagefile);
                    app.czyUcieto = false;
                    app.zdjecieSem.rysowaneFigury = app.Switch.Value;
                catch ME
                    uialert(app.UIFigure, "Sproboj jeszcze raz.", 'Blad!');
                    return;
                end            
            
                imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
         
        end
        
        function parametry = pokazDialog(app, iloscWejsc, tytul, tekst)
            try
                 f = dialog('Units','Normalized',...
                 'Position',[.4 .4 .3 .3],...
                 'NumberTitle','off',...
                 'Name','Info');
                 txt = uicontrol('Parent',f,...
                 'Style','text',...
                 'Position',[135 210 210 40],...
                 'String',tytul);
                 txte = [];
                 
                     for i = 1:iloscWejsc
                         txte(i) = uicontrol('Parent',f,...
                         'Style','text',...
                         'Position',[20 (15+i*32) 60 30],...
                         'String',tekst(i));
                         parametr(i) = uicontrol('Style','Edit',...
                         'Units','Normalized',...
                         'Position',[.2 (.10+i*.12) .3 .1],...
                         'Tag','');
                     end
                     
                 p = uicontrol('Style','PushButton',...
                 'Units','Normalized',...
                 'Position',[.6 .2 .3 .1],...
                 'String','Ok',...
                 'CallBack','uiresume(gcbf)');
                 uiwait(f);
                 
                     for i = 1:iloscWejsc
                         parametry(i) = str2num(get(parametr(i),'String'));
                     end
                 close(f);
            catch ME
                uialert(app.UIFigure, "Sproboj jeszcze raz.", 'Blad!');
            end
        end
       
        function b = kopiujObjekt(app,a)
            b = eval(class(a));  
                for p =  properties(a).'  
                    try   
                        b.(p) = a.(p);
                    catch
                    disp("nie udalo sie skopiowac");
                    end
                end
        end
            
        
        function zdjecie = zmienKolorystyke(app, zdj)
                zdj = double(zdj);                
                zdj(:,:,3) = app.udzialNiebieskiego*zdj(:,:,3);                
                zdj(:,:,1) = app.udzialCzerwonego*zdj(:,:,1);                
                zdj(:,:,2) = app.udzialZielonego*zdj(:,:,2);  
                zdjecie = uint8(zdj); 
        end
    end
    
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Configure image axes
            app.ImageAxes.Visible = 'off';
            ax = axis(app.ImageAxes);
            colormap(app.ImageAxes, "Gray");
            app.DropDown.Items = {'Gray', 'Spring', 'HSV', 'Hot', 'Cool',...
            'Summer', 'Autumn', 'Winter', 'Jet', 'Bone',...
            'Copper', 'Pink', 'Lines'};
        end

        % Callback function
        function DropDownValueChanged(app, event)
            
            % Update the image and histograms
            zmienZdjece(app, app.DropDown.Value);
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
               
            % Display uigetfile dialog
            filterspec = {'*.jpg;*.tif;*.png;*.gif','All Image Files'};
            [f, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               fname = [p f];
               zmienZdjece(app, fname);
               app.zdjecieSem.rysujPolaczenia = app.RysujpolaczeniasasiednichobszarowCheckBox.Value;
            end
        end

        % Button pushed function: UtnijopisButton
        function UtnijopisButtonPushed(app, event)
            %try
                %if app.czyUcieto == false
                   app.zdjecieSem.utnijOpis();
                   imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
                %   app.czyUcieto = true;
                %else
                %    uialert(app.UIFigure, "Juz ucieto opis.", "Blad!");
                %end
            %catch ME
            %    uialert(app.UIFigure, "Sproboj zaladowac zdjecie ponownie.", "Blad!");
            %end 
        end

        % Button pushed function: ZamiennaszareButton
        function ZamiennaszareButtonPushed(app, event)
            try
                if app.zdjecieSem.pokazTypKoloru() == "truecolor"
                    app.zdjecieSem.zamienNaSzare();
                    imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
                else
                    uialert(app.UIFigure, "Zdjecie musi byc kolorowe.", "Blad!");
                end
            catch ME
                uialert(app.UIFigure, "Sproboj zaladowac zdjecie ponownie", "Blad!");
            end 
        end

        % Button pushed function: ZamiennabinarneButton
        function ZamiennabinarneButtonPushed(app, event)
            try
                app.zdjecieSem.zamienNaBinarne();
                imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            catch ME
                uialert(app.UIFigure, ME.message, "Blad! Zaladuj zdjecie ponownie.");
            end 
        end

        % Button pushed function: ZamiennabitplaneButton
        function ZamiennabitplaneButtonPushed(app, event)
            AB = pokazDialog(app, 2, 'Wybierz czulosc czulosc algorytmu (parametry A i B), zaleca sie wartosci 2-256.'...
               ,  {'Parametr A:', 'Parametr B:'});
            try
                app.zdjecieSem.zamienNaBitPlane(AB(1), AB(2));
                imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            catch ME
                uialert(app.UIFigure, "Zaladuj zdjecie ponownie lub wpisz parametry o wartosciach 2-256.", "Blad!");
            end 
        end

        % Button pushed function: RysujzielonaczesczdjeciaButton
        function RysujzielonaczesczdjeciaButtonPushed(app, event)
            try
                if(app.zdjecieSem.pokazTypKoloru() == "truecolor")
                    img = app.zdjecieSem.pokazZdjecie();
                    img = img(:,:,2);
                    a = zeros(size(img, 1), size(img, 2));
                    green = cat(3, a, img, a);
                    imagesc(app.ImageAxes,green);
                else
                    uialert(app.UIFigure, "Zdjecie musi byc kolorowe.", "Blad!");
                end
            catch ME
                uialert(app.UIFigure, "Zaladuj zdjecie ponownie.", "Blad!");
            end 
        end

        % Button pushed function: RysujczerwonaczesczdjeciaButton
        function RysujczerwonaczesczdjeciaButtonPushed(app, event)
            try
                if(app.zdjecieSem.pokazTypKoloru() == "truecolor")
                    img = app.zdjecieSem.pokazZdjecie();
                    img = img(:,:,1);
                    a = zeros(size(img, 1), size(img, 2));
                    red = cat(3, img, a, a);
                    imagesc(app.ImageAxes,red);
                else
                    uialert(app.UIFigure, "Zdjecie musi byc kolorowe.", "Blad!");
                end
            catch ME
                uialert(app.UIFigure, "Zaladuj zdjecie ponownie.", "Blad!");
            end 
        end

        % Button pushed function: RysujniebieskaczesczdjeciaButton
        function RysujniebieskaczesczdjeciaButtonPushed(app, event)
            try
                if(app.zdjecieSem.pokazTypKoloru() == "truecolor")
                    img = app.zdjecieSem.pokazZdjecie();
                    img = img(:,:,3);
                    a = zeros(size(img, 1), size(img, 2));
                    blue = cat(3, a, a, img);
                    imagesc(app.ImageAxes,blue);
                else
                    uialert(app.UIFigure, "Zdjecie musi byc kolorowe.", "Blad!");
                end
            catch ME
                uialert(app.UIFigure, "Zaladuj zdjecie ponownie.", "Blad!");
            end 
        end

        % Button pushed function: WyroznijporyButton
        function WyroznijporyButtonPushed(app, event)
            AB = pokazDialog(app, 2, 'Wybierz czulosc algorytmu, obie wartosci musza byc od 0 do 1 i A musi byc wieksze od B, np. to A=0.56,B=0.52.'...
               ,  {'Parametr B:', 'Parametr A:'});
            try
                app.zdjecieSem.wyroznijPola(AB(1), AB(2));
                imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            catch ME
                uialert(app.UIFigure, "Zaladuj ponownie zdjecie lub wpisz poprawne parametry.", "Blad!");
            end 
        end

        % Button pushed function: ZaznaczporyButton
        function ZaznaczporyButtonPushed(app, event)
            AB = pokazDialog(app, 2, 'Wybierz czulosc algorytmu, obie wartosci musza byc od 0 do 1 i A musi byc wieksze od B, np. A=0.56,B=0.52.'...
               ,  {'Parametr B:', 'Parametr A:'});
            try
                app.zdjecieSem.zaznaczPola(AB(1), AB(2));
                imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            catch ME
                uialert(app.UIFigure, "Zaladuj ponownie zdjecie lub wpisz poprawne parametry.", "Blad!");
            end 
        end

        % Button pushed function: PodzielnaobszaryButton
        function PodzielnaobszaryButtonPushed(app, event)
            ABCDE = pokazDialog(app, 5, 'Wybierz czulosc czulosc algorytmu, standardowe to 5,5,5,5,5.'...
               ,  {'Parametr A:', 'Parametr B:','Parametr C:', 'Parametr D:', 'Parametr E:'});
           if app.zdjecieSem.pokazTypKoloru() == "gray"
                try
                    app.zdjecieSem.podzielNaObszary(ABCDE(1), ABCDE(2), ABCDE(3), ABCDE(4), ABCDE(5));
                    imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
                catch ME
                    uialert(app.UIFigure, "Zaladuj ponownie zdjecie lub wpisz poprawne parametry.", "Blad!");
                end 
           else
               uialert(app.UIFigure, "Zdjecie musi byc szare!.", "Blad!");
           end
        end

        % Value changed function: IIoscumna100pikseliEditField
        function IIoscumna100pikseliEditFieldValueChanged(app, event)
            value = app.IIoscumna100pikseliEditField.Value;
            app.mNaStoPikseli = value;
        end

        % Value changed function: DropDown
        function DropDownValueChanged2(app, event)
            {'Jet', 'Spring', 'HSV', 'Hot', 'Cool',...
            'Summer', 'Autumn', 'Winter', 'Gray', 'Bone',...
            'Copper', 'Pink', 'Lines'};
            kolor = app.DropDown.Value;
            
            switch kolor
                case 'Gray'
                    colormap(app.ImageAxes, "Gray");
                case 'Spring'
                    colormap(app.ImageAxes, "Spring");
                case 'HSV'
                    colormap(app.ImageAxes, "HSV");
                case 'Hot'
                    colormap(app.ImageAxes, "Hot");
                case 'Cool'
                    colormap(app.ImageAxes, "Cool");
                case 'Lines'
                    colormap(app.ImageAxes, "Lines");
                case 'Summer'
                    colormap(app.ImageAxes, "Summer");
                case 'Autumn'
                    colormap(app.ImageAxes, "Autumn");
                case 'Winter'
                    colormap(app.ImageAxes, "Winter");
                case 'Jet'
                    colormap(app.ImageAxes, "Jet");
                case 'Bone'
                    colormap(app.ImageAxes, "Bone");
                case 'Copper'
                    colormap(app.ImageAxes, "Copper");
                case 'Pink'
                    colormap(app.ImageAxes, "Pink");
                otherwise
                    uialert(app.UIFigure, "Sproboj ponownie.", "Blad!");
            end
        end

        % Button pushed function: RysujfigurynaporachButton
        function RysujfigurynaporachButtonPushed(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "binary"
                uialert(app.UIFigure, "Funkcja nie przyjmuje obrazow binarnych.", 'Blad!');
            else
                try
                    app.zdjecieSem().sledzPory();  
                catch ME
                    uialert(app.UIFigure, "Sproboj jeszcze raz.", 'Blad!');
                end
            end

        end

        % Button pushed function: RysujfigurybinarnieButton
        function RysujfigurybinarnieButtonPushed(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "binary"
                uialert(app.UIFigure, "Funkcja nie przyjmuje obrazow binarnych.", 'Blad!');
            else
                try
                    app.zdjecieSem().sledzPoryBinarnie();  
                catch ME
                    uialert(app.UIFigure, "Sproboj jeszcze raz.", 'Blad!');
                end
            end
        end

        % Value changed function: ParametrASlider
        function ParametrASliderValueChanged(app, event)
            app.parB = app.ParametrASlider.Value/100;
            valA = app.parA;
            valB = app.parB;
            if valA < valB
                imagesc(app.ImageAxes,imadjust(app.zdjecieSem.pokazZdjecie(), [valA,valB],[]));
            end
        end

        % Value changed function: ParametrBSlider
        function ParametrBSliderValueChanged(app, event)
            app.parA = app.ParametrBSlider.Value/100;
            valA = app.parA;
            valB = app.parB;
            if valA < valB
                imagesc(app.ImageAxes,imadjust(app.zdjecieSem.pokazZdjecie(), [valA,valB],[]));
            end
        end

        % Button pushed function: ZatwierdzButton
        function ZatwierdzButtonPushed(app, event)
            if app.parA < app.parB
                app.zdjecieSem.wyostrzZdjecie(app.parA, app.parB);
                imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            else
                uialert(app.UIFigure, "Parametr A musi byc wiekszy od B!", 'Blad!');
            end
        end

        % Button pushed function: AnulujButton
        function AnulujButtonPushed(app, event)
            imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            set(app.ParametrASlider, 'value', 80);
            set(app.ParametrBSlider, 'value', 20);
            app.parA = 0.2;
            app.parB = 0.8;
        end

        % Value changed function: CzewronySlider
        function CzewronySliderValueChanged(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "truecolor"
                app.udzialCzerwonego = app.CzewronySlider.Value/100;
                zdjBuf = app.zdjecieSem.pokazZdjecie();
                zdjBuf = zmienKolorystyke(app, zdjBuf);
                imagesc(app.ImageAxes,zdjBuf);                      
            else
                uialert(app.UIFigure, "Zdjecie musi byc kolorowe!", 'Blad!');
            end
        end

        % Value changed function: NiebieskiSlider
        function NiebieskiSliderValueChanged(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "truecolor"
                app.udzialNiebieskiego = app.NiebieskiSlider.Value/100;
                zdjBuf = app.zdjecieSem.pokazZdjecie();
                zdjBuf = zmienKolorystyke(app, zdjBuf);
                imagesc(app.ImageAxes,zdjBuf);                      
            else
                uialert(app.UIFigure, "Zdjecie musi byc kolorowe!", 'Blad!');
            end
        end

        % Value changed function: ZielonySlider
        function ZielonySliderValueChanged(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "truecolor"
                app.udzialZielonego = app.ZielonySlider.Value/100;
                zdjBuf = app.zdjecieSem.pokazZdjecie();
                zdjBuf = zmienKolorystyke(app, zdjBuf);
                imagesc(app.ImageAxes,zdjBuf);                      
            else
                uialert(app.UIFigure, "Zdjecie musi byc kolorowe!", 'Blad!');
            end
            
        end

        % Button pushed function: AnulujButton_2
        function AnulujButton_2Pushed(app, event)
            imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            set(app.ZielonySlider, 'value', 100);
            set(app.CzewronySlider, 'value', 100);
            set(app.NiebieskiSlider, 'value', 100);

        end

        % Button pushed function: ZatwierdzButton_2
        function ZatwierdzButton_2Pushed(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "truecolor"   
                app.zdjecieSem.zwielokrotnijZawartoscZielonego(app.udzialZielonego);
                app.zdjecieSem.zwielokrotnijZawartoscCzerwonego(app.udzialCzerwonego);
                app.zdjecieSem.zwielokrotnijZawartoscNiebieskiego(app.udzialNiebieskiego);
                imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            else
                uialert(app.UIFigure, "Zdjecie musi byc kolorowe!", 'Blad!');
            end
        end

        % Button pushed function: OdswiezButton
        function OdswiezButtonPushed(app, event)
            imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            set(app.ZielonySlider, 'value', 100);
            set(app.CzewronySlider, 'value', 100);
            set(app.NiebieskiSlider, 'value', 100);
            set(app.ParametrASlider, 'value', 80);
            set(app.ParametrBSlider, 'value', 20);
            set(app.ParASlider, 'value', 0);
            set(app.ParBSlider, 'value', 0);
            set(app.ParCSlider, 'value', 0);
            app.parA = 0.2;
            app.parB = 0.8;
        end

        % Value changed function: ParASlider
        function ParASliderValueChanged(app, event)
                if app.zdjecieSem.pokazTypKoloru() == "truecolor"
                    zdjBuf = app.zdjecieSem.pokazZdjecie();
                    zdjBuf = app.ParASlider.Value*zdjBuf(:,:,1) +...
                             app.ParBSlider.Value*zdjBuf(:,:,2) +...
                             app.ParCSlider.Value*zdjBuf(:,:,3);
                    imagesc(app.ImageAxes,zdjBuf);
                else
                    uialert(app.UIFigure, "Zdjecie musi byc kolorowe.", "Blad!");
                end
        end

        % Value changed function: ParBSlider
        function ParBSliderValueChanged(app, event)
                if app.zdjecieSem.pokazTypKoloru() == "truecolor"
                    zdjBuf = app.zdjecieSem.pokazZdjecie();
                    zdjBuf = app.ParASlider.Value*zdjBuf(:,:,1) +...
                             app.ParBSlider.Value*zdjBuf(:,:,2) +...
                             app.ParCSlider.Value*zdjBuf(:,:,3);
                    imagesc(app.ImageAxes,zdjBuf);
                else
                    uialert(app.UIFigure, "Zdjecie musi byc kolorowe.", "Blad!");
                end
        end

        % Value changed function: ParCSlider
        function ParCSliderValueChanged(app, event)
                if app.zdjecieSem.pokazTypKoloru() == "truecolor"
                    zdjBuf = app.zdjecieSem.pokazZdjecie();
                    zdjBuf = app.ParASlider.Value*zdjBuf(:,:,1) +...
                             app.ParBSlider.Value*zdjBuf(:,:,2) +...
                             app.ParCSlider.Value*zdjBuf(:,:,3);
                    imagesc(app.ImageAxes,zdjBuf);
                else
                    uialert(app.UIFigure, "Zdjecie musi byc kolorowe.", "Blad!");
                end
        end

        % Button pushed function: ZatwierdzButton_3
        function ZatwierdzButton_3Pushed(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "truecolor"   
                app.zdjecieSem.zamienNaSzareManualnie(app.ParASlider.Value,app.ParBSlider.Value,...
                                                      app.ParCSlider.Value);
                imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            else
                uialert(app.UIFigure, "Zdjecie musi byc kolorowe!", 'Blad!');
            end
        end

        % Button pushed function: AnulujButton_3
        function AnulujButton_3Pushed(app, event)
            imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
            set(app.ParASlider, 'value', 0);
            set(app.ParBSlider, 'value', 0);
            set(app.ParCSlider, 'value', 0);

        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            app.zdjecieSem.rysowaneFigury = app.Switch.Value;
        end

        % Menu selected function: RysujhistogramodcieniMenu
        function RysujhistogramodcieniMenuSelected(app, event)
            try
                app.zdjecieSem.rysujHistogram();
            catch ME
                uialert(app.UIFigure, "Zaladuj zdjecie ponownie.", "Blad!");
            end 
        end

        % Menu selected function: RysujhistogramkontrastowyMenu
        function RysujhistogramkontrastowyMenuSelected(app, event)
            if app.zdjecieSem.pokazTypKoloru == "binary"
                uialert(app.UIFigure, "Funkcja nie przyjmuje zdjec binarnych.", "Blad!");
            else
                try
                    app.zdjecieSem.rysujHistogramKontrastowy();
                catch ME
                    uialert(app.UIFigure, "Zaladuj zdjecie ponownie.", "Blad!");
                end
            end
        end

        % Menu selected function: RysujhistogrampolpowporowMenu
        function RysujhistogrampolpowporowMenuSelected(app, event)
            try
                if app.mNaStoPikseli <= 0
                    uialert(app.UIFigure, "Wpisz wartosc wieksza od 0 w polu ilosc mikrometrow (pod zdjeciem) na 100 pikseli!", "Blad!");
                else
                    app.zdjecieSem.zamienNaBinarne();
                    app.zdjecieSem.obliczPowierzchniePorow(app.mNaStoPikseli);
                    if app.zdjecieSem.pokazPowierzchniePorow()~=0
                        h = histogram(app.zdjecieSem.pokazPowierzchniePorow());
                        [sciezkaPliku,nazwa,rozszerzenie] = fileparts(app.zdjecieSem.pokazNazwe());
                        title(nazwa + " - histogram powierzchnii porow");
                        ylabel('Ilosc porow o polu powierzchnii z danego przedzialu');
                        xlabel('Wielkosc pola powerzchnii porow [um]');
                    else
                        disp("Powierzchnie porow tego zdjecia nie zostaly jeszcze obliczone!"...
                      + " Uzyj funkcji obliczPowierzchniePorow() z klasy ZdjecieSEM");
                    end
                    imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
                end
            catch ME
                uialert(app.UIFigure, "Zaladuj zdjecie ponownie.", "Blad!");
            end 
        end

        % Menu selected function: RysujhistogramsrednicporowMenu
        function RysujhistogramsrednicporowMenuSelected(app, event)
           try
                if app.mNaStoPikseli <= 0
                    uialert(app.UIFigure, "Wpisz wartosc wieksza od 0 w polu ilosc mikrometrow (pod zdjeciem) na 100 pikseli!", "Blad!");
                else
                    app.zdjecieSem.zamienNaBinarne();
                    app.zdjecieSem.obliczPowierzchniePorow(app.mNaStoPikseli);
                    app.zdjecieSem.obliczSrednicePorow();
                    if app.zdjecieSem.pokazSrednicePorow()~=0
                        h = histogram(app.zdjecieSem.pokazSrednicePorow());
                        [sciezkaPliku,nazwa,rozszerzenie] = fileparts(app.zdjecieSem.pokazNazwe());
                        title(nazwa + " - histogram srednic porow");
                        ylabel('Ilosc porow o srednicy z danego przedzialu');
                        xlabel('Wielkosc srednic porow [um]');
                    else
                        disp("Srednice porow tego zdjecia nie zostaly jeszcze obliczone!"...
                      + " Uzyj funkcji obliczPowierzchniePorow() z klasy ZdjecieSEM");
                    end
                    imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
                end
            catch ME
                uialert(app.UIFigure, "Zaladuj zdjecie ponownie.", "Blad!");
            end 
        end

        % Menu selected function: RysujhistogramobwodowporowMenu
        function RysujhistogramobwodowporowMenuSelected(app, event)
            try
                if app.mNaStoPikseli <= 0
                    uialert(app.UIFigure, "Wpisz wartosc wieksza od 0 w polu ilosc mikrometrow (pod zdjeciem) na 100 pikseli!", "Blad!");
                else
                    app.zdjecieSem.zamienNaBinarne();
                    app.zdjecieSem.obliczObwodyPorow(app.mNaStoPikseli);
                    if app.zdjecieSem.pokazObwodyPorow()~=0
                        h = histogram(app.zdjecieSem.pokazObwodyPorow());
                        [sciezkaPliku,nazwa,rozszerzenie] = fileparts(app.zdjecieSem.pokazNazwe());
                        title(nazwa + " - histogram obwodow porow");
                        ylabel('Ilosc porow o obwodzie z danego przedzialu');
                        xlabel('Wielkosc obwodow porow [um]');
                    else
                        disp("Powierzchnie porow tego zdjecia nie zostaly jeszcze obliczone!"...
                      + " Uzyj funkcji obliczPowierzchniePorow() z klasy ZdjecieSEM");
                    end
                    imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
                end
            catch ME
                    uialert(app.UIFigure, "Zaladuj zdjecie ponownie.", "Blad!");
            end 
        end

        % Button pushed function: RysujobszaryporowButton
        function RysujobszaryporowButtonPushed(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "binary"
                uialert(app.UIFigure, "Funkcja nie przyjmuje obrazow binarnych.", 'Blad!');
            else
                %try
                    app.zdjecieSem().rysujMaksymalneFigury(false);  
                %catch ME
                %    uialert(app.UIFigure, "Sproboj jeszcze raz.", 'Blad!');
                %end
            end
        end

        % Menu selected function: 
        % ObszarywpostacitrojkatowrownobocznychMenu
        function ObszarywpostacitrojkatowrownobocznychMenuSelected(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "binary"
                uialert(app.UIFigure, "Funkcja nie przyjmuje obrazow binarnych.", 'Blad!');
            else
                if app.mNaStoPikseli <= 0
                    uialert(app.UIFigure, "Wpisz wartosc wieksza od 0 w polu ilosc mikrometrow (pod zdjeciem) na 100 pikseli!", "Blad!");
                else
                        switchBuf = app.zdjecieSem.rysowaneFigury;
                        app.zdjecieSem.rysowaneFigury = "Trojkaty";
                        app.zdjecieSem.rysujMaksymalneFigury(true); 
                        app.zdjecieSem.obliczPolaObszarow(app.mNaStoPikseli);
                        h = histogram(app.zdjecieSem.pokazPowierzchnieObszarowTrojkatow());
                        [sciezkaPliku,nazwa,rozszerzenie] = fileparts(app.zdjecieSem.pokazNazwe());
                        title(nazwa + " - histogram pol powierzchnii obszarow porow w postaci trojkatow rownobocznych");
                        annotation('textbox',[.9 .5 .1 .2],'String',"Stosunek pola zajetego przez figury do pola reszty obrazu = " + app.zdjecieSem.pokazStosunekPolTrojkatyObraz(app.mNaStoPikseli),'EdgeColor','none')
                        ylabel('Ilosc trojkatow rownobocznych o srednicy z danego przedzialu');
                        xlabel('Wielkosc pol obszarow (trojkatow rownobocznych) [um^2]');
                        imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
                        app.zdjecieSem.rysowaneFigury = switchBuf;
                end
            end
        end

        % Menu selected function: ObszarywpostacikwadratowMenu
        function ObszarywpostacikwadratowMenuSelected(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "binary"
                uialert(app.UIFigure, "Funkcja nie przyjmuje obrazow binarnych.", 'Blad!');
            else
                try
                    if app.mNaStoPikseli <= 0
                        uialert(app.UIFigure, "Wpisz wartosc wieksza od 0 w polu ilosc mikrometrow (pod zdjeciem) na 100 pikseli!", "Blad!");
                    else
                        switchBuf = app.zdjecieSem.rysowaneFigury;
                        app.zdjecieSem.rysowaneFigury = "Kwadraty";
                        app.zdjecieSem.rysujMaksymalneFigury(true); 
                        app.zdjecieSem.obliczPolaObszarow(app.mNaStoPikseli);
                        h = histogram(app.zdjecieSem.pokazPowierzchnieObszarowKwadratow());
                        [sciezkaPliku,nazwa,rozszerzenie] = fileparts(app.zdjecieSem.pokazNazwe());
                        title(nazwa + " - histogram pol powierzchnii obszarow porow w postaci kwadratow");
                        annotation('textbox',[.9 .5 .1 .2],'String',"Stosunek pola zajetego przez figury do pola reszty obrazu = " + app.zdjecieSem.pokazStosunekPolKwadratyObraz(app.mNaStoPikseli),'EdgeColor','none')
                        ylabel('Ilosc kwadratow o srednicy z danego przedzialu');
                        xlabel('Wielkosc pol obszarow (kwadratow) [um^2]');
                        imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
                        app.zdjecieSem.rysowaneFigury = switchBuf;
                                    end
                catch ME
                    uialert(app.UIFigure, "Sproboj jeszcze raz.", 'Blad!');
                end
            end
        end

        % Value changed function: 
        % RysujpolaczeniasasiednichobszarowCheckBox
        function RysujpolaczeniasasiednichobszarowCheckBoxValueChanged(app, event)
            app.zdjecieSem.rysujPolaczenia = app.RysujpolaczeniasasiednichobszarowCheckBox.Value;
        end

        % Menu selected function: 
        % RysujhistogramodlegloscisasiednichobszarowporowMenu
        function RysujhistogramodlegloscisasiednichobszarowporowMenuSelected(app, event)
            if app.zdjecieSem.pokazTypKoloru() == "binary"
                uialert(app.UIFigure, "Funkcja nie przyjmuje obrazow binarnych.", 'Blad!');
            else
                try
                    if app.mNaStoPikseli <= 0
                        uialert(app.UIFigure, "Wpisz wartosc wieksza od 0 w polu ilosc mikrometrow (pod zdjeciem) na 100 pikseli!", "Blad!");
                    else
                        switchBuf = app.zdjecieSem.rysujPolaczenia;
                        app.zdjecieSem.rysujPolaczenia = 1;
                        app.zdjecieSem.rysujMaksymalneFigury(true); 
                        h = histogram(app.zdjecieSem.pokazOdleglosciObszarow(app.mNaStoPikseli));
                        [sciezkaPliku,nazwa,rozszerzenie] = fileparts(app.zdjecieSem.pokazNazwe());
                        if app.zdjecieSem.rysowaneFigury == "Kwadraty";
                            title(nazwa + " - histogram odleglosci miedzy sasiednimi obszarami porow (kwadratami)");
                        else
                            title(nazwa + " - histogram odleglosci miedzy sasiednimi obszarami porow (trojkatami)");
                        end

                        ylabel('Ilosc odleglosci z danego przedzialu');
                        xlabel('Odleglosc miedzy sasiednimi obszarami porow [um]');
                        imagesc(app.ImageAxes,app.zdjecieSem.pokazZdjecie());
                        app.zdjecieSem.rysujPolaczenia = switchBuf;
                    end
                catch ME
                    uialert(app.UIFigure, "Sproboj jeszcze raz.", 'Blad!');
                end
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.IntegerHandle = 'on';
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 712 754];
            app.UIFigure.Name = 'Analizator zdjec SEM';
            app.UIFigure.Resize = 'off';

            % Create RysujhistogramMenu
            app.RysujhistogramMenu = uimenu(app.UIFigure);
            app.RysujhistogramMenu.Text = 'Rysuj histogram...';

            % Create RysujhistogramodcieniMenu
            app.RysujhistogramodcieniMenu = uimenu(app.RysujhistogramMenu);
            app.RysujhistogramodcieniMenu.MenuSelectedFcn = createCallbackFcn(app, @RysujhistogramodcieniMenuSelected, true);
            app.RysujhistogramodcieniMenu.Text = 'Rysuj histogram odcieni';

            % Create RysujhistogramkontrastowyMenu
            app.RysujhistogramkontrastowyMenu = uimenu(app.RysujhistogramMenu);
            app.RysujhistogramkontrastowyMenu.MenuSelectedFcn = createCallbackFcn(app, @RysujhistogramkontrastowyMenuSelected, true);
            app.RysujhistogramkontrastowyMenu.Text = 'Rysuj histogram kontrastowy';

            % Create RysujhistogrampolpowporowMenu
            app.RysujhistogrampolpowporowMenu = uimenu(app.RysujhistogramMenu);
            app.RysujhistogrampolpowporowMenu.MenuSelectedFcn = createCallbackFcn(app, @RysujhistogrampolpowporowMenuSelected, true);
            app.RysujhistogrampolpowporowMenu.Text = 'Rysuj histogram pol pow. porow';

            % Create RysujhistogramsrednicporowMenu
            app.RysujhistogramsrednicporowMenu = uimenu(app.RysujhistogramMenu);
            app.RysujhistogramsrednicporowMenu.MenuSelectedFcn = createCallbackFcn(app, @RysujhistogramsrednicporowMenuSelected, true);
            app.RysujhistogramsrednicporowMenu.Text = 'Rysuj histogram srednic porow';

            % Create RysujhistogramobwodowporowMenu
            app.RysujhistogramobwodowporowMenu = uimenu(app.RysujhistogramMenu);
            app.RysujhistogramobwodowporowMenu.MenuSelectedFcn = createCallbackFcn(app, @RysujhistogramobwodowporowMenuSelected, true);
            app.RysujhistogramobwodowporowMenu.Text = 'Rysuj histogram obwodow porow';

            % Create RysujhistogrampolobszarowporowMenu
            app.RysujhistogrampolobszarowporowMenu = uimenu(app.RysujhistogramMenu);
            app.RysujhistogrampolobszarowporowMenu.Text = 'Rysuj histogram pol obszarow porow';

            % Create ObszarywpostacitrojkatowrownobocznychMenu
            app.ObszarywpostacitrojkatowrownobocznychMenu = uimenu(app.RysujhistogrampolobszarowporowMenu);
            app.ObszarywpostacitrojkatowrownobocznychMenu.MenuSelectedFcn = createCallbackFcn(app, @ObszarywpostacitrojkatowrownobocznychMenuSelected, true);
            app.ObszarywpostacitrojkatowrownobocznychMenu.Text = 'Obszary w postaci trojkatow rownobocznych';

            % Create ObszarywpostacikwadratowMenu
            app.ObszarywpostacikwadratowMenu = uimenu(app.RysujhistogrampolobszarowporowMenu);
            app.ObszarywpostacikwadratowMenu.MenuSelectedFcn = createCallbackFcn(app, @ObszarywpostacikwadratowMenuSelected, true);
            app.ObszarywpostacikwadratowMenu.Text = 'Obszary w postaci kwadratow';

            % Create RysujhistogramodlegloscisasiednichobszarowporowMenu
            app.RysujhistogramodlegloscisasiednichobszarowporowMenu = uimenu(app.RysujhistogramMenu);
            app.RysujhistogramodlegloscisasiednichobszarowporowMenu.MenuSelectedFcn = createCallbackFcn(app, @RysujhistogramodlegloscisasiednichobszarowporowMenuSelected, true);
            app.RysujhistogramodlegloscisasiednichobszarowporowMenu.Text = 'Rysuj histogram odleglosci sasiednich obszarow porow';

            % Create ImageAxes
            app.ImageAxes = uiaxes(app.UIFigure);
            app.ImageAxes.XTick = [];
            app.ImageAxes.XTickLabel = {'[ ]'};
            app.ImageAxes.YTick = [];
            app.ImageAxes.Position = [241 356 448 399];

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [12 709 175 22];
            app.LoadButton.Text = 'Wybierz zdjecie';

            % Create UtnijopisButton
            app.UtnijopisButton = uibutton(app.UIFigure, 'push');
            app.UtnijopisButton.ButtonPushedFcn = createCallbackFcn(app, @UtnijopisButtonPushed, true);
            app.UtnijopisButton.Position = [12 677 175 22];
            app.UtnijopisButton.Text = 'Utnij opis';

            % Create ZamiennaszareButton
            app.ZamiennaszareButton = uibutton(app.UIFigure, 'push');
            app.ZamiennaszareButton.ButtonPushedFcn = createCallbackFcn(app, @ZamiennaszareButtonPushed, true);
            app.ZamiennaszareButton.Position = [12 644 175 22];
            app.ZamiennaszareButton.Text = 'Zamien na szare';

            % Create ZamiennabinarneButton
            app.ZamiennabinarneButton = uibutton(app.UIFigure, 'push');
            app.ZamiennabinarneButton.ButtonPushedFcn = createCallbackFcn(app, @ZamiennabinarneButtonPushed, true);
            app.ZamiennabinarneButton.Position = [12 612 175 22];
            app.ZamiennabinarneButton.Text = 'Zamien na binarne';

            % Create ZamiennabitplaneButton
            app.ZamiennabitplaneButton = uibutton(app.UIFigure, 'push');
            app.ZamiennabitplaneButton.ButtonPushedFcn = createCallbackFcn(app, @ZamiennabitplaneButtonPushed, true);
            app.ZamiennabitplaneButton.Position = [12 578 175 22];
            app.ZamiennabitplaneButton.Text = 'Zamien na bitplane';

            % Create RysujzielonaczesczdjeciaButton
            app.RysujzielonaczesczdjeciaButton = uibutton(app.UIFigure, 'push');
            app.RysujzielonaczesczdjeciaButton.ButtonPushedFcn = createCallbackFcn(app, @RysujzielonaczesczdjeciaButtonPushed, true);
            app.RysujzielonaczesczdjeciaButton.Position = [12 546 175 22];
            app.RysujzielonaczesczdjeciaButton.Text = 'Rysuj zielona czesc zdjecia';

            % Create RysujczerwonaczesczdjeciaButton
            app.RysujczerwonaczesczdjeciaButton = uibutton(app.UIFigure, 'push');
            app.RysujczerwonaczesczdjeciaButton.ButtonPushedFcn = createCallbackFcn(app, @RysujczerwonaczesczdjeciaButtonPushed, true);
            app.RysujczerwonaczesczdjeciaButton.Position = [12 514 175 22];
            app.RysujczerwonaczesczdjeciaButton.Text = 'Rysuj czerwona czesc zdjecia';

            % Create RysujniebieskaczesczdjeciaButton
            app.RysujniebieskaczesczdjeciaButton = uibutton(app.UIFigure, 'push');
            app.RysujniebieskaczesczdjeciaButton.ButtonPushedFcn = createCallbackFcn(app, @RysujniebieskaczesczdjeciaButtonPushed, true);
            app.RysujniebieskaczesczdjeciaButton.Position = [12 480 175 22];
            app.RysujniebieskaczesczdjeciaButton.Text = 'Rysuj niebieska czesc zdjecia';

            % Create WyroznijporyButton
            app.WyroznijporyButton = uibutton(app.UIFigure, 'push');
            app.WyroznijporyButton.ButtonPushedFcn = createCallbackFcn(app, @WyroznijporyButtonPushed, true);
            app.WyroznijporyButton.Position = [12 447 175 22];
            app.WyroznijporyButton.Text = 'Wyroznij pory';

            % Create ZaznaczporyButton
            app.ZaznaczporyButton = uibutton(app.UIFigure, 'push');
            app.ZaznaczporyButton.ButtonPushedFcn = createCallbackFcn(app, @ZaznaczporyButtonPushed, true);
            app.ZaznaczporyButton.Position = [12 413 175 22];
            app.ZaznaczporyButton.Text = 'Zaznacz pory';

            % Create PodzielnaobszaryButton
            app.PodzielnaobszaryButton = uibutton(app.UIFigure, 'push');
            app.PodzielnaobszaryButton.ButtonPushedFcn = createCallbackFcn(app, @PodzielnaobszaryButtonPushed, true);
            app.PodzielnaobszaryButton.Position = [12 379 175 22];
            app.PodzielnaobszaryButton.Text = 'Podziel na obszary';

            % Create IIoscumna100pikseliEditFieldLabel
            app.IIoscumna100pikseliEditFieldLabel = uilabel(app.UIFigure);
            app.IIoscumna100pikseliEditFieldLabel.HorizontalAlignment = 'right';
            app.IIoscumna100pikseliEditFieldLabel.Position = [241 332 127 22];
            app.IIoscumna100pikseliEditFieldLabel.Text = 'IIosc um na 100 pikseli';

            % Create IIoscumna100pikseliEditField
            app.IIoscumna100pikseliEditField = uieditfield(app.UIFigure, 'numeric');
            app.IIoscumna100pikseliEditField.ValueChangedFcn = createCallbackFcn(app, @IIoscumna100pikseliEditFieldValueChanged, true);
            app.IIoscumna100pikseliEditField.Position = [383 332 100 22];

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.ValueChangedFcn = createCallbackFcn(app, @DropDownValueChanged2, true);
            app.DropDown.Position = [496 311 100 22];

            % Create TypkolorowaniaszaregoLabel
            app.TypkolorowaniaszaregoLabel = uilabel(app.UIFigure);
            app.TypkolorowaniaszaregoLabel.Position = [496 332 142 22];
            app.TypkolorowaniaszaregoLabel.Text = 'Typ kolorowania szarego:';

            % Create RysujfigurynaporachButton
            app.RysujfigurynaporachButton = uibutton(app.UIFigure, 'push');
            app.RysujfigurynaporachButton.ButtonPushedFcn = createCallbackFcn(app, @RysujfigurynaporachButtonPushed, true);
            app.RysujfigurynaporachButton.Position = [496 270 142 22];
            app.RysujfigurynaporachButton.Text = 'Rysuj figury na porach';

            % Create RysujfigurybinarnieButton
            app.RysujfigurybinarnieButton = uibutton(app.UIFigure, 'push');
            app.RysujfigurybinarnieButton.ButtonPushedFcn = createCallbackFcn(app, @RysujfigurybinarnieButtonPushed, true);
            app.RysujfigurybinarnieButton.Position = [496 237 142 22];
            app.RysujfigurybinarnieButton.Text = 'Rysuj figury binarnie';

            % Create ParametrASliderLabel
            app.ParametrASliderLabel = uilabel(app.UIFigure);
            app.ParametrASliderLabel.HorizontalAlignment = 'right';
            app.ParametrASliderLabel.Position = [83 173 66 22];
            app.ParametrASliderLabel.Text = 'Parametr A';

            % Create ParametrASlider
            app.ParametrASlider = uislider(app.UIFigure);
            app.ParametrASlider.ValueChangedFcn = createCallbackFcn(app, @ParametrASliderValueChanged, true);
            app.ParametrASlider.Position = [170 182 150 3];
            app.ParametrASlider.Value = 80;

            % Create ParametrBSliderLabel
            app.ParametrBSliderLabel = uilabel(app.UIFigure);
            app.ParametrBSliderLabel.HorizontalAlignment = 'right';
            app.ParametrBSliderLabel.Position = [341 172 66 22];
            app.ParametrBSliderLabel.Text = 'Parametr B';

            % Create ParametrBSlider
            app.ParametrBSlider = uislider(app.UIFigure);
            app.ParametrBSlider.ValueChangedFcn = createCallbackFcn(app, @ParametrBSliderValueChanged, true);
            app.ParametrBSlider.Position = [428 181 150 3];
            app.ParametrBSlider.Value = 20;

            % Create OstroscABLabel
            app.OstroscABLabel = uilabel(app.UIFigure);
            app.OstroscABLabel.Position = [3 173 81 22];
            app.OstroscABLabel.Text = 'Ostrosc(A>B):';

            % Create ZatwierdzButton
            app.ZatwierdzButton = uibutton(app.UIFigure, 'push');
            app.ZatwierdzButton.ButtonPushedFcn = createCallbackFcn(app, @ZatwierdzButtonPushed, true);
            app.ZatwierdzButton.Position = [611 170 99 25];
            app.ZatwierdzButton.Text = 'Zatwierdz';

            % Create AnulujButton
            app.AnulujButton = uibutton(app.UIFigure, 'push');
            app.AnulujButton.ButtonPushedFcn = createCallbackFcn(app, @AnulujButtonPushed, true);
            app.AnulujButton.Position = [611 138 98 23];
            app.AnulujButton.Text = 'Anuluj';

            % Create UdzialkolorowLabel
            app.UdzialkolorowLabel = uilabel(app.UIFigure);
            app.UdzialkolorowLabel.Position = [5 103 87 22];
            app.UdzialkolorowLabel.Text = 'Udzial kolorow:';

            % Create CzewronySliderLabel
            app.CzewronySliderLabel = uilabel(app.UIFigure);
            app.CzewronySliderLabel.HorizontalAlignment = 'right';
            app.CzewronySliderLabel.Position = [91 104 59 22];
            app.CzewronySliderLabel.Text = 'Czewrony';

            % Create CzewronySlider
            app.CzewronySlider = uislider(app.UIFigure);
            app.CzewronySlider.Limits = [0 400];
            app.CzewronySlider.MajorTicks = [0 200 400];
            app.CzewronySlider.ValueChangedFcn = createCallbackFcn(app, @CzewronySliderValueChanged, true);
            app.CzewronySlider.Position = [171 113 79 3];
            app.CzewronySlider.Value = 100;

            % Create NiebieskiSliderLabel
            app.NiebieskiSliderLabel = uilabel(app.UIFigure);
            app.NiebieskiSliderLabel.HorizontalAlignment = 'right';
            app.NiebieskiSliderLabel.Position = [259 104 54 22];
            app.NiebieskiSliderLabel.Text = 'Niebieski';

            % Create NiebieskiSlider
            app.NiebieskiSlider = uislider(app.UIFigure);
            app.NiebieskiSlider.Limits = [0 400];
            app.NiebieskiSlider.ValueChangedFcn = createCallbackFcn(app, @NiebieskiSliderValueChanged, true);
            app.NiebieskiSlider.Position = [334 113 84 3];
            app.NiebieskiSlider.Value = 100;

            % Create ZielonySliderLabel
            app.ZielonySliderLabel = uilabel(app.UIFigure);
            app.ZielonySliderLabel.HorizontalAlignment = 'right';
            app.ZielonySliderLabel.Position = [428 103 44 22];
            app.ZielonySliderLabel.Text = 'Zielony';

            % Create ZielonySlider
            app.ZielonySlider = uislider(app.UIFigure);
            app.ZielonySlider.Limits = [0 400];
            app.ZielonySlider.ValueChangedFcn = createCallbackFcn(app, @ZielonySliderValueChanged, true);
            app.ZielonySlider.Position = [493 112 85 3];
            app.ZielonySlider.Value = 100;

            % Create ZatwierdzButton_2
            app.ZatwierdzButton_2 = uibutton(app.UIFigure, 'push');
            app.ZatwierdzButton_2.ButtonPushedFcn = createCallbackFcn(app, @ZatwierdzButton_2Pushed, true);
            app.ZatwierdzButton_2.Position = [611 104 98 22];
            app.ZatwierdzButton_2.Text = 'Zatwierdz';

            % Create AnulujButton_2
            app.AnulujButton_2 = uibutton(app.UIFigure, 'push');
            app.AnulujButton_2.ButtonPushedFcn = createCallbackFcn(app, @AnulujButton_2Pushed, true);
            app.AnulujButton_2.Position = [611 73 98 22];
            app.AnulujButton_2.Text = 'Anuluj';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Position = [32 82 25 22];
            app.Label.Text = '(%)';

            % Create OdswiezButton
            app.OdswiezButton = uibutton(app.UIFigure, 'push');
            app.OdswiezButton.ButtonPushedFcn = createCallbackFcn(app, @OdswiezButtonPushed, true);
            app.OdswiezButton.Position = [41 332 118 32];
            app.OdswiezButton.Text = 'Odswiez';

            % Create ParASliderLabel
            app.ParASliderLabel = uilabel(app.UIFigure);
            app.ParASliderLabel.HorizontalAlignment = 'right';
            app.ParASliderLabel.Position = [113 40 38 22];
            app.ParASliderLabel.Text = 'Par. A';

            % Create ParASlider
            app.ParASlider = uislider(app.UIFigure);
            app.ParASlider.Limits = [0 1];
            app.ParASlider.ValueChangedFcn = createCallbackFcn(app, @ParASliderValueChanged, true);
            app.ParASlider.Position = [172 49 82 3];

            % Create ParBSliderLabel
            app.ParBSliderLabel = uilabel(app.UIFigure);
            app.ParBSliderLabel.HorizontalAlignment = 'right';
            app.ParBSliderLabel.Position = [280 39 38 22];
            app.ParBSliderLabel.Text = 'Par. B';

            % Create ParBSlider
            app.ParBSlider = uislider(app.UIFigure);
            app.ParBSlider.Limits = [0 1];
            app.ParBSlider.ValueChangedFcn = createCallbackFcn(app, @ParBSliderValueChanged, true);
            app.ParBSlider.Position = [339 48 83 3];

            % Create ParCSliderLabel
            app.ParCSliderLabel = uilabel(app.UIFigure);
            app.ParCSliderLabel.HorizontalAlignment = 'right';
            app.ParCSliderLabel.Position = [436 40 39 22];
            app.ParCSliderLabel.Text = 'Par. C';

            % Create ParCSlider
            app.ParCSlider = uislider(app.UIFigure);
            app.ParCSlider.Limits = [0 1];
            app.ParCSlider.ValueChangedFcn = createCallbackFcn(app, @ParCSliderValueChanged, true);
            app.ParCSlider.Position = [496 49 81 3];

            % Create ZamiennaszareLabel
            app.ZamiennaszareLabel = uilabel(app.UIFigure);
            app.ZamiennaszareLabel.Position = [6 40 95 22];
            app.ZamiennaszareLabel.Text = 'Zamien na szare';

            % Create manualnieLabel
            app.manualnieLabel = uilabel(app.UIFigure);
            app.manualnieLabel.Position = [6 19 64 22];
            app.manualnieLabel.Text = 'manualnie:';

            % Create ZatwierdzButton_3
            app.ZatwierdzButton_3 = uibutton(app.UIFigure, 'push');
            app.ZatwierdzButton_3.ButtonPushedFcn = createCallbackFcn(app, @ZatwierdzButton_3Pushed, true);
            app.ZatwierdzButton_3.Position = [611 40 98 22];
            app.ZatwierdzButton_3.Text = 'Zatwierdz';

            % Create AnulujButton_3
            app.AnulujButton_3 = uibutton(app.UIFigure, 'push');
            app.AnulujButton_3.ButtonPushedFcn = createCallbackFcn(app, @AnulujButton_3Pushed, true);
            app.AnulujButton_3.Position = [611 10 97 22];
            app.AnulujButton_3.Text = 'Anuluj';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'toggle');
            app.Switch.Items = {'Kwadraty', 'Trojkaty'};
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [669 226 20 45];
            app.Switch.Value = 'Kwadraty';

            % Create RysujobszaryporowButton
            app.RysujobszaryporowButton = uibutton(app.UIFigure, 'push');
            app.RysujobszaryporowButton.ButtonPushedFcn = createCallbackFcn(app, @RysujobszaryporowButtonPushed, true);
            app.RysujobszaryporowButton.Position = [496 205 142 22];
            app.RysujobszaryporowButton.Text = 'Rysuj obszary porow';

            % Create RysujpolaczeniasasiednichobszarowCheckBox
            app.RysujpolaczeniasasiednichobszarowCheckBox = uicheckbox(app.UIFigure);
            app.RysujpolaczeniasasiednichobszarowCheckBox.ValueChangedFcn = createCallbackFcn(app, @RysujpolaczeniasasiednichobszarowCheckBoxValueChanged, true);
            app.RysujpolaczeniasasiednichobszarowCheckBox.Text = 'Rysuj polaczenia sasiednich obszarow';
            app.RysujpolaczeniasasiednichobszarowCheckBox.Position = [247 205 229 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = AnalizatorZdjecSemGUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end