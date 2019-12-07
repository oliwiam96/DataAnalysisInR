# Projekt z analizy danych
## Oliwia Masian 127324 grupa wtorki 16:50

Celem analizy jest odkrycie przyczyn zmniejszania się rozmiaru śledzia europejskiego.

## 1. Kod wyliczający wykorzystane biblioteki.


```R
library(dplyr)
library(ggplot2)
library(reshape2)
library(caret)
```

## 2. Kod zapewniający powtarzalność wyników przy każdym uruchomieniu raportu na tych samych danych.


```R
set.seed(42)
```

## 3. Kod pozwalający wczytać dane z pliku.

Na przestrzeni ostatnich lat zauważono stopniowy spadek rozmiaru śledzia oceanicznego wyławianego w Europie. Do analizy zebrano pomiary śledzi i warunków w jakich żyją z ostatnich 60 lat. Dane były pobierane z połowów komercyjnych jednostek. W ramach połowu jednej jednostki losowo wybierano od 50 do 100 sztuk trzyletnich śledzi.

Kolejne kolumny w zbiorze danych to:

    length: długość złowionego śledzia [cm];
    cfin1: dostępność planktonu [zagęszczenie Calanus finmarchicus gat. 1];
    cfin2: dostępność planktonu [zagęszczenie Calanus finmarchicus gat. 2];
    chel1: dostępność planktonu [zagęszczenie Calanus helgolandicus gat. 1];
    chel2: dostępność planktonu [zagęszczenie Calanus helgolandicus gat. 2];
    lcop1: dostępność planktonu [zagęszczenie widłonogów gat. 1];
    lcop2: dostępność planktonu [zagęszczenie widłonogów gat. 2];
    fbar: natężenie połowów w regionie [ułamek pozostawionego narybku];
    recr: roczny narybek [liczba śledzi];
    cumf: łączne roczne natężenie połowów w regionie [ułamek pozostawionego narybku];
    totaln: łączna liczba ryb złowionych w ramach połowu [liczba śledzi];
    sst: temperatura przy powierzchni wody [°C];
    sal: poziom zasolenia wody [Knudsen ppt];
    xmonth: miesiąc połowu [numer miesiąca];
    nao: oscylacja północnoatlantycka [mb].

Wiersze w zbiorze są uporządkowane chronologicznie.

Wczytajmy dane do zmiennej all_data


```R
all_data <- read.csv("sledzie.csv", na.string="?")
head(all_data)
```


<table>
<thead><tr><th scope=col>X</th><th scope=col>length</th><th scope=col>cfin1</th><th scope=col>cfin2</th><th scope=col>chel1</th><th scope=col>chel2</th><th scope=col>lcop1</th><th scope=col>lcop2</th><th scope=col>fbar</th><th scope=col>recr</th><th scope=col>cumf</th><th scope=col>totaln</th><th scope=col>sst</th><th scope=col>sal</th><th scope=col>xmonth</th><th scope=col>nao</th></tr></thead>
<tbody>
	<tr><td>0        </td><td>23.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>      NA </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>1        </td><td>22.5     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>2        </td><td>25.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>3        </td><td>25.5     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>4        </td><td>24.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>5        </td><td>22.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>      NA </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
</tbody>
</table>




```R
sapply(all_data, class)
```


<dl class=dl-horizontal>
	<dt>X</dt>
		<dd>'integer'</dd>
	<dt>length</dt>
		<dd>'numeric'</dd>
	<dt>cfin1</dt>
		<dd>'numeric'</dd>
	<dt>cfin2</dt>
		<dd>'numeric'</dd>
	<dt>chel1</dt>
		<dd>'numeric'</dd>
	<dt>chel2</dt>
		<dd>'numeric'</dd>
	<dt>lcop1</dt>
		<dd>'numeric'</dd>
	<dt>lcop2</dt>
		<dd>'numeric'</dd>
	<dt>fbar</dt>
		<dd>'numeric'</dd>
	<dt>recr</dt>
		<dd>'integer'</dd>
	<dt>cumf</dt>
		<dd>'numeric'</dd>
	<dt>totaln</dt>
		<dd>'numeric'</dd>
	<dt>sst</dt>
		<dd>'numeric'</dd>
	<dt>sal</dt>
		<dd>'numeric'</dd>
	<dt>xmonth</dt>
		<dd>'integer'</dd>
	<dt>nao</dt>
		<dd>'numeric'</dd>
</dl>



Widzimy brakujące wartości (NA). Zgodnie z oczekiwaniami wszystkie kolumny zostały potraktowane jako liczby.

## 4. Kod przetwarzający brakujące dane.

Spróbujmy usunąć te wiersze, które zawierają puste wartości.


```R
complete_indexes <- complete.cases(all_data)
data_complete <- all_data[complete_indexes, ]
print(nrow(data_complete))
print(nrow(all_data))
print(nrow(data_complete)/nrow(all_data))
```

    [1] 42488
    [1] 52582
    [1] 0.8080332
    

Brakujące dane to aż 20% (ponad 10 000 rekordów). Szkoda marnować zawarty w nich potencjał. Uzupełnijmy je średnią, wcześniej tylko upewnijmy się, że rozkłady nie są zbyt skośne (odpowiadające średnie i mediany nie leżą zbyt daleko od siebie).


```R
for(i in 1:ncol(all_data)){
    cat("mean: ", mean(all_data[,i], na.rm = TRUE), "median: ", median(all_data[,i], na.rm = TRUE), "\n")
}
```

    mean:  26290.5 median:  26290.5 
    mean:  25.30436 median:  25.5 
    mean:  0.445828 median:  0.11111 
    mean:  2.024818 median:  0.70118 
    mean:  10.00566 median:  5.75 
    mean:  21.22108 median:  21.67333 
    mean:  12.81081 median:  7 
    mean:  28.41883 median:  24.85867 
    mean:  0.3303509 median:  0.332 
    mean:  520366.5 median:  421391 
    mean:  0.2298095 median:  0.2319097 
    mean:  514972.9 median:  539558.4 
    mean:  13.87466 median:  13.85867 
    mean:  35.5098 median:  35.51234 
    mean:  7.25756 median:  8 
    mean:  -0.09236012 median:  0.2 
    


```R
data <- all_data
for(i in 1:ncol(data)){
    data[is.na(data[,i]), i] <- median(data[,i], na.rm = TRUE)
}
```

Sprawdźmy wynik transformacji.


```R
head(data)
```


