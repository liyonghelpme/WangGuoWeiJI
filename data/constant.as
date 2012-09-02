const DARK_PRI = -1;
const SIZEX = 32;
const SIZEY = 16;

//var SX = SIZEX-10;
//var SY = SIZEY-10;

const AddX = 15;
const AddY = 7;
const MapWidth = 3000;
const MapHeight = 1120;
const NotBigZone = 0;
const InZone = 1;
const NotSmallZone = 2;

const Moving = 0;
const Free = 1;
const Working = 2;
const ShowMenuing = 4;
const Wait_Lock = 5;

//植物的生长状态
const SOW = 0;
const SEED = 1;
const MEDIUM = 2;
const MATURE = 3;
const ROT = 4;

//经营页面士兵状态
const SOL_FREE = 0;
const SOL_MOVE = 1;
const SOL_WAIT = 2;
const SOL_POS = 3;

const INSPIRE = 1; 


const ISLAND_LAYER = 1; 
const CLOUD_LAYER = 2; 
const FLY_LAYER = 3;

const FLAG_Z = 1;
const LOCK_Z = 2;

const MAX_BUILD_ZORD = 100000;

//buildFunc
const FARM_BUILD = 0;
const HOUSE_BUILD = 1;
const DECOR_BUILD = 2;
const CASTLE_BUILD = 3;
const GOD_BUILD = 4;
const DRUG_BUILD = 5;
const FORGE_SHOP = 6;
const BUSI_SOL = 7;
//木牌 不可移动 不再allBuildings 中 
const STATIC_BOARD = 8;
const MINE_KIND = 9;
const LOVE_TREE = 10;


const GRAY = m_color(
70, 20, 10, 0, 0,
70, 20, 10, 0, 0,
70, 20, 10, 0, 0,
0, 0, 0, 100, 0
);
const BLACK = m_color(
0, 0, 0, 0, 0,
0, 0, 0, 0, 0,
0, 0, 0, 0, 0,
0, 0, 0, 100, 0
);
const RED = m_color(
0, 0, 0, 0, 10000,
0, 0, 0, 0, 0,
0, 0, 0, 0, 0,
0, 0, 0, 100, 0
);
const BLUE = m_color(
0, 0, 0, 0, 0,
0, 0, 0, 0, 0,
0, 0, 0, 0, 10000,
0, 0, 0, 100, 0
);
const FEA_RED = m_color(
100, 100, 100, 0, 0,
0, 50, 0, 0, 0,
0, 0, 50, 0, 0,
0, 0, 0, 100, 0
);
const FEA_BLUE = m_color(
50, 0, 0, 0, 0,
0, 50, 0, 0, 0,
100, 100, 100, 0, 0,
0, 0, 0, 100, 0
);
const WHITE = m_color(
100, 0, 0, 0, 0,
0, 100, 0, 0, 0,
0, 0, 100, 0, 0,
0, 0, 0, 100, 0
);


/*
需要同时设置ZoneCenter 和FullZone 控制建筑物显示区域
可能需要提供一个接口 用于确定建筑物类型 和建筑活动区域
允许用户建造在任意的区域

initX initY SIZEX SIZEY
*/
const FullZone = [
//[2205, 486, 723, 363],

[987, 498, 1914, 438],
//[1209, 483, 678, 543],
];
//limit soldier move zone
const TrainZone = [100, 498, 2400, 400];
//then check in which zone
const FarmZone = [
[2193, 432, 735, 393],
[2298, 801, 531, 177],
[2082, 729, 138, 96],
[2118, 450, 87, 69],
];



//id coin crystal cae possible
/*
var fallThings = [
[0, 5, 0, 0, 20], [1, 10, 0, 0, 15], [2, 20, 0, 0, 15], 
[3, 30, 0, 0, 15], [4, 40, 0, 0, 15], [5, 50, 0, 0, 5],
[6, 0, 0, 1, 2], [7, 0, 1, 0, 1], [8, 0, 1, 0, 2], 
[9, 100, 0, 0, 10]];
*/
//0-9 id


/*
有没有必要不同的类型的建筑物拥有相同的属性 这个在后台的数据处理中有一定的优势
可以通过不同的访问函数来构造相应的hash表
*/
//id = 10 静态属性
//dir = 0 dir = 1 动态属性 决定建筑物 朝向
//id costSilver costCrystal costGold kind/farm/normal-->whichZone sx sy name hasAnimate funcId 可否旋转方向 需要等级 增加人口上限 增加防御力



