Fantasy on rails is a Ruby on Rails web application made to improve your Fantasy football experience.

Fantasy on rails imports your NFL.com, yahoo, or ESPN league and gives you guidance on trades, waiver wire pickups and lineup choices.

As NFL.com does not give out API access to filthy casuals like me, I resort to scraping for the information I need.
The application uses Nokogiri to scrape three main sources for its information.

NFL.com, ESPN or Yahoo leagues
     - Team information, Lineups and free agents are scraped from one of the above three sources (user choice)
     - This is used to create an overview of the league with all teams and players
     
FantsyPros trade value chart/CBS dave richard trade value
     - Trade values associated with the top valued players in the league is scraped from either of the two sources
     - This is used to determine the fairness of trades between teams, as well as free agency pickups
     
Boris Chen's weekly tiers
     - Optimal lineups are determined using Boris Chen's weekly tiers (compilation of the top 10 fantasy experts from the past season split into tiers with a clustering algorithm