<table>
<thead><tr><th scope=col>X</th><th scope=col>length</th><th scope=col>cfin1</th><th scope=col>cfin2</th><th scope=col>chel1</th><th scope=col>chel2</th><th scope=col>lcop1</th><th scope=col>lcop2</th><th scope=col>fbar</th><th scope=col>recr</th><th scope=col>cumf</th><th scope=col>totaln</th><th scope=col>sst</th><th scope=col>sal</th><th scope=col>xmonth</th><th scope=col>nao</th></tr></thead>
<tbody>
	<tr><td>0        </td><td>23.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.67333 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>1        </td><td>22.5     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>2        </td><td>25.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>3        </td><td>25.5     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>4        </td><td>24.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
	<tr><td>5        </td><td>22.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>24.85867 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td></tr>
</tbody>
</table>




```R
sapply(data, function(x) sum(is.na(x)))
```


<dl class=dl-horizontal>
	<dt>X</dt>
		<dd>0</dd>
	<dt>length</dt>
		<dd>0</dd>
	<dt>cfin1</dt>
		<dd>0</dd>
	<dt>cfin2</dt>
		<dd>0</dd>
	<dt>chel1</dt>
		<dd>0</dd>
	<dt>chel2</dt>
		<dd>0</dd>
	<dt>lcop1</dt>
		<dd>0</dd>
	<dt>lcop2</dt>
		<dd>0</dd>
	<dt>fbar</dt>
		<dd>0</dd>
	<dt>recr</dt>
		<dd>0</dd>
	<dt>cumf</dt>
		<dd>0</dd>
	<dt>totaln</dt>
		<dd>0</dd>
	<dt>sst</dt>
		<dd>0</dd>
	<dt>sal</dt>
		<dd>0</dd>
	<dt>xmonth</dt>
		<dd>0</dd>
	<dt>nao</dt>
		<dd>0</dd>
</dl>



W danych nie ma już brakujących wartości.

## 5. Sekcja podsumowująca rozmiar zbioru i podstawowe statystyki.


```R
nrow(data)
```


52582



```R
summary(data)
```


           X             length         cfin1             cfin2        
     Min.   :    0   Min.   :19.0   Min.   : 0.0000   Min.   : 0.0000  
     1st Qu.:13145   1st Qu.:24.0   1st Qu.: 0.0000   1st Qu.: 0.2778  
     Median :26291   Median :25.5   Median : 0.1111   Median : 0.7012  
     Mean   :26291   Mean   :25.3   Mean   : 0.4358   Mean   : 1.9862  
     3rd Qu.:39436   3rd Qu.:26.5   3rd Qu.: 0.3333   3rd Qu.: 1.7936  
     Max.   :52581   Max.   :32.5   Max.   :37.6667   Max.   :19.3958  
         chel1            chel2            lcop1              lcop2       
     Min.   : 0.000   Min.   : 5.238   Min.   :  0.3074   Min.   : 7.849  
     1st Qu.: 2.469   1st Qu.:13.589   1st Qu.:  2.5479   1st Qu.:17.808  
     Median : 5.750   Median :21.673   Median :  7.0000   Median :24.859  
     Mean   : 9.880   Mean   :21.234   Mean   : 12.6281   Mean   :28.311  
     3rd Qu.:11.500   3rd Qu.:27.193   3rd Qu.: 21.2315   3rd Qu.:37.232  
     Max.   :75.000   Max.   :57.706   Max.   :115.5833   Max.   :68.736  
          fbar             recr              cumf             totaln       
     Min.   :0.0680   Min.   : 140515   Min.   :0.06833   Min.   : 144137  
     1st Qu.:0.2270   1st Qu.: 360061   1st Qu.:0.14809   1st Qu.: 306068  
     Median :0.3320   Median : 421391   Median :0.23191   Median : 539558  
     Mean   :0.3304   Mean   : 520367   Mean   :0.22981   Mean   : 514973  
     3rd Qu.:0.4560   3rd Qu.: 724151   3rd Qu.:0.29803   3rd Qu.: 730351  
     Max.   :0.8490   Max.   :1565890   Max.   :0.39801   Max.   :1015595  
          sst             sal            xmonth            nao          
     Min.   :12.77   Min.   :35.40   Min.   : 1.000   Min.   :-4.89000  
     1st Qu.:13.63   1st Qu.:35.51   1st Qu.: 5.000   1st Qu.:-1.89000  
     Median :13.86   Median :35.51   Median : 8.000   Median : 0.20000  
     Mean   :13.87   Mean   :35.51   Mean   : 7.258   Mean   :-0.09236  
     3rd Qu.:14.16   3rd Qu.:35.52   3rd Qu.: 9.000   3rd Qu.: 1.63000  
     Max.   :14.73   Max.   :35.61   Max.   :12.000   Max.   : 5.08000  


Zbiór liczy 52582 rekordów. Średnia długość śledzia to 25.3 cm.

## 6. Szczegółowa analiza wartości atrybutów (np. poprzez prezentację rozkładów wartości).

Spróbujmy zwizualizować dane zwrócone przez funkcję summary. Użyjemy do tego wykresów pudełkowych i histogramów.


```R
meltData <- melt(data, id.vars="X")
p <- ggplot(meltData, aes(factor(variable), value)) 
p + geom_boxplot() + facet_wrap(~variable, scale="free")
```


![png](output_27_0.png)


Jak widzimy w przypadku długości śledzia średnia jest w przybliżeniu w równej odległości od kwartyli Q1 i Q3. Pojawia się wiele outlierów.

Również dla zmiennej sal (poziom zasolenia) jest wiele wartości odstających, widocznie występują miejsca o szczególnie wysokim i niskim zasoleniu (np. niskie tam, gdzie rzeki wpadają do morza).

Dla zmiennej cfin1 (dostępność planktonu [zagęszczenie Calanus finmarchicus gat. 1]) obserwujemy niesymetryczny rozkład - albo tego rodzaju planktonu jest bardzo niewiele (w większości przypadków) albo bardzo dużo.

Spójrzmy na histogramy.


```R
par(mfrow=c(2,5))
for (i in 1:length(data)) {
        hist(data[,i], main=names(data[i]), xlab="")
}
```


![png](output_29_0.png)



![png](output_29_1.png)


Do podobnych wniosków dochodzimy obserwując histogramy - rozkład cfin1 jest silnie prawoskośny, podobnie cfin2 i lcop1.

## 7. Sekcja sprawdzająca korelacje między zmiennymi; sekcja ta powinna zawierać jakąś formę graficznej prezentacji korelacji.

Po pierwsze zobaczmy, jak wielkość śledzia (length) zależy od czasu (X).


```R
ggplot(data = data, aes(x=X, y=length, group=1)) +
  geom_line(color="steelblue") +
  geom_smooth(method="lm", fill="lightgreen", color="darkgreen", alpha=0.4) +
  theme_grey()
```


![png](output_33_0.png)


Widzimy tendencję malejącą, jednak wykres nie jest zbyt czytelny. Spróbujmy pogrupować dane.

