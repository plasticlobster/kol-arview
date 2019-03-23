buffer add_ar_box() {
   buffer page = visit_url();
   page = replace_string(page, "<head>", "<head><script type=\"text/javascript\" src=\"pl_jquery.js\"></script><script type=\"text/javascript\" src=\"pl_backoffice.js\"></script>");
   page = replace_string(page, "[sales activity]", "[sales activity]&nbsp;&nbsp;<input id='toggle_ar_mode' type='checkbox'>AR Mode&nbsp;&nbsp;[<a href='#' onclick='refreshSales(); return false'>Refresh</a>]<div id='orig_content' style='visibility: hidden; display: none'></div>");
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
