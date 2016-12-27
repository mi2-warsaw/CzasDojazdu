lang <- list(
  body = list(
    rooms = list(
      `1` = "With every clik of '",
      `2` = "' button, we have the following number of offers: ",
      `3` = " from the chosen location. This aplication is making use of google
            maps Api which enables to check only 2500 distances free of charge
            per day. The chances are that the aplication is working for 20
            persons per day. We are working on increasing the potential of this
            aplication. When you notice such a message: no such index at level 1
            - it means that you have run out of the daily limit for the beta
            version of this aplication."
    ),
    analysis = "If the map doesn't show up, you should try to clik twice on the
               upper browser bar in order to center the map.",
    apartments = list(
      `1` = "Seraching for apartments option is currently unavailable but we are
            willing to add it in the nearest future. If you want to join our
            team by preparing scripts, making this data available based on",
      `2` = "our source codes",
      `3` = ", then contact us immediately!"
    ),
    about = list(
      header = "About Commuting Time project",
      paragraph = "Commuting Time aplication enables to search for rooms to let,
                  which commuting time from the chosen location doesn't exceed
                  the given parameters. The information about rooms are
                  downloaded from the well-known web portals with
                  announcements.",
      `1` = "1) Select a location which you want to get to.",
      `2` = "2) Choose a mode of transportation out of these three options: by car, on bike or on foot.",
      `3` = "3) Determine a maximum commuting time (in minutes).",
      `4` = "4) Select a price range.",
      `5` = "5) Specify the date of the announcements (we suggest the last 2-3
            days to keep up to date).",
      `6` = "6) Then clik on the button below. :)",
      `7` = "7) After choosing the Rooms/Apartments panel, you will get the
            following result: the green marker shows the chosen location, the
            blue one shows offers that measure up to your expectations.",
      `8` = "8) After clicking on the marker, you wil get detailed information
            about the offer: the link to the announcement, the address, the
            price and the size of the Room/Apartment.",
      suggestions = "If you think that the aplication needs some corrections or
                    you have any questions or suggestions, please leave a
                    message on the panel below."
    ),
    table = list(
      `1` = "The table shows the data which fulfil the requirements specified on
            the sidebar panel after clicking '",
      `2` = "The complete data are available here."
    )
  ),
  header = list(
    title = "Commuting Time",
    offers = "offers",
    project = list(
      from = "Project",
      message = "Click to proceed"
    ),
    data = list(
      from = "Data",
      message = "Valid untill"
    ),
    profile = "Click to proceed on a profile",
    team = list(
      from = "GitHub team",
      message = "Click to proceed"
    )
  ),
  sidebar = list(
    language = "Choose language:",
    about = list(
      item = "About the project",
      subitem = list(
        goal = "Goal",
        authors = "Co-authors",
        data = "Data"
      )
    ),
    rooms = "Rooms to let",
    apartments = "Apartments to let",
    analysis = "Analysis",
    location = "Location: ",
    commuting = "Maximum commuting time: ",
    transport = list(
      label = "Mode of transportation: ",
      driving = "Car",
      bicycling = "Bike",
      walking = "On foot"
    ),
    price = "Price range: ",
    date = "Offers on the following days",
    lang = "en",
    separator = " to ",
    button = "Show locations",
    content_lok = "Your location"
  )
)

lang %>% jsonlite::toJSON(pretty = TRUE) %>% cat(file = "app/lang/en.json")