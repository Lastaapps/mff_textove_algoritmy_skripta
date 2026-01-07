## Zkouška ze stránky předmětu
- Nalézt opakující se podslovo slova x v suffixovém stromě. (viz. slide číslo7)
- Kódovat slovo pomocí suffixového pole (viz. slide číslo 24) (slovo bylo stejné)
- Konstrukce DAWG / CDAWG na slovo cocoa (jak se konstruují, jaká je prostorová složitost, porovnání se suffix stromem)
- Problém nejdelší společné podposloupnosti - najít nějaký rozumný algoritmus ... Wagner - Fischer (viz. slide číslo 14,15)
- Problém palindromu (viz. slide číslo 13)


## Zkouška 2013-01-29 23:15:09
- Prostorová složitost suffixového stromu a suffixové trie.
- Nalezení všech dvojic i, j takových že existuje k>=0 t.ž. [i..i+k]=[j..j+k].
- Nalezení nejdelší společné podposloupnosti.
- Sestrojit automat pro regulární výraz ((ab)|(c)) nad abecedou {a,b,c}.

Jinak je zkouška pohodová, nevadilo, že jsem si nejdříve špatně přečetl (3) a místo LCS jsem hledal maximální NRE... Není potřeba psát moc formálně, stačí když to umíte okecat. ;-)


## Zkouška z 16.1.2014:
- Popište efektivní algoritmus na sestavení sufixového pole. Odvoďte jeho časovou složitost. (slide 23-42)
- Popište algoritmus na vytváření NFA z regulárního výrazu. Popište jeho časovou a prostorovou složitost. (slide 8-18)
- Určování vzdálenosti mezi slovy pomocí dynamického programování. Rekurentní vztah a časová + prostorová složitost. (slide 10-13)



## 3.9.2014
- Sufixový strom: efektivní konstrukce
- Bitový paralelismus: vybrat si problém a vyřešit ho pomocí bitových operací + pseudokód
- Konečná množina vzorků - časová složitost

ad 1) Ukkonen + 4 triky.
V algoritmu pro i-tou iteraci jsem měl napsáno že se řídím podle toho, zda návěští hrany je x*, což není pravda, protože návěští hran mohou být víceznaková, tak se zeptal na definici sufixového stromu a nakonec ze mě dostal že se řídím podle prvního znaku návěští.

Chtěl po mně vysvětlení každého triku, proč triky a pozorování k nim potřebná platí. Nemohl jsem přijít na to proč funguje "pokud x[j..i] je list pak i x[j-1..i] je list". Docela jsme se na tom zasekli než mi ukázal že listy v implicitním SS reprezentují unikátní přípony (tedy přípony tam nejsou 2x) a z toho už to jde vidět.

Chtěl po mně ještě sufixové hrany, tak jsem napsal co to je a jak se to používá. Ptal se co se stane když tam sufixová hrana není (vytvořím ji), jak se vytváří, co je to fastscan, co je to slowscan a jak se liší, jak dlouho trvají a jak dlouho trvá celý Ukkonen,

ad 2) Vybral jsem si přesné vyhledávání vzoru, Chtěl to ještě vysvětlit, proč tam jsou ty bitové operace tak jak jsou, co je s^i, jak dlouho to trvá a pak dodal že je to vhodné jen pro malé délky vzorků.

ad 3) Vybral jsem si Aho-Corasicka a napsal k tomu složitost konstrukce trie a hledání pomocí ní a zmínil jsem nejlepší dolní odhad .

Výsledek, za dva hned nebo se na něco zeptá. Chtěl jsem vzít dvojku, ale začal mi to rozmlouvat že chce vědět podrobnější časovou analýzu buď u 1) nebo 3). Věděl jsem obojí - u 1) mu šlo o důkaz m = O(n) kde stačilo říct že sufixová funkce jde pořád hlouběji a počet vrcholů na cestě je <= n a u 3) chtěl vědět že tam je fail funkce, co to je a k času jsem řekl že to je stejný argument jako u hranic a zmínil jsem jak se upočítá, že #iterací je < n.

Zkouška příjemná, zvlášť absence důkazů (až na pár triviálních) :D Na druhou stranu se Dvořák hodně!! ptá: na spoustu detailů, proč co platí, chce všechno vysvětlit a nepřehlídne žádnou chybu. Narozdíl od některých zkoušejících nenapovídá. Pokud budete přemýšlet, tak bude svorně mlčet s vámi dokud něco neřeknete. Pokud to nevymyslíte, neprozradí vám správnou odpověď, ale přeskočí otázku a nechá vám ji na později. Přišlo mi dobré (pokud jsem nevěděl odpověď hned) mu narovinu říct, že chcete otázku přeskočit a promyslet si ji.*



