#define FILTERSCRIPT
#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS 51 //максимум игроков на сервере + 1 (если 50 игроков, то пишем 51 !!!)
#include <a_http>
#include <mxINI>
#include <sscanf2>
#include <Pawn.CMD>
#include <Pawn.Raknet>

const
	vue = 1,
	svelte = 0;

#define public:%0(%1) forward%0(%1); public%0(%1)
#include <LauncherAddon>

//~~~~~~~~~~~~~~~~~~~~~~~~~[ Технические настройки проекта ]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
#define INTERFACE			"hud.waller-hosting.online" //Сайты интерфейсов где лежат интерфейсы
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

#define SCM	SendClientMessage

#define ExecuteEventf(%4,%0,%1,%2,%3)					str_d[0] = EOS, format(str_d, sizeof(str_d), %2, %3) && ExecuteEvent(%0,%1,str_d,%4)
#define str_f(%0,%1) format(SQL_STRING, sizeof SQL_STRING, %0, %1), SQL_STRING

const COLOR_LIGHTRED =		0xFF6347FF;

new MaxOnline;
//new format_string[128];
new SQL_STRING[4097];

new str_d[4096];//dialog
#define SCMF(%1,%2,%3)    format(format_string,188,%3), SendClientMessage(%1,%2,format_string)

//
new
	bool:player_Vue_Init[MAX_PLAYERS],
	bool:player_Svetle_Init[MAX_PLAYERS],
	bool:player_Status_Focus[MAX_PLAYERS],
	player_Cef_PositionWindow_X[MAX_PLAYERS],
	player_Cef_PositionWindow_Y[MAX_PLAYERS],
	player_Cef_PositionWindow_rX[MAX_PLAYERS],
	player_Cef_PositionWindow_rY[MAX_PLAYERS];
	
//anim
new bool:IsPlayerAnimationMenu[MAX_PLAYERS];
new bool:IsPlayerFillMenu[MAX_PLAYERS];
new bool:IsPlayerIterCarMenu[MAX_PLAYERS];
new bool:IsPlayerBattlePass[MAX_PLAYERS];
enum animationInfo
{
	animUID,
	animLib[16],
	animName[24],
	animtime
};
static const animInfo[][animationInfo] = {
	{1, "GANGS", "INVITE_YES", 264192},
	{2, "GANGS", "INVITE_NO", 264192},
	{3, "DEALER", "DEALER_IDLE_02", 264192},
	{4, "CAMERA", "CAMSTND_CMON", 264192},
	{5, "KISSING", "GFWAVE2", 264192},
	{6, "ON_LOOKERS", "WAVE_LOOP", 264192},
	{7, "GANGS", "HNDSHKCB", 264192},
	{8, "GANGS", "HNDSHKFA", 264192},
	{9, "GANGS", "HNDSHKFA_SWT", 264192},
	{10, "GANGS", "HNDSHKDA", 264192},
	{11, "GANGS", "HNDSHKEA", 264192},
	{12, "GANGS", "HNDSHKAA", 264192},
	{13, "GANGS", "HNDSHKBA", 264192},
	{14, "GANGS", "HNDSHKCA", 264192},
	{15, "GANGS", "PRTIAL_GNGTLKC", 264192},
	{16, "GANGS", "PRTIAL_GNGTLKD", 264192},
	{17, "GANGS", "PRTIAL_GNGTLKE", 264192},
	{18, "GANGS", "PRTIAL_GNGTLKF", 264192},
	{19, "GANGS", "PRTIAL_GNGTLKA", 264192},
	{20, "GANGS", "PRTIAL_GNGTLKB", 264192},
	{21, "GANGS", "PRTIAL_GNGTLKH", 264192},
	{22, "MISC", "IDLE_CHAT_02", 264192},
	{23, "CASINO", "CARDS_PICK_02", 264192},
	{24, "GANGS", "PRTIAL_GNGTLKA", 264192},
	{25, "GANGS", "PRTIAL_GNGTLKB", 264192},
	{26, "GANGS", "PRTIAL_GNGTLKG", 264192},
	{27, "KISSING", "GF_STREETARGUE_01", 264192},
	{28, "PED", "ENDCHAT_01", 264192},
	{29, "PED", "ENDCHAT_03", 264192},
	{30, "KISSING", "GIFT_GIVE", 264192},
	{31, "GANGS", "SHAKE_CARSH", 264192},
	{32, "PED", "IDLE_TAXI", 17041408},
	{33, "CAR", "FLAG_DROP", 264192},
	{34, "INT_HOUSE", "WASH_UP", 264192},
	{35, "GANGS", "SMKCIG_PRTL", 151259136},
	{36, "DEALER", "SHOP_PAY", 264192},
	{37, "SHOP", "ROB_LOOP_THREAT", 151259136},
	{38, "SHOP", "SHP_ROB_HANDSUP", 151259136},
	{39, "DEALER", "DEALER_DEAL", 264192},
	{40, "CASINO", "CARDS_LOOP", 151259136},
	{41, "CLOTHES", "CLO_POSE_LOOP", 151259136},
	{42, "DEALER", "DEALER_IDLE", 17041408},
	{43, "PED", "ROADCROSS", 264192},
	{44, "DEALER", "DEALER_IDLE_01", 17041408},
	{45, "PAULNMAC", "PISS_OUT", 264192},
	{46, "PAULNMAC", "PISS_IN", 264192},
	{47, "MISC", "SCRATCHBALLS_01", 264192},
	{48, "LOWRIDER", "PRTIAL_GNGTLKE", 264192},
	{49, "GANGS", "SHAKE_CARK", 264192},
	{50, "POLICE", "DOOR_KICK", 264192},
	{51, "PLAYIDLES", "STRETCH", 264192},
	{52, "BENCHPRESS", "GYM_BP_CELEBRATE", 264192},
	{53, "BOMBER", "BOM_PLANT", 264192},
	{54, "CARRY", "PUTDWN", 264192},
	{55, "CARRY", "LIFTUP", 264192},
	{56, "CASINO", "CARDS_RAISE", 264192},
	{57, "CASINO", "CARDS_WIN", 264192},
	{58, "BAR", "BARSERVE_BOTTLE", 264192},
	{59, "BSKTBALL", "BBALL_JUMP_SHOT", 264192},
	{60, "COP_AMBIENT", "COPBROWSE_NOD", 264192},
	{61, "COP_AMBIENT", "COPBROWSE_SHAKE", 264192},
	{62, "PED", "FUCKU", 264192},
	{63, "GHANDS", "GSIGN2LH", 264192},
	{64, "GHANDS", "GSIGN3", 264192},
	{65, "GHANDS", "GSIGN5", 264192},
	{66, "GHANDS", "GSIGN3LH", 264192},
	{67, "GHANDS", "GSIGN1", 264192},
	{68, "GHANDS", "GSIGN4LH", 264192},
	{69, "GHANDS", "GSIGN1LH", 264192},
	{70, "GHANDS", "GSIGN2", 264192},
	{71, "GHANDS", "GSIGN5LH", 264192},
	{72, "GHANDS", "GSIGN4", 264192},
	{73, "COP_AMBIENT", "COPLOOK_LOOP", 17041408},
	{74, "COP_AMBIENT", "COPLOOK_SHAKE", 17041408},
	{75, "PLAYIDLES", "TIME", 17041408},
	{76, "GANGS", "LEANIDLE", 17041408},
	{77, "MISC", "PLYRLEAN_LOOP", 17041408},
	{78, "COP_AMBIENT", "COPLOOK_THINK", 17041408},
	{79, "CAMERA", "CAMSTND_IDLELOOP", 17041408},
	{80, "BD_FIRE", "M_SMKLEAN_LOOP", 151259136},
	{81, "LOWRIDER", "M_SMKLEAN_LOOP", 151259136},
	{82, "CRACK", "BBALBAT_IDLE_01", 17041408},
	{83, "CRACK", "BBALBAT_IDLE_02", 17041408},
	{84, "GRAVEYARD", "MRNM_LOOP", 17041408},
	{85, "GRAVEYARD", "PRST_LOOPA", 17041408},
	{86, "OTB", "WTCHRACE_LOOP", 17041408},
	{87, "PLAYIDLES", "SHIFT", 17041408},
	{88, "BAR", "BARMAN_IDLE", 17041408},
	{89, "HEIST9", "SWT_WLLPK_L", 17041408},
	{90, "HEIST9", "SWT_WLLPK_R", 17041408},
	{91, "CRIB", "PED_CONSOLE_WIN", 264192},
	{92, "CASINO", "MANWIND", 151259136},
	{93, "OTB", "WTCHRACE_CMON", 264192},
	{94, "FOOD", "EAT_VOMIT_P", 264192},
	{95, "FOOD", "EAT_VOMIT_SK", 264192},
	{96, "ON_LOOKERS", "PANIC_POINT", 264192},
	{97, "MISC", "PLYR_SHKHEAD", 264192},
	{98, "ON_LOOKERS", "PANIC_HIDE", 151259136},
	{99, "PED", "SEAT_IDLE", 151259136},
	{100, "JST_BUISNESS", "GIRL_02", 151259136},
	{101, "INT_HOUSE", "LOU_LOOP", 151259136},
	{102, "ATTRACTORS", "STEPSIT_LOOP", 151259136},
	{103, "CAMERA", "CAMCRCH_IDLELOOP", 151259136},
	{104, "PED", "SEAT_down", 17041408},
	{105, "BEACH", "PARKSIT_M_LOOP", 151259136},
	{106, "INT_OFFICE", "OFF_SIT_BORED_LOOP", 151259136},
	{107, "BEACH", "LAY_BAC_LOOP", 151259136},
	{108, "BEACH", "PARKSIT_W_LOOP", 151259136},
	{109, "CRACK", "CRCKIDLE1", 151259136},
	{110, "CRACK", "CRCKIDLE2", 151259136},
	{111, "CRACK", "CRCKIDLE4", 151259136},
	{112, "DANCING", "DANCE_LOOP", 134481920},
	{113, "DANCING", "DAN_DOWN_A", 134481920},
	{114, "DANCING", "DAN_LEFT_A", 134481920},
	{115, "DANCING", "DAN_LOOP_A", 134481920},
	{116, "DANCING", "DAN_RIGHT_A", 134481920},
	{117, "DANCING", "DAN_UP_A", 134481920},
	{118, "DANCING", "DNCE_M_A", 134481920},
	{119, "DANCING", "DNCE_M_B", 134481920},
	{120, "DANCING", "DNCE_M_C", 134481920},
	{121, "DANCING", "DNCE_M_D", 134481920},
	{122, "DANCING", "DNCE_M_E", 134481920},
	{123, "SWEET", "SWEET_INJUREDLOOP", 151259136},
	{124, "CRACK", "CRCKDETH2", 151259136},
	{125, "CRACK", "CRCKDETH1", 151259136},
	{126, "MEDIC", "CPR", 264192},
	{127, "custom_dance", "null"}
};
stock SearchAnimationInfo(uid)
{
	for(new i; i < sizeof(animInfo); i++) if(animInfo[i][animUID] == uid) return i;
	return -1;
}
//fix clear anim
stock ClearAnimationsEx(playerid)
{
	SetPlayerSpecialAction(playerid, 0);
    ClearAnimations(playerid);
    ApplyAnimation(playerid, !"CARRY", !"crry_prtial", 4.1, 0, 0, 0, 0, 1, 1);
	return 1;
}
#if defined _ALS_ClearAnimations
    #undef ClearAnimations