//id costSilver costCrystal costGold name addAtt addDef 
//动画的锚点 在50 50
/*
类型0 逐帧动画
类型1 旋转动画360 需要时间
变换建筑物朝向 需要相应的变换动画图片
动画的锚点
pictures position time type 0/animate 1rotate 2selfAnimate anchor
*/
const BUILD_ANI_OBJ = 0;
const BUILD_ANI_ROT = 1;
const BUILD_ANI_ANI = 2;
var buildAnimate = dict([
    [1, [["mb0.png", "mb1.png", "mb2.png", "mb3.png", "mb4.png", "mb5.png", "mb6.png", "mb7.png"], [62, 49], 2000, 0, [50, 100]]],
    [140, [["f0.png"], [100, 100], 2000, 1, [50, 50]]],
    [141, [["f1.png"], [100, 100], 2000, 1, [50, 50]]],
    [202, [["god0.png", "god1.png","god2.png","god3.png","god4.png","god5.png","god6.png","god7.png","god8.png"], [51, 23], 2000, 0, [50, 50]]],
    [203, [["god0.png", "god1.png","god2.png","god3.png","god4.png","god5.png","god6.png","god7.png","god8.png"], [140, 2], 2000, 0, [50, 50]]],
    [204, [["drugStore0.png",  "drugStore1.png","drugStore2.png","drugStore3.png","drugStore4.png","drugStore5.png","drugStore6.png","drugStore7.png","drugStore8.png","drugStore9.png"], [0, 75], 2000, 0, [0, 0]]],
    [205, [["drugStore0.png",  "drugStore1.png","drugStore2.png","drugStore3.png","drugStore4.png","drugStore5.png","drugStore6.png","drugStore7.png","drugStore8.png","drugStore9.png"], [110, 74], 2000, 0, [0, 0]]],
    [206, [["forgeShop0.png", "forgeShop1.png", "forgeShop2.png", "forgeShop3.png", "forgeShop4.png", "forgeShop5.png", "forgeShop6.png", "forgeShop7.png", "forgeShop8.png", "forgeShop9.png" ], [34, 5], 2000, 0, [0, 0]]],
    [207, [["forgeShop0.png", "forgeShop1.png", "forgeShop2.png", "forgeShop3.png", "forgeShop4.png", "forgeShop5.png", "forgeShop6.png", "forgeShop7.png", "forgeShop8.png", "forgeShop9.png"], [130, 7], 2000, 0, [0, 0]]],
    [162, [["build162.png", "build162a1.png", "build162a2.png", "build162a3.png", "build162a4.png"], [0, 0], 2000, 2, [0, 0]]],
]);

