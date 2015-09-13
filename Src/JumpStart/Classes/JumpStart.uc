class JumpStart extends XComMutator
config(JumpStart);

struct TFacility
{
    var XGGameData.EFacilityType iType;
    var int X;
    var int Y;
};

struct TCustomSoldier
{
    var int iClass;
    var XGTacticalGameCoreNativeBase.ESoldierRanks iRank;
    var int iPsiRank;
    var array<XGTacticalGameCoreNativeBase.EPerkType> iPerk;
    var int iCountry;
    var int iGender;
    var string strFirstName;
    var string strLastName;
    var string strNickName;
    var int iRace;
    var int iHead;
    var int iHaircut;
    var int iHairColor;
    var int iFacialHair;
    var int iSkinColor;
    var int iVoice;
    var int iLanguage;
    var int iArmorDeco;
    var int iArmorTint;
    var int iHP;
    var int iAim;
    var int iWill;
    var int iMobility;
    var int iDefense;
    var bool bAttribBonus;

    structdefaultproperties
    {
        iClass=eSC_Sniper
        iRank=eRank_Rookie
        iPsiRank=0
        iCountry=-1
        iGender=0
        strFirstName=""
        strLastName=""
        strNickName=""
        iRace=-1
        iHead=-1
        iHaircut=-1
        iHairColor=-1
        iFacialHair=-1
        iSkinColor=-1
        iVoice=-1
        iLanguage=-1
        iArmorDeco=-1
        iArmorTint=-1
        iHP=0
        iAim=0
        iWill=0
        iMobility=0
        iDefense=0
        bAttribBonus=true
    }
};

struct TBlankSoldier
{
    var int iRank;
    var int iCount;
};

struct TStorageItem
{
    var int iType;
    var int iCount;

    structdefaultproperties
    {
        iCount=1
    }
};

struct TPanic
{
    var int iCountry;
    var int iAmount;
};

struct TAirForce
{
    var int iContinent;
    var XGGameData.EItemType iWeapon;
    var int iKills;
    var bool bFirestorm;

    structdefaultproperties
    {
        iContinent=-1
        iWeapon=eItem_IntWeap_II
        iKills=0
        bFirestorm=false
    }
};

var config int START_DAY;
var config int START_MONTH;
var config int START_YEAR;
var config int SLINGSHOT_START_DAYS;
var config int EXALT_CLUE_COUNT;

var config int CREDITS;
var config int ELERIUM;
var config int ALLOYS;
var config int SCIENTISTS;
var config int ENGINEERS;
var config int MELD;
var config int FRAGMENTS;

var config int ALIEN_RESOURCES;
var config int ALIEN_RESEARCH;
var config int XCOM_THREAT;
var config int RANDOM_BASES;

var config array<XGGameData.ETechType> research;
var config array<int> foundry;
var config array<XGGameData.EOTSTech> ots;
var config array<TFacility> facility;
var config array<TCustomSoldier> soldier;
var config array<TBlankSoldier> blanksoldier;
var config array<TStorageItem> storage;
var config array<TPanic> paniclevel;
var config array<int> satellite;
var config array<int> alienbase;
var config array<TAirForce> airforce;

var int iSoldierIndex;
var int iCountIndex;

function Mutate(String MutateString, PlayerController Sender)
{
    if (MutateString == "XGStrategy.StartNewGame")
    {
        ExecuteJumpStart();
    }
    super.Mutate(MutateString, Sender);
}

function XGGeoscape GEO()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetGeoscape();
}

function XGStrategyAI AI()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetAI();
}

function XGStrategy GAME()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore();
}

function XGTacticalGameCore TACTICAL()
{
    return XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kGameCore;
}

function XComHQPresentationLayer PRES()
{
    return XComHQPresentationLayer(XComHeadquartersController(XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).PlayerController).m_Pres);
}

function XGFacility_Labs LABS()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kLabs;   
}

function XGFacility_Engineering ENGINEERING()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kEngineering;
}