#else
    #define _ALS_ClearAnimations
#endif
#define ClearAnimations ClearAnimationsEx

//
enum ServerCFGSettings
{
    server_name,
    server_logo
}
new ServerCFG[ServerCFGSettings][70];
new NumberServID;

new Serv_Names[25][50] =
{
	"None",
	"Phoenix",//1
	"Tucson",//2
	"Scottdale",//3
	"Chandler",//4
	"Brainburg",//5
	"Saint-Rose",//6
	"Mesa",//7
	"Red-Rock",//8
	"Yuma",//9
	"Surprise",//10
	"Prescott",//11
	"Glendale",//12
	"Kingman",//13
	"Winslow",//14
	"Payson",//15
	"Gilbert",//16
	"Show Low",//17
	"Casa-Grande",//18
	"Page",//19
	"Sun-City",//20
	"Queen-Creek",//21
	"Sedona",//22
	"Holiday",//23
	"Wednesday"//24
};

forward ChangeSpeedometr(playerid, type);
forward ChangeHud(playerid, hudstatus);
forward ChangePubgHud(playerid, hudstatus);
forward ChangeViceHud(playerid, hudstatus);
forward AddKeys(playerid, phone, member, fam, radio);
forward ChangeSatietyHud(playerid, satiety);
forward ChangeSatietyViceHud(playerid, satiety);
forward ChangePowerHud(playerid, power);
forward ChangeVehicleLiters(playerid, fuel);
forward ChangeVehicleMileage(playerid, kmh);
forward ChangeVehicleFuelType(playerid, type);
forward ChangeNearBoomBox(playerid, status);
forward ChangeVehicleUpdateSpeedTime(playerid, time);
forward CloseDonationShop(playerid);
forward CloseAuthVideo(playerid);
forward CloseAuth(playerid);
forward AuthErrorPassword(playerid);
forward AuthErrorMail(playerid);
forward AuthErrorReferal(playerid);
forward LoadAuth(playerid, nickname[]);
forward LoadRegister(playerid, nickname[]);
forward LoadRegisterTwo(playerid, nickname[]);
forward ClosePhone(playerid);
forward CloseAnims(playerid);
forward CloseIterCarMenu(playerid);
forward CloseFuel(playerid);
forward ChangeWantedLVLViceHud(playerid, wanted);
forward ChangeRadar(playerid, type);
forward LoadDonate(playerid, donatemoney);
forward ChangeDonateBalance(playerid, donatemoney);
forward LoadCefPhone(playerid, phone_id, phone_color, phone_background);
forward ChangePhoneBg(playerid, phone_background);
forward ChangeChat(playerid, chat_status);
forward ChangeSaveDialog(playerid, dialog_status);
forward ChangeNewNametag(playerid, newnametag_status);
forward ChangeRenderDialog(playerid, type);
forward FuncPlayer_Snow(playerid, status);
forward UpdateSelectCef(playerid);
forward LoadCefAnims(playerid);
forward LoadBattlePass(playerid);
forward LoadFuel(playerid, kind, costone, costtwo, fuel);
forward SendPlayerNotificationCef(playerid, nottype[], notname[], nottext[], nottimeout);
forward LoadCarIterMenu(playerid);

enum cpinfo
{
	uide, //fix
	uname[24+6+3]
};
static const CefPublic[][cpinfo] = {
	//{0, "onSvelteAppInit"},
	{0, "vueReady"},
	{1, "onActiveViewChanged"},
	{2, "useAction"},
	{3, "startSearch"},
	{4, "stopSearch"},
	{5, "onClickBuyShopItem"},
	{6, "onClickMenuCategory"},
	{7, "onLobbyPlayerClick"},
	{8, "declineLobbyInvite"},
	{9, "acceptLobbyInvite"},
	{10, "exitLobby"},
	{11, "handleRightClick"},
	{12, "onDraggedItem"},
	{13, "callbackcompleteTask"},
	{14, "callbackskipTask"},
	{15, "BattlePassRatingSelectedServer"},
	{16, "callbackBattlePassBuyCommonPress"},
	{17, "callbackBattlePassBuyGolden"},
	{18, "getAwardCallback"},
	{19, "sellAwardCallback"},
	{20, "BPSHOP"},
	{21, "closeBattlePass"},
	{22, "pickContainer"},
	{23, "pickedContainerRewards"},
	{24, "lowerThenCurrentBet"},
	{25, "sendBetContainer"},
	{26, "closeContainerAuction"},
	{27, "buyItemDonationButton"},
	{28, "closeDonationShop"},
	{29, "pickedGenre"},
	{30, "nextPage"},
	{31, "pickedTrack"},
	{32, "hideRadio"},
	{33, "StopTrack"},
	{34, "addToFavorite"},
	{35, "answerCall"},
	{36, "declineCall"},
	{37, "press_number_phone"},
	{38, "call"},
	{39, "pickOrderWorker"},
	{40, "pickOrderButtonPlayer"},
	{41, "declineOrderWorker"},
	{42, "readToGo"},
	{43, "rentedCar"},
	{44, "pickedCar"},
	{45, "rentVehicleMenu"},
	{46, "topUpBalance"},
	{47, "setGeoLocation"},
	{48, "createOrder"},
	{49, "declineOrder"},
	{50, "finishOrder"},
	{51, "driverRating"},
	{52, "launchedApp"},
	{53, "closeGasStation"},
	{54, "authorization"},
	{55, "registration"},
	{56, "authSpawn"},
	{57, "authRecovery"},
	{58, "authRecoveryCodeByMail"},
	{59, "createCharacter"},
	{60, "playAnimation"},
	{61, "addToFavorites"},
	{62, "closeAnimationsMenu"},
	{63, "purchaseFuel"},
	{64, "purchaseProduct"},
	{65, "playTrack"}
};
public OnFilterScriptInit()
{
    new currenttime = GetTickCount();

	printf("Interfaces загрузился за %i ms", GetTickCount() - currenttime);
    return 1;
}

