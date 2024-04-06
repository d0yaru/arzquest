	if GetString(global_str, "127.0.0.1") *then
		mysql = mysql_connect("localhost", "root", "arizona", "");

	else if GetString(global_str, "45.95.203.117") *then
		mysql = mysql_connect("localhost", "root", "arizona", "q7ewVX4gkCEvHGfb");
		
	else
		mysql = mysql_connect("51.68.139.153", "country_bonus", "country_bonus", "XihKO7nCEfk1IfeN");

	if !mysql_errno(mysql) *then
		print("[DataBase]: No errors found, database was successfully connected.");
	else
		printf("[DataBase]: Error '%d' found. Database wasn't successfully connected.", mysql_errno(mysql));