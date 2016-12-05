dashboardBody <- dashboardBody(
    tags$head(tags$script(
      "(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
      ga('create', 'UA-76544868-1', 'auto');
      ga('send', 'pageview');")
    ),
    tags$head(tags$script(src="dzielnice.js")),
    # includeCSS('monokai.css'),
    # includeCSS('skel.css'),
    # includeCSS('style.css'),
    tabItems(
      tabItem(
        "pokoje",
        div(HTML('<p> With every clik of \'Show location\' button, we have the following number of offers </p>')),
        verbatimTextOutput("dane_debug"),
        div(HTML('<p> from the chosen location. This aplication is making use of google maps Api which enables to check only 2500 distances free of charge per day. 
The chances are that the aplication is working for 20 persons per day. We are working on increasing the potential of this aplication.
When you notice such a message: no such index at level 1 - it means that you have run out of the daily limit for the beta version of this aplication.</p>')),
        leafletOutput("mymap" , height = 800)
      ),
      tabItem(
        "analizy",
        # Ten komunikat nie jest dla mnie czytelny!
        div(HTML('<p> If the map doesn\'t show up, you should try to clik twice on the upper browser bar in order to center the map.</p>')),
        includeHTML("../Rscripts/mapa/mapa_en.html")
      ),
      tabItem(
        "mieszkania",
        div(
          HTML('<p style="font-size:18px; font-family:Verdana;"align="justify"> Seraching for apartments option is currently
unavailable but we are willing to add it in the nearest future. If you want to join our team by preparing scripts, 
making this data available based on <a href="https://github.com/mi2-warsaw/CzasDojazdu/tree/master/Rscripts/collect_data"> our source codes</a>, then contact us immediately!</p>')
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
            HTML('<p style="font-size:32px; font-family:Verdana;"align="justify"><h2> About a project Commuting Time </h2></p>'),
            HTML('<p style="font-size:16px; font-family:Verdana;"align="justify"> Commuting time aplication enables to search for rooms to let,
which commuting time from the chosen location doesn\'t exceed the given parameters. The information about rooms are downloaded from the well-known web portals with announcements.</p>'),

            HTML('<img src="lokalizacja.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 1) Give a location which you want to get to.</p><br><br>'),
            
            HTML('<img src="transport.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 2) Choose a mode of transportation out of these three options: a car, a bike or on foot.</p><br><br>'),
            
            HTML('<img src="czas.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 3) Determine a maximum commuting time (in minutes).</p><br><br>'),
            
            HTML('<img src="cena.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 4) Give a price range.</p><br><br>'),
            
            HTML('<img src="data.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify"> 5) Specify the date of the announcements. (We suggest the last 2-3 days to keep up to date)</p><br><br>'),
            
            HTML('<img src="pokaz.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">  6) Then clik on the button below :) </p><br><br>'),
            
            HTML('<img src="mapa.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">  7) After choosing the Rooms/Apartments panel, you will get the following result: the green marker shows the chosen location, the blue one shows offers that measure up to your expectations. </p><br>'),
            
            HTML('<img src="dokladnie.jpg" alt="Opis" width="140" height="60" align = "left" >'),
            HTML('<p style="font-size:15px; font-family:Verdana;"align="justify">  8) After clicking on the marker, you wil get detailed information about the offer: the link to the announcement, the address, the price and the size of the Room/Apartment. </p><br><br>'),
            
            
            HTML('<p style="font-size:20px; font-family:Verdana;"align="justify"> If you think that the aplication needs some corrections or you have any questions or suggestions, please leave a message on the panel below.</p>'),
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
        div(HTML('<p> The table shows the data which fulfil the requirements specified on the sidebar panel after clicking \'Show location\'. <a href="http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/dane/"> The complete data are available here. </a></p>')),
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
                 box(width=4,
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
         box(width=4,
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
        box(width=4,
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
        box(width=4,
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
        ),
        box(width=4,
        div(HTML('
                <center>
                <img src="witek.jpeg" align="center" width="150" height="150">
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h4>Witold Chodor</h4></p>
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h5>Translations & Marketing</h5></p>
                <a href="https://github.com/wchodor" style="font-size:2.0em;">
                  <i class="fa fa-git"></i>
                </a>&nbsp;&nbsp;
                <a href="https://www.linkedin.com/in/witold-chodor-691a94115" style="font-size:2.0em;">
                  <i class="fa fa-linkedin"></i>
                </a>&nbsp;&nbsp;
                <a href="mailto:witoldchodor@gmail.com" style="font-size:2.0em;">
                  <i class="fa fa-envelope-o"></i>
                </a>
              </center>
            '))
        ),
        box(width=4,
        div(HTML('
                <center>
                <img src="krzysztof.png" align="center" width="120" height="150">
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h4>Krzysztof Słomczyński</h4></p>
                <p style="font-size:15px; font-family:Verdana;"align="justify"><h5>Maintaining & Testing & Refactoring</h5></p>
                <a href="https://github.com/krzyslom" style="font-size:2.0em;">
                  <i class="fa fa-git"></i>
                </a>&nbsp;&nbsp;
                <a href="https://www.linkedin.com/in/krzysztof-słomczyński-20a364134" style="font-size:2.0em;">
                  <i class="fa fa-linkedin"></i>
                </a>&nbsp;&nbsp;
                <a href="http://stackoverflow.com/users/6295945/krzyslom" style="font-size:2.0em;">
                  <i class="fa fa-stack-overflow"></i>
                </a>&nbsp;&nbsp;
                <a href="mailto:krzysztofslomczynski@gmail.com" style="font-size:2.0em;">
                  <i class="fa fa-envelope-o"></i>
                </a>
              </center>
            '))
        )
      )
      

    ),
    div(HTML('<script id="dsq-count-scr" src="//mi2-czasdojazdu.disqus.com/count.js" async></script>'))
  )
