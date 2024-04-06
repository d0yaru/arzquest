
public: fortunetimer()//fortune
{
	if(fortunestep > 0)
	{
	    FortuneMove();
		fortunestep--;
	}
	else
	{
	    SetCameraBehindPlayer(fortunestarter);
		TogglePlayerControllable(fortunestarter, true);
		new a = Rand(10, 40);
  		new b = Rand(1000, 50000);
		switch(random(100))
		{
		    case 0..10: GiveDonate(fortunestarter, b), SCMF(fortunestarter, 0xAFAFAFFF, "Вы получили AZ Coins в размере %d", b);
		    case 11..16: GiveRoubles(fortunestarter, a), SCMF(fortunestarter, 0xAFAFAFFF, "Вы получили AZ Rub в размере %d",a);
		    case 17..30: AddItem(fortunestarter, 591, 10), SCM(fortunestarter, 0xAFAFAFFF, "Вы получили EXP в размере 10");
			case 31..40: AddItem(fortunestarter, 1461, 500000), SCM(fortunestarter, 0xAFAFAFFF, "Вы получили 500.000 BTC!");
			case 41..50: AddItem(fortunestarter, 324, 10), SCM(fortunestarter, 0xAFAFAFFF, "Вы получили Бронзовую рулетку в размере 10");
			case 51..60: AddItem(fortunestarter, 323, 10), SCM(fortunestarter, 0xAFAFAFFF, "Вы получили Серебряную рулетку в размере 10");
			case 61..70: AddItem(fortunestarter, 322, 10), SCM(fortunestarter, 0xAFAFAFFF, "Вы получили Золотую рулетку в размере 10");
			case 71..90: AddItem(fortunestarter, 316, 100000), SCM(fortunestarter, 0xAFAFAFFF, "Вы получили Фишки казино в размере 100000");
			case 91..97: AddItem(fortunestarter, 365, 5000), SCM(fortunestarter, 0xAFAFAFFF, "Вы получили Семейный талон в размере 5000");
			case 98..99:
			{
       			AddItem(fortunestarter, 1741, 1);
       			SCM(fortunestarter, 0xAFAFAFFF, "ПОЗДРАВЛЯЕМ! Вы получили ГЛАВНЫЙ ПРИЗ: Lamborghini Countach");
			}
		}
		fortunestarter = -1;
	    KillTimer(fortunespeed);
	}
}
	
stock FortuneMove()
{
    new Float:x, Float:y, Float:z, Float:Rx, Float:Ry, Float:Rz;
	GetObjectPos(fortune, x, y, z);
	GetObjectRot(fortune, Rx, Ry, Rz);
    Ry += 18.0;
    if(Ry >= 360.0) Ry = 0.0;
    MoveObject(fortune, x, y, z, 0.5, Rx, Ry, Rz);
}
stock Rand(min, max)
{
	new a = random(max - min) + min;
	return a;
}