//skillId
//animate time plistFile
var skillAnimate = dict([
    [0, [["skill0.plist/skill0a0.png", "skill0.plist/skill0a1.png", "skill0.plist/skill0a2.png", "skill0.plist/skill0a3.png", "skill0.plist/skill0a4.png", "skill0.plist/skill0a5.png", "skill0.plist/skill0a6.png", "skill0.plist/skill0a7.png", "skill0.plist/skill0a8.png", "skill0.plist/skill0a9.png", "skill0.plist/skill0a10.png"], 1500, "skill0.plist"]] ,
    [1, [["skill1.plist/skill1a0.png", "skill1.plist/skill1a1.png", "skill1.plist/skill1a2.png", "skill1.plist/skill1a3.png", "skill1.plist/skill1a4.png", "skill1.plist/skill1a5.png", "skill1.plist/skill1a6.png", "skill1.plist/skill1a7.png", "skill1.plist/skill1a8.png", "skill1.plist/skill1a9.png", "skill1.plist/skill1a10.png"], 1500, "skill1.plist"]] ,
    [2, [["skill2.plist/skill2a0.png", "skill2.plist/skill2a1.png", "skill2.plist/skill2a2.png", "skill2.plist/skill2a3.png", "skill2.plist/skill2a4.png", "skill2.plist/skill2a5.png", "skill2.plist/skill2a6.png", "skill2.plist/skill2a7.png", "skill2.plist/skill2a8.png", "skill2.plist/skill2a9.png", "skill2.plist/skill2a10.png", "skill2.plist/skill2a11.png", "skill2.plist/skill2a12.png", "skill2.plist/skill2a13.png"], 1500, "skill2.plist"]] ,
    [3, [["skill3.plist/skill3a0.png", "skill3.plist/skill3a1.png", "skill3.plist/skill3a2.png", "skill3.plist/skill3a3.png", "skill3.plist/skill3a4.png", "skill3.plist/skill3a5.png", "skill3.plist/skill3a6.png", "skill3.plist/skill3a7.png", "skill3.plist/skill3a8.png", "skill3.plist/skill3a9.png", "skill3.plist/skill3a10.png", "skill3.plist/skill3a11.png", "skill3.plist/skill3a12.png"], 1500, "skill3.plist"]] ,
    [4, [["skill4.plist/skill4a0.png", "skill4.plist/skill4a1.png", "skill4.plist/skill4a2.png", "skill4.plist/skill4a3.png", "skill4.plist/skill4a4.png", "skill4.plist/skill4a5.png", "skill4.plist/skill4a6.png", "skill4.plist/skill4a7.png", "skill4.plist/skill4a8.png", "skill4.plist/skill4a9.png", "skill4.plist/skill4a10.png", "skill4.plist/skill4a11.png", "skill4.plist/skill4a12.png", "skill4.plist/skill4a13.png", "skill4.plist/skill4a14.png", "skill4.plist/skill4a15.png", "skill4.plist/skill4a16.png", "skill4.plist/skill4a17.png", "skill4.plist/skill4a18.png", "skill4.plist/skill4a19.png", "skill4.plist/skill4a20.png", "skill4.plist/skill4a21.png", "skill4.plist/skill4a22.png", "skill4.plist/skill4a23.png", "skill4.plist/skill4a24.png", "skill4.plist/skill4a25.png", "skill4.plist/skill4a26.png", "skill4.plist/skill4a27.png"], 1500, "skill4.plist"]] ,
    [5, [["skill5.plist/skill5a0.png", "skill5.plist/skill5a1.png", "skill5.plist/skill5a2.png", "skill5.plist/skill5a3.png", "skill5.plist/skill5a4.png", "skill5.plist/skill5a5.png", "skill5.plist/skill5a6.png", "skill5.plist/skill5a7.png", "skill5.plist/skill5a8.png", "skill5.plist/skill5a9.png"], 1500, "skill5.plist"]] ,
    [6, [["skill6.plist/skill6a0.png", "skill6.plist/skill6a1.png", "skill6.plist/skill6a2.png", "skill6.plist/skill6a3.png", "skill6.plist/skill6a4.png", "skill6.plist/skill6a5.png", "skill6.plist/skill6a6.png", "skill6.plist/skill6a7.png", "skill6.plist/skill6a8.png", "skill6.plist/skill6a9.png", "skill6.plist/skill6a10.png", "skill6.plist/skill6a11.png", "skill6.plist/skill6a12.png", "skill6.plist/skill6a13.png"], 1500, "skill6.plist"]] ,
    [7, [["skill7.plist/skill7a0.png", "skill7.plist/skill7a1.png", "skill7.plist/skill7a2.png", "skill7.plist/skill7a3.png", "skill7.plist/skill7a4.png", "skill7.plist/skill7a5.png", "skill7.plist/skill7a6.png", "skill7.plist/skill7a7.png", "skill7.plist/skill7a8.png", "skill7.plist/skill7a9.png", "skill7.plist/skill7a10.png", "skill7.plist/skill7a11.png", "skill7.plist/skill7a12.png", "skill7.plist/skill7a13.png", "skill7.plist/skill7a14.png", "skill7.plist/skill7a15.png", "skill7.plist/skill7a16.png", "skill7.plist/skill7a17.png", "skill7.plist/skill7a18.png", "skill7.plist/skill7a19.png", "skill7.plist/skill7a20.png"], 1500, "skill7.plist"]] ,
    [8, [["skill8.plist/skill8a0.png", "skill8.plist/skill8a1.png", "skill8.plist/skill8a2.png", "skill8.plist/skill8a3.png", "skill8.plist/skill8a4.png", "skill8.plist/skill8a5.png", "skill8.plist/skill8a6.png", "skill8.plist/skill8a7.png", "skill8.plist/skill8a8.png", "skill8.plist/skill8a9.png", "skill8.plist/skill8a10.png", "skill8.plist/skill8a11.png", "skill8.plist/skill8a12.png", "skill8.plist/skill8a13.png", "skill8.plist/skill8a14.png", "skill8.plist/skill8a15.png", "skill8.plist/skill8a16.png"], 1500, "skill8.plist"]] ,
    [9, [["skill9.plist/skill9a0.png", "skill9.plist/skill9a1.png", "skill9.plist/skill9a2.png", "skill9.plist/skill9a3.png", "skill9.plist/skill9a4.png", "skill9.plist/skill9a5.png", "skill9.plist/skill9a6.png", "skill9.plist/skill9a7.png", "skill9.plist/skill9a8.png", "skill9.plist/skill9a9.png", "skill9.plist/skill9a10.png", "skill9.plist/skill9a11.png", "skill9.plist/skill9a12.png", "skill9.plist/skill9a13.png", "skill9.plist/skill9a14.png", "skill9.plist/skill9a15.png", "skill9.plist/skill9a16.png", "skill9.plist/skill9a17.png", "skill9.plist/skill9a18.png", "skill9.plist/skill9a19.png"], 1500, "skill9.plist"]] ,
    [10, [["skill10.plist/skill10a0.png", "skill10.plist/skill10a1.png", "skill10.plist/skill10a2.png", "skill10.plist/skill10a3.png", "skill10.plist/skill10a4.png", "skill10.plist/skill10a5.png", "skill10.plist/skill10a6.png", "skill10.plist/skill10a7.png", "skill10.plist/skill10a8.png", "skill10.plist/skill10a9.png"], 1500, "skill10.plist"]] ,

    [11, [["skill10.plist/skill10a0.png", "skill10.plist/skill10a1.png", "skill10.plist/skill10a2.png", "skill10.plist/skill10a3.png", "skill10.plist/skill10a4.png", "skill10.plist/skill10a5.png", "skill10.plist/skill10a6.png", "skill10.plist/skill10a7.png", "skill10.plist/skill10a8.png", "skill10.plist/skill10a9.png"], 1500, "skill10.plist"]] ,

    [16, [["skill10.plist/skill10a0.png", "skill10.plist/skill10a1.png", "skill10.plist/skill10a2.png", "skill10.plist/skill10a3.png", "skill10.plist/skill10a4.png", "skill10.plist/skill10a5.png", "skill10.plist/skill10a6.png", "skill10.plist/skill10a7.png", "skill10.plist/skill10a8.png", "skill10.plist/skill10a9.png"], 1500, "skill10.plist"]] ,
    [15, [
["skill15a0.png", "skill15a1.png", "skill15a2.png", "skill15a3.png", "skill15a4.png", "skill15a5.png", "skill15a6.png", "skill15a7.png", "skill15a8.png", "skill15a9.png", "skill15a10.png", "skill15a11.png", "skill15a12.png", "skill15a13.png", "skill15a14.png"]

    , 1500]],


]);


