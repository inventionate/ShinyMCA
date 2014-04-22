# Anwendung veröffentlichen

# Proxy für devtools einrichten
# library(devtools)
# library(httr)
# set_config(use_proxy(url="http://proxy.ph-karlsruhe.de", port=3128))
# devtools::install_github('rstudio/shinyapps')

# Pakete laden
library(shiny)
library(shinyapps)

# Proxyeinstellungen vornehmen
options(RCurlOptions = list(proxy = "http://proxy.ph-karlsruhe.de:3128"))

# Lokalisation umstellen (shinyapps bug hotfix)
Sys.setlocale(locale="en_US.UTF-8")

# Account verknüpfen
shinyapps::setAccountInfo(name="inventionate", token="E172ED250C4DAB9D133AA9FA6BC525D4", secret="f7Pa7SxRCATVauSzXxGpmhApH8+64WH4i79tIOhG")

shinyapps::configureApp("ShinyMCA", size="medium")

# Anwendung veröfentlichen
deployApp()
