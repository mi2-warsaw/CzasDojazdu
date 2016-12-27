lang <- list(
  body = list(
    rooms = list(
      `1` = "Przy każdym kliknięciu '",
      `2` = "' sprawdzana jest odległość tylu dostępnych ofert: ",
      `3` = " od wskazanej lokalizacji. Aplikacja korzysta z google maps API,
            która umożliwia sprawdzenie za darmo jedynie 2500 odległości
            dziennie. Prawdopodonnie aplikacja działa dla 20 osób dziennie.
            Pracujemy nad zwiększeniem potencjału aplikacji. Gdy widzisz
            komunikat: no such index at level 1 - oznacza to, że dzienny limit
            póki co się wyczerpał dla wersji beta tej aplikacji."
    ),
    analysis = "Jeżeli mapa się nie wyświetla, spróbuj dwukrotnie kliknąć w
                górny pasek przeglądarki, w celu wyśrodkowania mapy.",
    apartments = list(
      `1` = "Obecnie opcja wyszukiwania mieszkań nie jest dostępna, ale bardzo
            chętnie pomożemy ją dodać. Jeżeli chcesz dołączyć do autorów,
            przygotowując skrypty udostępniające te dane w oparciu o",
      `2` = "nasze kody",
      `3` = ", daj znać!"
    ),
    about = list(
      header = "O projekcie Czas Dojazdu",
      paragraph = "Aplikacja Czas Dojazdu umożliwia wyszukanie pokoi do
                    wynajęcia, których czas dojazdu nie przekracza danych
                    parametrów od wybranego miejsca. Informacje o pokojach
                    pobierane są z popularnych portali z ogłoszeniami.",
      `1` = "1) Podaj lokalizację w Warszawie, do której chciałbyś dojechać.",
      `2` = "2) Wybierz środek transportu. Umożliwiamy 3 opcje: samochód, rower
            oraz pieszo.",
      `3` = "3) Określ maksymalny czas dojazdu (w minutach).",
      `4` = "4) Podaj zakres cenowy.",
      `5` = "5) Sprecyzuj datę ogłoszeń (sugerujemy ostatnie 2-3 dni, ze względu
            na aktualność)",
      `6` = "6) Następnie kliknij w poniższy przycisk :)",
      `7` = "7) Po przejściu do panelu Pokoje/Mieszkania, dostaniesz następujący
            wynik: zielony marker oznacza wskazaną przez Ciebie lokalizację,
            niebieski to oferty spełniające Twoje oczekiwania.",
      `8` = "8) Po kliknięciu na marker otrzymasz szczegółowe informacje
            odnośnie oferty: adres, link do ogłoszenia, cenę oraz wielkość.",
      suggestions = "Jeżeli uważasz, że aplikację można poprawić, albo masz
                jakiekolwiek pytania bądź sugestie, proszę zostaw wiadomość w
                poniższym panelu."
    ),
    table = list(
      `1` = "Tabela przedstawi dane spełniające wymagania sprecyzowane w lewym
      panelu, po kliknięciu '",
      `2` = "Pełne dane dostępne są tutaj."
    )
  ),
  header = list(
    title = "Czas Dojazdu",
    offers = "ofert",
    project = list(
      from = "Projekt",
      message = "Kliknij by przejść"
    ),
    data = list(
      from = "Dane",
      message = "Aktualne na dzień"
    ),
    profile = "Kliknij by przejść na profil",
    team = list(
      from = "Zespół na GitHubie",
      message = "Kliknij by przejść"
    )
  ),
  sidebar = list(
    language = "Wybierz język:",
    about = list(
      item = "O projekcie",
      subitem = list(
        goal = "Cel",
        authors = "Ludzie",
        data = "Dane"
      )
    ),
    rooms = "Pokoje",
    apartments = "Mieszkania",
    analysis = "Analizy",
    location = "Lokalizacja: ",
    commuting = "Maksymalny czas dojazdu: ",
    transport = list(
      label = "Środek transportu: ",
      driving = "Samochód",
      bicycling = "Rower",
      walking = "Pieszo"
    ),
    price = "Zakres cenowy: ",
    date = "Oferty z dni",
    lang = "pl",
    separator = " do ",
    button = "Pokaż lokalizacje",
    content_lok = "Twoja lokalizacja"
  )
)

lang %>% jsonlite::toJSON(pretty = TRUE) %>% cat(file = "app/lang/pl.json")