W opisie danych jest informacja, że w zmiennej xmonth przechowywany jest miesiąc połowu.


```R
head(data$xmonth, 100)
```


<ol class=list-inline>
	<li>7</li>
	<li>7</li>
	<li>7</li>
	<li>7</li>
	<li>7</li>
	<li>7</li>
	<li>7</li>
	<li>7</li>
	<li>7</li>
	<li>7</li>
	<li>7</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>5</li>
	<li>5</li>
	<li>3</li>
	<li>3</li>
	<li>3</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>3</li>
	<li>3</li>
	<li>3</li>
	<li>3</li>
	<li>3</li>
	<li>3</li>
	<li>3</li>
	<li>3</li>
	<li>3</li>
	<li>3</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>5</li>
	<li>5</li>
	<li>5</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>3</li>
	<li>3</li>
	<li>5</li>
	<li>5</li>
	<li>5</li>
	<li>5</li>
	<li>5</li>
	<li>5</li>
	<li>5</li>
	<li>9</li>
	<li>9</li>
	<li>9</li>
	<li>9</li>
	<li>9</li>
	<li>9</li>
	<li>4</li>
</ol>



Okazuje się, że miesiące nie są podane chronologicznie ("6 6 5 5 3 3 3 6"), zatem nie można pogrupować na ich podstawie danych w lata.

Sprawdźmy zmienną recr, która opisuje roczny narybek.


```R
length(unique(data$recr))
```


52


Przez 60 lat spodziewalibyśmy się 60 różnych wartości. Okazuje się, że jest ich 52, więc ta zmienna również się nie przyda.
Pogrupujmy zatem dane w kubełki o równej liczności (za wyjątkiem ostatniego) na podstawie kolejności chronologicznej (X).


```R
numberOfYears = 60
rowsInYear = ceiling( nrow(data) / 60)
print(rowsInYear)
data_years <- data %>%  mutate(year = floor(X/rowsInYear) + 1)
```

    [1] 877
    


```R
head(data_years, 5)
tail(data_years, 5)
```


<table>
<thead><tr><th scope=col>X</th><th scope=col>length</th><th scope=col>cfin1</th><th scope=col>cfin2</th><th scope=col>chel1</th><th scope=col>chel2</th><th scope=col>lcop1</th><th scope=col>lcop2</th><th scope=col>fbar</th><th scope=col>recr</th><th scope=col>cumf</th><th scope=col>totaln</th><th scope=col>sst</th><th scope=col>sal</th><th scope=col>xmonth</th><th scope=col>nao</th><th scope=col>year</th></tr></thead>
<tbody>
	<tr><td>0        </td><td>23.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.67333 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td><td>1        </td></tr>
	<tr><td>1        </td><td>22.5     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td><td>1        </td></tr>
	<tr><td>2        </td><td>25.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td><td>1        </td></tr>
	<tr><td>3        </td><td>25.5     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td><td>1        </td></tr>
	<tr><td>4        </td><td>24.0     </td><td>0.02778  </td><td>0.27785  </td><td>2.46875  </td><td>21.43548 </td><td>2.54787  </td><td>26.35881 </td><td>0.356    </td><td>482831   </td><td>0.3059879</td><td>267380.8 </td><td>14.30693 </td><td>35.51234 </td><td>7        </td><td>2.8      </td><td>1        </td></tr>
</tbody>
</table>




<table>
<thead><tr><th></th><th scope=col>X</th><th scope=col>length</th><th scope=col>cfin1</th><th scope=col>cfin2</th><th scope=col>chel1</th><th scope=col>chel2</th><th scope=col>lcop1</th><th scope=col>lcop2</th><th scope=col>fbar</th><th scope=col>recr</th><th scope=col>cumf</th><th scope=col>totaln</th><th scope=col>sst</th><th scope=col>sal</th><th scope=col>xmonth</th><th scope=col>nao</th><th scope=col>year</th></tr></thead>
<tbody>
	<tr><th scope=row>52578</th><td>52577    </td><td>24.0     </td><td>1.02508  </td><td>3.66319  </td><td>6.42127  </td><td>25.51806 </td><td>10.92857 </td><td>37.39201 </td><td>0.485    </td><td>724151   </td><td>0.3838187</td><td>457143.9 </td><td>13.7116  </td><td>35.51169 </td><td>11       </td><td> 2.05    </td><td>60       </td></tr>
	<tr><th scope=row>52579</th><td>52578    </td><td>26.0     </td><td>1.02508  </td><td>3.66319  </td><td>6.42127  </td><td>25.51806 </td><td>10.92857 </td><td>37.39201 </td><td>0.485    </td><td>724151   </td><td>0.3838187</td><td>457143.9 </td><td>13.7116  </td><td>35.51169 </td><td>11       </td><td> 2.05    </td><td>60       </td></tr>
	<tr><th scope=row>52580</th><td>52579    </td><td>25.0     </td><td>1.02508  </td><td>3.66319  </td><td>6.42127  </td><td>25.51806 </td><td>10.92857 </td><td>37.39201 </td><td>0.485    </td><td>724151   </td><td>0.3838187</td><td>457143.9 </td><td>13.7116  </td><td>35.51169 </td><td>11       </td><td> 2.05    </td><td>60       </td></tr>
	<tr><th scope=row>52581</th><td>52580    </td><td>25.0     </td><td>0.36032  </td><td>5.36402  </td><td>4.32674  </td><td>27.16006 </td><td> 5.08099 </td><td>36.68770 </td><td>0.434    </td><td>441827   </td><td>0.3726272</td><td>191976.2 </td><td>14.4796  </td><td>35.50777 </td><td> 6       </td><td>-1.90    </td><td>60       </td></tr>
	<tr><th scope=row>52582</th><td>52581    </td><td>23.5     </td><td>0.36032  </td><td>5.36402  </td><td>4.32674  </td><td>27.16006 </td><td> 7.00000 </td><td>36.68770 </td><td>0.434    </td><td>441827   </td><td>0.3726272</td><td>191976.2 </td><td>14.4796  </td><td>35.50777 </td><td> 6       </td><td>-1.90    </td><td>60       </td></tr>
</tbody>
</table>




```R
plot_data <- data_years %>% group_by(year) %>% summarize(mean_length=mean(length), from = mean(length) - sd(length), to = mean(length) + sd(length))
plot_data
```


