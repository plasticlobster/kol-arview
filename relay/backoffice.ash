record sale {
   string date;
   string time;
   int playerid;
   string playername;
   int qty;
   item purchased_item;
   int price;
   string ticket_no;
   string full_line;
   int item_num;
};

record sale_day {
   int qty;
   sale[int] sales;
};

string reverse(string string_in) {
   int len = length(string_in);
   buffer out;
   for a from (len - 1) downto 0 {
      out = append(out, char_at(string_in, a));
   }
   return to_string(out);
}

string nwc(int num_in) {
   buffer out;
   string neg = "";
   if (num_in < 0) {
      neg = "-";
      num_in = (-1) * num_in;
   }

   string rev = reverse(to_string(num_in));
   int len = length(rev);
   for a from 0 upto (len - 1) {
      out = append(out, char_at(rev, a));
      if ((((a + 1) % 3) == 0) && (a != (len - 1))){
         out = append(out, ",");
      }
   }
   return neg+reverse(to_string(out));
}

string get_final_html(sale_day[string][item] sale_days) {
   string html = "";
   string[int] dates;
   int num_dates = 0;
   foreach a in sale_days {
      dates[num_dates] = a;
      num_dates = num_dates + 1;
   }

   html = html + "<table style='font-size: 12px; width: 100%; cellpadding='3px'><tbody>";
   for a from num_dates - 1 downto 0 {
      foreach b in sale_days[dates[a]] {
         html = html + "<tr><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Ticket #(s)</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Date</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Time</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Player Name</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Quantity</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Item</th><th style='margin-top: 5px; border-bottom: 1px solid black; border-top: 1px solid black !important'>Price</th></tr>";
         foreach c in sale_days[dates[a]][b].sales {
             sale tmp = sale_days[dates[a]][b].sales[c];
             html = html + "<tr><td style='border-bottom: 1px solid #EFEFEF; padding: 3px'><b>"+tmp.ticket_no+"</td><td style='border-bottom: 1px solid #EFEFEF; padding: 3px'>"+tmp.date+"</td><td style='border-bottom: 1px solid #EFEFEF; padding: 3px'>"+tmp.time+"</td><td style='border-bottom: 1px solid #EFEFEF; padding: 3px'><a href='/sendmessage.php?toid="+url_encode(tmp.playername)+"'>"+tmp.playername+"</a></td><td style='border-bottom: 1px solid #EFEFEF; padding: 3px'>"+tmp.qty+"</td><td style='border-bottom: 1px solid #EFEFEF; padding: 3px'>"+tmp.purchased_item+"</td><td style='border-bottom: 1px solid #EFEFEF; padding: 3px'>"+nwc(tmp.price)+" Meat</td></tr>";
#            html = html + sale_days[dates[a]][b].sales[c].full_line;
         }
         html = html + "</tbody>";
      }
   }
   html = html + "</table>";
   return html;
}

sale_day[string][item] update_ticket_numbers(sale_day[string][item] sale_days) {
   int ticket;
   string ticket_txt;
   foreach a in sale_days {
      #a is the date.
      foreach b in sale_days[a] {
         #b is the item.
         ticket = 1;
         for c from count(sale_days[a][b].sales) - 1 downto 0 {
            string s = "s";
            if (sale_days[a][b].sales[c].qty == 1) s = "";
            ticket_txt = "<b>Ticket" + s + " #";
            for d from 1 upto sale_days[a][b].sales[c].qty {
               ticket_txt = ticket_txt + ticket + ", ";
               ticket = ticket + 1;
            }
            ticket_txt = ticket_txt + "</b> ";
            ticket_txt = replace_string(ticket_txt, ", </b>", "</b>");
            sale_days[a][b].sales[c].full_line = ticket_txt + sale_days[a][b].sales[c].full_line;
            sale_days[a][b].sales[c].ticket_no = ticket_txt;
         }
      }
   }
   return sale_days;
}

sale_day[string][item] get_days(sale[int] sales) {
   sale_day[string][item] out;
   boolean found_date = false;
   boolean found_item = false;
   foreach a in sales {
      found_date = false;
      found_item = false;
      foreach b in out {
         if (b == sales[a].date) {
            found_date = true;
            foreach c in out[b] {
               if (sales[a].purchased_item == c) {
                  found_item = true;
               }
            }
         }
      }
      if (found_item && found_date) {
         out[sales[a].date][sales[a].purchased_item].qty = out[sales[a].date][sales[a].purchased_item].qty + sales[a].qty;
      } else {
         out[sales[a].date][sales[a].purchased_item].qty = sales[a].qty;
      }
      out[sales[a].date][sales[a].purchased_item].sales[count(out[sales[a].date][sales[a].purchased_item].sales)] = sales[a];
   }
   foreach a in out {
      foreach b in out[a] {
         out[a][b].sales[count(out[a][b].sales) -1].full_line = out[a][b].sales[count(out[a][b].sales) -1].full_line + "<hr>";
      }
   }
   return out;
}

buffer ar_view(buffer page) {
   matcher page_match = create_matcher("\<span class=small\>(.*)?\</span\>", page);
   if (find(page_match)) {
      string all_items = group(page_match, 1);
      page = replace_string(page, "<span class=small>", "<div class=small>");
      page = replace_string(page, "</span>", "</div>");
#      page = replace_string(page, all_items, "___PLACEHOLDER___");
      matcher item_match = create_matcher("([0-9]*?/[0-9]*?/[0-9]*?) ([0-9]*?:[0-9]*?:[0-9]*?) .*?who\=([0-9]*?)\".*?\<b\>(.*?)\</b\>\</a\> bought ([0-9]*?) [\(](.*?)[\)] for ([0-9]*?) Meat.\<br\>", all_items);
      sale[int] sales;
      int num_found = 0;
      while (find(item_match)) {
         sale tmp;
         tmp.date = group(item_match, 1);
         tmp.time = group(item_match, 2);
         tmp.playerid = to_int(group(item_match, 3));
         tmp.playername = group(item_match, 4);
         tmp.qty = to_int(group(item_match, 5));
         tmp.purchased_item = to_item(group(item_match, 6));
         tmp.price = to_int(group(item_match, 7));
         tmp.full_line = group(item_match, 0);
         sales[num_found] = tmp;
         num_found = num_found + 1;
      }
      sale_day[string][item] days = get_days(sales);
      days = update_ticket_numbers(days);
      string html = get_final_html(days);
      replace_string(page, all_items, html);
   }
   page = replace_string(page, "[sales activity]", "<a href='/backoffice.php?which=3'>[sales activity]</a>");
   return page;
}

buffer add_ar_link() {
   buffer page = visit_url();
   matcher my_match = create_matcher("\<td\>\<center\>(.*?)inventory management(.*?)\</center\>", page);
   if (my_match.find()) {
      string my_string = "&nbsp; &nbsp;[";
      if (form_field("ar_view") != 1) {
         my_string = my_string + "<a href='/backoffice.php?which=3&ar_view=1'>AR View</a>";
      } else {
         my_string = my_string + "AR View";
      }
      my_string = my_string + "]</center>";
      string res = group(my_match);
      res = replace_string(res, "</center>", "");
      replace_string(page, res, res + my_string);
   }
   return page;
}

void main() {
   buffer page = add_ar_link();
   if(form_field("ar_view") == 1) page = ar_view(page);
   write(page);
}
