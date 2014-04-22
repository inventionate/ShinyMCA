library(shiny)
library(FactoMineR)
library(GDAtools)

# Hier die unterschiedlichen CSV Dateien laden
data(tea)
teaAktiv <- tea[1:18]
teaPassiv <- tea[19:21]
data(hobbies)
hobbiesAktiv <- hobbies[20:22]
hobbiesPassiv <- hobbies[17:19]

# Es muss die Datensatz-Eingabe noch dynamisiert werden!

shinyServer(function(input, output) {
  
  # Datensatz auswählen
  datensatzEingabe  <- reactive({
    switch(input$datensatz,
           "Tee" = data.frame(teaAktiv,teaPassiv),
           "Hobbies" = data.frame(hobbiesAktiv,hobbiesPassiv) )
  })
  
  # Aktive Variablen auswählbar machen
  output$auswahlAktiverVariablen <- renderUI({
    datensatz <- datensatzEingabe()
    # Alle Variablen als aktiv deklarieren
    # Überprüfen, um welchen Datensatz es sich handelt
    if( input$datensatz == "Tee")
    {
      alleAktivenVariablen <- names(datensatz[1:ncol(teaAktiv)])
    }
    if( input$datensatz == "Hobbies")
    {
      alleAktivenVariablen <- names(datensatz[1:ncol(hobbiesAktiv)])
    }
    # Automatisch Inputboxen für alle Daten generieren
    checkboxGroupInput("aktiveVariablen","Aktive Variablen:",alleAktivenVariablen,alleAktivenVariablen)
  })
  
  # Passive Variablen auswählbar machen
  output$auswahlPassiverVariablen <- renderUI({
    datensatz <- datensatzEingabe()
    # Alle Variablen als aktiv deklarieren
    # Überprüfen, um welchen Datensatz es sich handelt
    if( input$datensatz == "Tee")
    {
      allePassiveVariablen <- names(datensatz[(ncol(teaAktiv)+1):(ncol(teaAktiv)+ncol(teaPassiv))])
    }
    if( input$datensatz == "Hobbies")
    {
      allePassiveVariablen <- names(datensatz[(ncol(hobbiesAktiv)+1):(ncol(hobbiesAktiv)+ncol(hobbiesPassiv))])
    }
    # Automatisch Inputboxen für alle Daten generieren
    checkboxGroupInput("passiveVariablen","Passive Variablen:",allePassiveVariablen)
  })
  
  # MCA berechnen
  mca.daten <- reactive({
    datensatz <- datensatzEingabe()
    
    # Zu verwendende aktive Variablen auswählen
    verwendeteAktiveVariablen <- input$aktiveVariablen   
    
    # Zu verwendende passive Variablen auswählen
    verwendetePassiveVariablen <- input$passiveVariablen

    # Verwendete Variablen insgesamt
    if( !is.null(verwendetePassiveVariablen) )
    {
      verwendeteVariablen <- cbind(verwendeteAktiveVariablen,verwendetePassiveVariablen)
      # Relevante aktive Variablen auswählen 
      aktiverDatensatz <- datensatz[,(names(datensatz)) %in% verwendeteVariablen]
      # Umfang aktive Variablen
      anzahlAktiveVariablen <- length(verwendeteAktiveVariablen)
      # Umfang passive Variablen
      anzahlPassiveVariablen <- length(verwendetePassiveVariablen)
      # MCA Algorithmus (aus FactoMineR Paket) ausführen
      # Es wurde eine passive Variable ausgewählt
      if( anzahlPassiveVariablen == 1 )
      {
        res.mca <- MCA(aktiverDatensatz, graph = FALSE, quali.sup=(anzahlAktiveVariablen+anzahlPassiveVariablen))
      }
      # Es wurden zwei oder mehr passive Variablen ausgewählt
      else
      {
        res.mca <- MCA(aktiverDatensatz, graph = FALSE, quali.sup=(anzahlAktiveVariablen+1):(anzahlAktiveVariablen+anzahlPassiveVariablen))
      }
    }
    else
    {
      verwendeteVariablen <- verwendeteAktiveVariablen
      # Relevante aktive Variablen auswählen 
      aktiverDatensatz <- datensatz[,(names(datensatz)) %in% verwendeteVariablen]
      # MCA Algorithmus (aus FactoMineR Paket) ausführen
      res.mca <- MCA(aktiverDatensatz, graph = FALSE)
    }
  })
  
  # Plot der Kategorien erzeugen
  output$kategorienPlot <- renderPlot({
    res.mca <- mca.daten()
    plot.MCA(res.mca, invisible=c("ind"), cex=0.8)
  })
  
  # Plot der Individuen erzeugen TEA
  output$individuenPlot <- renderPlot({
    res.mca <- mca.daten()
    plot.MCA(res.mca, invisible=c("var","quali.sup"), cex=0.8)
  })
  
  # Beschreibung der Dimensionen
  output$dimensionenBeschreiben <- renderPrint({
    res.mca <- mca.daten()
    dimdesc(res.mca)
  })
  
  # Numersiche Ergebnisse erzeugen
  output$numerischeErgebnisse <- renderPrint({
    res.mca <- mca.daten()
    summary(res.mca)
  })
  
})