<table>
<thead><tr><th scope=col>year</th><th scope=col>mean_length</th><th scope=col>from</th><th scope=col>to</th></tr></thead>
<tbody>
	<tr><td> 1      </td><td>23.75770</td><td>22.04112</td><td>25.47428</td></tr>
	<tr><td> 2      </td><td>25.41334</td><td>23.92273</td><td>26.90396</td></tr>
	<tr><td> 3      </td><td>25.19270</td><td>23.65274</td><td>26.73267</td></tr>
	<tr><td> 4      </td><td>24.88940</td><td>23.29200</td><td>26.48679</td></tr>
	<tr><td> 5      </td><td>25.20296</td><td>23.80239</td><td>26.60354</td></tr>
	<tr><td> 6      </td><td>25.14994</td><td>23.81802</td><td>26.48186</td></tr>
	<tr><td> 7      </td><td>25.09350</td><td>23.65872</td><td>26.52828</td></tr>
	<tr><td> 8      </td><td>25.35120</td><td>24.00170</td><td>26.70070</td></tr>
	<tr><td> 9      </td><td>25.46351</td><td>24.12292</td><td>26.80410</td></tr>
	<tr><td>10      </td><td>26.15393</td><td>24.90898</td><td>27.39889</td></tr>
	<tr><td>11      </td><td>25.50114</td><td>24.12414</td><td>26.87814</td></tr>
	<tr><td>12      </td><td>25.94413</td><td>24.71183</td><td>27.17643</td></tr>
	<tr><td>13      </td><td>26.40992</td><td>25.17641</td><td>27.64343</td></tr>
	<tr><td>14      </td><td>26.12144</td><td>24.85665</td><td>27.38622</td></tr>
	<tr><td>15      </td><td>26.21095</td><td>24.95993</td><td>27.46196</td></tr>
	<tr><td>16      </td><td>26.20468</td><td>25.03817</td><td>27.37118</td></tr>
	<tr><td>17      </td><td>26.47891</td><td>25.28658</td><td>27.67123</td></tr>
	<tr><td>18      </td><td>26.72691</td><td>25.59803</td><td>27.85579</td></tr>
	<tr><td>19      </td><td>26.82109</td><td>25.47079</td><td>28.17140</td></tr>
	<tr><td>20      </td><td>26.95724</td><td>25.80891</td><td>28.10557</td></tr>
	<tr><td>21      </td><td>27.08324</td><td>25.90098</td><td>28.26550</td></tr>
	<tr><td>22      </td><td>26.99190</td><td>25.72993</td><td>28.25388</td></tr>
	<tr><td>23      </td><td>26.32269</td><td>25.19263</td><td>27.45275</td></tr>
	<tr><td>24      </td><td>26.18187</td><td>24.86213</td><td>27.50161</td></tr>
	<tr><td>25      </td><td>25.67674</td><td>23.95811</td><td>27.39537</td></tr>
	<tr><td>26      </td><td>24.72030</td><td>23.21306</td><td>26.22753</td></tr>
	<tr><td>27      </td><td>26.55188</td><td>25.16935</td><td>27.93442</td></tr>
	<tr><td>28      </td><td>26.15884</td><td>24.81657</td><td>27.50110</td></tr>
	<tr><td>29      </td><td>25.66762</td><td>23.91270</td><td>27.42254</td></tr>
	<tr><td>30      </td><td>26.78221</td><td>25.34919</td><td>28.21523</td></tr>
	<tr><td>31      </td><td>25.20296</td><td>23.44593</td><td>26.96000</td></tr>
	<tr><td>32      </td><td>25.40422</td><td>23.32916</td><td>27.47928</td></tr>
	<tr><td>33      </td><td>25.56328</td><td>24.09084</td><td>27.03572</td></tr>
	<tr><td>34      </td><td>26.25371</td><td>24.91143</td><td>27.59598</td></tr>
	<tr><td>35      </td><td>25.70696</td><td>24.43773</td><td>26.97619</td></tr>
	<tr><td>36      </td><td>25.62942</td><td>24.31561</td><td>26.94323</td></tr>
	<tr><td>37      </td><td>25.71722</td><td>24.32134</td><td>27.11310</td></tr>
	<tr><td>38      </td><td>25.25257</td><td>23.93952</td><td>26.56561</td></tr>
	<tr><td>39      </td><td>24.75656</td><td>23.15648</td><td>26.35663</td></tr>
	<tr><td>40      </td><td>25.00969</td><td>23.62642</td><td>26.39296</td></tr>
	<tr><td>41      </td><td>25.11345</td><td>24.00673</td><td>26.22018</td></tr>
	<tr><td>42      </td><td>25.26340</td><td>24.15168</td><td>26.37511</td></tr>
	<tr><td>43      </td><td>25.04390</td><td>23.88252</td><td>26.20528</td></tr>
	<tr><td>44      </td><td>24.99145</td><td>23.86341</td><td>26.11949</td></tr>
	<tr><td>45      </td><td>24.50000</td><td>23.07673</td><td>25.92327</td></tr>
	<tr><td>46      </td><td>24.49715</td><td>23.24578</td><td>25.74852</td></tr>
	<tr><td>47      </td><td>24.32965</td><td>23.05327</td><td>25.60603</td></tr>
	<tr><td>48      </td><td>24.40650</td><td>23.09605</td><td>25.71695</td></tr>
	<tr><td>49      </td><td>24.02737</td><td>22.72741</td><td>25.32732</td></tr>
	<tr><td>50      </td><td>24.73888</td><td>23.71871</td><td>25.75906</td></tr>
	<tr><td>51      </td><td>23.99202</td><td>22.65223</td><td>25.33180</td></tr>
	<tr><td>52      </td><td>24.03820</td><td>22.78081</td><td>25.29558</td></tr>
	<tr><td>53      </td><td>23.82212</td><td>22.69684</td><td>24.94741</td></tr>
	<tr><td>54      </td><td>24.03763</td><td>22.72373</td><td>25.35152</td></tr>
	<tr><td>55      </td><td>23.90479</td><td>22.63573</td><td>25.17384</td></tr>
	<tr><td>56      </td><td>24.32269</td><td>22.95707</td><td>25.68832</td></tr>
	<tr><td>57      </td><td>23.89453</td><td>22.65312</td><td>25.13593</td></tr>
	<tr><td>58      </td><td>23.69042</td><td>22.69488</td><td>24.68596</td></tr>
	<tr><td>59      </td><td>23.59692</td><td>22.54097</td><td>24.65287</td></tr>
	<tr><td>60      </td><td>24.32956</td><td>22.81960</td><td>25.83952</td></tr>
</tbody>
</table>




```R
ggplot(data = plot_data, aes(x=year, y=mean_length, group=1)) +
  geom_line(size=1, color="steelblue") +
  geom_smooth(method="lm", fill="lightgreen", color="darkgreen") +
  geom_ribbon(aes(ymin = from, ymax = to), alpha = 0.3, fill="lightblue", color = "transparent") +
  xlab("lata") +
  ylab("długość śledzia") +
  theme_minimal()

```


![png](output_42_0.png)