public OnIncomingPacket(playerid, packetid, BitStream:bs)
{
	if(packetid == 220)
	{
		static custom;
		BS_IgnoreBits(bs, 8);
		BS_ReadUint8(bs, custom);
		switch(custom)
		{
			case 20: //getplayerWindow
			{
				BS_ReadUint8(bs, player_Cef_PositionWindow_X[playerid]);
				BS_ReadUint8(bs, player_Cef_PositionWindow_Y[playerid]);
				BS_IgnoreBits(bs, 16);
				BS_ReadUint8(bs, player_Cef_PositionWindow_rX[playerid]);
				BS_ReadUint8(bs, player_Cef_PositionWindow_rY[playerid]);
			}
			case 38: //init cef
			{
			    OnPlayerInitializingBrowser(playerid);
			    
				player_Vue_Init[playerid] = true;
				// SCM(playerid, -1, "[vue] цеф инициализирован");
				player_Svetle_Init[playerid] = true;
				// SCM(playerid, -1, "[svetle] цеф инициализирован");
				
				ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.auth.updateServerOnline', '[[ %i ]]');", MaxOnline);
			}
			case 24: //cursor
			{
				//24, browserid, 0, 0, 0, 0, 0
				//24, browserid, 0, 0, 0, 128
				BS_IgnoreBits(bs, 32);
				static number;
				BS_ReadUint8(bs, number);
				if(!number && player_Status_Focus[playerid] == true)
				{
					player_Status_Focus[playerid] = false;
					HideCEF_Interface(playerid);
				}
				else player_Status_Focus[playerid] = true;
				//SCMF(playerid, -1, "cursor = %i", number);
			}
			case 17: //flood cef
			{

			}
			default:
			{
				static query[300];
				BS_ReadString32(bs, query);
				ShowCefPublic(playerid, query, custom);
			}
		}
		//printf("%i -> %s", custom, query);
		//SCMF(playerid, -1, "%s - %i(custom %i)", data, id1, custom);
	}
	return 1;
}
stock SearchCefPublic(const call[])
{
	for(new i; i < sizeof CefPublic; i++) if(GetString(call, CefPublic[i][uname])) return CefPublic[i][uide];
	return -1;
}
stock HideCEF_Interface(playerid, bool:hide=false)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"null\"]');");
	//UpdateBrowser(playerid, 25, 1, 0, 0, 0, 0);
	UpdateBrowser(playerid, 52, 2);
	UpdateBrowser(playerid, 86, 0);
	UpdateBrowser(playerid, 73, 0);
	//SetFocusBrowser(playerid, svelte, false);
	if(!hide)
	{
		IsPlayerAnimationMenu[playerid] = false;
		IsPlayerFillMenu[playerid] = false;
		IsPlayerIterCarMenu[playerid] = false;
		IsPlayerBattlePass[playerid] = false;
	}
	return 1;
}
public CloseAuthVideo(playerid)
{
	ExecuteEvent(playerid, 0, "window.executeEvent('event.setActiveView', '[ null ]');");
	ExecuteEvent(playerid, 0, "window.executeEvent('event.azpotify.stopTrackEvent', '[ null ]');");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.auth.updateVideoBackgroundVisible', '[false]')");
	SetFocusBrowser(playerid, svelte, false);
	return 1;
}
public CloseAuth(playerid)
{
	ExecuteEvent(playerid, 0, "window.executeEvent('event.setActiveView', '[ null ]');");
	return 1;
}
public AuthErrorPassword(playerid)
{
	ExecuteEvent(playerid, 0, "window.executeEvent('event.auth.sendPasswordError', '[ \"Данные от аккаунта неверны или аккаунт не существует!\" ]');", 13);
	return 1;
}
public AuthErrorMail(playerid)
{
	ExecuteEvent(playerid, 0, "window.executeEvent('event.auth.updateMailError', '[ \"Данная почта не существует!\" ]');", 13);
	return 1;
}
public AuthErrorReferal(playerid)
{
	ExecuteEvent(playerid, 0, "window.executeEvent('event.auth.updateReferralError', '[ \"Данный реферал не зарегистрирован!\" ]');", 13);
	return 1;
}
public: ArizonaGamesCefStatus(playerid)
{
	new status = -1;
    if(player_Vue_Init[playerid] || player_Svetle_Init[playerid]) status = 1;
	return status;
}
public LoadAuth(playerid, nickname[])
{
    LoadServerConfig();
    
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"Auth\"]');");
	ExecuteEventf(13, playerid, svelte, "window.executeEvent('event.auth.initializeServerInformation',\
	 '[{ \"id\": %i,\
	  \"title\": \"%s\",\
	   \"flag\": \"http://arizona-recovery.react.domains/desktop/resources/icons/arizona/%i.png\",\
	    \"online\": %i,\
		 \"status\": \"good\",\
		  \"username\": \"%s\",\
		   \"password\": \"\",\
		    \"remember\": false }]');", NumberServID, ServerCFG[server_logo], NumberServID, MaxOnline, nickname);

	return 1;
}
public LoadRegister(playerid, nickname[])
{
    LoadServerConfig();

	//event.auth.initializeCharacterEditor
	//event.auth.initializeSignupPage
	//event.auth.initializeSpawnPoints
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"Auth\"]');");
	ExecuteEventf(13, playerid, svelte, "window.executeEvent('event.auth.initializeServerInformation',\
	 '[{ \"id\": %i,\
	  \"title\": \"%s\",\
	   \"flag\": \"http://arizona-recovery.react.domains/desktop/resources/icons/arizona/%i.png\",\
	    \"online\": %i,\
		 \"status\": \"good\",\
		  \"username\": \"%s\",\
		   \"password\": \"\",\
		    \"remember\": false }]');", NumberServID, ServerCFG[server_logo], NumberServID, MaxOnline, nickname);

	ExecuteEvent(playerid, svelte, "window.executeEvent('event.auth.initializeSignupPage', '[ null ]');");
	return 1;
}
public LoadRegisterTwo(playerid, nickname[])
{
    LoadServerConfig();

	//event.auth.initializeSpawnPoints
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"Auth\"]');");
	ExecuteEventf(13, playerid, svelte, "window.executeEvent('event.auth.initializeServerInformation',\
	 '[{ \"id\": %i,\
	  \"title\": \"%s\",\
	   \"flag\": \"http://arizona-recovery.react.domains/desktop/resources/icons/arizona/%i.png\",\
	    \"online\": %i,\
		 \"status\": \"good\",\
		  \"username\": \"%s\",\
		   \"password\": \"\",\
		    \"remember\": false }]');", NumberServID, ServerCFG[server_logo], NumberServID, MaxOnline, nickname);

	ExecuteEvent(playerid, svelte, "window.executeEvent('event.auth.initializeCharacterEditor', '[ null ]');");
	
	SetFocusBrowser(playerid, svelte, true);
	return 1;
}
public CloseDonationShop(playerid)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"null\"]')");
	UpdateBrowser(playerid, 25, 1, 0, 0, 0, 0);
	UpdateBrowser(playerid, 52, 2);
	UpdateBrowser(playerid, 86, 0);
	UpdateBrowser(playerid, 73, 0);
	SetFocusBrowser(playerid, svelte, false);
	return 1;
}
public ClosePhone(playerid)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"null\"]');");
	SetFocusBrowser(playerid, svelte, false);
	return 1;
}
public CloseAnims(playerid)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"null\"]');");
	SetFocusBrowser(playerid, svelte, false);
	return 1;
}
public CloseIterCarMenu(playerid)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"null\"]');");
	SetFocusBrowser(playerid, svelte, false);
	return 1;
}
public CloseFuel(playerid)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"null\"]');");
	SetFocusBrowser(playerid, svelte, false);
	return 1;
}
public SendPlayerNotificationCef(playerid, nottype[], notname[], nottext[], nottimeout)
{
	ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.notify.initialize', '[\"%s\",\"%s\",\"%s\",%i]');", nottype, notname, nottext, nottimeout);
	return 1;
}
public LoadFuel(playerid, kind, costone, costtwo, fuel)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"GasStation\"]');");

	if(kind == 0)
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.gasstation.initializeFuelTypes', \
			'[[{\"id\":0,\"title\":\"Дизель\",\"price\":400,\"available\": 1},\
			{\"id\":1,\"title\":\"АИ-92\",\"price\":400,\"available\": 0},\
			{\"id\":2,\"title\":\"АИ-95\",\"price\":400,\"available\": 0},\
			{\"id\":3,\"title\":\"АИ-98\",\"price\":400,\"available\": 0}]]');");
	}
	else if(kind == 1)
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.gasstation.initializeFuelTypes', \
			'[[{\"id\":0,\"title\":\"Дизель\",\"price\":400,\"available\": 0},\
			{\"id\":1,\"title\":\"АИ-92\",\"price\":400,\"available\": 1},\
			{\"id\":2,\"title\":\"АИ-95\",\"price\":400,\"available\": 0},\
			{\"id\":3,\"title\":\"АИ-98\",\"price\":400,\"available\": 0}]]');");
	}
	else if(kind == 2)
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.gasstation.initializeFuelTypes', \
			'[[{\"id\":0,\"title\":\"Дизель\",\"price\":400,\"available\": 0},\
			{\"id\":1,\"title\":\"АИ-92\",\"price\":400,\"available\": 0},\
			{\"id\":2,\"title\":\"АИ-95\",\"price\":400,\"available\": 1},\
			{\"id\":3,\"title\":\"АИ-98\",\"price\":400,\"available\": 0}]]');");
	}
	else if(kind == 3)
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.gasstation.initializeFuelTypes', \
			'[[{\"id\":0,\"title\":\"Дизель\",\"price\":400,\"available\": 0},\
			{\"id\":1,\"title\":\"АИ-92\",\"price\":400,\"available\": 0},\
			{\"id\":2,\"title\":\"АИ-95\",\"price\":400,\"available\": 0},\
			{\"id\":3,\"title\":\"АИ-98\",\"price\":400,\"available\": 1}]]');");
	}

	ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.gasstation.initializeProducts', \
		'[[{\"id\":0,\"title\":\"Рем.комплект\",\"image\":520,\"price\":%d},\
		{\"id\":1,\"title\":\"Канистра\",\"image\":516,\"price\":%d},\
		{\"id\":2,\"title\":\"Повербанк для зарядки авто\",\"image\":700054,\"price\":29999}]]');", costone, costtwo);

	ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.gasstation.initializeMaxLiters', '[%i]');", 100);
	ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.gasstation.initializeCurrentLiters', '[%i]');", fuel);
	SetFocusBrowser(playerid, svelte, true);
	return 1;
}

stock ShowCefPublic(playerid, const request[], custom)
{
	static
		data[50],
		sscanf_id_0,
		sscanf_id_1,
		sscanf_id_2,
		testrequest[100];

    new skinid;
	new nick[24];//string player
	new pass[64];//string player
	new mail[50];//string player
 	new reftype[24];//string player
  	new referal[24];//string player
  	new sex[11];//string player
  	new race[11];//string player
		
	sscanf(request, "P<|>s[50]iii", data, sscanf_id_0, sscanf_id_1, sscanf_id_2);
	sscanf(testrequest, "P<|>s[50]iii", (str_f(data, sscanf_id_0, sscanf_id_1, sscanf_id_2)));
	//sscanf(request, "P<|>iii", sscanf_id_3, sscanf_id_4, sscanf_id_5);
	new id = SearchCefPublic(data);
	//printf("id %i(%i) & data [%s] & sscanf_id >- [%i,%i,%i]", id, custom, data, sscanf_id_0, sscanf_id_1, sscanf_id_2);
	//SCM(playerid, -1, (str_f("id %i(%i) & data [%s] & sscanf_id >- [%i,%i,%i]", id, custom, data, sscanf_id_0, sscanf_id_1, sscanf_id_2)));

	//if(id != -1 && custom == 24) CallRemoteFunction("HideTextDraws", "d", playerid);
	switch(id)
	{
		case 2: //useAction"},
		{
			//SCMF(playerid, -1, "id %i(%i) & data [%s] & sscanf_id >- [%i,%i,%i]", id, custom, data, sscanf_id_0, sscanf_id_1, sscanf_id_2);
			CallRemoteFunction("UseCarAction", "dd", playerid, sscanf_id_0);
		}
		case 26: //closeContainerAuction"},
		{
			ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"null\"]');");
			SetFocusBrowser(playerid, svelte, false);
		}
		case 27: //buyItemDonationButton"},
		{
			if(custom != 18) return HideCEF_Interface(playerid);
			CallRemoteFunction("DonateInfoCef", "ddd", playerid, sscanf_id_0, sscanf_id_1);
		}
		case 28: //closeDonationShop"},
		{
			// CallRemoteFunction("HideTextDraws", "d", playerid);
			CloseDonationShop(playerid);
		}
		case 52: //launchedApp"},
		{
		    //if(custom != 18) return HideCEF_Interface(playerid);
		    CallRemoteFunction("LaunchedApp", "dd", playerid, sscanf_id_0);
		}
		case 53: //closeGasStation"},
		{
			CallRemoteFunction("HideTextDraws", "d", playerid);
		}
		case 54: //auth
		{
			sscanf(request, "P<|>s[50]s[24]s[100]i", data, data, pass, sscanf_id_0);
			//SCMF(playerid, -1, "nick %s | pass %s | type %i", data, pass, sscanf_id_0);
			CallRemoteFunction("AuthLogin", "ds", playerid, pass);
		}
		case 55: //register
		{
		    sscanf(request, "P<|>s[50]s[24]s[100]s[100]s[100]s[100]i", data, nick, pass, mail, reftype, referal, sscanf_id_0);
			//SCMF(playerid, -1, "%s", request);
			//registration|Testa|123321|null|friends|Martys_Mcfly
			
			//SCMF(playerid, -1, "nick %s | pass %s | mail %s | referal %s | type %i", nick, pass, mail, referal, sscanf_id_0);

			CallRemoteFunction("RegisterLogin", "dsssss", playerid, nick, pass, mail, reftype, referal);
		}
		case 59: //createCharacter
		{
		    sscanf(request, "P<|>s[50]s[10]s[10]i", data, sex, race, skinid);
			//SCMF(playerid, -1, "%s", request);
			//createCharacter|man|white|0-4 / createCharacter|man|black|0-4
			//createCharacter|girl|white|0-1 / createCharacter|girl|black|0-1

			//SCMF(playerid, -1, "sex %s | race %s | skinid %i", sex, race, skinid);

		    CallRemoteFunction("ChangeCharacterRegister", "dssd", playerid, sex, race, skinid);
		}
		case 60: //playAnimation"},
		{
			if(!IsPlayerAnimationMenu[playerid]) return HideCEF_Interface(playerid);
			new animation_id = SearchAnimationInfo(sscanf_id_0);
			if(animation_id == -1) return SCM(playerid, COLOR_LIGHTRED, "[Ошибка] {FFFFFF}Такой анимации нет!");
			ApplyAnimation(playerid, animInfo[animation_id][animLib], animInfo[animation_id][animName], 4.1, 0, 0, 0, 0, animInfo[animation_id][animtime]);
			
			CallRemoteFunction("AnimsStart", "d", playerid);
		}
		case 62: //closeAnimationsMenu"}
		{
		    CallRemoteFunction("HideTextDraws", "d", playerid);
		}
		case 63: //purchaseFuel
		{
		    CallRemoteFunction("FillingStart", "df", playerid, float(sscanf_id_1));
		}
		case 64: //purchaseProduct
		{
		    if(custom != 18) return HideCEF_Interface(playerid);
		    CallRemoteFunction("FuelProductCef", "dd", playerid, sscanf_id_0);
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    MaxOnline -= 1;
    return 1;
}

public OnPlayerConnect(playerid)
{
    MaxOnline += 1;
    
	IsPlayerAnimationMenu[playerid] = false;
	IsPlayerFillMenu[playerid] = false;
	IsPlayerIterCarMenu[playerid] = false;
	IsPlayerBattlePass[playerid] = false;
	player_Status_Focus[playerid] = false;
    return 1;
}

stock OnPlayerInitializingBrowser(playerid)
{
	player_Vue_Init[playerid] = false;
	player_Svetle_Init[playerid] = false;
	// CreateBrowser(playerid, svelte, "file:///frontend/svelte_js/index_new.html");
	CreateBrowser(playerid, vue, "file:///frontend/vue_js/index.html");
	CreateBrowser(playerid, svelte, "file:///frontend/svelte_js/index.html");
	return 1;
}

stock UpdateBrowser(playerid, arg0, arg1, arg2=-1, arg3=-1, arg4=-1, arg5=-1)
{
	new BitStream:bs = BS_New();
	BS_WriteValue(bs, PR_UINT8, 220);
	BS_WriteValue(bs, PR_UINT8, arg0);
	BS_WriteValue(bs, PR_UINT8, arg1);
	if(arg2 != -1) BS_WriteValue(bs, PR_UINT8, arg2);
	if(arg3 != -1) BS_WriteValue(bs, PR_UINT8, arg3);
	if(arg4 != -1) BS_WriteValue(bs, PR_UINT8, arg4);
	if(arg5 != -1) BS_WriteValue(bs, PR_UINT8, arg5);
	PR_SendPacket(bs, playerid);
	return 1;
}

public ChangePhoneBg(playerid, phone_background)
{
    ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.phone.changePhoneBg', '[%i]');", phone_background);
	return 1;
}

public UpdateSelectCef(playerid)
{
	SetFocusBrowser(playerid, svelte, true);
	return 1;
}

public LoadBattlePass(playerid)
{
	IsPlayerBattlePass[playerid] = !IsPlayerBattlePass[playerid];
	HideCEF_Interface(playerid, IsPlayerBattlePass[playerid]);
	if(IsPlayerBattlePass[playerid] != false)
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeBattlePass', '[{}]');");
	    /*
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeServersData', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeRatingData', '[100]');");

		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeCoins', '[1000]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeQuests', '[1]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeContainer', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeContainerRewards', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeContainers', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializePickableRewards', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeGenres', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeMusic', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeLastPageIndex', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
        ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonapass.initializeRadioShowEvent', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
		*/
		SetFocusBrowser(playerid, svelte, true);
	}
	return 1;
}

public LoadCefAnims(playerid)
{
	IsPlayerAnimationMenu[playerid] = !IsPlayerAnimationMenu[playerid];
	HideCEF_Interface(playerid, IsPlayerAnimationMenu[playerid]);
	if(IsPlayerAnimationMenu[playerid] != false)
	{
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"AnimationsMenu\"]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.animationsMenu.initializeAnimations', '[[{\"id\":134,\"category\":\"uniq\",\"name\":\"Танец: Брейк (1)\",\"image\":\"2.png\",\"imageHover\":\"2.gif\",\"liked\":0}]]');");
		SetFocusBrowser(playerid, svelte, true);
	}
	return 1;
}

public LoadCarIterMenu(playerid)
{
	IsPlayerIterCarMenu[playerid] = !IsPlayerIterCarMenu[playerid];
	HideCEF_Interface(playerid, IsPlayerIterCarMenu[playerid]);
	if(IsPlayerIterCarMenu[playerid] != false)
	{
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.radial_menu.setInteractionMenuItems', '[[\"OpenBag\",\"OpenCap\",\"OpenCar\",\"OpenGlass\",\"FuelCar\",\"SFuelCar\",\"ONLight\",\"PaintCar\"]]');");
  		SetFocusBrowser(playerid, svelte, true);
	}
	return 1;
}

public LoadCefPhone(playerid, phone_id, phone_color, phone_background)
{
	LoadServerConfig();

	static const uid[] = {1,45,34,12,23};
	/*1 xiaomi 1
	12 Huawei P20 PRO 4
	23 pixel 5
	34 samsung 3
	45 iphone x 2*/
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"Phone\"]');");

	ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.phone.changePhoneBorder', '[%i]');", uid[phone_id-1]+phone_color);
	ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.phone.changePhoneBg', '[%i]');", phone_background);
	ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.phone.initializeServer', '[\"%s\"]');", ServerCFG[server_logo]);

	SetFocusBrowser(playerid, svelte, true);
	return 1;
}

public LoadDonate(playerid, donatemoney)
{
    UpdateBrowser(playerid, 25, 1, 0, 0, 0, 128);
	UpdateBrowser(playerid, 52, 0);
	UpdateBrowser(playerid, 86, 128);
	UpdateBrowser(playerid, 73, 128);
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"DonationShop\"]');");
	ExecuteEventf(6, playerid, svelte, "window.executeEvent('event.donationshop.ShopCountDonate', '[[ %i ]]');", donatemoney);
	SetFocusBrowser(playerid, svelte, true);
    return 1;
}

public ChangeDonateBalance(playerid, donatemoney)
{
	ExecuteEventf(6, playerid, svelte, "window.executeEvent('event.donationshop.ShopCountDonate', '[[ %i ]]');", donatemoney);
    return 1;
}

public ChangeChat(playerid, chat_status)
{
    UpdateBrowser(playerid, 33, !chat_status);
    return 1;
}
public ChangeSaveDialog(playerid, dialog_status)
{
    UpdateBrowser(playerid, 39, !dialog_status);
    return 1;
}
public ChangeNewNametag(playerid, newnametag_status)
{
    UpdateBrowser(playerid, 42, !newnametag_status);
    return 1;
}
public ChangeRenderDialog(playerid, type)
{
    UpdateBrowser(playerid, 53, !type);
    return 1;
}
public FuncPlayer_Snow(playerid, status)
{
    new BitStream:bs = BS_New();
	BS_WriteValue(bs, PR_UINT8, 220);
	BS_WriteValue(bs, PR_UINT8, status == 1 ? 47 : 48);
	BS_WriteValue(bs, PR_UINT8, 8);
	BS_WriteValue(bs, PR_UINT8, 83);
	BS_WriteValue(bs, PR_UINT8, 78);
	BS_WriteValue(bs, PR_UINT8, 79);
	BS_WriteValue(bs, PR_UINT8, 87);
	BS_WriteValue(bs, PR_UINT8, 70);
	BS_WriteValue(bs, PR_UINT8, 88);
	BS_WriteValue(bs, PR_UINT16, 73);
	BS_WriteValue(bs, PR_UINT32, 0);
	BS_WriteValue(bs, PR_UINT32, 0);
	BS_WriteValue(bs, PR_UINT8, 128);
	BS_WriteValue(bs, PR_UINT8, 63);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 64);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 208);
	BS_WriteValue(bs, PR_UINT8, 7);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	PR_SendPacket(bs, playerid);
    return 1;
}
public ChangeSpeedometr(playerid, type)
{
	if(type == 0)
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.speedometerType', '[\"false\"]');");
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.vehicleUpdateSpeedTime', '[0]');");
	}
	else if(type == 1)
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.speedometerType', '[\"advanced\"]')");
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.vehicleUpdateSpeedTime', '[100]');");
	}
	else if(type == 2)
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.speedometerType', '[\"simplified\"]')");
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.vehicleUpdateSpeedTime', '[500]');");
	}
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.vehicleMileage', '[0]');");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.vehicleLiters', '[100]');");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.vehicleFuelType', '[\"petrol\"]');");
    return 1;
}