### Zkouška 18.9. 2014

- Sufixové pole
  a) Detailně algoritmus konstrukce
  b) důkaz časové složitosti
- Rekurentní vztah u algoritmu pro vzdálenost dvou slov
- Popsat algoritmus pro stavbu NFA pro regulární výrazy

zkouška není těžká, ale pan Dvořák se na všechno detailně ptá, co a jak funguje a proč, u druhé otázky nestačí pouze napsat vztah ale nutné je říci proč tak funguje. Jak už bylo řečeno, pokud nevíte tak neradí a čeká, popřípadě odejde a vrátí se až po chvíli. Takže když něco nevíte a myslíte že to dohromady nedáte, rovnou to řekněte a možná se zeptá na něco jiného. Jinak pokud napíšete zkoušku na 2, bude vás dlouho přemlouvat aby vám mohl dát další otázku a zlepšit hodnocení.




## Zkouška 26. 1. 2016

- Srovnat prostorovou složitost sufixového trie, sufixového stromu, DAWG a CDAWG a vysvětlit, proč to tak je
- Aho-Corasick, napsat definici Fail funkce, popsat, k čemu slouží, napsat algoritmus pro efektivní konstrukci a jak dlouho bude trvat
- Algoritmus pro určení vzdálenosti dvou slov (dynamické programování)

Nechal nám dost času na přípravu, a taky čas na rozmyšlenou, když jsem něco nevěděla hned. Jak už tady všichni psali, hodně se ptá na detaily, chce vědět, proč co funguje, je potřeba tomu docela rozumět.
Na druhou stranu mi připadalo, že moc netrvá na formalismech a když jsem mu třeba u 2) napsala pseudokód na konstrukci těch zpětných hran, tak mě pochválil, že to mám hodně precizně :D (a to jsem si myslela, že jsem to odflákla :D). U 3) si přečetl, co jsem napsala, řekl, že všechno dobře, a pak se ptal ještě na spoustu věcí - jak z té tabulky poznáme, které operace použít, jestli poznáme délku nejdelší podposloupnosti, zajímalo ho i vylepšení toho algoritmu (jak se berou jenom určité diagonály).
Nakonec jsem ale dostala jedničku, takže možná se takhle moc ptal proto, že se chtěl přesvědčit, jestli tomu fakt rozumím :)
slunicko at 2019-02-04 15:29:29




## Zkouška 23. 1. 2019

- normální forma slova (nevím, jak přesně znělo zadání, ale asi s jakou složitostí se dá zjistit),
- využití sufixového pole pro pattern matching - popsat pomocí pseudokódu
- Ukkonen-Meyers - hlavní myšlenka

U jedničky jsem zběžně popsala, že se to získává z border arraye pomocí DP v lineárním čase. Ke dvojce jsem napsala pseudokód SANaive, SASimple + hledání ostatních výskytů a jen jsem zmínila, že to jde ještě složitěji s předpočítaným lcp. K trojce jsem napsala rekurentní vztah pro vyplnění matice vzdáleností, pak omezení na použité diagonály.
Přečetl si to a v zásadě vždy odsouhlasil, pak se doptával. K 1 chtěl důkaz, mohla jsem si vybrat ze tří: buď důkaz korektnosti algoritmu pro sestrojení border array, nebo důkaz linearity, třetí si nepamatuju. U 2 se ptal na složitost. Pseudokód byl podle mě nepřesný, ale detaily vůbec neřešil. Ke trojce se určitě taky na něco ptal, ale nepamatuju si na co..
Celkově docela pohodová zkouška, času bylo podle mě až dost (horní limit nebyl, ale prý to máme ideálně dodělat do poledne).
regina at 2019-02-06 11:52:56




## Zkouška 6.2.2019:

- Asymptotickou složitost časovou a prostorovou pro nalezení všech výskytů vzoru v textu.
- Jak se využívá suffix array pro nalezení všech výskytů vzoru v textu?
- Rekurentní vztah u algoritmu pro vzdálenost dvou slov




## Distanční zkouška 14.1.2021

### Písemná část - čas byl 60 minut

- prostorová složitost (včetně odůvodnění) - sufixový trie, strom, pole, CDAWG (+ FM index)
- myšlenka Longest Common Subsequence (LCS)
- myšlenka a použití bitového paralelismu

### Ústní část - 30 minut

Nejprve pan Dvořák procházel písemnou část a doptával se na nějaké související věci - například k 2) a 3) chtěl odvodit časovou složitost
Potom se zeptal na myšlenku algoritmu Ukkonen-Meyers.