Wykres jest czytelniejszy, widzimy, że długość śledzia maleje w czasie.

Narysujmy macierz korelacji.


```R
cormat <- round(cor(data), 2)
cormat
```


<table>
<thead><tr><th></th><th scope=col>X</th><th scope=col>length</th><th scope=col>cfin1</th><th scope=col>cfin2</th><th scope=col>chel1</th><th scope=col>chel2</th><th scope=col>lcop1</th><th scope=col>lcop2</th><th scope=col>fbar</th><th scope=col>recr</th><th scope=col>cumf</th><th scope=col>totaln</th><th scope=col>sst</th><th scope=col>sal</th><th scope=col>xmonth</th><th scope=col>nao</th></tr></thead>
<tbody>
	<tr><th scope=row>X</th><td> 1.00</td><td>-0.34</td><td>-0.15</td><td> 0.06</td><td>-0.16</td><td> 0.05</td><td>-0.22</td><td> 0.04</td><td> 0.09</td><td> 0.00</td><td> 0.23</td><td>-0.36</td><td> 0.35</td><td>-0.06</td><td> 0.00</td><td> 0.41</td></tr>
	<tr><th scope=row>length</th><td>-0.34</td><td> 1.00</td><td> 0.08</td><td> 0.10</td><td> 0.22</td><td>-0.01</td><td> 0.23</td><td> 0.05</td><td> 0.25</td><td>-0.01</td><td> 0.01</td><td> 0.10</td><td>-0.45</td><td> 0.03</td><td> 0.01</td><td>-0.26</td></tr>
	<tr><th scope=row>cfin1</th><td>-0.15</td><td> 0.08</td><td> 1.00</td><td> 0.15</td><td> 0.09</td><td> 0.19</td><td> 0.11</td><td> 0.20</td><td>-0.06</td><td> 0.11</td><td>-0.05</td><td> 0.13</td><td> 0.01</td><td> 0.13</td><td> 0.01</td><td> 0.01</td></tr>
	<tr><th scope=row>cfin2</th><td> 0.06</td><td> 0.10</td><td> 0.15</td><td> 1.00</td><td> 0.00</td><td> 0.30</td><td>-0.04</td><td> 0.63</td><td> 0.15</td><td>-0.10</td><td> 0.33</td><td>-0.21</td><td>-0.23</td><td>-0.08</td><td> 0.01</td><td>-0.01</td></tr>
	<tr><th scope=row>chel1</th><td>-0.16</td><td> 0.22</td><td> 0.09</td><td> 0.00</td><td> 1.00</td><td> 0.28</td><td> 0.93</td><td> 0.24</td><td> 0.16</td><td>-0.05</td><td> 0.07</td><td> 0.16</td><td>-0.21</td><td>-0.15</td><td> 0.05</td><td>-0.50</td></tr>
	<tr><th scope=row>chel2</th><td> 0.05</td><td>-0.01</td><td> 0.19</td><td> 0.30</td><td> 0.28</td><td> 1.00</td><td> 0.17</td><td> 0.86</td><td> 0.03</td><td> 0.00</td><td> 0.26</td><td>-0.37</td><td> 0.01</td><td>-0.22</td><td> 0.07</td><td>-0.06</td></tr>
	<tr><th scope=row>lcop1</th><td>-0.22</td><td> 0.23</td><td> 0.11</td><td>-0.04</td><td> 0.93</td><td> 0.17</td><td> 1.00</td><td> 0.14</td><td> 0.09</td><td> 0.00</td><td>-0.01</td><td> 0.26</td><td>-0.26</td><td>-0.10</td><td> 0.03</td><td>-0.54</td></tr>
	<tr><th scope=row>lcop2</th><td> 0.04</td><td> 0.05</td><td> 0.20</td><td> 0.63</td><td> 0.24</td><td> 0.86</td><td> 0.14</td><td> 1.00</td><td> 0.05</td><td> 0.00</td><td> 0.29</td><td>-0.30</td><td>-0.12</td><td>-0.18</td><td> 0.06</td><td>-0.04</td></tr>
	<tr><th scope=row>fbar</th><td> 0.09</td><td> 0.25</td><td>-0.06</td><td> 0.15</td><td> 0.16</td><td> 0.03</td><td> 0.09</td><td> 0.05</td><td> 1.00</td><td>-0.24</td><td> 0.82</td><td>-0.51</td><td>-0.18</td><td> 0.04</td><td> 0.01</td><td> 0.07</td></tr>
	<tr><th scope=row>recr</th><td> 0.00</td><td>-0.01</td><td> 0.11</td><td>-0.10</td><td>-0.05</td><td> 0.00</td><td> 0.00</td><td> 0.00</td><td>-0.24</td><td> 1.00</td><td>-0.26</td><td> 0.37</td><td>-0.20</td><td> 0.28</td><td> 0.02</td><td> 0.09</td></tr>
	<tr><th scope=row>cumf</th><td> 0.23</td><td> 0.01</td><td>-0.05</td><td> 0.33</td><td> 0.07</td><td> 0.26</td><td>-0.01</td><td> 0.29</td><td> 0.82</td><td>-0.26</td><td> 1.00</td><td>-0.71</td><td> 0.03</td><td>-0.10</td><td> 0.03</td><td> 0.23</td></tr>
	<tr><th scope=row>totaln</th><td>-0.36</td><td> 0.10</td><td> 0.13</td><td>-0.21</td><td> 0.16</td><td>-0.37</td><td> 0.26</td><td>-0.30</td><td>-0.51</td><td> 0.37</td><td>-0.71</td><td> 1.00</td><td>-0.28</td><td> 0.15</td><td>-0.03</td><td>-0.39</td></tr>
	<tr><th scope=row>sst</th><td> 0.35</td><td>-0.45</td><td> 0.01</td><td>-0.23</td><td>-0.21</td><td> 0.01</td><td>-0.26</td><td>-0.12</td><td>-0.18</td><td>-0.20</td><td> 0.03</td><td>-0.28</td><td> 1.00</td><td> 0.01</td><td>-0.01</td><td> 0.50</td></tr>
	<tr><th scope=row>sal</th><td>-0.06</td><td> 0.03</td><td> 0.13</td><td>-0.08</td><td>-0.15</td><td>-0.22</td><td>-0.10</td><td>-0.18</td><td> 0.04</td><td> 0.28</td><td>-0.10</td><td> 0.15</td><td> 0.01</td><td> 1.00</td><td>-0.02</td><td> 0.13</td></tr>
	<tr><th scope=row>xmonth</th><td> 0.00</td><td> 0.01</td><td> 0.01</td><td> 0.01</td><td> 0.05</td><td> 0.07</td><td> 0.03</td><td> 0.06</td><td> 0.01</td><td> 0.02</td><td> 0.03</td><td>-0.03</td><td>-0.01</td><td>-0.02</td><td> 1.00</td><td> 0.00</td></tr>
	<tr><th scope=row>nao</th><td> 0.41</td><td>-0.26</td><td> 0.01</td><td>-0.01</td><td>-0.50</td><td>-0.06</td><td>-0.54</td><td>-0.04</td><td> 0.07</td><td> 0.09</td><td> 0.23</td><td>-0.39</td><td> 0.50</td><td> 0.13</td><td> 0.00</td><td> 1.00</td></tr>
