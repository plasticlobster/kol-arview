buffer add_ar_box() {
   buffer page = visit_url();
   string kol_dates = "<input type='hidden' id='kol_dates' value='";
   boolean date_prop = get_property("PL_ARView_Use_KoL_Dates").to_boolean();
   if (date_prop) {
      kol_dates = kol_dates + "1'>";
   } else {
      kol_dates = kol_dates + "0'>";
   }
   page = replace_string(page, "<head>", "<head><script type=\"text/javascript\" src=\"pl_jquery.js\"></script><script type=\"text/javascript\" src=\"pl_backoffice.js\"></script>");
   page = replace_string(page, "[sales activity]", "[sales activity]&nbsp;&nbsp;<input id='toggle_ar_mode' type='checkbox'>AR Mode&nbsp;&nbsp;[<a href='#' onclick='refreshSales(); return false'>Refresh</a>]<div id='orig_content' style='visibility: hidden; display: none'></div>" + kol_dates);
   return page;
}

void main() {
   if (form_field("which") == 3) {
      buffer page = add_ar_box();
      write(page);
   } else {
      buffer page = visit_url();
      write(page);
   }
}
