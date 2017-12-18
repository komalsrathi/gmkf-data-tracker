source('R/viewDataTable.R')

# read google sheet
x <- gs_ls()
sheet <- gs_title("DataTracketSheet_Test")
dat <- gs_read(ss = sheet, ws = 1)
dat <- as.data.frame(dat)
for(i in 6:ncol(dat)){
  dat[,i] <- paste0(dat[,i],"; ",format(dat[,i]/dat$`Anticipated Number`*100, digits = 2),"%")
}
summary <- dat[nrow(dat),]

shinyServer(function(input, output, session){
  
  output$messageMenu <- renderMenu({
    dropdownMenu(type = "notifications", headerText = "For any questions, click below:", badgeStatus = "danger", notificationItem(icon = icon("send-o"), text = "Contact Us", status = "warning", href = "mailto:ramanp@email.chop.edu"))
  })
  
  output$table <- DT::renderDataTable({
    viewDataTable(dat = dat[,c(2,3,4,5,1)])
  })
  
  
  output$indplot <- renderGrViz({
    if(!is.null(input$table_rows_selected)){
    
      # create this for the flowchart
      s <- input$table_rows_selected
      chrs <- as.character(dat[s,])
      P1 <- paste0('\"Sample Submitted \nby X01 PI: [',as.character(chrs[6]),']\"')
      P2 <- paste0('\"Sample Sequenced \nby \nSequencing Center: [',as.character(chrs[7]),']\"')
      P3 <- paste0('\"Genomic Data transferred \nto DRC: [',as.character(chrs[8]),']\"')
      A1 <- paste0('\"Minimal Annotation Acquired \nfrom X01 PI: [',as.character(chrs[9]),']\"')
      P4 <- paste0('\"Sample Available \non Cavatica: [',as.character(chrs[10]),']\"')
      P5 <- paste0('\"Genomic Data \nProcessed through \nKF Pipelines: [',as.character(chrs[11]),']\"')
      A2 <- paste0('\"QC check by DRC: [',as.character(chrs[12]),']\"')
      AP <- paste0('\"Harmonized Sample Data \nAvailable through \nKF Portal: [',as.character(chrs[13]),']\"')
      A3 <- paste0('\"Annotation Harmonized \nby DRC: [',as.character(chrs[13]),']\"')
      
      txt <- paste0('digraph GMKF_datatracker {\n', 
                    'node [shape = box,
                    fontname = Helvetica,
                    fontcolor = white,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = lightblue,
                    label =', A1,',\n',
                    'tooltip = ','"','The X01 PI has provided some annotation on the samples which have genomic data','"',',','
                    color = lightblue]\n','A1\n',
                    
                    'node [shape = box,
                    fontname = Helvetica,
                    width = 3, 
                    penwidth = 2,
                    style = filled,
                    fillcolor = lightblue,
                    label =', P1,',\n',
                    'tooltip = ','"','Sample has been submitted to the sequencing center','"',',','
                    color = lightblue]\n','P1\n',
                    
                    'node [shape = box,
                    fontname = Helvetica,
                    width = 3, 
                    penwidth = 2,
                    style = filled,
                    fillcolor = lightblue,
                    label =', P2,',\n',
                    'tooltip = ','"','The sample has been sequenced and there are now raw genomic data files associated with the sample','"',',','
                    color = lightblue]\n','P2\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', A2,',\n',
                    'tooltip = ','"','Sample phenotypic annotation will be harmonized according to KF specific CV’s and Ontologies.','"',',','
                    color = steelblue]\n','A2\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', A3,',\n',
                    'tooltip = ','"','Annotation harmonized by DRC','"',',','
                    color = steelblue]\n','A3\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', P3,',\n',
                    'tooltip = ','"','This data can now be transferred to the corresponding X01 investigator directly.','"',',','
                    color = steelblue]\n','P3\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', P4,',\n',
                    'tooltip = ','"','Once the annotation and the genomic data (raw / processed) has been received it is available in a Cavatica project','"',',','
                    color = steelblue]\n','P4\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', P5, ',\n',
                    'tooltip = ','"','The raw data will be processed through KF pipelines so all the data in the KF DRC will have been processed the same way.','"',',','
                    color = steelblue]\n','P5\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    alpha = 0.5,
                    label =', AP,',\n',
                    'tooltip = ','"','The raw data will be processed through KF pipelines so all the data in the KF DRC will have been processed the same way.','"',',','
                    color = steelblue]\n','AP\n',
                    
                    '# edge statements\n','P1','->','P2 ','P2','->','P3 ','P3','->','P4 ','P4','->','P5 ','P5','->','AP\n',
                    'A1','->','A2','->','A3\n',
                    'A2','->','P4\n',
                    'A3','->','AP\n\n',
                    
                    '# define ranks
                    subgraph {
                    rank = same; ', 'A2','; ','P4\n','}\n\n',
                    
                    'subgraph {
                    rank = same; ', 'A1','; ', 'P2\n','}',
                    '}')
      
      grViz(diagram = txt)
    }
  })
  
  # summary plot
  output$summplot <- renderGrViz({

      # create this for the flowchart
      chrs <- as.character(dat[nrow(dat),])
      P1 <- paste0('\"Sample Submitted \nby X01 PI: [',as.character(chrs[6]),']\"')
      P2 <- paste0('\"Sample Sequenced \nby \nSequencing Center: [',as.character(chrs[7]),']\"')
      P3 <- paste0('\"Genomic Data transferred \nto DRC: [',as.character(chrs[8]),']\"')
      A1 <- paste0('\"Minimal Annotation Acquired \nfrom X01 PI: [',as.character(chrs[9]),']\"')
      P4 <- paste0('\"Sample Available \non Cavatica: [',as.character(chrs[10]),']\"')
      P5 <- paste0('\"Genomic Data \nProcessed through \nKF Pipelines: [',as.character(chrs[11]),']\"')
      A2 <- paste0('\"QC check by DRC: [',as.character(chrs[12]),']\"')
      AP <- paste0('\"Harmonized Sample Data \nAvailable through \nKF Portal: [',as.character(chrs[13]),']\"')
      A3 <- paste0('\"Annotation Harmonized \nby DRC: [',as.character(chrs[13]),']\"')
      
      txt <- paste0('digraph GMKF_datatracker {\n', 
                    'node [shape = box,
                    fontname = Helvetica,
                    fontcolor = white,
                    width = 3, 
                    penwidth = 2,
                    style = filled,
                    fillcolor = lightblue,
                    label =', A1,
                    'tooltip = ','"','The X01 PI has provided some annotation on the samples which have genomic data','"',',','
                    color = lightblue]\n','A1\n',
                    
                    'node [shape = box,
                    fontname = Helvetica,
                    width = 3, 
                    penwidth = 2,
                    style = filled,
                    fillcolor = lightblue,
                    label =', P1,
                    'tooltip = ','"','Sample has been submitted to the sequencing center','"',',','
                    color = lightblue]\n','P1\n',
                    
                    'node [shape = box,
                    fontname = Helvetica,
                    width = 3, 
                    penwidth = 2,
                    style = filled,
                    fillcolor = lightblue,
                    label =', P2,
                    'tooltip = ','"','The sample has been sequenced and there are now raw genomic data files associated with the sample','"',',','
                    color = lightblue]\n','P2\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', A2,
                    'tooltip = ','"','Sample phenotypic annotation will be harmonized according to KF specific CV’s and Ontologies.','"',',','
                    color = steelblue]\n','A2\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', A3,
                    'tooltip = ','"','Annotation harmonized by DRC','"',',','
                    color = steelblue]\n','A3\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', P3,
                    'tooltip = ','"','This data can now be transferred to the corresponding X01 investigator directly.','"',',','
                    color = steelblue]\n','P3\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', P4,
                    'tooltip = ','"','Once the annotation and the genomic data (raw / processed) has been received it is available in a Cavatica project','"',',','
                    color = steelblue]\n','P4\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    label =', P5,
                    'tooltip = ','"','The raw data will be processed through KF pipelines so all the data in the KF DRC will have been processed the same way.','"',',','
                    color = steelblue]\n','P5\n',
                    
                    '# right node statements
                    node [shape = box,
                    fontname = Helvetica,
                    width = 3,
                    penwidth = 2,
                    style = filled,
                    fillcolor = steelblue,
                    alpha = 0.5,
                    label =', AP,
                    'tooltip = ','"','The raw data will be processed through KF pipelines so all the data in the KF DRC will have been processed the same way.','"',',','
                    color = steelblue]\n','AP\n',
                    
                    '# edge statements\n','P1','->','P2 ','P2','->','P3 ','P3','->','P4 ','P4','->','P5 ','P5','->','AP\n',
                    'A1','->','A2','->','A3\n',
                    'A2','->','P4\n',
                    'A3','->','AP\n\n',
                    
                    '# define ranks
                    subgraph {
                    rank = same; ', 'A2','; ','P4\n','}\n\n',
                    
                    'subgraph {
                    rank = same; ', 'A1','; ', 'P2\n','}',
                    '}')
      
      grViz(diagram = txt)
  })
  
})