</tbody>
</table>




```R
melted_cormat <- melt(cormat)
head(melted_cormat)
```


<table>
<thead><tr><th scope=col>Var1</th><th scope=col>Var2</th><th scope=col>value</th></tr></thead>
<tbody>
	<tr><td>X     </td><td>X     </td><td> 1.00 </td></tr>
	<tr><td>length</td><td>X     </td><td>-0.34 </td></tr>
	<tr><td>cfin1 </td><td>X     </td><td>-0.15 </td></tr>
	<tr><td>cfin2 </td><td>X     </td><td> 0.06 </td></tr>
	<tr><td>chel1 </td><td>X     </td><td>-0.16 </td></tr>
	<tr><td>chel2 </td><td>X     </td><td> 0.05 </td></tr>
</tbody>
</table>




```R
  get_upper_tri <- function(cormat){
    cormat[lower.tri(cormat)]<- NA
    return(cormat)
  }

upper_tri <- get_upper_tri(cormat)
```


```R
melted_cormat <- melt(upper_tri, na.rm = TRUE)
```


```R
ggheatmap <- ggplot(data = melted_cormat, aes(Var2, Var1, fill = value))+
 geom_tile(color = "white")+
 scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
   midpoint = 0, limit = c(-1,1), space = "Lab", 
   name="Pearson\nCorrelation") +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
    size = 12, hjust = 1))+
  coord_fixed()

```


```R
ggheatmap + 
geom_text(aes(Var2, Var1, label = value), color = "black", size = 2.5) +
theme(
  axis.title.x = element_blank(),
  axis.title.y = element_blank(),
  panel.grid.major = element_blank(),
  panel.border = element_blank(),
  panel.background = element_blank(),
  axis.ticks = element_blank(),
  legend.justification = c(1, 0),
  legend.position = c(0.6, 0.7),
  legend.direction = "horizontal")+
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                title.position = "top", title.hjust = 0.5))
```


![png](output_49_0.png)


Widzimy, że zmienne lcop1 (zagęszczenie widłonogów gat. 1) i chel1(zagęszczenie Calanus helgolandicus gat. 1) są bardzo mocno ze sobą skorelowane, więc jedną z nich można potencjalnie usunąć ze względu na redundancję. Podobnie lcop2 i chel2.

Duży współczynnik korelacji mają także cumf i fbar (obie zmienne opisują ułamek pozostawionego narybku). Cumf i length są praktycznie w ogóle nieskorelowane, dlatego decydujemy się usunąć cumf (jej wpływ na length jest prawie zerowy, więc można ją bezpiecznie usunąć).


```R
data_reduced <- select(data, -c(chel1, chel2, cumf, X))
```

Ostatnim krokiem w tej sekcji będzie dokonanie analizy głównych składowych (PCA).
Ma to na celu zbadanie istotności cech.


```R
pca <- prcomp(data, center = TRUE,scale. = TRUE)

summary(pca)
```


    Importance of components:
                              PC1    PC2    PC3     PC4     PC5     PC6     PC7
    Standard deviation     1.8063 1.7766 1.3505 1.22974 1.09650 1.00144 0.97763
    Proportion of Variance 0.2039 0.1973 0.1140 0.09452 0.07514 0.06268 0.05974
    Cumulative Proportion  0.2039 0.4012 0.5152 0.60970 0.68485 0.74753 0.80726
                               PC8     PC9    PC10    PC11    PC12    PC13   PC14
    Standard deviation     0.84486 0.81709 0.76491 0.67350 0.50501 0.45164 0.3047
    Proportion of Variance 0.04461 0.04173 0.03657 0.02835 0.01594 0.01275 0.0058
    Cumulative Proportion  0.85187 0.89360 0.93017 0.95852 0.97446 0.98721 0.9930
                              PC15    PC16
    Standard deviation     0.24523 0.22735
    Proportion of Variance 0.00376 0.00323
    Cumulative Proportion  0.99677 1.00000



```R
sum_variance <- cumsum(pca$sdev^2 / sum(pca$sdev^2))
df <- data.frame(sum_variance = sum_variance,
                n=1:length(sum_variance))
df
```


<table>
<thead><tr><th scope=col>sum_variance</th><th scope=col>n</th></tr></thead>
<tbody>
	<tr><td>0.2039268</td><td> 1       </td></tr>
	<tr><td>0.4011992</td><td> 2       </td></tr>
	<tr><td>0.5151849</td><td> 3       </td></tr>
	<tr><td>0.6097017</td><td> 4       </td></tr>
	<tr><td>0.6848462</td><td> 5       </td></tr>
	<tr><td>0.7475263</td><td> 6       </td></tr>
	<tr><td>0.8072615</td><td> 7       </td></tr>
	<tr><td>0.8518735</td><td> 8       </td></tr>
	<tr><td>0.8936010</td><td> 9       </td></tr>
	<tr><td>0.9301691</td><td>10       </td></tr>
	<tr><td>0.9585190</td><td>11       </td></tr>
	<tr><td>0.9744588</td><td>12       </td></tr>
	<tr><td>0.9872074</td><td>13       </td></tr>
	<tr><td>0.9930111</td><td>14       </td></tr>
	<tr><td>0.9967696</td><td>15       </td></tr>
	<tr><td>1.0000000</td><td>16       </td></tr>
</tbody>
</table>




```R
ggplot(data=df, aes(x=n, y=sum_variance)) +
  geom_bar(stat="identity", fill="steelblue")+
  theme_minimal() +
  xlab("n") +
  ylab("% wyjaśnianej wariancji") 
```


![png](output_55_0.png)


Na wykresie przedstawiono skumulowaną sumę wyjaśnianej wariancji dla pierwszych n głównych składowych.

Procent wyjaśnianej waraiancji gwałtownie rośnie dla pierwszych kilku n, a nasyca się w okolicach n = 11,
skąd można wysnuć wniosek, że nie wszystkie cechy są istotne i można zmniejszyć wymiarowość problemu.

## 8. Interaktywny wykres lub animacja prezentującą zmianę rozmiaru śledzi w czasie.

# *WYKRES STWORZONO PRZY UŻYCIU SHINY I ZNAJDUJE SIĘ W OSOBNYCH PLIKACH (SERVER I UI).*

