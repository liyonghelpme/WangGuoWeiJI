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
*/
const FullZone = [
//[2205, 486, 723, 363],

[93, 498, 2800, 438],
//[1209, 483, 678, 543],
];
const TrainZone = [93, 498, 772, 550];
//then check in which zone
const FarmZone = [
[2193, 432, 735, 393],
[2298, 801, 531, 177],
[2082, 729, 138, 96],
[2118, 450, 87, 69],
];



//id coin crystal cae possible
var fallThings = [
[0, 5, 0, 0, 10], [1, 10, 0, 0, 10], [2, 20, 0, 0, 10], 
[3, 30, 0, 0, 10], [4, 40, 0, 0, 10], [5, 50, 0, 0, 10],
[6, 0, 0, 1, 50], [7, 0, 2, 0, 100], [8, 0, 1, 0, 100], 
[9, 100, 0, 0, 50]];

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
*/
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
]);
var buildFunc = dict([
[FARM_BUILD, [["photo"], ["acc", "sell"]]],
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
    return animate(2000, "m1a0.png", "m1a1.png", "m1a2.png", ARGB_8888);
}
function ani2()
{
    return animate(2000, "m2a0.png", "m2a1.png","m2a2.png","m2a3.png","m2a4.png","m2a5.png","m2a6.png","m2a7.png","m2a8.png","m2a9.png","m2a10.png","m2a11.png","m2a12.png","m2a13.png","m2a14.png","m2a15.png","m2a16.png","m2a17.png","m2a18.png");
}
function ani3()
{
    return animate(2000, "m3a0.png", "m3a1.png", "m3a2.png", "m3a3.png", "m3a4.png", "m3a5.png", "m3a6.png", "m3a7.png", "m3a8.png", "m3a9.png", "m3a10.png", "m3a11.png", "m3a12.png", "m3a13.png", "m3a14.png", "m3a15.png", "m3a16.png", "m3a17.png", "m3a18.png", "m3a19.png");
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
var ZoneCenter = [
[2526, 626],
[423, 732],
[1533, 726],
[1533, 726],
];

var buildingKey = ["funcs", "kind", "sx", "cityDefense", "name", "gold", "level", "people", "sy", "id", "hasAni", "crystal", "changeDir", "silver"] ;
var buildingData = dict( [[0, [0, 0, 2, 0, "building0", 0, 5, 0, 2, 0, 0, 0, 0, 100]], [1, [0, 0, 2, 0, "building1", 0, 10, 0, 2, 1, 1, 100, 0, 0]], [10, [1, 1, 2, 0, "building10", 0, 5, 1, 2, 10, 0, 0, 1, 100]], [12, [1, 2, 2, 0, "building12", 0, 10, 10, 2, 12, 0, 0, 1, 0]], [100, [2, 2, 2, 10, "building100", 0, 20, 0, 2, 100, 0, 0, 1, 0]], [140, [2, 2, 3, 10, "building140", 0, 30, 0, 3, 140, 1, 0, 1, 0]], [142, [2, 2, 2, 10, "building142", 0, 40, 0, 2, 142, 0, 0, 1, 0]], [144, [2, 2, 2, 10, "building144", 0, 0, 0, 2, 144, 0, 0, 1, 0]], [200, [3, 3, 5, 10, "building200", 0, 0, 0, 5, 200, 0, 0, 1, 0]], [202, [4, 3, 3, 10, "building202", 0, 0, 0, 3, 202, 1, 0, 1, 0]], [204, [5, 3, 3, 10, "building204", 0, 0, 0, 3, 204, 1, 0, 1, 0]], [206, [6, 3, 3, 10, "building206", 0, 0, 0, 3, 206, 1, 0, 1, 0]], [102, [2, 2, 2, 10, "building102", 0, 0, 0, 2, 102, 0, 0, 1, 0]], [104, [2, 2, 2, 10, "building104", 0, 0, 0, 2, 104, 0, 0, 1, 0]], [106, [2, 2, 2, 10, "building106", 0, 0, 0, 2, 106, 0, 0, 1, 0]], [108, [2, 2, 1, 10, "building108", 0, 0, 0, 1, 108, 0, 0, 1, 0]], [110, [2, 2, 2, 10, "building110", 0, 0, 0, 2, 110, 0, 0, 1, 0]], [112, [2, 2, 2, 10, "building112", 0, 0, 0, 2, 112, 0, 0, 1, 0]], [114, [2, 2, 2, 10, "building114", 0, 0, 0, 2, 114, 0, 0, 1, 0]], [116, [2, 2, 2, 10, "building116", 0, 0, 0, 2, 116, 0, 0, 1, 0]], [118, [2, 2, 1, 10, "building118", 0, 0, 0, 1, 118, 0, 0, 1, 0]], [120, [2, 2, 2, 10, "building120", 0, 0, 0, 2, 120, 0, 0, 1, 0]], [122, [2, 2, 2, 10, "building122", 0, 0, 0, 2, 122, 0, 0, 1, 0]], [124, [2, 2, 1, 10, "building124", 0, 0, 0, 1, 124, 0, 0, 1, 0]], [126, [2, 2, 1, 10, "building126", 0, 0, 0, 1, 126, 0, 0, 1, 0]], [128, [2, 2, 2, 10, "building128", 0, 0, 0, 2, 128, 0, 0, 1, 0]], [130, [2, 2, 3, 10, "building130", 0, 0, 0, 3, 130, 0, 0, 1, 0]], [132, [2, 2, 1, 10, "building132", 0, 0, 0, 1, 132, 0, 0, 1, 0]], [134, [2, 2, 2, 10, "building134", 0, 0, 0, 2, 134, 0, 0, 1, 0]], [136, [2, 2, 1, 10, "building136", 0, 0, 0, 1, 136, 0, 0, 1, 0]], [138, [2, 2, 2, 10, "building138", 0, 0, 0, 2, 138, 0, 0, 1, 0]]] );




var crystalKey = ["gold", "gaincrystal", "name", "showGain", "id"] ;
var crystalData = dict( [[0, [10, 10, "crystal0", 0, 0]], [1, [50, 50, "crystal1", 0, 1]], [2, [100, 100, "crystal2", 0, 2]]] );
var drugKey = ["name", "gold", "level", "id", "crystal", "attack", "defense", "health", "exp", "silver"] ;
var drugData = dict( [[0, ["drug0", 0, 0, 0, 0, 0, 0, 100, 0, 100]], [1, ["drug1", 0, 0, 1, 0, 100, 0, 0, 0, 100]], [2, ["drug2", 0, 0, 2, 0, 0, 0, 0, 0, 100]], [3, ["drug3", 0, 0, 3, 0, 0, 0, 0, 100, 100]], [4, ["drug4", 0, 0, 4, 0, 0, 100, 0, 0, 100]], [10, ["drug10", 0, 0, 10, 0, 0, 0, 100, 0, 200]], [11, ["drug11", 0, 0, 11, 0, 0, 0, 0, 0, 10]], [12, ["drug12", 0, 0, 12, 0, 0, 0, 0, 0, 0]], [13, ["drug13", 0, 0, 13, 0, 0, 0, 0, 0, 0]], [14, ["drug14", 0, 0, 14, 0, 0, 0, 0, 0, 0]], [20, ["drug20", 0, 0, 20, 0, 0, 0, 0, 0, 0]], [21, ["drug21", 0, 0, 21, 0, 0, 0, 0, 0, 0]], [22, ["drug22", 0, 0, 22, 0, 0, 0, 0, 0, 0]], [23, ["drug23", 0, 0, 23, 0, 0, 0, 0, 0, 0]], [24, ["drug24", 0, 0, 24, 0, 0, 0, 0, 0, 0]], [30, ["drug30", 0, 0, 30, 0, 0, 0, 0, 0, 0]], [31, ["drug31", 0, 0, 31, 0, 0, 0, 0, 0, 0]], [32, ["drug32", 0, 0, 32, 0, 0, 0, 0, 0, 0]], [33, ["drug33", 0, 0, 33, 0, 0, 0, 0, 0, 0]], [34, ["drug34", 0, 0, 34, 0, 0, 0, 0, 0, 0]]] );
var equipKey = ["name", "gold", "level", "id", "crystal", "attack", "defense", "silver"] ;
var equipData = dict( [[0, ["equip0", 0, 0, 0, 0, 10, 0, 100]], [1, ["equip1", 0, 0, 1, 0, 10, 0, 100]], [2, ["equip2", 0, 0, 2, 0, 10, 0, 100]], [3, ["equip3", 0, 0, 3, 0, 10, 0, 100]], [4, ["equip4", 0, 0, 4, 0, 0, 0, 0]], [5, ["equip5", 0, 0, 5, 0, 0, 0, 0]], [6, ["equip6", 0, 0, 6, 0, 0, 0, 0]], [7, ["equip7", 0, 0, 7, 0, 0, 0, 0]], [8, ["equip8", 0, 0, 8, 0, 0, 0, 0]], [9, ["equip9", 0, 0, 9, 0, 0, 0, 0]], [10, ["equip10", 0, 0, 10, 0, 0, 0, 0]], [11, ["equip11", 0, 0, 11, 0, 0, 0, 0]], [12, ["equip12", 0, 0, 12, 0, 0, 0, 0]], [13, ["equip13", 0, 0, 13, 0, 0, 0, 0]], [14, ["equip14", 0, 0, 14, 0, 0, 0, 0]], [15, ["equip15", 0, 0, 15, 0, 0, 0, 0]], [16, ["equip16", 0, 0, 16, 0, 0, 0, 0]], [17, ["equip17", 0, 0, 17, 0, 0, 0, 0]], [18, ["equip18", 0, 0, 18, 0, 0, 0, 0]], [19, ["equip19", 0, 0, 19, 0, 0, 0, 0]], [20, ["equip20", 0, 0, 20, 0, 0, 0, 0]], [21, ["equip21", 0, 0, 21, 0, 0, 0, 0]]] );
var goldKey = ["gaingold", "papaya", "id", "showGain", "name"] ;
var goldData = dict( [[0, [10, 1000, 0, 0, "gold0"]], [1, [60, 5000, 1, 0, "gold1"]], [2, [125, 10000, 2, 0, "gold2"]], [3, [275, 20000, 3, 0, "gold3"]], [4, [600, 40000, 4, 0, "gold4"]], [5, [1600, 100000, 5, 0, "gold5"]]] );
var plantKey = ["name", "exp", "level", "time", "gainsilver", "silver", "id"] ;
var plantData = dict( [[0, ["plant0", 10, 0, 20, 0, 100, 0]], [1, ["plant1", 10, 0, 20, 0, 0, 1]], [2, ["plant2", 10, 0, 20, 0, 0, 2]], [3, ["plant3", 10, 0, 20, 0, 0, 3]], [4, ["plant4", 10, 0, 20, 0, 0, 4]], [5, ["plant5", 10, 0, 20, 0, 0, 5]], [6, ["plant6", 10, 0, 20, 0, 0, 6]], [7, ["plant7", 10, 0, 20, 0, 0, 7]], [8, ["plant8", 10, 0, 20, 0, 0, 8]], [9, ["plant9", 10, 0, 20, 0, 0, 9]]] );
var silverKey = ["gold", "gainsilver", "id", "showGain", "name"] ;
var silverData = dict( [[0, [10, 10000, 0, 0, "silver0"]], [1, [100, 100000, 1, 0, "silver1"]], [2, [500, 500000, 2, 0, "silver2"]]] );

//不同等级名字图片 一些基本属性不同+ 还要加上 装备的属性 
//基本图片 和 等级相关的图片 
//需要的等级和士兵等级不同 
//基本属性 升级之后的基本属性也不同 soldierLevel 
/*
士兵专职之后, id 不同, 基本属性也不同, 图片也不同
ss id m/a num
士兵有动态的装备属性和
*/
var soldierKey = ["kind", "arrpx", "name", "gold", "level", "attNum", "id", "crystal", "attack", "defense", "range", "volumn", "silver", "moveNum", "arrpy"] ;
var soldierData = dict( [[0, [0, -50, "soldier0", 0, 100, 8, 0, 0, 0, 0, 64, 40, 100, 7, -50]], [1, [0, -50, "soldier1", 0, 0, 8, 1, 0, 0, 0, 64, 40, 0, 7, -50]], [2, [0, -50, "soldier2", 0, 0, 8, 2, 0, 0, 0, 64, 40, 0, 7, -50]], [3, [0, -50, "soldier3", 0, 0, 8, 3, 0, 0, 0, 64, 40, 0, 7, -50]], [10, [0, -50, "soldier10", 0, 3, 8, 10, 0, 0, 0, 64, 40, 0, 7, -50]], [11, [0, -50, "soldier11", 0, 0, 8, 11, 0, 0, 0, 64, 40, 0, 7, -50]], [12, [0, -50, "soldier12", 0, 0, 8, 12, 0, 0, 0, 64, 40, 0, 7, -50]], [13, [0, -50, "soldier13", 0, 0, 8, 13, 0, 0, 0, 64, 40, 0, 7, -50]], [20, [1, -50, "soldier20", 0, 0, 8, 20, 0, 0, 0, 256, 40, 0, 7, -50]], [21, [1, -50, "soldier21", 0, 0, 8, 21, 0, 0, 0, 256, 40, 0, 7, -50]], [22, [1, -50, "soldier22", 0, 0, 8, 22, 0, 0, 0, 256, 40, 0, 7, -50]], [23, [1, -50, "soldier23", 0, 0, 8, 23, 0, 0, 0, 256, 40, 0, 7, -50]], [30, [0, -50, "soldier30", 0, 0, 8, 30, 0, 0, 0, 64, 40, 0, 7, -50]], [31, [0, -50, "soldier31", 0, 0, 8, 31, 0, 0, 0, 64, 40, 0, 7, -50]], [32, [0, -50, "soldier32", 0, 0, 8, 32, 0, 0, 0, 64, 40, 0, 7, -50]], [33, [0, -50, "soldier33", 0, 0, 8, 33, 0, 0, 0, 64, 40, 0, 7, -50]], [40, [1, -50, "soldier40", 0, 0, 8, 40, 0, 0, 0, 256, 40, 0, 7, -50]], [41, [1, -50, "soldier41", 0, 0, 8, 41, 0, 0, 0, 256, 40, 0, 7, -50]], [42, [1, -50, "soldier42", 0, 0, 8, 42, 0, 0, 0, 256, 40, 0, 7, -50]], [43, [1, -50, "soldier43", 0, 0, 8, 43, 0, 0, 0, 256, 40, 0, 7, -50]], [50, [0, -50, "soldier50", 0, 0, 8, 50, 0, 0, 0, 64, 40, 0, 7, -50]], [51, [0, -50, "soldier51", 0, 0, 8, 51, 0, 0, 0, 64, 40, 0, 7, -50]], [52, [0, -50, "soldier52", 0, 0, 8, 52, 0, 0, 0, 64, 40, 0, 7, -50]], [53, [0, -50, "soldier53", 0, 0, 8, 53, 0, 0, 0, 64, 40, 0, 7, -50]], [60, [2, -50, "soldier60", 0, 0, 8, 60, 0, 0, 0, 256, 40, 0, 7, -50]], [61, [2, -50, "soldier61", 0, 0, 8, 61, 0, 0, 0, 256, 40, 0, 7, -50]], [62, [2, -50, "soldier62", 0, 0, 8, 62, 0, 0, 0, 256, 40, 0, 7, -50]], [63, [2, -50, "soldier63", 0, 0, 8, 63, 0, 0, 0, 256, 40, 0, 7, -50]], [70, [0, -50, "soldier70", 0, 0, 8, 70, 0, 0, 0, 64, 40, 0, 7, -50]], [71, [0, -50, "soldier71", 0, 0, 8, 71, 0, 0, 0, 64, 40, 0, 7, -50]], [110, [0, -50, "soldier110", 0, 0, 8, 110, 0, 0, 0, 64, 40, 0, 7, -50]], [100, [0, -50, "soldier100", 0, 0, 8, 100, 0, 0, 0, 64, 40, 0, 7, -50]], [80, [0, -50, "soldier80", 0, 0, 8, 80, 0, 0, 0, 64, 40, 0, 7, -50]], [81, [0, -50, "soldier81", 0, 0, 8, 81, 0, 0, 0, 64, 40, 0, 7, -50]], [82, [0, -50, "soldier82", 0, 0, 8, 82, 0, 0, 0, 64, 40, 0, 7, -50]], [83, [0, -50, "soldier83", 0, 0, 8, 83, 0, 0, 0, 64, 40, 0, 7, -50]], [90, [0, -50, "soldier90", 0, 0, 8, 90, 0, 0, 0, 64, 40, 0, 7, -50]], [91, [0, -50, "soldier91", 0, 0, 8, 91, 0, 0, 0, 64, 40, 0, 7, -50]], [92, [0, -50, "soldier92", 0, 0, 8, 92, 0, 0, 0, 64, 40, 0, 7, -50]], [93, [0, -50, "soldier93", 0, 0, 8, 93, 0, 0, 0, 64, 40, 0, 7, -50]], [72, [0, -50, "soldier72", 0, 0, 8, 72, 0, 0, 0, 64, 40, 0, 7, -50]], [73, [0, -50, "soldier73", 0, 0, 8, 73, 0, 0, 0, 64, 40, 0, 7, -50]], [120, [0, -50, "soldier120", 0, 0, 8, 120, 0, 0, 0, 64, 40, 0, 7, -50]], [130, [0, -50, "soldier130", 0, 0, 8, 130, 0, 0, 0, 64, 40, 0, 7, -50]], [140, [0, -50, "soldier140", 0, 0, 8, 140, 0, 0, 0, 64, 40, 0, 7, -50]], [150, [0, -50, "soldier150", 0, 0, 8, 150, 0, 0, 0, 64, 40, 0, 7, -50]], [160, [1, -50, "soldier160", 0, 0, 8, 160, 0, 0, 0, 64, 40, 0, 7, -50]], [170, [2, -50, "soldier170", 0, 0, 8, 170, 0, 0, 0, 64, 40, 0, 7, -50]], [180, [0, -50, "soldier180", 0, 0, 8, 180, 0, 0, 0, 64, 40, 0, 7, -50]], [190, [0, -50, "soldier190", 0, 0, 8, 190, 0, 0, 0, 64, 40, 0, 7, -50]]] );

//士兵最大的ID 
//士兵ID 是连续的
var SOLDIER_MAX_ID = max(soldierData);

var magicAnimate = dict([
    [60, [["fire0.png", "fire1.png","fire2.png","fire3.png","fire4.png","fire5.png","fire6.png"], 1500, [-20, 34]]],
    [170, [["s170e0.png","s170e1.png","s170e2.png","s170e3.png","s170e4.png","s170e5.png","s170e6.png","s170e7.png"], 1500, [-20, 34]]],
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

var addKey = ["people", "cityDefense", "attack", "defense", "health", "gainsilver", "gaincrystal", "gaingold"];
var costKey = ["silver", "gold", "crystal", "papaya"];
var addToUser = [1, 1, 0, 0, 0];



/*
商店增加新的物品类型
类型 id 键 数据字典
图片名字前缀+id 
有些物品的图片不会改变 需要一个标识id替换字符串
有些需要改变
*/


const BUILD = 0;
const EQUIP = 1;
const DRUG = 2;
const GOLD = 3;
const SILVER = 4;
const CRYSTAL = 5;
const PLANT = 6;
const SOLDIER = 7;

var Keys = [
    buildingKey,
    equipKey,
    drugKey,
    goldKey,
    silverKey,
    crystalKey,
    plantKey,
    soldierKey,
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
];


var obstacleBlock = 
dict(
[[310043, 1], [330055, 1], [300048, 1], [330053, 1], [330051, 1], [310045, 1], [330059, 1], [620050, 1], [620052, 1], [650053, 1], [640042, 1], [660040, 1], [300028, 1], [680058, 1], [640052, 1], [290045, 1], [290041, 1], [290043, 1], [650041, 1], [610031, 1], [660058, 1], [640054, 1], [320062, 1], [320060, 1], [660054, 1], [280040, 1], [280042, 1], [660056, 1], [650057, 1], [650055, 1], [630051, 1], [630053, 1], [600048, 1], [280038, 1], [600046, 1], [280034, 1], [280036, 1], [280032, 1], [630043, 1], [610051, 1], [310027, 1], [640034, 1], [640036, 1], [640032, 1], [640038, 1], [680060, 1], [600050, 1], [670059, 1], [650039, 1], [610049, 1], [330057, 1], [610045, 1], [610047, 1], [600030, 1], [300060, 1], [300062, 1], [630031, 1], [600028, 1], [270039, 1], [270037, 1], [270035, 1], [270033, 1], [310041, 1], [310047, 1], [630037, 1], [310049, 1], [330061, 1], [300054, 1], [300056, 1], [300050, 1], [300052, 1], [300058, 1], [270041, 1], [660038, 1], [290035, 1], [290037, 1], [290031, 1], [290033, 1], [650035, 1], [650037, 1], [290039, 1], [650033, 1], [310051, 1], [310053, 1], [310055, 1], [310057, 1], [310059, 1], [300042, 1], [300040, 1], [300046, 1], [320052, 1], [290027, 1], [290029, 1], [320050, 1], [330049, 1], [670055, 1], [670057, 1], [320056, 1], [310061, 1], [660034, 1], [320054, 1], [320046, 1], [320048, 1], [590049, 1], [590047, 1], [300030, 1], [320058, 1]]

);

var mapInfo = dict([
    [0, [[0, 104], [1020, 84]]],
    [1, [[5, 92], [1022, 79]]],
    [2, [[0, 75], [1032, 95]]],
    [3, [[5, 104], [1038, 89]]],
    [4, [[3, 45], [1014, 65]]],
]);

const MAP_INITY = 130;
const MAP_INITX = 0;
const MAP_OFFX = 85;
const MAP_OFFY = 85;
const MAP_WIDTH = 12;
const MAP_HEIGHT = 4;


const MAP_SOL_FREE = 0;
const MAP_SOL_ARRANGE = 1;
const MAP_SOL_MOVE = 2;
const MAP_SOL_TOUCH = 4;
const MAP_SOL_ATTACK = 5;
const MAP_SOL_DEAD = 6;
const MAP_SOL_WATI_TOUCH = 7;
