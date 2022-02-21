
## star.rank
# The Rancor That Won't Bite

### Description:
An R based API wrapper that ranks Star Wars data and displays results graphically.  Connects with the SWAPI Star Wars API and returns graphical ranking for features of interest related to people, planets, starships, vehicles, species and films. Please see [Vignette](https://github.com/The0therChad/star.rank/blob/main/vignettes/Vignette.Rmd) for examples and more detailed information.

### Installation
To access the development version 
```
library(devtools)
install_github("The0therChad/star.wrap")
```
[Link to the latest release zip file](https://github.com/The0therChad/star.rank/releases/tag/v0.1.0)

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
- The0therChad

### Continuous Integration Badge
The SWAPI website is unavailable at the time of release.<br>
Please see Actions -> Workflow -> R-CDM-check for a complete CI log demonstrating passing integration milestones.<br>
[![R-CMD-check](https://github.com/The0therChad/star.rank/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/The0therChad/star.rank/actions/workflows/check-standard.yaml)

#### *Available Metrics (units)*
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