## 9. Sekcja próbującą stworzyć regresor przewidujący rozmiar śledzia; dobór parametrów modelu oraz oszacowanie jego skuteczności powinny zostać wykonane za pomocą techniki podziału zbioru na dane uczące, walidujące i testowe; trafność regresji powinna zostać oszacowana na podstawie miar *R2* i *RMSE*.

Przypomijmy, że w wyniku analizy korelacji zdecydowaliśmy się na usunięcie zmiennych chel1, chel2, cumf, X ze względu na to, że przedstawia numer wiersza także decydujemy się usunąć.


```R
data_reduced <- select(data, -c(chel1, chel2, cumf, X))
```

Przeprowadzamy podział na zbiory treningowy (do nauki), walidacyjny (do walidacji najlepszych parametrów) i testowy (na którym zdecydujemy się przetestować najlepszy algorytm).


```R
inTrainingValidAll <- 
    createDataPartition(
        y = data_reduced$length,
        p = .8,
        list = FALSE)
```


```R
training_valid_all <- data_reduced[ inTrainingValidAll,]
testing  <- data_reduced[-inTrainingValidAll,]
```


```R
inTraining <- 
    createDataPartition(
        y = training_valid_all$length,
        p = .8,
        list = FALSE)
```


```R
training <- training_valid_all[ inTraining,]
validating  <- training_valid_all[-inTraining,]
```


```R
print(nrow(training))
print(nrow(validating))
print(nrow(testing))
print(nrow(data))
```

    [1] 33655
    [1] 8412
    [1] 10515
    [1] 52582
    


```R
ggplot(mapping=aes(alpha=0.4)) + 
 geom_density(aes(training$length, fill="zbiór treningowy"), training) + 
 geom_density(aes(validating$length, fill="zbiór walidacyjny"), validating) + 
 geom_density(aes(testing$length, fill="zbiór testowy"), testing) + 
 theme_minimal() +
  xlab("Długość śledzia") +
  ylab("Gęstość prawdopodobieństwa") 
```


![png](output_68_0.png)


Widzimy, że próbkowanie zbioru danych nastąpiło poprawnie, w każdym typie zbioru występuje podobny rozkład zmiennej wyjściowej.


```R
basic_model <- train(length ~ .,
               data = training,
               method = "lm")
basic_model
```


    Linear Regression 
    
    33655 samples
       11 predictor
    
    No pre-processing
    Resampling: Bootstrapped (25 reps) 
    Summary of sample sizes: 33655, 33655, 33655, 33655, 33655, 33655, ... 
    Resampling results:
    
      RMSE      Rsquared  MAE     
      1.422033  0.265067  1.132041
    
    Tuning parameter 'intercept' was held constant at a value of TRUE


Rozszerzmy model o powtarzaną kroswalidację.


```R
ctrl <- trainControl(
    # powtórzona ocena krzyżowa
    method = "repeatedcv",
    # liczba podziałów
    number = 5,
    # liczba powtórzeń
    repeats = 3)
```


```R
model <- train(length ~ .,
               data = training,
               trControl = ctrl,
               method = "lm")
model
```


    Linear Regression 
    
    33655 samples
       11 predictor
    
    No pre-processing
    Resampling: Cross-Validated (5 fold, repeated 3 times) 
    Summary of sample sizes: 26923, 26924, 26925, 26924, 26924, 26924, ... 
    Resampling results:
    
      RMSE      Rsquared   MAE     
      1.424091  0.2637254  1.133492
    
    Tuning parameter 'intercept' was held constant at a value of TRUE



```R
ggplot(varImp(model))
```


![png](output_74_0.png)



```R
preprocessed_model <- train(length ~ .,
               data = training,
               trControl = ctrl,
               preProcess = c('scale', 'center'),
               method = "lm")
```


```R
preprocessed_model
```


    Linear Regression 
    
    33655 samples
       11 predictor
    
    Pre-processing: scaled (11), centered (11) 
    Resampling: Cross-Validated (5 fold, repeated 3 times) 
    Summary of sample sizes: 26923, 26924, 26924, 26924, 26925, 26924, ... 
    Resampling results:
    
      RMSE      Rsquared   MAE     
      1.424087  0.2637934  1.133478
    
    Tuning parameter 'intercept' was held constant at a value of TRUE


Preprocessing danych (skalowanie i centrowanie) niewiele pomogły. Spróbujmy innych rodzajów regresji.


```R
lasso_model <- train(length ~ .,
               data = training,
               trControl = ctrl,
               preProcess = c('scale', 'center'),
               method = "lasso")
```


```R
lasso_model
```


    The lasso 
    
    33655 samples
       11 predictor
    
    Pre-processing: scaled (11), centered (11) 
    Resampling: Cross-Validated (5 fold, repeated 3 times) 
    Summary of sample sizes: 26924, 26924, 26924, 26924, 26924, 26925, ... 
    Resampling results across tuning parameters:
    
      fraction  RMSE      Rsquared   MAE     
      0.1       1.587939  0.2038671  1.280882
      0.5       1.448721  0.2473496  1.160785
      0.9       1.424408  0.2635382  1.133967
    
    RMSE was used to select the optimal model using the smallest value.
    The final value used for the model was fraction = 0.9.



```R
ridge_model <- train(length ~ .,
               data = training,
               trControl = ctrl,
               preProcess = c('scale', 'center'),
               method = "ridge")
ridge_model
```


    Ridge Regression 
    
    33655 samples
       11 predictor
    
    Pre-processing: scaled (11), centered (11) 
    Resampling: Cross-Validated (5 fold, repeated 3 times) 
    Summary of sample sizes: 26924, 26924, 26924, 26924, 26924, 26924, ... 
    Resampling results across tuning parameters:
    
      lambda  RMSE      Rsquared   MAE     
      0e+00   1.424037  0.2637555  1.133489
      1e-04   1.424037  0.2637556  1.133486
      1e-01   1.425090  0.2627916  1.132254
    
    RMSE was used to select the optimal model using the smallest value.
    The final value used for the model was lambda = 1e-04.


