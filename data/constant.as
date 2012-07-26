const DARK_PRI = -1;
const sizeX = 32;
const sizeY = 16;
//const NorSizeX = sizeX+4;
//const NorSizeY = sizeY+4;
var SX = sizeX-10;
var SY = sizeY-10;
//var XDir = sizeX*10;
//var YDir = sizeY*10;
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

const INSPIRE = 1; 


const ISLAND_LAYER = 1; 
const CLOUD_LAYER = 2; 
const FLY_LAYER = 3;

const FLAG_Z = 1;
const LOCK_Z = 2;

const MAX_BUILD_ZORD = 100000;

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
100, 100, 100, 0, 0,
0, 0, 0, 0, 0,
0, 0, 0, 0, 0,
0, 0, 0, 100, 0
);
const BLUE = m_color(
0, 0, 0, 0, 0,
0, 0, 0, 0, 0,
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

initX initY sizeX sizeY
*/
const FullZone = [
//[2205, 486, 723, 363],

[987, 498, 1914, 438],
//[1209, 483, 678, 543],
];
//limit soldier move zone
const TrainZone = [93, 498, 2500, 438];
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



var buildFunc = dict([
[FARM_BUILD, [["photo"], ["sell"]]],
[HOUSE_BUILD, [["photo"], ["sell"]]],
[DECOR_BUILD, [[], []]],
[CASTLE_BUILD, [["photo", "tip"], ["story", "soldier", "collection"]]],
[GOD_BUILD, [["photo"], ["relive", "transfer"]]],
[DRUG_BUILD, [["photo"], ["makeDrug"]]],
[FORGE_SHOP, [["photo"], ["forge"]]],
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
//[423, 732],
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

var addKey = ["people", "cityDefense", "attack", "defense", "health", "gainsilver", "gaincrystal", "gaingold", "exp", 
    "healthBoundary", "physicAttack", "physicDefense", "magicAttack", "magicDefense", "recoverSpeed",];
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
];

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
];
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
    "herb",
    "prescription",
    null,
    "drug[ID].png",
    "",
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


//MSG_ID
const RELIVE_SOL = 0;
const CASTLE_DEF = 1;
const SHOW_DIALOG = 2;
const BUYSOL = 3;//购买卖出士兵 修改士兵数量
const INITDATA_OVER = 4;//初始化用户数据结束
const LEVEL_UP = 5;


const MAX_BUSI_SOLNUM = 50;
const SELL_RATE = 10;

const RECOVER_TIME = 15000;

const CHALLENGE_MON = 0;
const CHALLENGE_FRI = 1;

const ENEMY = -1;
const MAX_SCORE = 9999999;
