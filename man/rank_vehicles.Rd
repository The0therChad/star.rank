% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rank_vehicles.R
\name{rank_vehicles}
\alias{rank_vehicles}
\title{Rank Vehicles by specified metric}
\usage{
rank_vehicles(interested = NULL, n = 15)
}
\arguments{
\item{interested}{Metric to rank vehicles on. ("cost_in_credits", "length", "max_atmosphering_speed", "crew", "passengers", "cargo_capacity", "films")}

\item{n}{number of results to plot. (default = 15)}
}
\value{
A plot with vehicle name on the y-axis and the ranking metric on  the x-axis.
}
\description{
Returns a plot showing the top "n" number of Star Wars vehicles
sorted by a specified metric with vehicle name on the y-axis,
and the ranking metric on the x-axis.
}
\examples{
\dontrun{rank_vehicles(interested = "length"),
rank_vehicles(interested = "passengers")}
}
