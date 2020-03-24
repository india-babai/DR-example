# Dummy data ----
# path <- "D:/Office work/inputs/default dummy data.xlsx"
# dum_dat <- openxlsx::read.xlsx(path, detectDates = T)
library(lubridate)
library(xts)
library(dygraphs)



dummy_creator_single <- function(cust_id = 1, m1, y1, m2, y2, dflt_dt, rslv_dt) {
  # m1 <- 1
  # y1 <- 2008
  # m2 <- 9
  # y2 <- 2013

  # Snapshot date creation
  if (y1 < y2) {
    d1 <- paste0(y1, "-", m1, "-", 01) %>% as.Date(format = "%Y-%m-%d")
    d2 <- paste0(y2, "-", m2, "-", 01) %>% as.Date(format = "%Y-%m-%d")
    
    snapshot_dt <- seq(d1, d2, by = "months")
    day(snapshot_dt) <- lubridate::days_in_month(snapshot_dt)
  }
  
  temp <- data.frame(snapshot_dt)
  temp$cust_id <- cust_id

  # Default and resolve date
  dflt_dt <- as.Date(dflt_dt, format = "%Y-%m-%d")
  rslv_dt <- as.Date(rslv_dt, format = "%Y-%m-%d")
  
  day(dflt_dt) <- days_in_month(dflt_dt)
  day(rslv_dt) <- days_in_month(rslv_dt)
  
  temp <- temp %>% 
    dplyr::mutate(dflt_dt = dflt_dt, rslv_dt = rslv_dt)
  
  # Flags
  temp <- temp %>%
    dplyr::mutate(
      def_flag = ifelse(snapshot_dt < dflt_dt, 0,
                        ifelse(snapshot_dt == dflt_dt, 1, ifelse(snapshot_dt >= rslv_dt, 0, NA))),
      in_def_flag = ifelse(snapshot_dt >= dflt_dt &
                             snapshot_dt <= rslv_dt, 1, 0),
      diff_in_mon = floor(as.numeric(dflt_dt - snapshot_dt) / 30),
      def_flag_12m = ifelse(diff_in_mon <= 12 & diff_in_mon >= 1, 1, 0)
    ) %>% 
    dplyr::select(-diff_in_mon) %>% 
    dplyr::select(cust_id, snapshot_dt, dflt_dt, rslv_dt, def_flag, def_flag_12m, in_def_flag)
  
  temp
}


cust_id <- 1:300
y_def <- sample(2008:2020,size = length(cust_id), replace = T)
m_def <- sample(1:12, size = length(cust_id), replace = T)
dflt_dt <- paste0(y_def, "-", m_def, "-", 01) %>% as.Date(format = "%Y-%m-%d")
rslv_dt <- dflt_dt + sample(90:600, size = length(cust_id), replace = T)

snap_start <- dflt_dt - sample(365:1460, size = length(cust_id), replace = T)
y1 <- year(snap_start)
m1 <- month(snap_start)

snap_end <- rslv_dt + sample(1:1, size = length(cust_id), replace = T)
y2 <- year(snap_end)
m2 <- month(snap_end)


base_dat <- data.frame(cust_id, m1, y1, m2, y2, dflt_dt, rslv_dt)


final_dat <- NULL
for (i in cust_id) {
  # params <- list(base_dat[i,])
  # temp_dat <- do.call("dummy_creator_single", params)
  temp_dat <- dummy_creator_single(base_dat$cust_id[i], base_dat$m1[i], base_dat$y1[i], base_dat$m2[i], base_dat$y2[i],
                                   base_dat$dflt_dt[i], base_dat$rslv_dt[i])
  final_dat <- rbind(final_dat, temp_dat)
}



# Default_rate calculation ----
dr <- final_dat %>%
  dplyr::arrange(snapshot_dt) %>% 
  dplyr::group_by(snapshot_dt) %>% 
  dplyr::summarise(DR_ONE_YR = sum(def_flag_12m)/(n() - sum(in_def_flag)))


as.Date(dr$snapshot_dt, "%Y-%m")
dr_xts <- xts::xts(dr %>% select(-snapshot_dt), order.by = dr$snapshot_dt)


de_yr <- final_dat %>% 
  mutate(yr = year(snapshot_dt)) %>% 
  group_by(cust_id, yr) %>% 
  dplyr::summarise(def_flag_yr = max(def_flag))


# Time series plot of default rate ----
tsdyplot <- function(data, lvl = "m") {
  dr_xts <-
    xts::xts(data %>% select(-snapshot_dt), order.by = dr$snapshot_dt)
  
  xl <- ifelse(lvl == "m", "Months", "Years")
 
  
  dygraph(
    data = dr_xts,
    xlab = xl,
    ylab = "Default rate",
    main = paste0("One year default rate over time (", xl,")")
  ) %>%
    dyOptions(fillGraph = F,
              fillAlpha = 0.1,
              axisLineWidth = 1.5, colors = "#137218", strokeWidth = 2) %>%
    dyAxis("y", valueRange = c(0, 1.1) ) %>%
    dyLegend(show = "onmouseover", hideOnMouseOut = T) %>%
    dyRangeSelector(fillColor = "#90BCCB")
}
tsdyplot(data = dr)
