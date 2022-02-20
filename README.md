
## star.rank
# The Rancor That Won't Bite

### Description:
An R based API wrapper that ranks Star Wars data and displays results graphically.  Connects with the SWAPI Star Wars API and returns graphical ranking for features of interest related to people, planets, starships, vehicles, species and films. Please see [Vignette](https://github.com/The0therChad/star.rank/blob/main/vignettes/Vignette.Rmd) for more detailed information.

### Installation


### Dependencies
  - [attempt](https://cran.r-project.org/web/packages/attempt/index.html)
  - [curl](https://cran.r-project.org/web/packages/curl/index.html)
  - [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
  - [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html)
  - [httr](https://cran.r-project.org/web/packages/httr/index.html)
  - [jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html)
  - [magrittr](https://cran.r-project.org/web/packages/magrittr/index.html)

### License
Distributed under MIT license. See [license.md](https://github.com/The0therChad/star.rank/blob/main/LICENSE.md) for more information.

### Contributors
- Energix11
- obsprof
- TheOtherChad



#### Available Metrics to Rank (units)
#### People/Characters
- height (centimeters)
- mass (kilograms)
- films (count)

#### Planets 
- diameter (kilometers)
- rotation_period (standard hours)
- orbital_period (standard days)
- population (count)
- films (count) 

#### Starships
- cost_in_credits (galactic credits)
- length (meters)
- crew (count personnel needed to operate Starship)
- passengers (count)
- max_atmosphering_speed (max speed in the atmosphere)
- cargo_capacity (kilograms)
- films (count)

#### Vehicles
- cost (galactic credits)
- length (meters)
- crew (count personnel needed to operate Starship)
- passengers (count)
- speed (max speed in the atmosphere)
- cargo capacity (kilograms)
- popularity (count)

#### Species
- average_height (centimeters)
- average_lifespan (standard years)
- films (count)

#### Films
- characters (count)
- planets (count)
- starships (count)
- vehiicles(count)
- species diversity(count)




