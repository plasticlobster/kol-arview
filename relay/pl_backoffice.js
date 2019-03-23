$.noConflict();

function strip(html)
{
   var tmp = document.createElement("DIV");
   tmp.innerHTML = html;
   return tmp.textContent || tmp.innerText || "";
}

function convert_date(date) {
   var phoenix = moment.tz(date, "America/Phoenix");
   return phoenix;
}

function addSlashes( str ) {
    return (str + '').replace(/[\\"']/g, '\\$&').replace(/\u0000/g, '\\0');
}

function nwc(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function copyToClipboard(text) {
  var $temp = jQuery("<input>");
  jQuery("body").append($temp);
  $temp.val(strip(text)).select();
  document.execCommand("copy");
  $temp.remove();
}

function get_kol_date(date) {
   var day_one = moment.tz(moment("2003-02-01T03:30:00Z"), "America/Phoenix");
   var months = ['Jarlsuary', 'Frankuary', 'Starch', 'April', 'Martinus', 'Bill', 'Bor', 'Petember', 'Carlvember', 'Porktober', 'Boozember', 'Dougtember'];
   var days = [1, 2, 3, 4, 5, 6, 7, 8];
   var now = moment.tz(new Date(date), "America/Phoenix");
   var days_between = now.diff(day_one, "days");
   var kol_year = 1 + Math.floor(days_between / 96);
   var rem = days_between % 96;
   var kol_month = months[Math.floor(rem / 8)];
   var kol_day = days[rem % 8];
   var kol_date = kol_month + " " + kol_day + ", Year " + kol_year;
   return kol_date;
}

function getOrderedMatches(matches) {
   var out = new Map();
   for (var a = 0; a < matches.length; a++) {
      if (!matches[a]) continue;
      let kol_date = get_kol_date(matches[a][1] + " " + matches[a][2]);
      if (!out.has(kol_date)) out.set(kol_date, new Map());
      if (!out.get(kol_date).has(matches[a][6])) out.get(kol_date).set(matches[a][6], []);
      out.get(kol_date).get(matches[a][6]).push(matches[a]);
   }
   out.forEach((value, key) => {
      value.forEach((value2, key2) => {
         value2 = value2.reverse();
         var ticket_num = 1;
         for (let a = 0; a < value2.length; a++) {
            let qty = value2[a][5];
            var ticket_nums = [];
            for (let b = 1; b <= qty; b++) {
               ticket_nums.push("#"+ticket_num);
               ticket_num++;
            }
            value2[a].unshift(ticket_nums.join(', '));
         }
      });
   });
   return out;
}

function replaceSales() {
   let data = jQuery('#orig_content').html();
   data = data.split("<br>");
   let matcher = /(\d+\/\d+\/\d+) (\d+:\d+:\d+).*[?]who\=(\d+).*<b>(.*)<\/b><\/a> bought (\d+) [\(](.*)[\)] for (\d+) Meat./;
   var matches = [];
   var this_match = [];
   var m;
   for (var a = 0; a < data.length; a++) {
      this_match = data[a].match(matcher);
      matches.push(this_match);
   }
   var ordered_matches = getOrderedMatches(matches);
   var table = jQuery("<table style='font-size: 12px; width: 100%; border-collapse: collapse; border: 1px solid black;' cellpadding='3px'></table");
   var tbody = jQuery("<tbody></tbody>");
   tbody.append(jQuery("<tr style='font-size: 1px;'><td colspan='7' style='background-color: blue; border-bottom: 1px solid black;'>&nbsp;</td></tr>"));
   ordered_matches.forEach((value, key) => {
      tbody.append(jQuery("<tr><td colspan='7' style='border: 1px solid black; font-weight: bold; text-align: center'>"+key+"</td></tr>"));
      value.forEach((value2, key2) => {
      tbody.append(jQuery("<tr style='font-size: 1px;'><td colspan='7' style='background-color: blue; border-bottom: 1px solid black;'>&nbsp;</td></tr>"));
      tbody.append(jQuery("<tr><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Ticket #(s)</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Date</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Time</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Player Name</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Quantity</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Item</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Price</th></tr>"));
         for (let a = 0; a < value2.length; a++) {
            var tr = jQuery("<tr></tr>");
            for (let b = 0; b < value2[a].length; b++) {
               if ((b == 1) || (b == 4)) continue;
               let td = jQuery("<td style='text-align: center; border-bottom: 1px solid #EFEFEF; padding: 3px'></td>");
               if (b == 0) {
                  td.append(jQuery("<b><a href='#' onclick='copyToClipboard(\""+addSlashes(value2[a][1])+"\"); return false;'>" + value2[a][b] + "</a></b>"));
               } else if (b == 5) {
                  td.append(jQuery("<a href='/sendmessage.php?toid=" + value2[a][b] + "'>" + value2[a][b] + "</a>"));
               } else if (b == 8) {
                  td.text(nwc(value2[a][b]));
               } else {
                  td.text(value2[a][b]);
               }
               tr.append(td);
            }
            tbody.append(tr);
         }
      });
      tbody.append(jQuery("<tr style='font-size: 1px;'><td colspan='7' style='background-color: blue; border-bottom: 1px solid black;'>&nbsp;</td></tr>"));
   });
   table.append(tbody);
   jQuery('span.small').html(table);
}

function refreshSales() {
   jQuery.get("/backoffice.php?which=3", function(data) {
      var our_data = jQuery(data).find("span.small").html();
      jQuery('#orig_content').html(our_data);
      if (jQuery('#toggle_ar_mode').attr('checked')) {
         replaceSales();
      } else {
         jQuery('span.small').html(jQuery('#orig_content').html());
      }
   });
}

jQuery( document ).ready(function( $ ) {
   $('#orig_content').html(jQuery('span.small').html());
   $('#toggle_ar_mode').change(function() {
      if ($('#toggle_ar_mode').prop('checked')) {
         replaceSales();
      } else {
         $('span.small').html($('#orig_content').html());
      }
   });
   if ($('#toggle_ar_mode').prop('checked')) {
      replaceSales();
   }

});
