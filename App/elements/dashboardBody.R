dashboardBody <- dashboardBody(
      tags$head(tags$script("(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-76544868-1', 'auto');
  ga('send', 'pageview');")),
    tabItems(
      tabItem(
        "pokoje",
        leafletOutput("mymap" , height = 800)
      ),
      tabItem(
        "mieszkania",
        div(
          HTML('<p style="font-size:18px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;Obecnie opcja wyszukiwania mieszkań nie jest dostępna, ale bardzo chętnie pomożemy ją dodać. Jeżeli chcesz dołączyć do autorów, przygotowując skrypty udostępniające te dane w oparciu <a href="https://github.com/mi2-warsaw/CzasDojazdu/tree/master/Rscripts/collect_data">o nasze kody</a>, daj znać!</p>')
        ),
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
        "cel",
        div(
            HTML('<p style="font-size:32px; font-family:Verdana;"align="justify"><h2> O projekcie Czas Dojazdu</h2></p>'),
            HTML('<p style="font-size:20px; font-family:Verdana;"align="justify">&nbsp;&nbsp;&nbsp;&nbsp;Aplikacja Czas Dojazdu umożliwia wyszukanie pokoi do wynajęcia, których czas dojazdu nie przekracza danych parametrów od wybranego miejsca. Informacje o pokojach pobierane są z popularnych portali z ogłoszeniami.</p>'),
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
        DT::dataTableOutput('content'),
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
      )
      

    ),
    div(HTML('<script id="dsq-count-scr" src="//mi2-czasdojazdu.disqus.com/count.js" async></script>'))
  )