Root mean squared error (RMSE, błąd średniokwadratowy) oblicza się ze wzoru $sqrt(mean((pred - obs)^2$


$pred$ to przewidziane przez model wartości, a $obs$ to faktycznie zaobserwowane dane wyjściowe

R-squared ($R^2$) to współczynnik mówiący o tym jak dobrze dane wyliczone za pomocą modelu pasują do danych prawdziwych (współczynnik korelacji między nimi do kwadratu), zatem chcemy minimalizować RMSE i maksymualizować R-squared.


```R
predictions <- predict(model, validating)
postResample(pred = predictions, obs = validating$length)
```


<dl class=dl-horizontal>
	<dt>RMSE</dt>
		<dd>1.41612888343055</dd>
	<dt>Rsquared</dt>
		<dd>0.254605417002908</dd>
	<dt>MAE</dt>
		<dd>1.13485442920146</dd>
</dl>




```R
predictions <- predict(preprocessed_model, validating)
postResample(pred = predictions, obs = validating$length)
```


<dl class=dl-horizontal>
	<dt>RMSE</dt>
		<dd>1.41612888343055</dd>
	<dt>Rsquared</dt>
		<dd>0.254605417002907</dd>
	<dt>MAE</dt>
		<dd>1.13485442920145</dd>
</dl>




```R
predictions <- predict(lasso_model, validating)
postResample(pred = predictions, obs = validating$length)
```


<dl class=dl-horizontal>
	<dt>RMSE</dt>
		<dd>1.41642899394755</dd>
	<dt>Rsquared</dt>
		<dd>0.254147962866139</dd>
	<dt>MAE</dt>
		<dd>1.13510914520611</dd>
</dl>




```R
predictions <- predict(ridge_model, validating)
postResample(pred = predictions, obs = validating$length)
```


<dl class=dl-horizontal>
	<dt>RMSE</dt>
		<dd>1.41612939103711</dd>
	<dt>Rsquared</dt>
		<dd>0.254605073581269</dd>
	<dt>MAE</dt>
		<dd>1.13485213156802</dd>
</dl>



Wszystkie modele działają praktycznie tak samo. Spróbujmy jeszcze wytrenować regresor na wszystkich kolumnach.


```R
all_training_valid_all <- data[ inTrainingValidAll,]
all_testing  <- data[-inTrainingValidAll,]
all_training <- data[ inTraining,]
all_validating  <- data[-inTraining,]
```


```R
all_ridge_model <- train(length ~ .,
               data = all_training,
               trControl = ctrl,
               preProcess = c('scale', 'center'),
               method = "ridge")
all_ridge_model
```


    Ridge Regression 
    
    33655 samples
       15 predictor
    
    Pre-processing: scaled (15), centered (15) 
    Resampling: Cross-Validated (5 fold, repeated 3 times) 
    Summary of sample sizes: 26924, 26923, 26925, 26924, 26924, 26924, ... 
    Resampling results across tuning parameters:
    
      lambda  RMSE      Rsquared   MAE     
      0e+00   1.339599  0.2831957  1.059560
      1e-04   1.339599  0.2831958  1.059557
      1e-01   1.356933  0.2663379  1.072745
    
    RMSE was used to select the optimal model using the smallest value.
    The final value used for the model was lambda = 1e-04.



```R
predictions <- predict(all_ridge_model, all_validating)
postResample(pred = predictions, obs = all_validating$length)
```


<dl class=dl-horizontal>
	<dt>RMSE</dt>
		<dd>1.47154634709673</dd>
	<dt>Rsquared</dt>
		<dd>0.268014225907215</dd>
	<dt>MAE</dt>
		<dd>1.16562470360038</dd>
</dl>



Biorąc pod uwagę RMSE można wysnuć wniosek, że redukcja atrybutów była dobrym posunięciem.

## 10. Analiza ważności atrybutów najlepszego znalezionego modelu regresji.
Przyjrzyjmy się najważniejszym cechom według trenowanych modeli regresji.


```R
ggplot(varImp(preprocessed_model))
```


![png](output_92_0.png)



```R
ggplot(varImp(lasso_model))
```


![png](output_93_0.png)



```R
ggplot(varImp(ridge_model))
```


![png](output_94_0.png)


W badanych modelach dużą ważność mają następujące cechy:
- sst (temperatura przy powierzchni wody [°C])
- fbar (natężenie połowów w regionie [ułamek pozostawionego narybku])
- nao (nao: oscylacja północnoatlantycka [mb]) - w regresjach typu lasso i ridge
- lcop1: dostępność planktonu [zagęszczenie widłonogów gat. 1]


Stąd można wysnuć wniosek, że na wielkość śledzia mają największy wpływ powyższe czynniki.

Uznajmy, że model ridge za osteczny i dokonajmy predykcji na zbiorze testowym.


```R
test_predictions <- predict(ridge_model, testing)
postResample(pred = test_predictions, obs = testing$length)
```


<dl class=dl-horizontal>
	<dt>RMSE</dt>
		<dd>1.42212885304851</dd>
	<dt>Rsquared</dt>
		<dd>0.249665403921797</dd>
	<dt>MAE</dt>
		<dd>1.13506273252789</dd>
</dl>




```R
ggplot(testing, aes(all_testing$X)) +
 geom_line(aes(y = testing$length, colour = "blue")) +
 geom_line(aes(y = test_predictions, colour = "green")) +
 xlab("X") +
 ylab("length") + 
 scale_color_discrete(name = "Y series", labels = c("ground truth", "predicted")) +
 theme_grey()
```


![png](output_98_0.png)


Model dobrze przewiduje długość śledzia w poszczególnych okresach, nie uwzględnia dużych wahań długości w krótkich odstępach czasu (generalizuje).

Na koniec zwizualizujmy zależności między odkrytymi ważnymi cechami a zmienną y (length, długość śledzia)


```R
by_sst <- data %>%
  group_by(sst) %>%
  summarise(sst_mean = mean(sst), length_mean = mean(length))
ggplot(by_sst,  aes(x=sst_mean,y=length_mean)) +
geom_point() + geom_smooth(method='lm')
```


![png](output_101_0.png)


Im wyższa temperatura przy powierzchni, tym krótsze śledzie.


```R
by_fbar <- data %>%
  group_by(fbar) %>%
  summarise(fbar_mean = mean(fbar), length_mean = mean(length))
ggplot(by_fbar,  aes(x=fbar_mean,y=length_mean)) +
geom_point() + geom_smooth(method='lm')
```


![png](output_103_0.png)


Im więcej pozostanie narybku, tym dłuższe śledzie.


```R
by_nao <- data %>%
  group_by(nao) %>%
  summarise(nao_mean = mean(nao), length_mean = mean(length))
ggplot(by_nao,  aes(x=nao_mean,y=length_mean)) +
geom_point() + geom_smooth(method='lm')
```


![png](output_105_0.png)


Im większe nao (Oscylacja północnoatlantycka), tym krótsze śledzie.


```R
by_lcop1 <- data %>%
  group_by(lcop1) %>%
  summarise(lcop1_mean = mean(lcop1), length_mean = mean(length))
ggplot(by_lcop1,  aes(x=lcop1_mean,y=length_mean)) +
geom_point() + geom_smooth(method='lm')
```


![png](output_107_0.png)


Im większa dostępność planktonu [zagęszczenie widłonogów gat. 1], tym dłuższe śledzie.


```R

```