var buildFunc = dict([
[FARM_BUILD, [["photo"], ["sell"]]],
[HOUSE_BUILD, [["photo"], ["sell"]]],
[DECOR_BUILD, [[], []]],
[CASTLE_BUILD, [["photo", "tip"], ["story", "soldier", "collection"]]],
[GOD_BUILD, [["photo", "train"], ["relive", "transfer"]]],
[DRUG_BUILD, [["photo"], ["makeDrug", "allDrug"]]],
[FORGE_SHOP, [["photo"], ["forge", "allEquip"]]],
[MINE_KIND, [["photo"], ["upgrade"]]],
[LOVE_TREE, [["photo"], ["love", "loveRank"]]],
]);


/*
森林
洞穴
湖泊 
平原 多个动画的序列位置 可能很多 需要小心
雪地
一个地图 多个动画
一个动画 多个位置
*/
var mapAllAnimate = dict([
    [0, [0]],
    [1, [1]],
    [2, [2, 4]],
    [3, [3]],
    [4, []],
]);
function ani0()
{
    return animate(2000, "m0a0.png", "m0a1.png","m0a2.png","m0a3.png","m0a4.png","m0a5.png","m0a6.png","m0a7.png");
}
function ani1()
{
    return animate(2000, "m3a0.png", "m3a1.png", "m3a2.png", "m3a3.png", "m3a4.png", "m3a5.png", "m3a6.png", "m3a7.png", "m3a8.png", "m3a9.png", "m3a10.png", "m3a11.png", "m3a12.png", "m3a13.png", "m3a14.png", "m3a15.png", "m3a16.png", "m3a17.png", "m3a18.png", "m3a19.png");
}