public ChangeHud(playerid, hudstatus)
{
    if(hudstatus == 1)
	{
	    LoadServerConfig();

	    UpdateTest(playerid, 8, 2);

    	ExecuteEvent(playerid, svelte, "window.executeEvent('event.hud.updateHudVisible', '[true]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudSA.updateSanAndreasHudVisible', '[true]')");
		
		//Serv_Names[NumberServID+1]

	    ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.arizonahud.serverInfo', \
			'[{\"id\":%i,\"title\":\"%s\",\"project\":\"%s\",\"type\":\"%s\",\"onLine\":\"%i\",\"flag\":\"%i\",\"logo\":\"%i\",\"multiplier\":\"%i\"}]')",\
			NumberServID, ServerCFG[server_logo], ServerCFG[server_name], ServerCFG[server_logo], MaxOnline, NumberServID, NumberServID+1, playerid);
    }
    else
    {
        UpdateTest(playerid, 8, 0);//худ

        ExecuteEvent(playerid, svelte, "window.executeEvent('event.hud.updateHudVisible', '[false]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudSA.updateSanAndreasHudVisible', '[false]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudViceCity.updateViceCityHudVisible', '[false]');");

	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.serverInfo', '')");
    }
    return 1;
}
public ChangePubgHud(playerid, hudstatus)
{
    if(hudstatus == 1)
	{
	    LoadServerConfig();
	    
	    UpdateTest(playerid, 8, 2);

    	ExecuteEvent(playerid, svelte, "window.executeEvent('event.hud.updateHudVisible', '[true]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudSA.updateSanAndreasHudVisible', '[true]')");

		new fullstr[1024];
		format(fullstr, sizeof(fullstr), "window.executeEvent('event.arizonahud.serverInfo', \
			'[{\"id\":%i,\"title\":\"%s\",\"project\":\"%s\",\"type\":\"%s\",\"onLine\":\"%i\",\"flag\":\"%i\",\"logo\":\"%i\",\"multiplier\":\"%i\"}]')",
			NumberServID, Serv_Names[NumberServID+1], ServerCFG[server_name], ServerCFG[server_logo], MaxOnline, NumberServID, NumberServID, playerid);

	    ExecuteEvent(playerid, svelte, fullstr);
	    
	    new fullstr3[1024];
		format(fullstr3, sizeof(fullstr3), "window.executeEvent('event.pubg.updateGameInformation', '[\"Тест PUBG запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr3);

	    new fullstr4[1024];
		format(fullstr4, sizeof(fullstr4), "window.executeEvent('event.pubg.updateMatchStartingText', '[\"Тест PUBG MATCH запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr4);

	    new fullstr5[1024];
		format(fullstr5, sizeof(fullstr5), "window.executeEvent('event.pubg.update_character_data', '[\"Тест PUBG DATA запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr5);

	    new fullstr6[1024];
		format(fullstr6, sizeof(fullstr6), "window.executeEvent('event.pubg.setLobbyPlayers', '[\"2000\"]')");

	    ExecuteEvent(playerid, svelte, fullstr6);

	    new fullstr7[1024];
		format(fullstr7, sizeof(fullstr7), "window.executeEvent('event.pubg.updateCurrentZoneData', '[\"Тест PUBG ZONE запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr7);

	    new fullstr8[1024];
		format(fullstr8, sizeof(fullstr8), "window.executeEvent('event.pubg.updateCurrentZoneProgress', '[\"Тест PUBG ZONE PROGRESS запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr8);

	    new fullstr9[1024];
		format(fullstr9, sizeof(fullstr9), "window.executeEvent('event.pubg.updateCurrentZoneTimer', '[\"Тест PUBG ZONE TIMER запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr9);

	    new fullstr10[1024];
		format(fullstr10, sizeof(fullstr10), "window.executeEvent('event.pubg.updatecurrentZoneName', '[\"Тест PUBG ZONE NAME запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr10);

	    new fullstr11[1024];
		format(fullstr11, sizeof(fullstr11), "window.executeEvent('event.pubg.setVehicleData', '[\"Тест PUBG VEHICLE DATA запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr11);

	    new fullstr12[1024];
		format(fullstr12, sizeof(fullstr12), "window.executeEvent('event.pubg.setVehicleSpeed', '[\"150\"]')");

	    ExecuteEvent(playerid, svelte, fullstr12);

	    new fullstr13[1024];
		format(fullstr13, sizeof(fullstr13), "window.executeEvent('event.pubg.setVehicleFuel', '[\"100\"]')");

	    ExecuteEvent(playerid, svelte, fullstr13);

	    new fullstr14[1024];
		format(fullstr14, sizeof(fullstr14), "window.executeEvent('event.pubg.updateCurrentZonePosition', '[\"Тест PUBG CURRENT ZONE POSITION запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr14);

	    new fullstr15[1024];
		format(fullstr15, sizeof(fullstr15), "window.executeEvent('event.pubg.updateNextZonePosition', '[\"Тест PUBG NEXT ZONE POSITION запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr15);

	    new fullstr16[1024];
		format(fullstr16, sizeof(fullstr16), "window.executeEvent('event.pubg.updateRedZonePosition', '[\"Тест PUBG RED ZONE POSITION запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr16);

	    new fullstr17[1024];
		format(fullstr17, sizeof(fullstr17), "window.executeEvent('event.pubg.updatePlanePosition', '[\"Тест PUBG PLANE POSITION запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr17);

	    new fullstr18[1024];
		format(fullstr18, sizeof(fullstr18), "window.executeEvent('event.pubg.updateAirdropPosition', '[\"Тест PUBG AIRDROP POSITION запись\"]')");

	    ExecuteEvent(playerid, svelte, fullstr18);

		new fullstr19[1024];
		format(fullstr19, sizeof(fullstr19), "window.executeEvent('event.pubg.setKillList', '[\"1000\"]')");

	    ExecuteEvent(playerid, svelte, fullstr19);
	    //addKillList,clearKillList
    }
    else
    {
        UpdateTest(playerid, 8, 0);//худ

    	ExecuteEvent(playerid, svelte, "window.executeEvent('event.hud.updateHudVisible', '[false]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudSA.updateSanAndreasHudVisible', '[false]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudViceCity.updateViceCityHudVisible', '[false]');");
        
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.serverInfo', '')");
	    
	    new fullstr3[1024];
		format(fullstr3, sizeof(fullstr3), "window.executeEvent('event.pubg.updateGameInformation', '')");

	    ExecuteEvent(playerid, svelte, fullstr3);

	    new fullstr4[1024];
		format(fullstr4, sizeof(fullstr4), "window.executeEvent('event.pubg.updateMatchStartingText', '')");

	    ExecuteEvent(playerid, svelte, fullstr4);

	    new fullstr5[1024];
		format(fullstr5, sizeof(fullstr5), "window.executeEvent('event.pubg.update_character_data', '')");

	    ExecuteEvent(playerid, svelte, fullstr5);

	    new fullstr6[1024];
		format(fullstr6, sizeof(fullstr6), "window.executeEvent('event.pubg.setLobbyPlayers', '')");

	    ExecuteEvent(playerid, svelte, fullstr6);

	    new fullstr7[1024];
		format(fullstr7, sizeof(fullstr7), "window.executeEvent('event.pubg.updateCurrentZoneData', '')");

	    ExecuteEvent(playerid, svelte, fullstr7);

	    new fullstr8[1024];
		format(fullstr8, sizeof(fullstr8), "window.executeEvent('event.pubg.updateCurrentZoneProgress', '')");

	    ExecuteEvent(playerid, svelte, fullstr8);

	    new fullstr9[1024];
		format(fullstr9, sizeof(fullstr9), "window.executeEvent('event.pubg.updateCurrentZoneTimer', '')");

	    ExecuteEvent(playerid, svelte, fullstr9);

	    new fullstr10[1024];
		format(fullstr10, sizeof(fullstr10), "window.executeEvent('event.pubg.updatecurrentZoneName', '')");

	    ExecuteEvent(playerid, svelte, fullstr10);

	    new fullstr11[1024];
		format(fullstr11, sizeof(fullstr11), "window.executeEvent('event.pubg.setVehicleData', '')");

	    ExecuteEvent(playerid, svelte, fullstr11);

	    new fullstr12[1024];
		format(fullstr12, sizeof(fullstr12), "window.executeEvent('event.pubg.setVehicleSpeed', '')");

	    ExecuteEvent(playerid, svelte, fullstr12);

	    new fullstr13[1024];
		format(fullstr13, sizeof(fullstr13), "window.executeEvent('event.pubg.setVehicleFuel', '')");

	    ExecuteEvent(playerid, svelte, fullstr13);

	    new fullstr14[1024];
		format(fullstr14, sizeof(fullstr14), "window.executeEvent('event.pubg.updateCurrentZonePosition', '')");

	    ExecuteEvent(playerid, svelte, fullstr14);

	    new fullstr15[1024];
		format(fullstr15, sizeof(fullstr15), "window.executeEvent('event.pubg.updateNextZonePosition', '')");

	    ExecuteEvent(playerid, svelte, fullstr15);

	    new fullstr16[1024];
		format(fullstr16, sizeof(fullstr16), "window.executeEvent('event.pubg.updateRedZonePosition', '')");

	    ExecuteEvent(playerid, svelte, fullstr16);

	    new fullstr17[1024];
		format(fullstr17, sizeof(fullstr17), "window.executeEvent('event.pubg.updatePlanePosition', '')");

	    ExecuteEvent(playerid, svelte, fullstr17);

	    new fullstr18[1024];
		format(fullstr18, sizeof(fullstr18), "window.executeEvent('event.pubg.updateAirdropPosition', '')");

	    ExecuteEvent(playerid, svelte, fullstr18);

	    new fullstr19[1024];
		format(fullstr19, sizeof(fullstr19), "window.executeEvent('event.pubg.setKillList', '')");

	    ExecuteEvent(playerid, svelte, fullstr19);
	    //addKillList,clearKillList
    }
    return 1;
}

public ChangeViceHud(playerid, hudstatus)
{
    if(hudstatus == 1)
	{
	    LoadServerConfig();

	    UpdateTest(playerid, 8, 2);

    	ExecuteEvent(playerid, svelte, "window.executeEvent('event.hud.updateHudVisible', '[true]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudSA.updateSanAndreasHudVisible', '[false]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudViceCity.updateViceCityHudVisible', '[true]');");
    }
    else
    {
        UpdateTest(playerid, 8, 0);//худ

    	ExecuteEvent(playerid, svelte, "window.executeEvent('event.hud.updateHudVisible', '[false]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudSA.updateSanAndreasHudVisible', '[false]');");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudViceCity.updateViceCityHudVisible', '[false]');");
    }
    return 1;
}
public AddKeys(playerid, phone, member, fam, radio)
{
	if(fam == -1)
	{
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setFamilyRadioKey', '[null]')");
	}
	else
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setFamilyRadioKey', '[null]')");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setFamilyRadioKey', '[\"K\"]')");
	}
	
	if(member == 0)
	{
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setFractionRadioKey', '[null]')");
	}
	else
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setFractionRadioKey', '[null]')");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setFractionRadioKey', '[\"J\"]')");
	}

	if(phone == -1)
	{
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setPhoneKey', '[null]')");
	}
	else
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setPhoneKey', '[null]')");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setPhoneKey', '[\"P\"]')");
	}
	
	if(radio == -1)
	{
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setRadioKey', '[null]')");
	}
	else
	{
	    ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setRadioKey', '[null]')");
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setRadioKey', '[\"R\"]')");
	}
   	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.hotkeysVisible', '[true]')");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setAnimationKey', '[\"U\"]')");
	return 1;
}
public ChangeSatietyHud(playerid, satiety)
{
	if(satiety <= 0)
	{
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.playerSatiety', '[\"0\"]')");
	}
	else
	{
		ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.arizonahud.playerSatiety', '[\"%i\"]')", satiety);
	}
	return 1;
}
public ChangeSatietyViceHud(playerid, satiety)
{
    if(satiety <= 0)
	{
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudViceCity.updateSatiety', '[\"0\"]')");
	}
	else
	{
		new satietystr[500];
		format(satietystr, sizeof(satietystr), "window.executeEvent('event.hudViceCity.updateSatiety', '[\"%i\"]')", satiety);
		ExecuteEvent(playerid, svelte, satietystr);
	}
	return 1;
}
public ChangeWantedLVLViceHud(playerid, wanted)
{
    if(wanted <= 0)
	{
		ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudViceCity.updateWantedLevel', '[\"0\"]')");
	}
	else
	{
		new satietystr[500];
		format(satietystr, sizeof(satietystr), "window.executeEvent('event.hudViceCity.updateWantedLevel', '[\"%i\"]')", wanted);
		ExecuteEvent(playerid, svelte, satietystr);
	}
	return 1;
}

public ChangePowerHud(playerid, power)
{
	new satietystr[500];
	format(satietystr, sizeof(satietystr), "window.executeEvent('event.arizonahud.playerPower', '[\"%i\"]')", power);
	ExecuteEvent(playerid, svelte, satietystr);
	return 1;
}
public ChangeVehicleLiters(playerid, fuel)
{
	ExecuteEventf(255, playerid, svelte, "window.executeEvent('event.arizonahud.vehicleLiters', '[\"%i\"]')", fuel);
	return 1;
}
public ChangeVehicleMileage(playerid, kmh)
{
	new satietystr[500];
	format(satietystr, sizeof(satietystr), "window.executeEvent('event.arizonahud.vehicleMileage', '[\"%i\"]')", kmh);
	ExecuteEvent(playerid, svelte, satietystr);
	return 1;
}
public ChangeVehicleFuelType(playerid, type)
{
	new satietystr[500];
	format(satietystr, sizeof(satietystr), "window.executeEvent('event.arizonahud.vehicleFuelType', '[\"%i\"]')", type);
	ExecuteEvent(playerid, svelte, satietystr);
	return 1;
}
public ChangeNearBoomBox(playerid, status)
{
	new satietystr[500];
	format(satietystr, sizeof(satietystr), "window.executeEvent('event.arizonahud.nearBoomBox', '[%s]')", status == 1 ? true:false);
	ExecuteEvent(playerid, svelte, satietystr);
	return 1;
}
public ChangeVehicleUpdateSpeedTime(playerid, time)
{
	new satietystr[500];
	format(satietystr, sizeof(satietystr), "window.executeEvent('event.arizonahud.vehicleUpdateSpeedTime', '[\"%i\"]')", time);
	ExecuteEvent(playerid, svelte, satietystr);
	return 1;
}
public ChangeRadar(playerid, type)
{
    UpdateTest(playerid, 9, type);//радар
    return 1;
}

stock LoadServerConfig()
{
    if !fexist("cfg_server.ini") *then
		return print("file 'cfg_server.ini' not found");
		
    new GetFile = ini_openFile("cfg_server.ini");
	ini_getInteger(GetFile,"server_id",NumberServID);
	ini_closeFile(GetFile);

    new FileID = ini_openFile("cfg_server.ini");
    ini_getString(FileID,"server_name",ServerCFG[server_name]);
    ini_getString(FileID,"server_logo",ServerCFG[server_logo]);

    ini_closeFile(FileID);
    return 1;
}

stock SetFocusBrowser(playerid, browserid, bool:toggle)
{
	if(!toggle) UpdateBrowser(playerid, 25, browserid, 0, 0, 0, 0);
	else UpdateBrowser(playerid, 25, browserid, 0, 0, 0, 128);
	player_Status_Focus[playerid] = toggle;
	return 1;
}

stock SetString(param_1[], const param_2[], size = 300) return strmid(param_1, param_2, 0, strlen(param_2), size);

stock GetString(const param1[], const param2[], log = 0)
{
	if(!log) return !strcmp(param1, param2, false);
	else return !strcmp(param1, param2, true);
}

stock ExecuteEvent(playerid, browserid, const event[], interfaceid=255)
{
	switch(browserid)
	{
		case 0: if(!player_Vue_Init[playerid]) return 0;
		case 1: if(!player_Svetle_Init[playerid]) return 0;
	}
	new BitStream:bs = BS_New();
	BS_WriteValue(bs, PR_UINT8, 220);
	BS_WriteValue(bs, PR_UINT8, 17);
	BS_WriteValue(bs, PR_UINT32, browserid);
	BS_WriteValue(bs, PR_UINT32, strlen(event));
	BS_WriteValue(bs, PR_STRING, event, strlen(event));
	BS_WriteValue(bs, PR_UINT32, interfaceid);
	PR_SendPacket(bs, playerid);
	return 1;
}
stock CreateBrowser(playerid, browserid, const url[])
{
	new BitStream:bs = BS_New();
	BS_WriteValue(bs, PR_UINT8, 220);
	BS_WriteValue(bs, PR_UINT8, 10);
	BS_WriteValue(bs, PR_UINT8, player_Cef_PositionWindow_X[playerid]); //160 240
	BS_WriteValue(bs, PR_UINT8, player_Cef_PositionWindow_Y[playerid]); //5 4
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, player_Cef_PositionWindow_rX[playerid]); //132 169
	BS_WriteValue(bs, PR_UINT8, player_Cef_PositionWindow_rY[playerid]); //3 2
	// printf("playerid %i -> window x y stable %i %i %i %i", playerid, player_Cef_PositionWindow_X[playerid], player_Cef_PositionWindow_Y[playerid], player_Cef_PositionWindow_rX[playerid], player_Cef_PositionWindow_rY[playerid]);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT8, 0);
	BS_WriteValue(bs, PR_UINT32, strlen(url));
	BS_WriteValue(bs, PR_STRING, url, strlen(url));
	if(browserid == svelte) //svelte
	{
		BS_WriteValue(bs, PR_UINT32, 12);
		BS_WriteValue(bs, PR_UINT8, 111);
		BS_WriteValue(bs, PR_UINT8, 114);
		BS_WriteValue(bs, PR_UINT8, 55);
		BS_WriteValue(bs, PR_UINT8, 108);
		BS_WriteValue(bs, PR_UINT8, 113);
		BS_WriteValue(bs, PR_UINT8, 56);
		BS_WriteValue(bs, PR_UINT8, 81);
		BS_WriteValue(bs, PR_UINT8, 56);
		BS_WriteValue(bs, PR_UINT8, 104);
		BS_WriteValue(bs, PR_UINT8, 101);
		BS_WriteValue(bs, PR_UINT8, 117);
		BS_WriteValue(bs, PR_UINT8, 114);
		BS_WriteValue(bs, PR_UINT32, 0);
		//BS_WriteValue(bs, PR_UINT8, browserid);
	}
	else //vue or cinema
	{
		BS_WriteValue(bs, PR_UINT32, 0);
		BS_WriteValue(bs, PR_UINT8, browserid);
		BS_WriteValue(bs, PR_UINT16, 0);
		BS_WriteValue(bs, PR_UINT8, 0);
	}
	PR_SendPacket(bs, playerid);
	return 1;
}
stock UpdateTest(playerid, index, status)
{
	new BitStream:bs = BS_New();

	BS_WriteValue(bs, PR_UINT8, 220);

	// 8 hud
	BS_WriteValue(bs, PR_UINT8, index);

	BS_WriteValue(bs, PR_UINT8, status);

	PR_SendPacket(bs, playerid);
}
cmd:hudpos(playerid)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"InteractionMenu\"]')");

	SetFocusBrowser(playerid, svelte, true);

	ExecuteEvent(playerid, svelte, "window.executeEvent('event.radial_menu.setInteractionMenuItems', '[[\"Greet\",\"Trade\",\"Say\",\"Showdock\",\"Showskill\",\"Showdskill\",\"Kiss\",\"Showbinfo\"]]')");
}

cmd:hudtest(playerid, params[])
{
    ExecuteEvent(playerid, svelte, "window.executeEvent('event.auth.updateVideoBackgroundVisible', '[false]');");
    
	extract params-> new id, status; else return SCM(playerid, 0xBE2D2DFF, "Используйте: /hudtest [id интерфейса] [статус: 0-1]");
	UpdateTest(playerid, id, status);
	return 1;
}

cmd:showinterface(playerid, params[])
{
	extract params-> new id, string:string[512]; else return SCM(playerid, 0xBE2D2DFF, "Используйте: /showinterface [id браузера: стандарт 1] [код задачи CEF]");

	ExecuteEvent(playerid, id, string);

	SetFocusBrowser(playerid, id, true);
	return 1;
}
cmd:allinterfaces(playerid)
{
    LoadServerConfig();
    
    UpdateTest(playerid, 8, 2);
    UpdateTest(playerid, 9, 2);
    
    ExecuteEvent(playerid, svelte, "window.executeEvent('event.hud.updateHudVisible', '[true]');");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.speedometerType', '[\"advanced\"]')");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudSA.updateSanAndreasHudVisible', '[true]')");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.hotkeysVisible', '[true]')");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setFractionRadioKey', '[\"R\"]')");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setPhoneKey', '[\"P\"]')");
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.arizonahud.setAnimationKey', '[\"U\"]')");

	new fullstr[1024];
	format(fullstr, sizeof(fullstr), "window.executeEvent('event.arizonahud.serverInfo', \
		'[{\"id\":%i,\"title\":\"%s\",\"project\":\"%s\",\"type\":\"%s\",\"onLine\":\"%i\",\"flag\":\"%i\",\"logo\":\"%i\",\"multiplier\":\"%i\"}]')",
		NumberServID, Serv_Names[NumberServID+1], ServerCFG[server_name], ServerCFG[server_logo], MaxOnline, NumberServID, NumberServID, playerid);

    ExecuteEvent(playerid, svelte, fullstr);
    
    new fullstr2[1024];
	format(fullstr2, sizeof(fullstr2), "window.executeEvent('event.notify.initialize', '[\"Тест запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr2);

    new fullstr3[1024];
	format(fullstr3, sizeof(fullstr3), "window.executeEvent('event.pubg.updateGameInformation', '[\"Тест PUBG запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr3);

    new fullstr4[1024];
	format(fullstr4, sizeof(fullstr4), "window.executeEvent('event.pubg.updateMatchStartingText', '[\"Тест PUBG MATCH запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr4);

    new fullstr5[1024];
	format(fullstr5, sizeof(fullstr5), "window.executeEvent('event.pubg.update_character_data', '[\"Тест PUBG DATA запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr5);

    new fullstr6[1024];
	format(fullstr6, sizeof(fullstr6), "window.executeEvent('event.pubg.setLobbyPlayers', '[\"2000\"]')");

    ExecuteEvent(playerid, svelte, fullstr6);

    new fullstr7[1024];
	format(fullstr7, sizeof(fullstr7), "window.executeEvent('event.pubg.updateCurrentZoneData', '[\"Тест PUBG ZONE запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr7);

    new fullstr8[1024];
	format(fullstr8, sizeof(fullstr8), "window.executeEvent('event.pubg.updateCurrentZoneProgress', '[\"Тест PUBG ZONE PROGRESS запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr8);

    new fullstr9[1024];
	format(fullstr9, sizeof(fullstr9), "window.executeEvent('event.pubg.updateCurrentZoneTimer', '[\"Тест PUBG ZONE TIMER запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr9);

    new fullstr10[1024];
	format(fullstr10, sizeof(fullstr10), "window.executeEvent('event.pubg.updatecurrentZoneName', '[\"Тест PUBG ZONE NAME запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr10);

    new fullstr11[1024];
	format(fullstr11, sizeof(fullstr11), "window.executeEvent('event.pubg.setVehicleData', '[\"Тест PUBG VEHICLE DATA запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr11);

    new fullstr12[1024];
	format(fullstr12, sizeof(fullstr12), "window.executeEvent('event.pubg.setVehicleSpeed', '[\"150\"]')");

    ExecuteEvent(playerid, svelte, fullstr12);

    new fullstr13[1024];
	format(fullstr13, sizeof(fullstr13), "window.executeEvent('event.pubg.setVehicleFuel', '[\"100\"]')");

    ExecuteEvent(playerid, svelte, fullstr13);

    new fullstr14[1024];
	format(fullstr14, sizeof(fullstr14), "window.executeEvent('event.pubg.updateCurrentZonePosition', '[\"Тест PUBG CURRENT ZONE POSITION запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr14);

    new fullstr15[1024];
	format(fullstr15, sizeof(fullstr15), "window.executeEvent('event.pubg.updateNextZonePosition', '[\"Тест PUBG NEXT ZONE POSITION запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr15);

    new fullstr16[1024];
	format(fullstr16, sizeof(fullstr16), "window.executeEvent('event.pubg.updateRedZonePosition', '[\"Тест PUBG RED ZONE POSITION запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr16);

    new fullstr17[1024];
	format(fullstr17, sizeof(fullstr17), "window.executeEvent('event.pubg.updatePlanePosition', '[\"Тест PUBG PLANE POSITION запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr17);

    new fullstr18[1024];
	format(fullstr18, sizeof(fullstr18), "window.executeEvent('event.pubg.updateAirdropPosition', '[\"Тест PUBG AIRDROP POSITION запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr18);
    
    new fullstr19[1024];
	format(fullstr19, sizeof(fullstr19), "window.executeEvent('event.notify.initializeMapPositions', '[\"Тест initializeMapPositions запись\"]')");

    ExecuteEvent(playerid, svelte, fullstr19);
    
    new fullstr20[1024];
	format(fullstr20, sizeof(fullstr20), "window.executeEvent('event.pubg.setKillList', '[\"1000\"]')");

    ExecuteEvent(playerid, svelte, fullstr20);
    //addKillList,clearKillList
}
cmd:huddonate(playerid)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"DonationShop\"]');");
	
	new fullstr20[1024];
	format(fullstr20, sizeof(fullstr20), "window.executeEvent('event.donationshop.updateDonateJsonUrl', '[\"arizona-kinder.ru\"]')");

    ExecuteEvent(playerid, svelte, fullstr20);
    
    new fullstr21[1024];
	format(fullstr21, sizeof(fullstr21), "window.executeEvent('event.donationshop.ShopCountDonate', '[\"10000\"]')");

    ExecuteEvent(playerid, svelte, fullstr21);

	SetFocusBrowser(playerid, svelte, true);
}
cmd:hudvicedonate(playerid)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('event.hudViceCity.updateDonateMultiplier', '[true]')");

	SetFocusBrowser(playerid, svelte, true);
}
cmd:rodina(playerid)
{
	ExecuteEvent(playerid, svelte, "window.executeEvent('cef.hud.updateVisibleComponents', JSON.stringify([['hotkeysInformation','walletMoney','needsInformation','serverInformation','wanted','weaponInformation','voiceChatSpeakers',]]));");
    ExecuteEvent(playerid, svelte, "window.executeEvent('cef.hud.updateServerInformation', '[{\"title\":\"Сервер Колда\",\"maxPlayersCount\":1,\"playerId\":1,\"multiplier\":4,\"logoType\":\"spring\"}]');");
    ExecuteEvent(playerid, svelte, "window.executeEvent('cef.addNotification', JSON.stringify([{ \"type\": \"error\", \"title\": \"cef загружен\", \"description\": \"можете проверять\", \"duration\": 6000 }]));");
}
cmd:arizona_pubg(playerid)
{
   ExecuteEvent(playerid, svelte, "window.executeEvent('event.setActiveView', '[\"BattleRoyaleHud\"]');");
   UpdateTest(playerid, 8, 1);
}
cmd:pubg_tp(playerid)
{
   SetPlayerPos(playerid, -2188.7239,1278.9629,1142.9453);
   SetPlayerInterior(playerid, 3);
   SetPlayerVirtualWorld(playerid, 0);
}

