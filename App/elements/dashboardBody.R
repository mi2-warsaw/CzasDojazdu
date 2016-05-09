dashboardBody <- dashboardBody(
    tags$head(tags$script(
      "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
      ga('create', 'UA-76544868-1', 'auto');
      ga('send', 'pageview');")
    ),
    # includeCSS('monokai.css'),
    # includeCSS('skel.css'),
    # includeCSS('style.css'),
    tabItems(
      tabItem(
        "pokoje",
        leafletOutput("mymap" , height = 800)
      ),
      tabItem(
        "mieszkania",
        div(
          HTML('<p style="font-size:18px; font-family:Verdana;"align="justify">Obecnie opcja wyszukiwania mieszkań nie jest dostępna, ale bardzo chętnie pomożemy ją dodać. Jeżeli chcesz dołączyć do autorów, przygotowując skrypty udostępniające te dane w oparciu <a href="https://github.com/mi2-warsaw/CzasDojazdu/tree/master/Rscripts/collect_data">o nasze kody</a>, daj znać!</p>')
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
            HTML('<p style="font-size:16px; font-family:Verdana;"align="justify">Aplikacja Czas Dojazdu umożliwia wyszukanie pokoi do wynajęcia, których czas dojazdu nie przekracza danych parametrów od wybranego miejsca. Informacje o pokojach pobierane są z popularnych portali z ogłoszeniami.</p>'),
           
            HTML('<img src="lokalizacja.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 1) Podaj lokalizację w Warszawie, do której chciałbyś dojechać.</p><br><br>'),
            
            HTML('<img src="transport.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 2) Wybierz środek transportu.  Umożliwiamy 3 opcje: samochód,  rower oraz pieszo.</p><br><br>'),
            
            HTML('<img src="czas.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 3) Określ maksymalny czas dojazdu (w minutach).</p><br><br>'),
            
            HTML('<img src="cena.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 4) Podaj zakres cenowy.</p><br><br>'),
            
            HTML('<img src="data.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 5) Sprecyzuj datę ogłoszeń. (Sugerujemy ostatnie 2-3 dni, ze względu na aktualność)</p><br><br>'),
            
            HTML('<img src="pokaz.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">  6) Następnie kliknij w poniższy przycisk :) </p><br><br>'),
            
            HTML('<img src="mapa.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">  7) Po przejściu do panelu Pokoje/Mieszkania, dostaniesz następujący wynik: zielony marker oznacza wskazaną przez Ciebie lokalizację, niebieski to oferty spełniające Twoje oczekiwania. </p><br>'),
            
            HTML('<img src="dokladnie.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">  8) Po kliknięciu na marker otrzymasz szczegółowe informacje odnośnie oferty: adres, link do ogłoszenia, cenę oraz wielkość.  </p><br><br>'),
            
            
            HTML('<p style="font-size:20px; font-family:Verdana;"align="justify">Jeżeli uważasz, że aplikację można poprawić, albo masz jakiekolwiek pytania bądź sugestie, proszę zostaw wiadomość w poniższym panelu.</p>'),
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
      ),
      tabItem(
        "ludzie",
                 box(
        div(HTML('
                <center>
                <img src="michal.jpg" align="center" width="150" height="150">
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h4>Michał Cisek</h4></p>
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h5>Web Harvesting & Data Management</h5></p>

                <a href="https://github.com/michalcisek" style="font-size:2.0em;">
                  <i class="fa fa-git"></i>
                </a>&nbsp;&nbsp;
                <a href="https://www.linkedin.com/in/michał-cisek-654381113" style="font-size:2.0em;">
                  <i class="fa fa-linkedin"></i>
                </a>&nbsp;&nbsp;
                <a href="http://stackoverflow.com/users/4708159/micha%C5%82" style="font-size:2.0em;">
                  <i class="fa fa-stack-overflow"></i>
                </a>&nbsp;&nbsp;
                <a href="mailto:mcisek93@gmail.com " style="font-size:2.0em;">
                  <i class="fa fa-envelope-o"></i>
                </a>
              </center>
            '))
        ),
         box(
        div(HTML('
                <center>
                <img src="aleksandra.jpg" align="center" width="150" height="150">
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h4>Aleksandra Brodecka</h4></p>
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h5>Shiny Application Frontend & User Experience</h5></p>

                <a href="https://github.com/abrodecka" style="font-size:2.0em;">
                  <i class="fa fa-git"></i>
                </a>&nbsp;&nbsp;
                <a href="https://www.linkedin.com/in/aleksandra-brodecka-92831511a" style="font-size:2.0em;">
                  <i class="fa fa-linkedin"></i>
                </a>&nbsp;&nbsp;
                <a href="mailto:aleksandrabrodecka@gmail.com" style="font-size:2.0em;">
                  <i class="fa fa-envelope-o"></i>
                </a>
              </center>
            '))
        ),
        box(
        div(HTML('
                <center>
                <img src="tomasz.png" align="center" width="150" height="150">
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h4>Tomasz Mikołajczyk</h4></p>
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h5>Data Analysis & Visualizations</h5></p>

                <a href="https://github.com/mikolajjj" style="font-size:2.0em;">
                  <i class="fa fa-git"></i>
                </a>&nbsp;&nbsp;
                <a href="http://stackoverflow.com/users/5341370/mikolajjj" style="font-size:2.0em;">
                  <i class="fa fa-stack-overflow"></i>
                </a>&nbsp;&nbsp;
                <a href="https://twitter.com/to_mikolaj" style="font-size:2.0em;">
                  <i class="fa fa-twitter"></i>
                </a>&nbsp;&nbsp;
                <a href="mailto:t.mikolajczyk@gmail.com" style="font-size:2.0em;">
                  <i class="fa fa-envelope-o"></i>
                </a>
              </center>
            '))
        ),
        box(
        div(HTML('
                <center>
                <img src="marcin.jpg" align="center" width="150" height="150">
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h4>Marcin Kosiński</h4></p>
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h5>e-mails writing & forwarding</h5></p>
                <a href="https://github.com/MarcinKosinski" style="font-size:2.0em;">
                  <i class="fa fa-git"></i>
                </a>&nbsp;&nbsp;
                <a href="https://www.linkedin.com/in/marcin-kosi%C5%84ski-81435aab" style="font-size:2.0em;">
                  <i class="fa fa-linkedin"></i>
                </a>&nbsp;&nbsp;
                <a href="http://stackoverflow.com/users/3857701/marcin-kosi%C5%84ski" style="font-size:2.0em;">
                  <i class="fa fa-stack-overflow"></i>
                </a>&nbsp;&nbsp;
                <a href="http://r-addict.com" style="font-size:2.0em;">
                  <i class="fa fa-comments"></i>
                </a>&nbsp;&nbsp;
                <a href="mailto:m.p.kosinski@gmail.com" style="font-size:2.0em;">
                  <i class="fa fa-envelope-o"></i>
                </a>
              </center>
            '))
        )
      )
      

    ),
    div(HTML('<script id="dsq-count-scr" src="//mi2-czasdojazdu.disqus.com/count.js" async></script>'))
  )