function ani2()
{
    return animate(2000, "m2a0.png", "m2a1.png","m2a2.png","m2a3.png","m2a4.png","m2a5.png","m2a6.png","m2a7.png","m2a8.png","m2a9.png","m2a10.png","m2a11.png","m2a12.png","m2a13.png","m2a14.png","m2a15.png","m2a16.png","m2a17.png","m2a18.png");
}

function ani3()
{
    return animate(2000, "m1a0.png", "m1a1.png", "m1a2.png", ARGB_8888);
}
function ani4()
{
    return animate(2000, "m4a0.png", "m4a1.png","m4a2.png","m4a3.png","m4a4.png","m4a5.png","m4a6.png","m4a7.png","m4a8.png","m4a9.png","m4a10.png","m4a11.png","m4a12.png","m4a13.png","m4a14.png","m4a15.png","m4a16.png","m4a17.png","m4a18.png","m4a19.png");
}
var mapAnimate = dict([
    [0, [ani0, [646+22, -62+61]]],
    [1, [ani1, [816, -15]]],
    [2, [ani2, [142, 293, 480, 293, 816, 156, 302, 140, 566, 92, 228, 26]]],
    [3, [ani3, [777, 58]]],
    [4, [ani4, [657, 306, 449, 226, 759, 178]]]
]);

/*
kind = 0 农田
kind = 1 民居
kind = 2 装饰
kind = 3 主要建筑物
*/
const FARM_ZONE = 0;
const HOUSE_ZONE = 1;
const DECOR_ZONE = 2;
const MAIN_ZONE = 3;
var ZoneCenter = [
[2526, 626],
[1533, 726],
[1533, 726],
[1533, 726],
[1533, 726],
];

//不同等级名字图片 一些基本属性不同+ 还要加上 装备的属性 
//基本图片 和 等级相关的图片 
//需要的等级和士兵等级不同 
//基本属性 升级之后的基本属性也不同 soldierLevel 
/*
士兵专职之后, id 不同, 基本属性也不同, 图片也不同
ss id m/a num
士兵有动态的装备属性和
我们所有的士兵的体积大小需要有一个分类
小体积 中等体积 大体积

*/
var MIN_VOL = 40;
var MID_VOL = 120;
var MAX_VOL = 150;


var magicAnimate = dict([
    [60, [["fire0.png", "fire1.png","fire2.png","fire3.png","fire4.png","fire5.png","fire6.png"], 1500, [-20, 34]]],
    [170, [["s170e0.png","s170e1.png","s170e2.png","s170e3.png","s170e4.png","s170e5.png","s170e6.png","s170e7.png"], 1500, [-20, 34]]],
    [90, [["music0.png", "music1.png","music2.png","music3.png","music4.png"], 1000, [-20, 34]]],
]);

//相对于士兵的anchor 50 100的偏移值 
//动画anchor 50 50
var soldierAnimate = dict([
    [50, [["soldier50ani0.png", "soldier50ani1.png","soldier50ani2.png","soldier50ani3.png","soldier50ani4.png","soldier50ani5.png"], [-50, 0], 800]],
]);

var moveAnimate = dict([
[0, [["ss0m0.png", "ss0m1.png","ss0m2.png","ss0m3.png","ss0m4.png","ss0m5.png","ss0m6.png"], 2000] ],
]);

var attAnimate = dict([
[0, [["ss0a0.png", "ss0a1.png","ss0a2.png","ss0a3.png","ss0a4.png","ss0a5.png","ss0a6.png","ss0a7.png"], 2000] ],
]);

/*
kind = 1 攻击特效
*/
var attEffect = dict([
[13, [["ss10e0.png", "ss10e0.png", "ss10e0.png", "ss10e0.png", "ss10e0.png", "ss10e0.png", "ss10e0.png", "ss10e0.png"], [-32, 15], 2000]]
]);

