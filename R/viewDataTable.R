viewDataTable <- function(dat){
           DT::datatable(data = dat, width = "auto",
                         rownames = FALSE, escape = FALSE, selection = "single",
                         extensions = c('Buttons'),
                         options = list(
                           pageLength = 5,
                           dom = 'tip',
                           # dom = 'Bfrtip',
                           # buttons = list('pageLength'),
                           searchHighlight = TRUE,
                           initComplete = JS("function(settings, json) {",
                                             "$(this.api().table().header()).css({'background-color': '#2e4477', 'color': '#fff'});",
                                             "}"),
                           scrollX = TRUE,
                           scrollY = TRUE
                         ),
                         class = 'nowrap display')
}