library(shiny)

# User Interface für die visuelle Datenaufbereitung einer multiplen Korrespondenzanalyse
shinyUI(pageWithSidebar(
  
  # Titel der Anwendung
  headerPanel("Konstruktion sozialer Räume"),
  
  sidebarPanel(
    # Auswahl der Datensätze
    selectInput("datensatz", "Datensatz:",
                choices = c("Tee","Hobbies"),
                selected = "Tee"
                ),
    
    
    # Auswahl der aktiven Variablen (über Checkboxen umsetzen)
    # Dynamisches Erzeugen der entsprechenden Eingaben
    uiOutput("auswahlAktiverVariablen"),
        
    # Auswahl der passiven Variablen (über Checkboxen umsetzen)
    # Dynamisches Erzeugen der entsprechenden Eingaben
    uiOutput("auswahlPassiverVariablen")
      
  ),
  
  # Verschiedene Sichtweisen auf die Ergebnisse (Plots und Tabellen)
  mainPanel(
    tabsetPanel(
      tabPanel("Kategorien Plot",plotOutput("kategorienPlot")), 
      tabPanel("Individuen Plot",plotOutput("individuenPlot")), 
      tabPanel("Beschreibung der Dimensionen",verbatimTextOutput("dimensionenBeschreiben")),
      tabPanel("Numerische Ergebnisse", verbatimTextOutput("numerischeErgebnisse"))
    )
  )
))