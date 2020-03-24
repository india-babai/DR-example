ui <-  bs4DashPage(
  sidebar_collapsed = TRUE,
  enable_preloader = TRUE,
  loading_duration = 3,
  controlbar_overlay = FALSE,
  title = "Private Banking UK simulation tool",
  loading_background = "#3B967F",
  navbar = bs4DashNavbar(
    status = "info",
    leftUi = h3(strong("Private Banking UK Advanced IRB models"), style = "color : #FFFFFF;")
  ),
  sidebar = bs4DashSidebar(
    expand_on_hover = TRUE,
    skin = "dark",
    status = "olive",
    title = strong("PBUK simulation tool"),
    brandColor = "dark",
    # url = "https://goo.co.uk/",
    # src = "sinclair logo.png",
    elevation = 3,
    opacity = 0.8,
    bs4SidebarMenu(
      id = "current_tab",
      flat = FALSE,
      compact = FALSE,
      child_indent = TRUE,
      bs4SidebarHeader(h4(strong("Explore me!"))),
      
      bs4SidebarMenuItem("Probability of default",
                         tabName = "pd",
                         icon = "chart-line"),
      bs4SidebarMenuItem("Loss given default",
                         tabName = "lgd",
                         icon = "cube"),
      bs4SidebarMenuItem("Exposure at default",
                         tabName = "ead",
                         icon = "cube"),
      bs4SidebarHeader("User guide"),
      bs4SidebarMenuItem("Read Me",
                         tabName = "user_guide",
                         icon = "info-circle")
      
    )
  ),
  
  body = bs4DashBody(bs4TabItems(pd_tab,
                                 lgd_tab,
                                 ead_tab,
                                 guide_tab))
  ,
  footer = bs4DashFooter(
    right_text = a(
      href = "https://github.com/india-babai/",
      target = "_blank",
      paste("WCR Analytics,", Sys.Date())
    )
  )
)