//getGain 复活等级
var addKey = ["people", "cityDefense", "attack", "defense", "health", "gainsilver", "gaincrystal", "gaingold", "exp", 
    "healthBoundary", "physicAttack", "physicDefense", "magicAttack", "magicDefense", "recoverSpeed",
    "percentHealth", "percentHealthBoundary", "percentAttack", "percentDefense", "effectLevel",
    ];

//getCost
var costKey = ["silver", "gold", "crystal", "papaya", "free"];

//必须name 引用string中内容
var freeKey = ["id", "name", "free"];
var freeData = dict([
[0, [0, "free0", 1]],
]);


/*
getData 返回相应的数据
修改Keys CostData GoodsPre KindPre
增加新的数据 描述 key和数据
 */
const BUILD = 0;
const EQUIP = 1;
const DRUG = 2;
const GOLD = 3;
const SILVER = 4;
const CRYSTAL = 5;
const PLANT = 6;
const SOLDIER = 7;
const FREE_GOLD = 8;
const TASK = 9;
const HERB = 10;
const PRESCRIPTION = 11;
const NOTIFY = 12;
const RELIVE = 13; //打开士兵的复活药水页面
const FALL_THING = 14;
const TREASURE_STONE = 15;
const MAGIC_STONE = 16;
const SKILL = 17;
const STATUS = 18;



var Keys = [
    buildingKey,
    equipKey,
    drugKey,
    goldKey,
    silverKey,
    crystalKey,
    plantKey,
    soldierKey,
    freeKey,
    taskKey,
    herbKey,
    prescriptionKey,
    null,
    drugKey,
    fallThingKey,
    goodsListKey,
    magicStoneKey,
    skillsKey,
    statusPossibleKey,
];
var CostData = [
    buildingData,
    equipData,
    drugData,
    goldData,
    silverData,
    crystalData,
    plantData,
    soldierData,
    freeData,
    taskData,
    herbData,
    prescriptionData,
    null,
    drugData,
    fallThingData,
    goodsListData,
    magicStoneData,
    skillsData,
    statusPossibleData,
];

/*
var GoodsPre = [
    "build[ID]",
    "equip[ID]",
    "drug[ID]",
    "goldBig",
    "silverBig",
    "crystalBig",
    "Wplant[ID]",
    "soldier[ID]",
    "goldBig",
    "task",
    "herb",
    "prescription",
    null,
    "drug[ID]",
    "",
    "stone[ID]",
    "magicStone[ID]",
    "skill[ID]",
];
*/
var KindsPre = [
    "build[ID].png",
    "equip[ID].png",
    "drug[ID].png",
    "goldBig.png",
    "silverBig.png",
    "crystalBig.png",
    "Wplant[ID].png",
    "soldier[ID].png",
    "goldBig.png",
    "task",
    "herb[ID].png",
    "prescription",
    null,
    "drug[ID].png",
    "",
    "stone[ID].png",
    "magicStone[ID].png",
    "skill[ID].png",
    "status[ID].png",
];

//260048  木牌位置
var obstacleBlock = 
dict(

[
[260048, 1], [250047, 1], [240046, 1],  [260046, 1], [250045, 1], [270045, 1], [270047, 1], [280046, 1],

[330055, 1], [330053, 1], [330051, 1], [650057, 1], [620052, 1], [650053, 1], [640042, 1], [660040, 1], [300028, 1], [640052, 1], [290045, 1], [290041, 1], [290043, 1], [650041, 1], [610031, 1], [640054, 1], [660054, 1], [660056, 1], [320062, 1], [280040, 1], [280042, 1], [320060, 1], [630037, 1], [620050, 1], [650055, 1], [630051, 1], [630053, 1], [280038, 1], [600046, 1], [600048, 1], [280034, 1], [280032, 1], [630043, 1], [610051, 1], [310027, 1], [640036, 1], [640038, 1], [600050, 1], [650039, 1], [610049, 1], [610045, 1], [610047, 1], [600030, 1], [300060, 1], [300062, 1], [630031, 1], [600028, 1], [270039, 1], [270033, 1], [310043, 1], [310041, 1], [310047, 1], [310045, 1], [310049, 1], [330061, 1], [300054, 1], [300050, 1], [300052, 1], [270041, 1], [290031, 1], [290033, 1], [650035, 1], [650037, 1], [290039, 1], [310051, 1], [310053, 1], [310055, 1], [310059, 1], [320052, 1], [300042, 1], [320050, 1], [300040, 1], [300046, 1], [320054, 1], [300044, 1], [300048, 1], [290027, 1], [290029, 1], [330049, 1], [660038, 1], [670055, 1], [670057, 1], [310061, 1], [660034, 1], [320046, 1], [320048, 1], [590047, 1], [300030, 1], [590049, 1]]


);



