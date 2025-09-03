Zamysł zadania: 
    Zadanie obejmuje server http. Server ten przy wysłaniu odpowiedniego zapytania http odeśle flage. Trzeba wiec zreversowac ten server i zobaczyc jakie wymogi musza byc spelnione zeby odeslal ta flage. Potem je spelnic i Vuala!
    Dodatkowo strona ta na zapytanie GET o zasób / zwroci zawartosc pliku hello.html jako dodatek.

Konfiguracja zadania: 
    1.socket mysi byc odpalony w tym samym folderze co flaga.txt oraz hello.html
    2.server odpala sie na localhost:8080

Rozwiązanie:
    request musi spelnić takie warunki:
        1. musi byc użyta metoda GET
        2. musi posiadac takie podstawowe headery jak:
            h1. "Host: "
            h2. "User-Agent: "
            h3. "Accept: "
        3. musi posiadac dodatkowy customowy header taki jak "Niesmiertelna-nawijka-pjatk-skladowa: " 
        4. request musi zapełnić cały buffer którego rozmiar wynosi 4096 wiec musi byc rozmiaru co najmniej 4096. jest to sprawdzane analizując przedostatni bit buffer czy jest równy 1 czyli zapis ascii ostatniego znaku musi wygladac tak 0b01xxxxxx a nie na przklad tak 0b00101111. (sprawdzam przedostatni bit poiewaz nie ma znaku ascii którego zapis binarny miałby zapalony bit 2^7 bo jest ich tylko 127 wiec osatni bit buffera zawsze będzie 0:)
