#ext_chartevents
# ext_chartevents <- function(itemids){
#   chartevnetslist <- list()
#   for (i in 1:17) {
#     chartevnetslist[[i]] <- dplyr::tbl(conn, dbplyr::in_schema("mimic3", paste0("chartevents_",i))) %>%
#       filter(itemid %in% itemids)
#     if (i == 1) {
#       filteredchart <- chartevnetslist[[i]]
#     } else {
#       filteredchart <- union(filteredchart, chartevnetslist[[i]])
#     }
#   }
#   return(filteredchart)
# } 