//左边的防御装置 anchor 0 0 的位置   右边防御装置的位置 掉落物品类别0-21 药材 100-109 矿石 概率 掉落数量1个
var mapInfo = dict([
    [0, [[7, 115], [1063, 112]]],
    [1, [[5, 118], [1066, 110]]],
    [2, [[0, 91], [1047, 120]]],
    [3, [[5, 120], [1060, 124]]],
    [4, [[3, 45+28], [1014+20, 65+37]]],
    [5, [[-5, 11], [1021, 68]]],
]);

const MAP_INITY = 130;
const MAP_INITX = 0;
const MAP_OFFX = 85;
const MAP_OFFY = 85;
const MAP_WIDTH = 12;
const MAP_HEIGHT = 5;

const MIN_SOL_ZORD = 0;
const MAX_SOL_ZORD = 100000;

const MAP_SOL_FREE = 0;
const MAP_SOL_ARRANGE = 1;
const MAP_SOL_MOVE = 2;
const MAP_SOL_TOUCH = 4;
const MAP_SOL_ATTACK = 5;
const MAP_SOL_DEAD = 6;
const MAP_SOL_WATI_TOUCH = 7;
const MAP_SOL_DEFENSE = 8;
const MAP_SOL_SAVE = 9;
const MAP_SOL_POS = 10;


//MSG_ID
const RELIVE_SOL = 0;
const CASTLE_DEF = 1;
const SHOW_DIALOG = 2;
const BUYSOL = 3;//购买卖出士兵 修改士兵数量
const INITDATA_OVER = 4;//初始化用户数据结束
const LEVEL_UP = 5;
const SOL_TRANSFER = 6;//sid
const SOL_UNLOADTHING = 7; //sid
const UPDATE_EQUIP = 8; //更新装备数据
const UPDATE_TREASURE = 9; //更新宝石数量
const UPDATE_SKILL = 10;
const UPDATE_MAGIC_STONE = 11;
const UPDATE_SKILL_STATE = 12; //战斗地图更新 技能状态  开始释放 确定目标 结束释放

//开始技能选择目标 释放技能选择目标结束
const MAP_START_SKILL = 0;
const MAP_FINISH_SKILL = 1;
const MAP_ARRANGE = 2;


const MAX_BUSI_SOLNUM = 50;
const SELL_RATE = 10;

/*
士兵生命值回复 可以缓冲 1分钟再统一发送状态请求
*/
const RECOVER_TIME = 5000;

const CHALLENGE_MON = 0;
const CHALLENGE_FRI = 1;
const CHALLENGE_SELF = 2;//怪兽布局 由数据库monX monY 决定
const CHALLENGE_NEIBOR = 3;
const CHALLENGE_TRAIN = 4;


const ENEMY = -1;
const MAX_SCORE = 9999999;

//0-4 闯关页面
const MAX_CHALLENGE = 4;

const MAKE_DRUG = 0;
const MAKE_EQUIP = 1;

const MEDICINE = 0;
const ORE = 1;

const ONCE_TASK = 0;
const CYCLE_TASK = 1;
const DAILY_TASK = 2;


//邮件信息类型
const NEIBOR_REQ = 0;
const GIFT_REQ = 1;

const VISIT_PAPAYA = 0;
const VISIT_NEIBOR = 1;
const VISIT_RECOMMAND = 2;
const VISIT_RANK = 3;

const UNVISIT_FRIEND = -1;
const EMPTY_SEAT = -2;
const ADD_NEIBOR_MAX = -3;

const FRIEND_CRY = 15;
const PAPAYA_CRY = 10;
const NEIBOR_CRY = 3;//3* neibornum

const ADD_MAX_CAE = 10;
const MINE_BUILD = 300;
const MINE_BID = -1;

const MINE_BEGIN_LEVEL = 6;

const PLAN_BUILDING = 0;
const PLAN_SOLDIER = 1;

