stock ClickPhone(playerid, id)
{
    if !GetPVarInt(playerid, "OpenPhoneKey") *then {
        switch id do 
        {
            case 3:
            {
                global_str = "� ����\t�� ����������\t������� ����\t����������� ������\n";
                for new i; i < MAX_HOUSES; i++ do
                    if HouseInfo[i][hAuction] *then
                        f(global_str, sizeof global_str, "%s��� �%d\t%s\t$%d\t$%d\n", global_str, i, Convert(HouseInfo[i][hAuctionTime]), HouseInfo[i][hAuctionMoney], HouseInfo[i][hAuctionCost][1]);

                
                ShowPlayerDialogEx(playerid, 0, DIALOG_STYLE_TABLIST_HEADERS, !"���� �� ��������", global_str, !"�������", !"");
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

                SCM(playerid,COLOR_LIGHTBLUE,"[����������] {FFFFFF}������ ��������� ��������������� �����:");
                SCM(playerid,-1,"{FFFFFF}1.{6495ED} 111 - {FFFFFF}��������� ������ ��������");
                SCM(playerid,-1,"{FFFFFF}2.{6495ED} 060 - {FFFFFF}������ ������� �������");
                SCM(playerid,-1,"{FFFFFF}3.{6495ED} 911 - {FFFFFF}����������� �������");
                SCM(playerid,-1,"{FFFFFF}4.{6495ED} 912 - {FFFFFF}������ ������");
                SCM(playerid,-1,"{FFFFFF}5.{6495ED} 913 - {FFFFFF}�����");
                SCM(playerid,-1,"{FFFFFF}6.{6495ED} 914 - {FFFFFF}�������");
                PlayerTextDrawSetString(playerid, PhonePlayer[playerid][7], Pstroka[playerid]);
            }
            case 33:
            {
                f(global_str, 550, "\
                {B03131}[1]{FFFFFF} ���������\n\
                {B03131}[2]{FFFFFF} ������ (���������)\n\
                {B03131}[3]{FFFFFF} ������/���������� ���. ����������\n\
                {B03131}[4]{FFFFFF} �����{B03131}\n\
                {B03131}[5]{FFFFFF} �����[%s{FFFFFF}]\n\
                {B03131}[6]{FFFFFF} ��������� ������\n\
                {B03131}[7]{FFFFFF} ��������� ������� � ����� \"%s\"\n\
                {B03131}[8]{FFFFFF} ������ �������\n\
                %s", PlayerPlayed{playerid} ? ("{7def58}���") : ("{ef5858}����"), PI[playerid][pTelWork] ? ("�������") : ("�������"),
                !(FP_Data[playerid][F_FAMILY_ID] == -1) ?  (GetFamilyDataInt(FP_Data[playerid][F_FAMILY_ID], "brend") ? "\n{B03131}[9]{FFFFFF} ����� ���������\n{B03131}[10]{FFFFFF} ����� ������������":""): "");
                ShowPlayerDialogEx(playerid, 966, DIALOG_STYLE_LIST, !"����", global_str, !"�������", !"������");
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
                    format(global_str,sizeof(global_str),"�� ������� ������ ��������: {73B461}%d${FFFFFF}.\n\n",PI[playerid][pTelBalance]);
                    if(GLS[23]>0) format(global_str,sizeof(global_str),"%s {73B461}[����������] {FFFFFF}������� �������� �����, �� ������� �������� �2 ���!",global_str);
                    if(GLS[24]>0) format(global_str,sizeof(global_str),"%s {73B461}[����������] {FFFFFF}������� �������� �����, �� ������� �������� �4 ���!",global_str);
                    else format(global_str,sizeof(global_str),"%s",global_str);
                    ShowPlayerDialogEx(playerid,0,0,"",global_str,"�������","");
                    SetPlayerChatBubble(playerid, "������ �� ��������� �����.", COLOR_PURPLE, 10.0, 5000);
                }
                if(!strcmp(Pstroka[playerid],"060",true))
                {
                    new hour,minuite,second;
                    gettime(hour,minuite,second);
                    new year, month,day;
                    getdate(year, month, day);
                    format(global_str,sizeof(global_str),"{FFFFFF}������������!\n�� ��������� � ������ ������� �������\n����������� ����: \t{2EA42E}%d:%d:%d{FFFFFF}\n������� �����: \t{345690}%d:%d:%d{FFFFFF}\n\n\n",day,month,year,hour,minuite,second);
                    if(GLS[23]>0) format(global_str,sizeof(global_str),"%s {73B461}[����������] {FFFFFF}�� ������� �������� �����, �������� �2 EXP",global_str);
                    if(GLS[24]>0) format(global_str,sizeof(global_str),"%s {73B461}[����������] {FFFFFF}�� ������� �������� �����, �������� �4 EXP",global_str);
                    else format(global_str,sizeof(global_str),"%s",global_str);
                    ShowPlayerDialogEx(playerid,0,0,"",global_str,"�������","");
                    SetPlayerChatBubble(playerid, "�������� � ������ ������� �������", COLOR_PURPLE, 10.0, 5000);
                }
                if(!strcmp(Pstroka[playerid],"911",true)) ShowPlayerDialogEx(playerid,959,1,"������� �������","{73B461}������� ����� ��� �� ����������\n{FF6347}��������� ������ �������� �� 6 �� 20 ��������!","�������","������");

                if(!strcmp(Pstroka[playerid],"912",true)) ShowPlayerDialogEx(playerid,958,1,"������� ������ ������","{73B461}������� ����� ��� �� ����������\n{FF6347}��������� ������ �������� �� 6 �� 20 ��������!","�������","������");

                if(!strcmp(Pstroka[playerid],"913",true)) ShowPlayerDialogEx(playerid,960,1,"������� �����","{73B461}������� ����� ��� �� ����������\n{FF6347}��������� ������ �������� �� 6 �� 20 ��������!","�������","������");
 
                if(!strcmp(Pstroka[playerid],"914",true)) ShowPlayerDialogEx(playerid,961,1,"������� ��������","{73B461}������� ����� ��� �� ����������\n{FF6347}��������� ������ �������� �� 6 �� 20 ��������!","�������","������");
                    
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