function XGBase Base()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kBase;
}

function XGHeadQuarters HQ()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ();
}

function XGCountry Country(int iCountry)
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetWorld().GetCountry(iCountry);    
}

function XGFacility_Barracks BARRACKS()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kBarracks;
}

function XGSetupPhaseManager SETUPMGR()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().m_kSetupPhaseManager;
}

function XGStorage STOR()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kEngineering.GetStorage();   
}

function XGTechTree TECHTREE()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().GetLabs().m_kTree;
}

function XGFacility_Hangar HANGAR()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetHQ().m_kHangar;
}

function XGItemTree ITEMTREE()
{
    return ENGINEERING().m_kItems;
}

function XComPerkManager PERKS()
{
    return BARRACKS().m_kPerkManager;
}

function XGWorld World()
{
    return XComHeadquartersGame(class'Engine'.static.GetCurrentWorldInfo().Game).GetGameCore().GetWorld();
}

function XGFundingCouncil FC()
{
    return World().m_kFundingCouncil;
}

function XGExaltSimulation EXALT()
{
    return Game().m_kExaltSimulation;
}

// Set up the game state. This function is split into several pieces,
// ExecuteJumpStart, ExecutePhase2, and ExecutePhase3.  This is to avoid
// accidentally triggering the runaway loop detection for extremely big setups
// or use with other mods that are also very complex. 
//
// Particularly, the Race and Gender Aware Namelist mod often triggered runaway
// loops when JumpStart was one enormous function that all executed in the same
// tick as it includes a *lot* of loops and conditionals.
//
// The fix is to split the function, setting timers at the end of each phase to
// execute the next phase. The main thread of execution that calls into the
// mutator will wait in an infinite sleep loop while this happens. When
// jumpstart is finished, it actually jumps directly to the HQ state, breaking
// out of the loop we left ourselves in.
// 
// Custom soldier creation also causes a lot of looping, enough to crash the
// game if enough soldiers are generated at once. Limit custom soldier generation
// to 25 at a time, re-entering the 2nd phase soldier generation function if there
// are still more to create after each chunk.
function ExecuteJumpStart() 
{ 
    local int i;

    for (i = 0; i < research.Length; ++i)
    {
        LABS().m_arrResearched[research[i]] = 1;
    }

    // Set foundry projects
    for (i = 0; i < foundry.Length; ++i)
    {
        ENGINEERING().m_arrFoundryHistory[foundry[i]] = 1;
    }

    // Set OTS projects
    for (i = 0; i < ots.Length; ++i)
    {
        TECHTREE().ApplyOTSTech(ots[i]);
    }

    // Set facilities
    for (i = 0; i < facility.Length; ++i)
    {
        Base().SetFacility(facility[i].iType, facility[i].X, facility[i].Y);
    }
    Base().UpdateTiles();

    iSoldierIndex = 0;
    SetTimer(0.01, false, 'ExecutePhase2');
    return;
}