const MAX_EQUIP_LEVEL = 12;

const ROUND_MAP_NUM = 5;//闯关地图的数量 每关旗帜的数量由 LevelSelect 中旗帜的数量决定

const LINE_SKILL = 0;
const SINGLE_ATTACK_SKILL = 1;
const MULTI_ATTACK_SKILL = 2;
const MAKEUP_SKILL = 3;
const SPIN_SKILL = 4;
const SAVE_SKILL = 5;
const HEAL_SKILL = 6;
const MULTI_HEAL_SKILL = 7;
const USE_DRUG_SKILL = 8;

const DRUG_SKILL_ID = 16;

const MYCOLOR = 0;
const ENECOLOR = 1;

const SKILL_MIN_COLDTIME = 5000;

const DRUG_COLD_TIME = 1000;//ms

//soldier type
const CLOSE_FIGHTING = 0;
const LONG_DISTANCE = 1;
const MAGIC = 2;


/*
//soldierDialog 士兵对话框
const ALL_SOL = 0;
const DEAD_SOl = 1;
const TRANSFER_SOL = 2;
*/


const SETPOS = 0;
const WAIT = 1;
const CLOSEUP = 2; 
const SPEAK_NOW = 3;
const DARK_BACK = 4;


const HeroPos = dict([
    [480, [576, 355]],
    [590, [496, 454]],
    [550, [867, 427]],
    [440, [550, 574]],
]);

const WEAPON_SOL = 0;
const DEFENSE_SOL = 1;
const MAGIAN = 2;
const HUNTER = 3;
const UNDERLING = 4;
const HEALTH_SOL = 5;
const ATTACK_SOL = 6;
const MAGIC_SOL = 7;
const PHYSIC_SOL = 8;
const ELITE = 9;
const BOSS = 10;

//这两个分类和上面的分类有重叠 分别是 isHero solOrMon 
//普通士兵 不是 英雄 不是 怪兽
//英雄
//怪兽
const NORMAL_SOL = 0;
const HERO = 1;
const MONSTER = 2;

const EASY = 0;
const MID = 1;
const DIFFICULT = 2;
const ABNORMAL = 3;

//英雄也分多种类型 只是 在基本属性之上增加了英雄系数
//英雄应该和普通兵种一样 是一种兵种 而不应该独立增加一个属性的计算步骤
//英雄的敌人有额外的属性加成 比如说攻击力加成
//和当前士兵相同档次 的 某种职业的士兵 随机出现
//只是有个不同的士兵能力系数
//怪兽应该是相同档次的
//不是英雄 不是 怪兽
var soldierMonsterTab = dict([
   [NORMAL_SOL, [[UNDERLING], [HEALTH_SOL, ATTACK_SOL], [MAGIC_SOL, PHYSIC_SOL], [ELITE]]],
   [HERO, [[UNDERLING, HEALTH_SOL, ATTACK_SOL, MAGIC_SOL, PHYSIC_SOL], [ELITE], [ELITE], [BOSS]]],
   [MONSTER, []],//怪兽同类
]);

//普通士兵 难度0 攻击力属性100
//英雄 攻击力属性
//怪兽攻击力属性
const ATTACK_RATE = dict([
[NORMAL_SOL, [100, 100, 100, 100]],
[HERO, [200, 200, 300, 100]],
[MONSTER, [80, 100, 110, 150]],
]);

const MONNUM = [
50, 80, 100, 200,
];

const GRASS_MAP = 0;
const PLANE_MAP = 1;
const LAKE_MAP = 2;
const CAVE_MAP = 3;
const SNOWFIELD_MAP = 4;

const SMOKE_SKILL_ID = 9;

//需要特定条件状态
const NO_STATUS = -1;
//可以清除
const BLOOD_STATUS = 0;
const HEART_STATUS = 1;
const TRANSFER_STATUS = 2;

//随机状态 可以清除
const INSPIRE_STATUS = 3;
const SUNFLOWER_STATUS = 4;
const SUN_STATUS = 5;
const FLOWER_STATUS = 6;
const STAR_STATUS = 7;
const MOON_STATUS = 8;
const GATHER_STATUS = 9;

const SOL_GAME = 1;
const MONEY_GAME = 2;

const LOVE_TREE_ID = 208;//等级提升 则 ID 变化
