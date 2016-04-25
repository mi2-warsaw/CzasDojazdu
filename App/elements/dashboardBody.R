dashboardBody <- dashboardBody(
    tags$head(tags$script(
      "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
      ga('create', 'UA-76544868-1', 'auto');
      ga('send', 'pageview');")
    ),
    tabItems(
      tabItem(
        "pokoje",
        leafletOutput("mymap" , height = 800)
      ),
      tabItem(
        "mieszkania",
        div(
          HTML('<p style="font-size:18px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;Obecnie opcja wyszukiwania mieszkań nie jest dostępna, ale bardzo chętnie pomożemy ją dodać. Jeżeli chcesz dołączyć do autorów, przygotowując skrypty udostępniające te dane w oparciu <a href="https://github.com/mi2-warsaw/CzasDojazdu/tree/master/Rscripts/collect_data">o nasze kody</a>, daj znać!</p>')
        )#,
        # div(id="disqus_thread",
        #     HTML("<script>
        #            (function() {  // DON'T EDIT BELOW THIS LINE
        #                var d = document, s = d.createElement('script');
        #                
        #                s.src = '//mi2-czasojazdu.disqus.com/embed.js';
        #                
        #                s.setAttribute('data-timestamp', +new Date());
        #                (d.head || d.body).appendChild(s);
        #            })();
        #        </script>
        #        <noscript>Please enable JavaScript to view the <a href='https://disqus.com/?ref_noscript' rel='nofollow'>comments powered by Disqus.</a></noscript>")
        #  )
      ),
      tabItem(
        "cel",
        div(
            HTML('<p style="font-size:32px; font-family:Verdana;"align="justify"><h2> O projekcie Czas Dojazdu</h2></p>'),
            HTML('<p style="font-size:20px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;Aplikacja Czas Dojazdu umożliwia wyszukanie pokoi do wynajęcia, których czas dojazdu nie przekracza danych parametrów od wybranego miejsca. Informacje o pokojach pobierane są z popularnych portali z ogłoszeniami.</p>'),
           
            HTML('<img src="/lokalizacja.jpg" alt="Opis" width="140" height="80" align = "right" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp; 1) Podaj lokalizację w Warszawie, do której chciałbyś dojechać.</p>'),
            
            HTML('<img src="/transport.jpg" alt="Opis" width="140" height="100" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp; 2) Wybierz środek transportu.  Umożliwiamy 3 opcję: samochód,  rower oraz pieszo.</p>'),
            
            HTML('<img src="/czas.jpg" alt="Opis" width="140" height="60" align = "right" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp; 3) Określ maksymalny czas dojazdu (w minutach).</p>'),
            
            HTML('<img src="/cena.jpg" alt="Opis" width="140" height="60" align = "right" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp; 4) Podaj zakres cenowy .</p>'),
            
            HTML('<img src="/data.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp; 5) Sprecyzuj datę ogłoszeń. (Sugerujemy ostatnie 2-3 dni, ze względu na aktualność)</p>'),
            
            HTML('<img src="/pokaz.jpg" alt="Opis" width="100" height="50" align = "right" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;  6) Następnie kliknij w poniższy przycisk :) </p>'),
            
            HTML('<img src="/mapa.jpg" alt="Opis" width="200" height="100" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;  7) Dostaniesz następujący wynik: Zielony marker oznacza wskazaną przez Ciebie lokalizację. Niebieski – oferty spełniające Twoje oczekiwania. </p>'),
            
            HTML('<img src="/dokladnie.jpg" alt="Opis" width="140" height="80" align = "right" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;  8) Po kliknięciu na marker otrzymasz szczegółowe informacje odnośnie oferty:  adres (wraz z linkiem  do ogłoszenia), cenę oraz wielkość.  </p>'),
            
            
            HTML('<p style="font-size:20px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;Jeżeli uważasz, że aplikację można poprawić, albo masz jakiekolwiek pytania bądź sugestie, proszę zostaw wiadomość w poniższym panelu.</p>'),
            style = 'max-width:1000px;width:98%;margin:auto;'),
            
        div(id="disqus_thread",
            HTML("<script>
                   (function() {  // DON'T EDIT BELOW THIS LINE
                       var d = document, s = d.createElement('script');
                       
                       s.src = '//mi2-czasojazdu.disqus.com/embed.js';
                       
                       s.setAttribute('data-timestamp', +new Date());
                       (d.head || d.body).appendChild(s);
                   })();
               </script>
               <noscript>Please enable JavaScript to view the <a href='https://disqus.com/?ref_noscript' rel='nofollow'>comments powered by Disqus.</a></noscript>")
         )
      ),
      tabItem(
        "dane",
        DT::dataTableOutput('content')#,
        # div(id="disqus_thread",
        #     HTML("<script>
        #            (function() {  // DON'T EDIT BELOW THIS LINE
        #                var d = document, s = d.createElement('script');
        #                
        #                s.src = '//mi2-czasojazdu.disqus.com/embed.js';
        #                
        #                s.setAttribute('data-timestamp', +new Date());
        #                (d.head || d.body).appendChild(s);
        #            })();
        #        </script>
        #        <noscript>Please enable JavaScript to view the <a href='https://disqus.com/?ref_noscript' rel='nofollow'>comments powered by Disqus.</a></noscript>")
        #  )
      )
      

    ),
    div(HTML('<script id="dsq-count-scr" src="//mi2-czasdojazdu.disqus.com/count.js" async></script>'))
  )