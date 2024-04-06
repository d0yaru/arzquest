stock ClickPhone(playerid, id)
{
    if !GetPVarInt(playerid, "OpenPhoneKey") *then {
        switch id do 
        {
            case 3:
            {
                global_str = "№ дома\tДо завершения\tТекущая цена\tМинимальная ставка\n";
                for new i; i < MAX_HOUSES; i++ do
                    if HouseInfo[i][hAuction] *then
                        f(global_str, sizeof global_str, "%sДом №%d\t%s\t$%d\t$%d\n", global_str, i, Convert(HouseInfo[i][hAuctionTime]), HouseInfo[i][hAuctionMoney], HouseInfo[i][hAuctionCost][1]);

                
                ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, !"Дома на аукционе", global_str, !"Закрыть", !"");
            }
            case 27:
            {
                f(global_str, 400,"SELECT t.`Name`, t.`Namez`, t.`Text`, t.`read`, t.`time` FROM `phonemes` AS t JOIN (SELECT `Name`, `Text`, max(`time`) as `mtime` FROM `phonemes` WHERE `Namez`='%s' GROUP BY `Name`) as t1 ON t.`Name`= t1.`Name` AND t.`time` = t1.`mtime` ORDER BY t.`time` DESC;",PN(playerid));
                mysql_tquery(mysql, global_str, "ShowPlayerMessages", "d", playerid);
            }
            case 29:
            {
                f(global_str, 400, "SELECT `phonebook`.`Namez`,`phonebook`.`Num`,`accounts`.`TelNum`,`accounts`.`Online_status`,`phonebook`.`Group` FROM `phonebook`,`accounts` WHERE `phonebook`.`Name` = '%s' AND `accounts`.`NickName`=`phonebook`.`Namez` ORDER BY `phonebook`.`Group` DESC", PN(playerid));
                mysql_tquery(mysql, global_str, "MysqlShowContacts", "d", playerid);
            }
            case 31:
            {
                SetPVarInt(playerid, "OpenPhoneKey", true);

                for new i = 2; i < 35; i++ do 
                    DestroyPlayerTD(playerid,  PhonePlayer[playerid][i]);
                #include <textdraws/cataloges/phone_key>
                for new i = 2; i < 35; i++ do 
                    PlayerTextDrawShow(playerid,  PhonePlayer[playerid][i]);

                SCM(playerid,COLOR_LIGHTBLUE,"[Информация] {FFFFFF}Номера телефонов государственных служб:");
                SCM(playerid,-1,"{FFFFFF}1.{6495ED} 111 - {FFFFFF}Проверить баланс телефона");
                SCM(playerid,-1,"{FFFFFF}2.{6495ED} 060 - {FFFFFF}Служба точного времени");
                SCM(playerid,-1,"{FFFFFF}3.{6495ED} 911 - {FFFFFF}Полицейский участок");
                SCM(playerid,-1,"{FFFFFF}4.{6495ED} 912 - {FFFFFF}Скорая помощь");
                SCM(playerid,-1,"{FFFFFF}5.{6495ED} 913 - {FFFFFF}Такси");
                SCM(playerid,-1,"{FFFFFF}6.{6495ED} 914 - {FFFFFF}Механик");
                PlayerTextDrawSetString(playerid, PhonePlayer[playerid][7], Pstroka[playerid]);
            }
            case 33:
            {
                f(global_str, 550, "\
                {B03131}[1]{FFFFFF} Настройки\n\
                {B03131}[2]{FFFFFF} Таймер (Будильник)\n\
                {B03131}[3]{FFFFFF} Номера/мониторинг гос. работников\n\
                {B03131}[4]{FFFFFF} Селфи{B03131}\n\
                {B03131}[5]{FFFFFF} Радио[%s{FFFFFF}]\n\
                {B03131}[6]{FFFFFF} Проверить баланс\n\
                {B03131}[7]{FFFFFF} Перевести телефон в режим \"%s\"\n\
                {B03131}[8]{FFFFFF} Убрать телефон\n\
                %s", PlayerPlayed{playerid} ? ("{7def58}ВКЛ") : ("{ef5858}ВЫКЛ"), PI[playerid][pTelWork] ? ("Самолет") : ("Обычный"),
                !(FP_Data[playerid][F_FAMILY_ID] == -1) ?  (GetFamilyDataInt(FP_Data[playerid][F_FAMILY_ID], "brend") ? "\n{B03131}[9]{FFFFFF} Отдел коммерции\n{B03131}[10]{FFFFFF} Отдел недвижимости":""): "");
                ShowPlayerDialogEx(playerid, 966, DIALOG_STYLE_LIST, !"Меню", global_str, !"Принять", !"Отмена");
            }
        }
    }
    else {
        switch id do
        {
            case 5:
            {
                if !strlen(Pstroka[playerid])  *then return false;
                strdel(Pstroka[playerid],strlen(Pstroka[playerid])-1, strlen(Pstroka[playerid]));
                if !strlen(Pstroka[playerid]) *then Pstroka[playerid] = "_";
                PlayerTextDrawSetString(playerid, PhonePlayer[playerid][7], Pstroka[playerid]);
            }
            case 18..27:
            {
                if strlen(Pstroka[playerid]) >= 11 *then return false;
                if !strcmp(Pstroka[playerid],"_",true) *then Pstroka[playerid] = "";
                new DataKey[11] = {0,8,7,9,5,4,6,2,1,3};
                strcat(Pstroka[playerid], IntToStr(DataKey[id-18]));
                PlayerTextDrawSetString(playerid, PhonePlayer[playerid][7], Pstroka[playerid]);
            }
            case 32:
            {
                DeletePVar(playerid, "OpenPhoneKey");
                for new i = 2; i < 35; i++ do 
                    DestroyPlayerTD(playerid,  PhonePlayer[playerid][i]);
                #include <textdraws/cataloges/phone_key>
                for new i = 2; i < 35; i++ do 
                    PlayerTextDrawShow(playerid,  PhonePlayer[playerid][i]);
            }
            case 33:
            {
                if GetString(Pstroka[playerid],"111") *then
                {
                    format(global_str,sizeof(global_str),"На балансе вашего телефона: {73B461}%d${FFFFFF}.\n\n",PI[playerid][pTelBalance]);
                    if(GLS[23]>0) format(global_str,sizeof(global_str),"%s {73B461}[Объявление] {FFFFFF}Сегодня проходит акция, на сервере включены х2 ЕХР!",global_str);
                    if(GLS[24]>0) format(global_str,sizeof(global_str),"%s {73B461}[Объявление] {FFFFFF}Сегодня проходит акция, на сервере включены х4 ЕХР!",global_str);
                    else format(global_str,sizeof(global_str),"%s",global_str);
                    ShowPlayerDialogEx(playerid,0,0,"",global_str,"Закрыть","");
                    SetPlayerChatBubble(playerid, "Набрал не известный номер.", COLOR_PURPLE, 10.0, 5000);
                }
                if(!strcmp(Pstroka[playerid],"060",true))
                {
                    new hour,minuite,second;
                    gettime(hour,minuite,second);
                    new year, month,day;
                    getdate(year, month, day);
                    format(global_str,sizeof(global_str),"{FFFFFF}Здравствуйте!\nВы позвонили в службу точного времени\nСегодняшняя дата: \t{2EA42E}%d:%d:%d{FFFFFF}\nТекущее время: \t{345690}%d:%d:%d{FFFFFF}\n\n\n",day,month,year,hour,minuite,second);
                    if(GLS[23]>0) format(global_str,sizeof(global_str),"%s {73B461}[Объявление] {FFFFFF}На сервере проходит акция, включены х2 EXP",global_str);
                    if(GLS[24]>0) format(global_str,sizeof(global_str),"%s {73B461}[Объявление] {FFFFFF}На сервере проходит акция, включены х4 EXP",global_str);
                    else format(global_str,sizeof(global_str),"%s",global_str);
                    ShowPlayerDialogEx(playerid,0,0,"",global_str,"Закрыть","");
                    SetPlayerChatBubble(playerid, "Позвонил в службу точного времени", COLOR_PURPLE, 10.0, 5000);
                }
                if(!strcmp(Pstroka[playerid],"911",true)) ShowPlayerDialogEx(playerid,959,1,"Вызвать полицию","{73B461}Опишите место где вы находитесь\n{FF6347}Сообщение должно состоять из 6 до 20 символов!","Принять","Отмена");

                if(!strcmp(Pstroka[playerid],"912",true)) ShowPlayerDialogEx(playerid,958,1,"Вызвать скорую помощь","{73B461}Опишите место где вы находитесь\n{FF6347}Сообщение должно состоять из 6 до 20 символов!","Принять","Отмена");

                if(!strcmp(Pstroka[playerid],"913",true)) ShowPlayerDialogEx(playerid,960,1,"Вызвать такси","{73B461}Опишите место где вы находитесь\n{FF6347}Сообщение должно состоять из 6 до 20 символов!","Принять","Отмена");
 
                if(!strcmp(Pstroka[playerid],"914",true)) ShowPlayerDialogEx(playerid,961,1,"Вызвать механика","{73B461}Опишите место где вы находитесь\n{FF6347}Сообщение должно состоять из 6 до 20 символов!","Принять","Отмена");
                    
                Pstroka[playerid] = "_";
            }
        }
    }
    return PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
}
stock PhoneTime() 
{
	new hour, minuite, time[16];
	gettime(hour, minuite, _);
	f(time,16, "%d:%02d", hour, minuite);
	return time;
}
stock HidePhone(playerid)
{
	for new i; i < 68; i++ do DestroyPlayerTD(playerid, PhonePlayer[playerid][i]);
	CancelSelectTextDraw(playerid);
	DeletePVar(playerid, "OpenPhoneKey");
    Pstroka[playerid] = "_";
	return OpenPhone{playerid} = false;
}