dbBody <- function(lang) {
  shinydashboard::dashboardBody(
    tags$head(
      tags$script(
        "(function(i,s,o,g,r,a,m){
        i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();
        a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;
        m.parentNode.insertBefore(a,m)})
        (window,document,'script',
        'https://www.google-analytics.com/analytics.js','ga');
        ga('create', 'UA-76544868-1', 'auto');
        ga('send', 'pageview');"
      )
    ), 
    tags$head(tags$script(src = "dzielnice.js")),
    shinydashboard::tabItems(
      shinydashboard::tabItem(
        "pokoje",
        div(
          tags$p(
            lang$body$rooms$`1`,
            lang$sidebar$button,
            lang$body$rooms$`2`,
            shiny::htmlOutput("dane_debug", TRUE),
            lang$body$rooms$`3`
          )
        ),
        leaflet::leafletOutput("mymap", height = 800)
      ),
      shinydashboard::tabItem(
        "analizy",
        div(
          tags$p(lang$body$analysis)
        ),
        includeHTML("../Rscripts/mapa/mapa.html")
      ),
      shinydashboard::tabItem(
        "mieszkania",
        div(
          tags$p(
            style = "font-size:18px; font-family:Verdana", align = "justify",
            lang$body$apartments$`1`,
            tags$a(
              href = "https://github.com/mi2-warsaw/CzasDojazdu/tree/master/Rscripts/collect_data",
              target = "_blank",
              style = "margin-right:-4px;",
              lang$body$apartments$`2`
            ),
            lang$body$apartments$`3`
          )
        )
      ),
      shinydashboard::tabItem(
        "cel",
        div(
          style = "max-width:1000px; width:98%; margin:auto;",
          tags$p(
            style = "font-size:32px; font-family:Verdana;", align = "justify",
            tags$h2(lang$body$about$header)
          ),
          tags$p(
            style = "font-size:16px; font-family:Verdana;", align = "justify",
            lang$body$about$paragraph
          ),
          tags$img(
            src = "lokalizacja.jpg", alt = "Opis", width = "140", height = "60",
            align = "left"
          ),
          tags$p(
            style = "font-size:15px; font-family:Verdana;", align = "justify",
            lang$body$about$`1`
          ),
          tags$br(),
          tags$br(),
          tags$img(
            src = "transport.jpg", alt = "Opis", width = "140", height = "60",
            align = "left"
          ),
          tags$p(
            style = "font-size:15px; font-family:Verdana;", align = "justify",
            lang$body$about$`2`
          ),
          tags$br(),
          tags$br(),
          tags$img(
            src = "czas.jpg", alt = "Opis", width = "140", height = "60",
            align = "left"
          ),
          tags$p(
            style = "font-size:15px; font-family:Verdana;", align = "justify",
            lang$body$about$`3`
          ),
          tags$br(),
          tags$br(),
          tags$img(
            src = "cena.jpg", alt = "Opis", width = "140", height = "60",
            align = "left"
          ),
          tags$p(
            style = "font-size:15px; font-family:Verdana;", align = "justify",
            lang$body$about$`4`
          ),
          tags$br(),
          tags$br(),
          tags$img(
            src = "data.jpg", alt = "Opis", width = "140", height = "60",
            align = "left"
          ),
          tags$p(
            style = "font-size:15px; font-family:Verdana;", align = "justify",
            lang$body$about$`5`
          ),
          tags$br(),
          tags$br(),
          tags$img(
            src = "pokaz.jpg", alt = "Opis", width = "140", height = "60",
            align = "left"
          ),
          tags$p(
            style = "font-size:15px; font-family:Verdana;", align = "justify",
            lang$body$about$`6`
          ),
          tags$br(),
          tags$br(),
          tags$img(
            src = "mapa.jpg", alt = "Opis", width = "140", height = "60",
            align = "left"
          ),
          tags$p(
            style = "font-size:15px; font-family:Verdana;", align = "justify",
            lang$body$about$`7`
          ),
          tags$br(),
          tags$img(
            src = "dokladnie.jpg", alt = "Opis", width = "140", height = "60",
            align = "left"
          ),
          tags$p(
            style = "font-size:15px; font-family:Verdana;", align = "justify",
            lang$body$about$`8`
          ),
          tags$br(),
          tags$br(),
          tags$p(
            style = "font-size:20px; font-family:Verdana;", align = "justify",
            lang$body$about$suggestions
          ),
          div(
            id = "disqus_thread",
            HTML(
              "<script>
              (function() {  // DON'T EDIT BELOW THIS LINE
              var d = document, s = d.createElement('script');
              s.src = '//mi2-czasojazdu.disqus.com/embed.js';
              s.setAttribute('data-timestamp', +new Date());
              (d.head || d.body).appendChild(s);
              })();
              </script>
              <noscript>Please enable JavaScript to view the
              <a href='https://disqus.com/?ref_noscript' rel='nofollow'>
              comments powered by Disqus.</a>
              </noscript>"
            )
          )
        )
      ), 
      shinydashboard::tabItem(
        "dane",
        div(
          tags$p(
            style = "margin-left:4px; margin-right:-4px;",
            lang$body$table$`1`,
            lang$sidebar$button,
            HTML("'."),
            tags$a(
              href = "http://mi2.mini.pw.edu.pl:3838/CzasDojazdu/dane/",
              target = "_blank",
              lang$body$table$`2`
            )
          )
        ),
        DT::dataTableOutput("content")
      ),
      shinydashboard::tabItem(
        "ludzie",
        shinydashboard::box(
          width = 4,
          div(
            HTML("<center>"),
            tags$img(
              src = "michal.jpg", align = "center", width = "150",
              height = "150"
            ),
            tags$p(
              style = "font-size:15px; font-family:Verdana;",
              align = "justify",
              tags$h4("Michał Cisek"),
              tags$h5("Web Harvesting & Data Management")
            ),
            tags$a(
              href = "https://github.com/michalcisek",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-git")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "https://www.linkedin.com/in/michał-cisek-654381113",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-linkedin")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "http://stackoverflow.com/users/4708159/micha%C5%82",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-stack-overflow")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "mailto:mcisek93@gmail.com",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-envelope-o")
            ),
            HTML("&nbsp;&nbsp;"),
            HTML("</center>")
          )
        ),
        shinydashboard::box(
          width = 4,
          div(
            HTML("<center>"),
            tags$img(
              src = "aleksandra.jpg", align = "center", width = "150",
              height = "150"
            ),
            tags$p(
              style = "font-size:15px; font-family:Verdana;", align = "justify",
              tags$h4("Aleksandra Brodecka"),
              tags$h5("Shiny Application Frontend & User Experience")
            ),
            tags$a(
              href = "https://github.com/abrodecka",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-git")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "https://www.linkedin.com/in/aleksandra-brodecka-92831511a",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-linkedin")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "mailto:aleksandrabrodecka@gmail.com",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-envelope-o")
            ),
            HTML("&nbsp;&nbsp;"),
            HTML("</center>")
          )
        ),
        shinydashboard::box(
          width = 4,
          div(
            HTML("<center>"),
            tags$img(
              src = "tomasz.png", align = "center", width = "150",
              height = "150"
            ),
            tags$p(
              style = "font-size:15px; font-family:Verdana;", align = "justify",
              tags$h4("Tomasz Mikołajczyk"),
              tags$h5("Data Analysis & Visualizations")
            ),
            tags$a(
              href = "https://github.com/mikolajjj",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-git")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "http://stackoverflow.com/users/5341370/mikolajjj",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-stack-overflow")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "https://twitter.com/to_mikolaj",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-twitter")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "mailto:t.mikolajczyk@gmail.com",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-envelope-o")
            ),
            HTML("&nbsp;&nbsp;"),
            HTML("</center>")
          )
        ),
        shinydashboard::box(
          width = 4,
          div(
            HTML("<center>"),
            tags$img(
              src = "marcin.jpg", align = "center", width = "150",
              height = "150"
            ),
            tags$p(
              style = "font-size:15px; font-family:Verdana;", align = "justify",
              tags$h4("Marcin Kosiński"),
              tags$h5("Critical Elements Sewing & Mail Forwarding & Dockerization")
            ),
            tags$a(
              href = "https://github.com/MarcinKosinski",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-git")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "https://www.linkedin.com/in/marcin-kosi%C5%84ski-81435aab",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-linkedin")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "http://stackoverflow.com/users/3857701/marcin-kosi%C5%84ski",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-stack-overflow")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "http://r-addict.com",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-comments")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "mailto:m.p.kosinski@gmail.com",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-envelope-o")
            ),
            HTML("&nbsp;&nbsp;"),
            HTML("</center>")
          )
        ),
        shinydashboard::box(
          width = 4,
          div(
            HTML("<center>"),
            tags$img(
              src = "witek.jpeg", align = "center", width = "150",
              height = "150"
            ),
            tags$p(
              style = "font-size:15px; font-family:Verdana;",
              align = "justify",
              tags$h4("Witold Chodor"),
              tags$h5("Translations & Marketing")
            ),
            tags$a(
              href = "https://github.com/wchodor",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-git")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "https://www.linkedin.com/in/witold-chodor-691a94115",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-linkedin")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "mailto:witoldchodor@gmail.com",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-envelope-o")
            ),
            HTML("&nbsp;&nbsp;"),
            HTML("</center>")
          )
        ),
        shinydashboard::box(
          width = 4,
          div(
            HTML("<center>"),
            tags$img(
              src = "krzysztof.png", align = "center", width = "150",
              height = "150"
            ),
            tags$p(
              style = "font-size:15px; font-family:Verdana;",
              align = "justify",
              tags$h4("Krzysztof Słomczyński"),
              tags$h5("Maintaining & Testing & Code Review & Refactoring")
            ),
            tags$a(
              href = "https://github.com/krzyslom",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-git")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "https://www.linkedin.com/in/krzysztof-słomczyński-20a364134",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-linkedin")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "http://stackoverflow.com/users/6295945/krzyslom",
              target = "_blank",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-stack-overflow")
            ),
            HTML("&nbsp;&nbsp;"),
            tags$a(
              href = "mailto:krzysztofslomczynski@gmail.com",
              style = "font-size:2.0em;",
              tags$i(class = "fa fa-envelope-o")
            ),
            HTML("&nbsp;&nbsp;"),
            HTML("</center>")
          )
        )
      )
    ),
    div(
      tags$script(
        id = "dsq-count-scr", src = "//mi2-czasdojazdu.disqus.com/count.js",
        async = "async"
      )
    )
  )
}