function ExecutePhase2()
{
    // Set soldiers
 
    local int i;
    local int startIndex;
    local int j;
    local bool isMec;
    local XGTacticalGameCoreData.ESoldierClass eClass;
    local XGTacticalGameCoreNativeBase.EPerkType ePerk;
    local XGStrategySoldier kSoldier;

    if (iSoldierIndex == 0 && (soldier.Length > 0 || blanksoldier.Length > 0))
    {
        BARRACKS().m_arrSoldiers.Length = 0;
    }

    startIndex = iSoldierIndex;
    for (i = iSoldierIndex; (i - startIndex) < 20; ++i)
    {
        if (i >= soldier.Length)
        {
            break;
        }
        kSoldier = Spawn(class'XGStrategySoldier');
        kSoldier.m_kSoldier = BARRACKS().m_kCharGen.CreateTSoldier(EGender(soldier[i].iGender), soldier[i].iCountry);
        kSoldier.m_kChar = TACTICAL().GetTCharacter(2);
        BARRACKS().RandomizeStats(kSoldier);
        STOR().AutoEquip(kSoldier);
        BARRACKS().AddNewSoldier(kSoldier, true);
        kSoldier.SetHQLocation(0, true);

        isMec = (soldier[i].iClass > 30);

        // Pretend this soldier is a human for now, and set them up as such. Then later we
        // will convert to mec.
        if (isMec)
        {
            soldier[i].iClass -= 20;
        }

        if (soldier[i].iRank > eRank_Rookie)
        {

            // Set the class perk. The "tens" digit indicates whether we have
            // the 1st or 2nd option in the tree:
            // 10 or 30 -> First option, 20 or 40 -> second option. We also
            // need to split based on human or mec classes: The
            // class-defining perks for human soldiers are in the tree for
            // the supraclass we we need to mod the class by 10. The
            // class-defining perks for mecs are in the specific class
            // itself.
            if ((soldier[i].iClass / 10) == 1)
            {
                ePerk = PERKS().GetPerkInTree(ESoldierClass(soldier[i].iClass % 10), 1, 0, false);
            }
            else if ((soldier[i].iClass / 10) == 2)
            {
                ePerk = PERKS().GetPerkInTree(ESoldierClass(soldier[i].iClass % 10), 1, 2, false);
            }
            else
            {
                `Log("Error: Failed to find perk for class " $ soldier[i].iClass $ " on soldier " $ i);
                ePerk = ePerk_None;
            }

            // Level up to squaddie to set the supraclass correctly.
            if (ePerk != ePerk_None)
            {
                kSoldier.LevelUp(ESoldierClass(soldier[i].iClass % 10));
            }
            else
            {
                // Level up with a random class
                kSoldier.LevelUp();
            }

            if (ePerk != ePerk_None)
            {
                kSoldier.GivePerk(ePerk);

                // Set the specific class for the soldier:
                // This is done by setting supra-class for the soldier, converting to mec if necessary
                eClass = ESoldierClass(soldier[i].iClass % 10);
                kSoldier.SetSoldierClass(eClass);
                kSoldier.LevelUpStats(((soldier[i].iClass / 10) == 1) ? 256 : 258);
            }

            // Barbie em up
            if (soldier[i].strFirstName != "")
            {
                kSoldier.m_kSoldier.strFirstName = soldier[i].strFirstName;
            }

            if (soldier[i].strLastName != "")
            {
                kSoldier.m_kSoldier.strLastName = soldier[i].strLastName;
            }

            if (soldier[i].strNickName != "")
            {
                kSoldier.m_kSoldier.strNickName = soldier[i].strNickName;
            }

            if (soldier[i].iRace != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iRace = soldier[i].iRace;
            }

            if (soldier[i].iHead != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iHead = soldier[i].iHead;
            }

            if (soldier[i].iHaircut != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iHaircut = soldier[i].iHaircut;
            }

            if (soldier[i].iHairColor != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iHairColor = soldier[i].iHairColor;
            }

            if (soldier[i].iFacialHair != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iFacialHair = soldier[i].iFacialHair;
            }

            if (soldier[i].iSkinColor != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iSkinColor = soldier[i].iSkinColor;
            }

            if (soldier[i].iVoice != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iVoice = soldier[i].iVoice;
            }

            if (soldier[i].iLanguage != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iLanguage = soldier[i].iLanguage;
            }

            if (soldier[i].iArmorDeco != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iArmorDeco = soldier[i].iArmorDeco;
            }

            if (soldier[i].iArmorTint != -1)
            {
                kSoldier.m_kSoldier.kAppearance.iArmorTint = soldier[i].iArmorTint;
            }
        }

        // Level up: we've already done it once.
        for (j = 1; j < soldier[i].iRank; ++j)
        {
            kSoldier.LevelUp();
            if (soldier[i].iClass != -1)
            {
                if (soldier[i].iPerk.Find(PERKS().GetPerkInTree(ESoldierClass(soldier[i].iClass), j+1, 0)) != -1)
                {
                    kSoldier.LevelUpStats((j + 1) << 8);
                }
                if (soldier[i].iPerk.Find(PERKS().GetPerkInTree(ESoldierClass(soldier[i].iClass), j+1, 1)) != -1)
                {
                    kSoldier.LevelUpStats(((j + 1) << 8) | 1);
                }
                if (soldier[i].iPerk.Find(PERKS().GetPerkInTree(ESoldierClass(soldier[i].iClass), j+1, 2)) != -1)
                {
                    kSoldier.LevelUpStats(((j + 1) << 8) | 2);
                }
            }
        }

        if (isMec)
        {
            kSoldier.SetSoldierClass(eSC_Mec);
            kSoldier.LevelUp();

            // Put the Mec in the infirmary and then back again. This forces a refresh
            // of the pawn: without it the display will be bugged in the soldier screen.
            kSoldier.SetStatus(2);
            kSoldier.SetStatus(0);
        }

        // Add psi XP
        if (soldier[i].iPsiRank > 0)
        {
            kSoldier.m_kChar.bHasPsiGift = true;
            kSoldier.m_kSoldier.iPsiRank = soldier[i].iPsiRank;
            kSoldier.m_kSoldier.iPsiXP = TACTICAL().GetPsiXPRequired(soldier[i].iPsiRank);
        }

        // Set remaining perks
        for (j = 0; j < soldier[i].iPerk.Length; ++j)
        {
            kSoldier.GivePerk(soldier[i].iPerk[j]);
        }

        // Set attributes
        if (soldier[i].bAttribBonus) 
        {
            kSoldier.m_kChar.aStats[0] += soldier[i].iHP;
            kSoldier.m_kChar.aStats[1] += soldier[i].iAim;
            kSoldier.m_kChar.aStats[2] += soldier[i].iDefense;
            kSoldier.m_kChar.aStats[3] += soldier[i].iMobility;
            kSoldier.m_kChar.aStats[7] += soldier[i].iWill;
        }
        else
        {
            kSoldier.m_kChar.aStats[0] = soldier[i].iHP;
            kSoldier.m_kChar.aStats[1] = soldier[i].iAim;
            kSoldier.m_kChar.aStats[2] = soldier[i].iDefense;
            kSoldier.m_kChar.aStats[3] = soldier[i].iMobility;
            kSoldier.m_kChar.aStats[7] = soldier[i].iWill;
        }

        ++iSoldierIndex;
    }

    if (iSoldierIndex < soldier.Length)
    {
        SetTimer(0.01, false, 'ExecutePhase2');
    }
    else
    {
        iSoldierIndex = 0;
        iCountIndex = 0;
        SetTimer(0.01, false, 'ExecutePhase3');
    }
}

function ExecutePhase3()
{
    local int i;
    local int j;
    local int k;
    local int startIndex;
    local XGStrategySoldier kSoldier;
    local XGShip_Interceptor kShip;
    local array<XGCountry> availableCountries;
    local XGCountry kCountry;

    // Handle random soldiers.
    while (iSoldierIndex < blanksoldier.Length)
    {
        startIndex = iCountIndex;
        for (j = iCountIndex; (j - startIndex) < 10; ++j)
        {
            if (j >= blanksoldier[iSoldierIndex].iCount)
            {
                break;
            }
            BARRACKS().AddNewSoldiers(1);
            kSoldier = BARRACKS().m_arrSoldiers[BARRACKS().m_arrSoldiers.Length-1];
            for (k = 0; k < blanksoldier[iSoldierIndex].iRank; ++k)
            {
                kSoldier.LevelUp();
            }
            ++iCountIndex;
        }
        
        if (iCountIndex >= blanksoldier[iSoldierIndex].iCount)
        {
            ++iSoldierIndex;
            iCountIndex = 0;
        }

        SetTimer(0.01, false, 'ExecutePhase3');
        return;
    }

    // Go back over all the soldiers and reset their pawns
    foreach BARRACKS().m_arrSoldiers(kSoldier)
    {
        kSoldier.SetHQLocation(0, true);
    }

    // Add storage items
    for (i = 0; i < storage.Length; ++i)
    {
        STOR().AddItem(storage[i].iType, storage[i].iCount);
    }

    // Add resources
    if (CREDITS != -1)
    {
        GAME().AddResource(eResource_Money, CREDITS - GAME().GetResource(eResource_Money));
    }
    if (ELERIUM != -1)
    {
        GAME().AddResource(eResource_Elerium, ELERIUM - GAME().GetResource(eResource_Elerium));
    }
    if (ALLOYS != -1)
    {
        GAME().AddResource(eResource_Alloys, ALLOYS - GAME().GetResource(eResource_Alloys));
    }

    if (ENGINEERS != -1)
    {
        GAME().AddResource(eResource_Engineers, ENGINEERS - GAME().GetResource(eResource_Engineers));
    }

    if (SCIENTISTS != -1)
    {
        GAME().AddResource(eResource_Scientists, SCIENTISTS - GAME().GetResource(eResource_Scientists));
    }

    if (MELD != -1)
    {
        GAME().AddResource(eResource_Meld, MELD - GAME().GetResource(eResource_Meld));
    }

    if (FRAGMENTS != -1)
    {
        STOR().AddItem(eItem_WeaponFragment, FRAGMENTS);
    }

    if (ALIEN_RESEARCH != -1)
    {
        GAME().STAT_SetStat(2, ALIEN_RESEARCH);
    }

    if (ALIEN_RESOURCES != -1)
    {
        GAME().STAT_SetStat(19, ALIEN_RESOURCES);
    }

    if (XCOM_THREAT != -1)
    {
        GAME().STAT_SetStat(21, XCOM_THREAT);
    }

    if (START_DAY != -1 && START_MONTH != -1 && START_YEAR != -1)
    {
        GEO().m_kDateTime.SetTime(0, 0, 0, START_MONTH, START_DAY, START_YEAR);
        GEO().m_iLastMonthPaid = GEO().EncodePayDay();
    }

    if (SLINGSHOT_START_DAYS != -1)
    {
        FC().m_iNextSlingshotDay = GEO().m_kDateTime.DifferenceInDays(AI().m_kStartDate) + SLINGSHOT_START_DAYS;
    }

    if (EXALT_CLUE_COUNT != -1)
    {
        EXALT().BeginSimulation();
        EXALT().m_eSimulationState = 2;
        STOR().AddItem(181, EXALT_CLUE_COUNT);
    }

    // Pretend we've already gone on one mission
    GAME().m_arrMissionTotals[21] = 1;

    // Set up initial panic
    for (i = 0; i < paniclevel.Length; ++i)
    {
        //Note: AddPanic wants a value between 0 and 99. GetPanicBlocks() returns the panic value + 1, so we need to add one more
        // onto the value passed here to account for the extra one returned by GetPanicBlocks.
        Country(paniclevel[i].iCountry).AddPanic(paniclevel[i].iAmount - Country(paniclevel[i].iCountry).GetPanicBlocks() + 1);
    }

    // Set up satellites
    for (i = 0; i < satellite.Length; ++i)
    {
        HQ().AddSatelliteNode(satellite[i], 106, true);
    }

    // Set up alien bases
    for (i = 0; i < alienbase.Length; ++i)
    {
        Country(alienbase[i]).LeaveXComProject();
    }

    // Set up random alien bases
    foreach World().m_arrCountries (kCountry)
    {
        if (kCountry.IsCouncilMember() && !kCountry.LeftXCom())
        {
            availableCountries.AddItem(kCountry);
        }
    }

    for (i = availableCountries.Length-1; i >= 0; --i)
    {
        j = Rand(i+1);
        kCountry = availableCountries[i];
        availableCountries[i] = availablecountries[j];
        availableCountries[j] = kCountry;
    }

    for (i = 0; i < RANDOM_BASES; ++i)
    {
        availableCountries[i].LeaveXComProject();
    }

    // Get rid of any geoscape alerts from panicked countries
    GEO().m_arrAlerts.Length = 0;

  // HQ().Init(true);

    if (airforce.Length > 0)
    {
        i = 0;
        while (HANGAR().GetAllInterceptors().Length > 0)
        {
            HANGAR().RemoveInterceptor(HANGAR().GetAllInterceptors()[0]);
        }
        HANGAR().m_iFirestormCounter = 0;
        HANGAR().m_iInterceptorCounter = 0;
    }


    // Re-initialize the item tree. A vanilla bug causes the ships
    // to not actually get updated the first time around: The item
    // tree is created and initialized by the engineering facility
    // during new game start (CreateFacilities()), but UpdateShips
    // won't update all the ships if ENGINEERING() is null, because
    // it needs to know whether foundry bonuses should be applied
    // to the ship stats. A quirk in how this was written for
    // start game means that engineering is created and initialized
    // before the member is set in the HQ so ENGINEERING() returns
    // none during the new game setup. This is usually OK because
    // the first mission triggers a save/load cycle to get back into
    // strategy mode and this re-inits all the facilities, including
    // updating the item tree.
    //
    // Failure to do this means all ships start with 0 HP and show
    // up as "destroyed". They'll sort themselves out after a few
    // ticks as they update themselves.
    ITEMTREE().UpdateShips();

    for (i = 0; i < airforce.Length; ++i)
    {
        kShip = Spawn(class'XGShip_Interceptor');

        if (airforce[i].iContinent == -1)
        {
            kShip.m_iHomeContinent = HQ().GetContinent();
        }
        else
        {
            kShip.m_iHomeContinent = airforce[i].iContinent;
        }

        if (airforce[i].iContinent == HQ().GetContinent())
        {
            kShip.m_iHomeBay = HANGAR().GetAvailableBay();
        }

        kShip.m_iConfirmedKills = airforce[i].iKills;

        if (airforce[i].bFirestorm)
        {
            kShip.Init(ITEMTREE().GetShip(3));
            HANGAR().m_iFirestormCounter += 1;
        }
        else
        {
            kShip.Init(ITEMTREE().GetShip(1));
            HANGAR().m_iInterceptorCounter += 1;
        }

        if (airforce[i].bFirestorm)
        {
            kShip.m_strCallSign = HANGAR().m_strCallSignFireStorm $ "-" $ string(HANGAR().m_iFirestormCounter);
        }
        else
        {
            kShip.m_strCallSign = HANGAR().m_strCallSignInterceptor $ "-" $ string(HANGAR().m_iInterceptorCounter);
        }

        kShip.EquipWeapon(airforce[i].iWeapon);
        HANGAR().m_arrInts.AddItem(kShip);
        HANGAR().ReorderCraft();
        kShip.UpdateHangarShip();
        HANGAR().UpdateHangarBays();
    }

    HANGAR().Update();

    // Ready to play: Clean up the camera view and states so 
    // we start in the default base view looking at the anthill.
    //
    // Note: Requires the patch file that calls this mutator to
    // go into the HQ state after this function returns.
   
    // Reset camera to the free view (it's currently in the mission
    // control view left over from the Country select UI).
    PRES().GetCamera().StartRoomView('FreeMovement', 1.0);

    // Disable the "loading" animation set by the Country select UI
    PRES().UILoadAnimation(false);

    // Allow input, was disabled by the Country select UI
    PRES().GetHUD().LowerInputGate();

    // Fade the screen back in (it was faded out by the country select
    // UI).
    PRES().GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0,0,0), vect2d(1.0,0.0), 1.0);

    // Tell the AI to refresh itself in light of the new start date and alien/xcom parameters.

    AI().m_arrObjectives.Length = 0;
    AI().AIAddNewObjectives();

    `Log("JumpStart complete!");

    GAME().GoToHQ();
}

