PRO SGARZA_READ_DATA_SUPPLEMENTAL_PLOTS_2

  ;June 20, 2018
  ;Program: PRO SGARZA_READ_DATA_SUPPLEMENTAL_PLOTS_2
  ;
  ;Purpose: Read in the IDL structures.
  ;
  ;
  ;Inputs: Data files (.sav)
  ;
  ;
  ;Outputs: A time series plot of all the primary data set that was read into IDL.
  ;
  ;
  ;
  ;
  ;
  ;Written by: Sierra N. Garza
  ;Harvard-Smithsonian Center for Astrophysics (CfA)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  convert_kev_nanometers = 1.24
  convert_meters_nanameters = 1.0e9
  convert_angstroms_nanameters = 1.0e-1
  convert_kev_ev = 1.0e3
  transmission_scale_percentage = 1.0e2
  convert_mm_to_cm = 1.0e-1
  convert_um_to_cm = 1.0e-4
  convert_m_to_cm = 1.0e2
  convert_arcseconds_to_radians = 4.84814e-6
  convert_ms_to_s = 1.0e-3
  sun_radius_cm = 6.95700e10
  contert_vem_to_cem = 1.0/(4.0*!pi*((sun_radius_cm)^(2.0)))
  ;half the sun's emission can be detected
  ;contert_vem_to_cem = 1.0/(2.0*!pi*((sun_radius_cm)^(2.0)))
  scale_1_vem_49 = 1.0e25
  scale_2_vem_49 = 1.0e24
  log_normalize_vem_49_to_cem_units = alog10(scale_1_vem_49) + alog10(scale_2_vem_49) + alog10(contert_vem_to_cem)
  normalize_vem_49_to_cem = (10.0)^(log_normalize_vem_49_to_cem_units)
  ; convert from radiance (intensity) at the sun to irradiance (flux) at earth, by multiplying by sterradians
  solar_radius_m = 6.963e8
  earth_sun_distance_m = 1.4960e11
  convert_intensity_at_sun_to_flux_at_earth = (!pi*((sin(atan(solar_radius_m, earth_sun_distance_m)))^(2.0)))
  log_vem_49 = 49.0
  CONVERT_kelvin_to_keV = 8.617328149741E-8
  CONVERT_TEMPERATURE_K_to_MK = 1.0E6
  Convert_keV_to_joules = 1.60218e-16
  Convert_cm_to_m = 1.0E-2
  Convert_cm_area_to_m_area = (1.0E-2)^(2.0)
  sun_radius_m = Convert_cm_to_m*sun_radius_cm
  Distance_1_AU_m = 1.496E11
  Convert_Flux_1_AU_to_Flux_Sun_Radius = (Distance_1_AU_m/sun_radius_m)^(2.0)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;Write as one nested for loop
 
 ;create an array for file paths
 folder_path = strarr(3)
 ; Set the Main file directory
 data_folder_path = path_sep()+'data'+path_sep()+'khnum'+path_sep()+'REU2018'+path_sep()+'sgarza'+path_sep()+'data'+path_sep()
 ;restore the xrt data for the different filters
 ;be_thin
 folder_path[0] = data_folder_path+path_sep()+'xrt'+path_sep()+'supplemental_data'+path_sep()+'xrt_level1_composite_dn_rate_Be_thin_20160610054253_20170423060433_1024_2.0.sav'
 ;Al_mesh
 folder_path[1] = data_folder_path+path_sep()+'xrt'+path_sep()+'supplemental_data'+path_sep()+'xrt_level1_composite_dn_rate_Al_mesh_20160610054213_20170423060342_1024_2.0.sav'
 ;Al_poly
 folder_path[2] = data_folder_path+path_sep()+'xrt'+path_sep()+'supplemental_data'+path_sep()+'xrt_level1_composite_dn_rate_Al_poly_20160610054233_20170423060403_1024_2.0.sav'
 
 ;create file path variable for xrt data different filters
 File_Path =  data_folder_path+path_sep()+'xrt'+path_sep()+'supplemental_data'+path_sep()+'*.sav'
 ;find number of files in that File_path variable
 File = FILE_SEARCH(File_Path, COUNT= N_File_Path)
 
 ;begin for loop to run through each xrt data filter files
 for x = 0, N_File_Path - 1 do begin
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Potential Problem
  ;get filter
  FileName = folder_path[x]
  restore, FileName
  ;Filter = File[x]
  XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter = XRT_COMPOSITE_STRUCTURE_DN_RATE_COMBINE
  ;set equal to null
  XRT_COMPOSITE_STRUCTURE_DN_RATE_COMBINE = !NULL
  N_XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter = n_elements(XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter.N_PIXELS_TOTAL_POSITIVE_DN_RATE)
  ;find the number of xrt filter images to find sdo data for
  XRT_COMPOSITE_STRUCTURE_all_Filter_JD_OBSERVATION_DATE = dblarr(N_XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter)
  
  ;nested for loop to extract the specified date of observation
  for t = 0, N_XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter - 1 do begin
    ;filter
    date_month = strmid(XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter[t].INDEX_NORM.DATE_OBS, 5, 2)
    date_day = strmid(XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter[t].INDEX_NORM.DATE_OBS, 8, 2)
    date_year = strmid(XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter[t].INDEX_NORM.DATE_OBS, 0, 4)
    date_hour = strmid(XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter[t].INDEX_NORM.DATE_OBS, 11, 2)
    date_minute = strmid(XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter[t].INDEX_NORM.DATE_OBS, 14, 2)
    date_second = strmid(XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter[t].INDEX_NORM.DATE_OBS, 17, 2)
    XRT_COMPOSITE_STRUCTURE_all_Filter_JD_OBSERVATION_DATE[t] = julday(date_month, date_day, date_year, date_hour, date_minute, date_second)
  endfor ;end on nested for loop
  
  print, 'IDL PROCEDURE stopped so that the User can check the (XRT Filter) data output, click "continue" to proceed'
  stop
  
  Filter_Name = ['Be_thin','Al_mesh','Al_poly']
  ;save plots as png
  window,[x] , retain = 2
  ;plot XRT Filter Rate vs time
  utplot,XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter.INDEX_NORM.date_obs,XRT_COMPOSITE_STRUCTURE_DN_RATE_Filter.TOTAL_POSITIVE_DN_RATE, background=255, color=0, psym=-6, sym_thick=2, title='XRT '+ Filter_Name[x]+' Filter', ytitle= 'DN/s', xthick=2, ythick=2
  
  screenshot = TVRD(TRUE = 1)
  image_path = data_folder_path+path_sep()+'xrt'+path_sep()+strcompress(string(x), /REMOVE_ALL)+'image.png'
  WRITE_PNG, image_path, screenshot
 endfor ;end of main for loop

 
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  END