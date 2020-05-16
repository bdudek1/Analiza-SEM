%UWAGA: Testy te powinno sie sprawdzac, tj uruchamiac po kazdej modyfikacji
%kodu, by uniknac nawarstwiania sie bledow w przyszlosci.
%Jesli testy nie przejda, ponizszy kod po prostu nie zadziala i
%wyrzuci blad.

a = ZdjecieSEM('220V2minI0006.png');
b = ZdjecieSEM('img.jpg');
wys = a.pokazWysokosc();

assert(a.pokazWysokosc()*a.pokazSzerokosc() == a.pokazPowierzchnieObrazu,...
       "Niezgodnosc wymiarow z obliczonym polem powierzchnii obrazu");
   
assert(a.pokazTypKoloru() == "grayscale" && b.pokazTypKoloru() == "truecolor",...
       "Problem z czytaniem typow kolorow");
   
b.zamienNaSzare();
assert(b.pokazTypKoloru() == "grayscale",...
       "Problem z zamiana obrazu kolorowego na szary");
   
b.zamienNaBinarne();
assert(b.pokazTypKoloru() == "binary", "Problem z zamiana koloru z szarego na binarny");

b.zmienZdjecie('img.jpg');
assert(b.pokazTypKoloru() == "truecolor", "Problem z funkcja zmieniajaca zdjecie");

b.zamienNaSzareManualnie(0.3, 0.4, 0.5);
assert(b.pokazTypKoloru() == "grayscale",...
       "Problem z zamiana obrazu kolorowego na szary manualnie");
   
b.zamienNaBitPlane(4, 4);
assert(b.pokazTypKoloru() == "binary",...
       "Problem z zamiana obrazu na bitplane");
   
b.zmienZdjecie('img.jpg')
b.zamienNaDouble();
assert((((max(b.pokazZdjecie(), [], 'all')) <= 1) && (min(b.pokazZdjecie(), [], 'all')) >= 0),...
       "Problem z funkcja zamieniajaca tablice obrazu na wartosci zmiennoprzecinkowe");

b.zapiszZdjecie('savetest.jpg', 'jpg');
b.zmienZdjecie('savetest.jpg');
assert(b.pokazNazwe() == "savetest.jpg", "Problem z funkcja zapisujaca obraz");

a.zamienNaBinarne();

a.obliczPowierzchniePorow(100000);
   
a.obliczIloscPorow();
assert(a.pokazIloscPorow() == 280, "Problem z funkcja liczaca ilosc porow");

a.obliczSrednicePorow();

assert(a.pokazSumeSrednicPorow() < 10000000 && a.pokazSumeSrednicPorow() > 9000000,...
    "Problem z funkcja liczaca srednice porow");

a.obliczObwodyPorow(100000);

assert(a.pokazSumeObwodowPorow() > 35000000 && a.pokazSumeObwodowPorow() < 40000000,...
       "Problem z funkcja liczaca obwody porow");