	if ItemsInfo[free][ItemModel] == - 1 *then
		DonatePreview[playerid][3] = CreatePlayerTextDraw(playerid, 270.134094, 331.167664, ItemsInfo[free][ItemPhoneColor]),
		PlayerTextDrawLetterSize(playerid, DonatePreview[playerid][3], 0.104176, 0.550847),
		PlayerTextDrawTextSize(playerid, DonatePreview[playerid][3], 20.0, 20.0),
		PlayerTextDrawAlignment(playerid, DonatePreview[playerid][3], 2),
		PlayerTextDrawColor(playerid, DonatePreview[playerid][3], 0x000000FF),
		PlayerTextDrawUseBox(playerid, DonatePreview[playerid][3], 0),
		PlayerTextDrawBoxColor(playerid, DonatePreview[playerid][3], 0x80808080),
		PlayerTextDrawSetShadow(playerid, DonatePreview[playerid][3], 1),
		PlayerTextDrawSetOutline(playerid, DonatePreview[playerid][3], 0),
		PlayerTextDrawBackgroundColor(playerid, DonatePreview[playerid][3], 0x00000040),
		PlayerTextDrawFont(playerid, DonatePreview[playerid][3], 2),
		PlayerTextDrawSetProportional(playerid, DonatePreview[playerid][3], 1),
		PlayerTextDrawSetSelectable(playerid, DonatePreview[playerid][3], 0);
	else
		DonatePreview[playerid][3] = CreatePlayerTextDraw(playerid, 259.634094, 323.421906, ""),
		PlayerTextDrawLetterSize(playerid, DonatePreview[playerid][3], 0.000000, 0.000000),
		PlayerTextDrawTextSize(playerid, DonatePreview[playerid][3], 21.000000, 26.000000),
		PlayerTextDrawAlignment(playerid, DonatePreview[playerid][3], 1),
		PlayerTextDrawColor(playerid, DonatePreview[playerid][3], 0xFFFFFFFFFFFFFFFF),
		PlayerTextDrawUseBox(playerid, DonatePreview[playerid][3], 0),
		PlayerTextDrawBoxColor(playerid, DonatePreview[playerid][3], 0xFFFFFFFFFFFFFFFF),
		PlayerTextDrawSetShadow(playerid, DonatePreview[playerid][3], 0),
		PlayerTextDrawSetOutline(playerid, DonatePreview[playerid][3], 0),
		PlayerTextDrawBackgroundColor(playerid, DonatePreview[playerid][3], 0x00000000),
		PlayerTextDrawFont(playerid, DonatePreview[playerid][3], 5),
		PlayerTextDrawSetProportional(playerid, DonatePreview[playerid][3], 0),
		PlayerTextDrawSetSelectable(playerid, DonatePreview[playerid][3], 1),
		PlayerTextDrawSetPreviewModel(playerid, DonatePreview[playerid][3], ( IsASkinInv(free) && !GetPlayerLauncher(playerid) ) ? GetSkinInfo(free):ItemsInfo[free][ItemModel]),
		PlayerTextDrawSetPreviewRot(playerid, DonatePreview[playerid][3], ItemsInfo[free][POSTDx], ItemsInfo[free][POSTDy], ItemsInfo[free][POSTDz], ItemsInfo[free][POSTDc]),
		PlayerTextDrawSetPreviewVehCol(playerid, DonatePreview[playerid][3], 0, 0);


	if ItemsInfo[one][ItemModel] == - 1 *then
		DonatePreview[playerid][2] = CreatePlayerTextDraw(playerid, 311.834106, 340.557922, ItemsInfo[one][ItemPhoneColor]),
		PlayerTextDrawLetterSize(playerid, DonatePreview[playerid][2], 0.213312, 1.101695),
		PlayerTextDrawTextSize(playerid, DonatePreview[playerid][2], 40.0, 40.0),
		PlayerTextDrawAlignment(playerid, DonatePreview[playerid][2], 2),
		PlayerTextDrawColor(playerid, DonatePreview[playerid][2], 0x000000FF),
		PlayerTextDrawUseBox(playerid, DonatePreview[playerid][2], 0),
		PlayerTextDrawBoxColor(playerid, DonatePreview[playerid][2], 0x80808080),
		PlayerTextDrawSetShadow(playerid, DonatePreview[playerid][2], 1),
		PlayerTextDrawSetOutline(playerid, DonatePreview[playerid][2], 0),
		PlayerTextDrawBackgroundColor(playerid, DonatePreview[playerid][2], 0x00000040),
		PlayerTextDrawFont(playerid, DonatePreview[playerid][2], 2),
		PlayerTextDrawSetProportional(playerid, DonatePreview[playerid][2], 1),
		PlayerTextDrawSetSelectable(playerid, DonatePreview[playerid][2], 1);
	else
		DonatePreview[playerid][2] = CreatePlayerTextDraw(playerid, 290.334106, 324.566406, ""),
		PlayerTextDrawLetterSize(playerid, DonatePreview[playerid][2], 0.000000, 0.000000),
		PlayerTextDrawTextSize(playerid, DonatePreview[playerid][2], 43.000000, 52.000000),
		PlayerTextDrawAlignment(playerid, DonatePreview[playerid][2], 1),
		PlayerTextDrawColor(playerid, DonatePreview[playerid][2], 0xFFFFFFFFFFFFFFFF),
		PlayerTextDrawUseBox(playerid, DonatePreview[playerid][2], 0),
		PlayerTextDrawBoxColor(playerid, DonatePreview[playerid][2], 0xFFFFFFFF80808080),
		PlayerTextDrawSetShadow(playerid, DonatePreview[playerid][2], 0),
		PlayerTextDrawSetOutline(playerid, DonatePreview[playerid][2], 0),
		PlayerTextDrawBackgroundColor(playerid, DonatePreview[playerid][2], 0x00000000),
		PlayerTextDrawFont(playerid, DonatePreview[playerid][2], 5),
		PlayerTextDrawSetProportional(playerid, DonatePreview[playerid][2], 0),
		PlayerTextDrawSetSelectable(playerid, DonatePreview[playerid][2], 1),
		PlayerTextDrawSetPreviewModel(playerid, DonatePreview[playerid][2], ( IsASkinInv(one) && !GetPlayerLauncher(playerid) ) ? GetSkinInfo(one):ItemsInfo[one][ItemModel]),
		PlayerTextDrawSetPreviewRot(playerid, DonatePreview[playerid][2], ItemsInfo[one][POSTDx], ItemsInfo[one][POSTDy], ItemsInfo[one][POSTDz], ItemsInfo[one][POSTDc]),
		PlayerTextDrawSetPreviewVehCol(playerid, DonatePreview[playerid][2], 0, 0);

	if ItemsInfo[two][ItemModel] == - 1 *then 
		DonatePreview[playerid][1] = CreatePlayerTextDraw(playerid, 354.300903, 331.597260, ItemsInfo[two][ItemPhoneColor]),
		PlayerTextDrawLetterSize(playerid, DonatePreview[playerid][1], 0.104176, 0.550847),
		PlayerTextDrawTextSize(playerid, DonatePreview[playerid][1], 20.0, 20.0),
		PlayerTextDrawAlignment(playerid, DonatePreview[playerid][1], 2),
		PlayerTextDrawColor(playerid, DonatePreview[playerid][1], 0x000000FF),
		PlayerTextDrawUseBox(playerid, DonatePreview[playerid][1], 0),
		PlayerTextDrawBoxColor(playerid, DonatePreview[playerid][1], 0x80808080),
		PlayerTextDrawSetShadow(playerid, DonatePreview[playerid][1], 1),
		PlayerTextDrawSetOutline(playerid, DonatePreview[playerid][1], 0),
		PlayerTextDrawBackgroundColor(playerid, DonatePreview[playerid][1], 0x00000040),
		PlayerTextDrawFont(playerid, DonatePreview[playerid][1], 2),
		PlayerTextDrawSetProportional(playerid, DonatePreview[playerid][1], 1),
		PlayerTextDrawSetSelectable(playerid, DonatePreview[playerid][1], 0);
	else
		DonatePreview[playerid][1] = CreatePlayerTextDraw(playerid, 343.800903, 323.851501, ""),
		PlayerTextDrawLetterSize(playerid, DonatePreview[playerid][1], 0.000000, 0.000000),
		PlayerTextDrawTextSize(playerid, DonatePreview[playerid][1], 21.000000, 26.000000),
		PlayerTextDrawAlignment(playerid, DonatePreview[playerid][1], 1),
		PlayerTextDrawColor(playerid, DonatePreview[playerid][1], 0xFFFFFFFFFFFFFFFF),
		PlayerTextDrawUseBox(playerid, DonatePreview[playerid][1], 0),
		PlayerTextDrawBoxColor(playerid, DonatePreview[playerid][1], 0xFFFFFFFF80808080),
		PlayerTextDrawSetShadow(playerid, DonatePreview[playerid][1], 0),
		PlayerTextDrawSetOutline(playerid, DonatePreview[playerid][1], 0),
		PlayerTextDrawBackgroundColor(playerid, DonatePreview[playerid][1], 0x00000000),
		PlayerTextDrawFont(playerid, DonatePreview[playerid][1], 5),
		PlayerTextDrawSetProportional(playerid, DonatePreview[playerid][1], 0),
		PlayerTextDrawSetSelectable(playerid, DonatePreview[playerid][1], 1),
		PlayerTextDrawSetPreviewModel(playerid, DonatePreview[playerid][1], ( IsASkinInv(two) && !GetPlayerLauncher(playerid) ) ? GetSkinInfo(two):ItemsInfo[two][ItemModel]),
		PlayerTextDrawSetPreviewRot(playerid, DonatePreview[playerid][1], ItemsInfo[two][POSTDx], ItemsInfo[two][POSTDy], ItemsInfo[two][POSTDz], ItemsInfo[two][POSTDc]),
		PlayerTextDrawSetPreviewVehCol(playerid, DonatePreview[playerid][1], 0, 0);

	DonatePreview[playerid][0] = CreatePlayerTextDraw(playerid, 311.666595, 314.404266, "");
	PlayerTextDrawLetterSize(playerid, DonatePreview[playerid][0], 0.176033, 0.977569);
	PlayerTextDrawTextSize(playerid, DonatePreview[playerid][0], 1280.000000, 1280.000000);
	PlayerTextDrawAlignment(playerid, DonatePreview[playerid][0], 2);
	PlayerTextDrawColor(playerid, DonatePreview[playerid][0], 0xC0C0C0FF);
	PlayerTextDrawUseBox(playerid, DonatePreview[playerid][0], 0);
	PlayerTextDrawBoxColor(playerid, DonatePreview[playerid][0], 0x80808080);
	PlayerTextDrawSetShadow(playerid, DonatePreview[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, DonatePreview[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, DonatePreview[playerid][0], 0x000000FF);
	PlayerTextDrawFont(playerid, DonatePreview[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, DonatePreview[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, DonatePreview[playerid][0], 0);