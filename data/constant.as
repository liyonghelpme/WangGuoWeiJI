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

//需要与 PARAMS 中进行 数据进行同步
/*
const Moving = 0;
const Free = 1;
const Working = 2;
const ShowMenuing = 4;
const Wait_Lock = 5;
*/


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
const SOL_NAME = 4;

const INSPIRE = 1; 


const ISLAND_LAYER = 1; 
const CLOUD_LAYER = 2; 
const FLY_LAYER = 3;
const MAX_MAP_LAYER = 1000;

const BANNER_LAYER = 10000;


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
const RING_FIGHTING = 11;
const CAMP = 12;


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
const RBINV = m_color(
0, 0, 100, 0, 0,
0, 100, 0, 0, 0,
100, 0, 0, 0, 0,
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
const TrainZone = [[100, 498, 2400, 400]];

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
    [140, [["f0.png"], [87, 37], 2000, 1, [50, 50]]],
    [141, [["f1.png"], [87, 37], 2000, 1, [50, 50]]],
    [202, [["god0.png", "god1.png","god2.png","god3.png","god4.png","god5.png","god6.png","god7.png","god8.png"], [101, 0], 2000, 0, [50, 50]]],
    [203, [["god0.png", "god1.png","god2.png","god3.png","god4.png","god5.png","god6.png","god7.png","god8.png"], [28, 0], 2000, 0, [50, 50]]],
    [204, [["drugStore0.png",  "drugStore1.png","drugStore2.png","drugStore3.png","drugStore4.png","drugStore5.png","drugStore6.png","drugStore7.png","drugStore8.png","drugStore9.png"], [31, -60], 2000, 0, [0, 0]]],
    [205, [["drugStore0.png",  "drugStore1.png","drugStore2.png","drugStore3.png","drugStore4.png","drugStore5.png","drugStore6.png","drugStore7.png","drugStore8.png","drugStore9.png"], [109, -60], 2000, 0, [0, 0]]],
    [206, [["forgeShop0.png", "forgeShop1.png", "forgeShop2.png", "forgeShop3.png", "forgeShop4.png", "forgeShop5.png", "forgeShop6.png", "forgeShop7.png", "forgeShop8.png", "forgeShop9.png" ], [31, -60], 2000, 0, [0, 0]]],
    [207, [["forgeShop0.png", "forgeShop1.png", "forgeShop2.png", "forgeShop3.png", "forgeShop4.png", "forgeShop5.png", "forgeShop6.png", "forgeShop7.png", "forgeShop8.png", "forgeShop9.png"], [109, -60], 2000, 0, [0, 0]]],
    [162, [["build162.png", "build162a1.png", "build162a2.png", "build162a3.png", "build162a4.png"], [0, 0], 2000, 2, [0, 0]]],
]);

//skillId
//animate time plistFile
var skillAnimate = dict([
    [0, [["skill0.plist/skill0a0.png", "skill0.plist/skill0a1.png", "skill0.plist/skill0a2.png", "skill0.plist/skill0a3.png", "skill0.plist/skill0a4.png", "skill0.plist/skill0a5.png", "skill0.plist/skill0a6.png", "skill0.plist/skill0a7.png", "skill0.plist/skill0a8.png", "skill0.plist/skill0a9.png", "skill0.plist/skill0a10.png"], 1500, "skill0.plist"]] ,
    [1, [["skill1.plist/skill1a0.png", "skill1.plist/skill1a1.png", "skill1.plist/skill1a2.png", "skill1.plist/skill1a3.png", "skill1.plist/skill1a4.png", "skill1.plist/skill1a5.png", "skill1.plist/skill1a6.png", "skill1.plist/skill1a7.png", "skill1.plist/skill1a8.png", "skill1.plist/skill1a9.png", "skill1.plist/skill1a10.png"], 1500, "skill1.plist"]] ,
    [2, [["skill2.plist/skill2a0.png", "skill2.plist/skill2a1.png", "skill2.plist/skill2a2.png", "skill2.plist/skill2a3.png", "skill2.plist/skill2a4.png", "skill2.plist/skill2a5.png", "skill2.plist/skill2a6.png", "skill2.plist/skill2a7.png", "skill2.plist/skill2a8.png", "skill2.plist/skill2a9.png"], 1500, "skill2.plist"]] ,
    [3, [["skill3.plist/skill3a0.png", "skill3.plist/skill3a1.png", "skill3.plist/skill3a2.png", "skill3.plist/skill3a3.png", "skill3.plist/skill3a4.png", "skill3.plist/skill3a5.png", "skill3.plist/skill3a6.png", "skill3.plist/skill3a7.png", "skill3.plist/skill3a8.png", "skill3.plist/skill3a9.png"], 1500, "skill3.plist"]] ,
    [4, [["skill4.plist/skill4a0.png", "skill4.plist/skill4a1.png", "skill4.plist/skill4a2.png", "skill4.plist/skill4a3.png", "skill4.plist/skill4a4.png", "skill4.plist/skill4a5.png", "skill4.plist/skill4a6.png", "skill4.plist/skill4a7.png"], 1500, "skill4.plist"]] ,
    [5, [["skill5.plist/skill5a0.png", "skill5.plist/skill5a1.png", "skill5.plist/skill5a2.png", "skill5.plist/skill5a3.png", "skill5.plist/skill5a4.png", "skill5.plist/skill5a5.png", "skill5.plist/skill5a6.png", "skill5.plist/skill5a7.png", "skill5.plist/skill5a8.png", "skill5.plist/skill5a9.png"], 1500, "skill5.plist"]] ,
    [6, [["skill6.plist/skill6a0.png", "skill6.plist/skill6a1.png", "skill6.plist/skill6a2.png", "skill6.plist/skill6a3.png", "skill6.plist/skill6a4.png", "skill6.plist/skill6a5.png", "skill6.plist/skill6a6.png", "skill6.plist/skill6a7.png", "skill6.plist/skill6a8.png", "skill6.plist/skill6a9.png"], 1500, "skill6.plist"]] ,
    [7, [["skill7.plist/skill7a0.png", "skill7.plist/skill7a1.png", "skill7.plist/skill7a2.png", "skill7.plist/skill7a3.png", "skill7.plist/skill7a4.png", "skill7.plist/skill7a5.png", "skill7.plist/skill7a6.png", "skill7.plist/skill7a7.png", "skill7.plist/skill7a8.png", "skill7.plist/skill7a9.png"], 1500, "skill7.plist"]] ,
    [8, [["skill8.plist/skill8a0.png", "skill8.plist/skill8a1.png", "skill8.plist/skill8a2.png", "skill8.plist/skill8a3.png", "skill8.plist/skill8a4.png", "skill8.plist/skill8a5.png", "skill8.plist/skill8a6.png", "skill8.plist/skill8a7.png", "skill8.plist/skill8a8.png", "skill8.plist/skill8a9.png"], 1500, "skill8.plist"]] ,

    [9, [["skill9.plist/skill9a0.png", "skill9.plist/skill9a1.png", "skill9.plist/skill9a2.png", "skill9.plist/skill9a3.png", "skill9.plist/skill9a4.png", "skill9.plist/skill9a5.png", "skill9.plist/skill9a6.png", "skill9.plist/skill9a7.png", "skill9.plist/skill9a8.png", "skill9.plist/skill9a9.png", "skill9.plist/skill9a10.png", "skill9.plist/skill9a11.png", "skill9.plist/skill9a12.png", "skill9.plist/skill9a13.png", "skill9.plist/skill9a14.png", "skill9.plist/skill9a15.png"], 1500, "skill9.plist"]] ,

    [10, [["skill10.plist/skill10a0.png", "skill10.plist/skill10a1.png", "skill10.plist/skill10a2.png", "skill10.plist/skill10a3.png", "skill10.plist/skill10a4.png", "skill10.plist/skill10a5.png", "skill10.plist/skill10a6.png", "skill10.plist/skill10a7.png", "skill10.plist/skill10a8.png"], 1500, "skill10.plist"]] ,

    [11, [["skill10.plist/skill10a0.png", "skill10.plist/skill10a1.png", "skill10.plist/skill10a2.png", "skill10.plist/skill10a3.png", "skill10.plist/skill10a4.png", "skill10.plist/skill10a5.png", "skill10.plist/skill10a6.png", "skill10.plist/skill10a7.png", "skill10.plist/skill10a8.png"], 1500, "skill10.plist"]] ,

    [16, [["skill10.plist/skill10a0.png", "skill10.plist/skill10a1.png", "skill10.plist/skill10a2.png", "skill10.plist/skill10a3.png", "skill10.plist/skill10a4.png", "skill10.plist/skill10a5.png", "skill10.plist/skill10a6.png", "skill10.plist/skill10a7.png", "skill10.plist/skill10a8.png"], 1500, "skill10.plist"]] ,


    [12, [["skill12.plist/skill12a0.png", "skill12.plist/skill12a1.png", "skill12.plist/skill12a2.png", "skill12.plist/skill12a3.png", "skill12.plist/skill12a4.png", "skill12.plist/skill12a5.png", "skill12.plist/skill12a6.png", "skill12.plist/skill12a7.png", "skill12.plist/skill12a8.png", "skill12.plist/skill12a9.png", "skill12.plist/skill12a10.png", "skill12.plist/skill12a11.png", "skill12.plist/skill12a12.png"], 1500, "skill12.plist"]] ,
    [13, [["skill13.plist/skill13a0.png", "skill13.plist/skill13a1.png", "skill13.plist/skill13a2.png", "skill13.plist/skill13a3.png", "skill13.plist/skill13a4.png", "skill13.plist/skill13a5.png", "skill13.plist/skill13a6.png", "skill13.plist/skill13a7.png", "skill13.plist/skill13a8.png", "skill13.plist/skill13a9.png", "skill13.plist/skill13a10.png", "skill13.plist/skill13a11.png", "skill13.plist/skill13a12.png", "skill13.plist/skill13a13.png", "skill13.plist/skill13a14.png"], 1500, "skill13.plist"]] ,
    [14, [["skill14.plist/skill14a0.png", "skill14.plist/skill14a1.png", "skill14.plist/skill14a2.png", "skill14.plist/skill14a3.png", "skill14.plist/skill14a4.png", "skill14.plist/skill14a5.png", "skill14.plist/skill14a6.png", "skill14.plist/skill14a7.png", "skill14.plist/skill14a8.png", "skill14.plist/skill14a9.png", "skill14.plist/skill14a10.png", "skill14.plist/skill14a11.png"], 1500, "skill14.plist"]] ,
    [15, [["skill15.plist/skill15a0.png", "skill15.plist/skill15a1.png", "skill15.plist/skill15a2.png", "skill15.plist/skill15a3.png", "skill15.plist/skill15a4.png", "skill15.plist/skill15a5.png", "skill15.plist/skill15a6.png", "skill15.plist/skill15a7.png", "skill15.plist/skill15a8.png", "skill15.plist/skill15a9.png", "skill15.plist/skill15a10.png", "skill15.plist/skill15a11.png"], 1500, "skill15.plist"]] ,


]);


var buildFunc = dict([
[FARM_BUILD, [["photo", "sell"], ["acc"]]],
[HOUSE_BUILD, [["photo"], [ "sell" ]]],//"upgradeBuild"
[DECOR_BUILD, [["photo"], ["sell"]]],
[CASTLE_BUILD, [["photo", "story"], ["tip", "collection"]]],
[GOD_BUILD, [["photo",  "soldier"], ["relive", "train"]]],
[DRUG_BUILD, [["photo"], ["makeDrug", "allDrug"]]],
[FORGE_SHOP, [["photo"], ["forge", "allEquip"]]],
[MINE_KIND, [["photo", "sell"], ["upgrade", "planMine"]]],
[LOVE_TREE, [["photo", "invite"], ["love", "loveRank"]]],//, "upgradeBuild"
[RING_FIGHTING, [[], []]],
[CAMP, [["photo", "sell"], ["call"]]],//accSoldier
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

function ani2(t)
{
    return animate(t, "m2a.plist/m2a0.png", "m2a.plist/m2a1.png", "m2a.plist/m2a2.png", "m2a.plist/m2a3.png", "m2a.plist/m2a4.png", "m2a.plist/m2a5.png", "m2a.plist/m2a6.png", "m2a.plist/m2a7.png", "m2a.plist/m2a8.png", "m2a.plist/m2a9.png", "m2a.plist/m2a10.png", "m2a.plist/m2a11.png", "m2a.plist/m2a12.png", "m2a.plist/m2a13.png", "m2a.plist/m2a14.png", "m2a.plist/m2a15.png", "m2a.plist/m2a16.png", "m2a.plist/m2a17.png", "m2a.plist/m2a18.png");
}



function ani3()
{
    return animate(2000, "m1a0.png", "m1a1.png", "m1a2.png", ARGB_8888);
}

function ani4(t)
{
    return animate(t, "m4a.plist/m4a0.png", "m4a.plist/m4a1.png", "m4a.plist/m4a2.png", "m4a.plist/m4a3.png", "m4a.plist/m4a4.png", "m4a.plist/m4a5.png", "m4a.plist/m4a6.png", "m4a.plist/m4a7.png", "m4a.plist/m4a8.png", "m4a.plist/m4a9.png", "m4a.plist/m4a10.png", "m4a.plist/m4a11.png", "m4a.plist/m4a12.png", "m4a.plist/m4a13.png", "m4a.plist/m4a14.png", "m4a.plist/m4a15.png", "m4a.plist/m4a16.png", "m4a.plist/m4a17.png", "m4a.plist/m4a18.png", "m4a.plist/m4a19.png");
}

var mapAnimate = dict([
    [0, [ani0, [646+22, -62+61]]],
    [1, [ani1, [816, -15]]],
    [2, [ani2, [103, 213, 350, 213, 595, 113, 220, 102, 413, 67, 166, 18]]],
    [3, [ani3, [777, 58]]],
    [4, [ani4, [479, 223, 327, 164, 554, 129]]],
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

//bomb 和 rocket 的图片需要缩放 以保证 仍出去的炸弹大小和 士兵手上的大小一致
//音符类似于bomb 两个阶段
var pureMagicData = dict([
    //音符产生
    [90, [["s90e.plist/s90e0.png", "s90e.plist/s90e1.png", "s90e.plist/s90e2.png", "s90e.plist/s90e3.png", "s90e.plist/s90e4.png", "s90e.plist/s90e5.png", "s90e.plist/s90e6.png"], 500, [-20, 34], 100]] ,

    [580, [["s580e.plist/s580e0.png", "s580e.plist/s580e1.png", "s580e.plist/s580e2.png", "s580e.plist/s580e3.png", "s580e.plist/s580e4.png", "s580e.plist/s580e5.png", "s580e.plist/s580e6.png", "s580e.plist/s580e7.png"], 1000, [-20, 34], 20*100/25]] ,

    [581, [["s581e.plist/s581e0.png", "s581e.plist/s581e1.png", "s581e.plist/s581e2.png", "s581e.plist/s581e3.png", "s581e.plist/s581e4.png"], 1000, [-20, 34], 20*100/25]] ,

    [582, [["s582e.plist/s582e0.png", "s582e.plist/s582e1.png", "s582e.plist/s582e2.png", "s582e.plist/s582e3.png", "s582e.plist/s582e4.png"], 1000, [-20, 34], 28*100/37]] ,

    [583, [["s583e.plist/s583e0.png", "s583e.plist/s583e1.png", "s583e.plist/s583e2.png", "s583e.plist/s583e3.png", "s583e.plist/s583e4.png"], 1000, [-20, 34], 75*100/130]] ,

    [570, [[], 0, [], 100]],

    [571, [["s571e.plist/s571e0.png", "s571e.plist/s571e1.png", "s571e.plist/s571e2.png", "s571e.plist/s571e3.png", "s571e.plist/s571e4.png", "s571e.plist/s571e5.png", "s571e.plist/s571e6.png", "s571e.plist/s571e7.png"], 1000, [-20, 34], 100]] ,

    [572, [["s572e.plist/s572e0.png", "s572e.plist/s572e1.png", "s572e.plist/s572e2.png", "s572e.plist/s572e3.png", "s572e.plist/s572e4.png", "s572e.plist/s572e5.png", "s572e.plist/s572e6.png", "s572e.plist/s572e7.png"], 1000, [-20, 34], 100]] ,

    [573, [["s573e.plist/s573e0.png", "s573e.plist/s573e1.png", "s573e.plist/s573e2.png", "s573e.plist/s573e3.png", "s573e.plist/s573e4.png", "s573e.plist/s573e5.png", "s573e.plist/s573e6.png", "s573e.plist/s573e7.png"], 1000, [-20, 34], 100]] ,

    [444, [["s444e.plist/s444e0.png", "s444e.plist/s444e1.png", "s444e.plist/s444e2.png", "s444e.plist/s444e3.png", "s444e.plist/s444e4.png", "s444e.plist/s444e5.png", "s444e.plist/s444e6.png"], 1000, [-20, 34], 100]] ,

    [590, [["s590e.plist/s590e0.png", "s590e.plist/s590e1.png", "s590e.plist/s590e2.png", "s590e.plist/s590e3.png", "s590e.plist/s590e4.png", "s590e.plist/s590e5.png", "s590e.plist/s590e6.png", "s590e.plist/s590e7.png"], 1000, [-20, 34], 100]] ,

    [594, [["s594e.plist/s594e0.png", "s594e.plist/s594e1.png", "s594e.plist/s594e2.png", "s594e.plist/s594e3.png", "s594e.plist/s594e4.png", "s594e.plist/s594e5.png", "s594e.plist/s594e6.png", "s594e.plist/s594e7.png", "s594e.plist/s594e8.png"], 1000, [-20, 34], 100]] ,

    [520, [["s520e.plist/s520e0.png", "s520e.plist/s520e1.png", "s520e.plist/s520e2.png", "s520e.plist/s520e3.png", "s520e.plist/s520e4.png", "s520e.plist/s520e5.png", "s520e.plist/s520e6.png", "s520e.plist/s520e7.png"], 1000, [-20, 34], 100]] ,

    
[532, [["s532e.plist/s532e0.png", "s532e.plist/s532e1.png", "s532e.plist/s532e2.png", "s532e.plist/s532e3.png", "s532e.plist/s532e4.png", "s532e.plist/s532e5.png", "s532e.plist/s532e6.png", "s532e.plist/s532e7.png"], 1000, [-20, 34], 100]] ,
[533, [["s533e.plist/s533e0.png", "s533e.plist/s533e1.png", "s533e.plist/s533e2.png", "s533e.plist/s533e3.png", "s533e.plist/s533e4.png", "s533e.plist/s533e5.png", "s533e.plist/s533e6.png", "s533e.plist/s533e7.png"], 1000, [-20, 34], 100]] ,


[540, [["s540e.plist/s540e0.png", "s540e.plist/s540e1.png", "s540e.plist/s540e2.png", "s540e.plist/s540e3.png", "s540e.plist/s540e4.png", "s540e.plist/s540e5.png", "s540e.plist/s540e6.png", "s540e.plist/s540e7.png"], 1000, [-20, 34], 100]] ,

[491, [["s491e.plist/s491e0.png", "s491e.plist/s491e1.png", "s491e.plist/s491e2.png", "s491e.plist/s491e3.png", "s491e.plist/s491e4.png"], 400, [-20, 34], 100]] ,

[492, [["s492e.plist/s492e0.png", "s492e.plist/s492e1.png", "s492e.plist/s492e2.png", "s492e.plist/s492e3.png"], 1000, [-20, 34], 100]] ,

[493, [["s493e.plist/s493e0.png", "s493e.plist/s493e1.png", "s493e.plist/s493e2.png", "s493e.plist/s493e3.png"], 1000, [-20, 34], 100]] ,


[10491, [["s10491e.plist/s10491e0.png", "s10491e.plist/s10491e1.png", "s10491e.plist/s10491e2.png", "s10491e.plist/s10491e3.png", "s10491e.plist/s10491e4.png", "s10491e.plist/s10491e5.png", "s10491e.plist/s10491e6.png", "s10491e.plist/s10491e7.png"], 1000, [-20, 34]]] ,

[10493, [["s10493e.plist/s10493e0.png", "s10493e.plist/s10493e1.png", "s10493e.plist/s10493e2.png", "s10493e.plist/s10493e3.png", "s10493e.plist/s10493e4.png", "s10493e.plist/s10493e5.png", "s10493e.plist/s10493e6.png", "s10493e.plist/s10493e7.png"], 1000, [-20, 34]]] ,

    [10000, [["s10000e.plist/s10000e0.png", "s10000e.plist/s10000e1.png", "s10000e.plist/s10000e2.png"], 300, [-20, 34]]] ,

    //音符飞动
    [10001, [["s10001e.plist/s10001e0.png", "s10001e.plist/s10001e1.png", "s10001e.plist/s10001e2.png", "s10001e.plist/s10001e3.png", "s10001e.plist/s10001e4.png", "s10001e.plist/s10001e5.png", "s10001e.plist/s10001e6.png", "s10001e.plist/s10001e7.png"], 1000, [-20, 34]]] ,

    [10002, [["s10002e.plist/s10002e0.png", "s10002e.plist/s10002e1.png", "s10002e.plist/s10002e2.png", "s10002e.plist/s10002e3.png", "s10002e.plist/s10002e4.png", "s10002e.plist/s10002e5.png", "s10002e.plist/s10002e6.png", "s10002e.plist/s10002e7.png"], 1000, [-20, 34]]] ,

    [10003, [["s10003e.plist/s10003e0.png", "s10003e.plist/s10003e1.png"], 1000, [-20, 34]]] ,
    [10004, [["s10004e.plist/s10004e0.png", "s10004e.plist/s10004e1.png", "s10004e.plist/s10004e2.png", "s10004e.plist/s10004e3.png"], 1000, [-20, 34]]] ,

    [10005, [["s10005e.plist/s10005e0.png", "s10005e.plist/s10005e1.png", "s10005e.plist/s10005e2.png", "s10005e.plist/s10005e3.png"], 1000, [-20, 34]]] ,

    [40, [[], 0, [], 40*100/60]],
    [41, [[], 0, [], 40*100/60]],
    [42, [[], 0, [], 40*100/60]],
    [43, [[], 0, [], 40*100/60]],

    [20, [[], 0, [], 100]],
    [21, [[], 0, [], 100]],
    [22, [[], 0, [], 100]],
    [23, [[], 0, [], 100]],

    [500, [["s500e.plist/s500e0.png", "s500e.plist/s500e1.png", "s500e.plist/s500e2.png", "s500e.plist/s500e3.png"], 1000, [-20, 34], 100]] ,

    [501, [["s501e.plist/s501e0.png", "s501e.plist/s501e1.png", "s501e.plist/s501e2.png"], 300, [-20, 34], 100]] ,

    [10501, [["s10501e.plist/s10501e0.png", "s10501e.plist/s10501e1.png", "s10501e.plist/s10501e2.png", "s10501e.plist/s10501e3.png", "s10501e.plist/s10501e4.png", "s10501e.plist/s10501e5.png", "s10501e.plist/s10501e6.png", "s10501e.plist/s10501e7.png"], 1000, [-20, 34], 100]] ,

    [20501, [["s20501e.plist/s20501e0.png", "s20501e.plist/s20501e1.png", "s20501e.plist/s20501e2.png", "s20501e.plist/s20501e3.png", "s20501e.plist/s20501e4.png", "s20501e.plist/s20501e5.png", "s20501e.plist/s20501e6.png"], 500, [-20, 34]]] ,

    [20502, [["s20502e.plist/s20502e0.png", "s20502e.plist/s20502e1.png", "s20502e.plist/s20502e2.png", "s20502e.plist/s20502e3.png", "s20502e.plist/s20502e4.png", "s20502e.plist/s20502e5.png"], 1000, [-20, 34], 100]] ,

    [20503, [["s20503e.plist/s20503e0.png", "s20503e.plist/s20503e1.png", "s20503e.plist/s20503e2.png", "s20503e.plist/s20503e3.png", "s20503e.plist/s20503e4.png", "s20503e.plist/s20503e5.png", "s20503e.plist/s20503e6.png", "s20503e.plist/s20503e7.png", "s20503e.plist/s20503e8.png"], 1000, [-20, 34], 100]] ,

    [10510, [["s10510e.plist/s10510e0.png", "s10510e.plist/s10510e1.png", "s10510e.plist/s10510e2.png", "s10510e.plist/s10510e3.png", "s10510e.plist/s10510e4.png", "s10510e.plist/s10510e5.png", "s10510e.plist/s10510e6.png", "s10510e.plist/s10510e7.png"], 1000, [-20, 34], 100]] ,

    [511, [["s511e.plist/s511e0.png", "s511e.plist/s511e1.png", "s511e.plist/s511e2.png", "s511e.plist/s511e3.png", "s511e.plist/s511e4.png"], 400, [-20, 34], 100]] ,

    [10511, [["s10511e.plist/s10511e0.png", "s10511e.plist/s10511e1.png", "s10511e.plist/s10511e2.png", "s10511e.plist/s10511e3.png", "s10511e.plist/s10511e4.png", "s10511e.plist/s10511e5.png", "s10511e.plist/s10511e6.png", "s10511e.plist/s10511e7.png"], 1000, [-20, 34], 100]] ,

    [512, [["s512e.plist/s512e0.png", "s512e.plist/s512e1.png", "s512e.plist/s512e2.png", "s512e.plist/s512e3.png", "s512e.plist/s512e4.png", "s512e.plist/s512e5.png", "s512e.plist/s512e6.png"], 1000, [-20, 34], 100]] ,

    [10512, [["s10512e.plist/s10512e0.png", "s10512e.plist/s10512e1.png", "s10512e.plist/s10512e2.png", "s10512e.plist/s10512e3.png", "s10512e.plist/s10512e4.png", "s10512e.plist/s10512e5.png", "s10512e.plist/s10512e6.png", "s10512e.plist/s10512e7.png"], 1000, [-20, 34], 100]] ,

    [513, [["s513e.plist/s513e0.png", "s513e.plist/s513e1.png", "s513e.plist/s513e2.png", "s513e.plist/s513e3.png", "s513e.plist/s513e4.png", "s513e.plist/s513e5.png"], 1000, [-20, 34], 100]] ,

    [10513, [["s10513e.plist/s10513e0.png", "s10513e.plist/s10513e1.png", "s10513e.plist/s10513e2.png", "s10513e.plist/s10513e3.png", "s10513e.plist/s10513e4.png", "s10513e.plist/s10513e5.png"], 1000, [-20, 34], 100]] ,
    //[170, [["s170e0.png","s170e1.png","s170e2.png","s170e3.png","s170e4.png","s170e5.png","s170e6.png","s170e7.png"], 1500, [-20, 34]]],

    [20554, [["s20554e.plist/s20554e0.png", "s20554e.plist/s20554e1.png", "s20554e.plist/s20554e2.png", "s20554e.plist/s20554e3.png", "s20554e.plist/s20554e4.png", "s20554e.plist/s20554e5.png", "s20554e.plist/s20554e6.png"], 1000, [-20, 34], 100]] ,

    [10550, [["s10550e.plist/s10550e0.png", "s10550e.plist/s10550e1.png", "s10550e.plist/s10550e2.png"], 1000, [-20, 34], 100]] ,

    [20550, [["s20550e.plist/s20550e0.png", "s20550e.plist/s20550e1.png", "s20550e.plist/s20550e2.png", "s20550e.plist/s20550e3.png", "s20550e.plist/s20550e4.png", "s20550e.plist/s20550e5.png", "s20550e.plist/s20550e6.png"], 1000, [-20, 34], 100]] ,


[11220, [["s11220e.plist/s11220e0.png", "s11220e.plist/s11220e1.png", "s11220e.plist/s11220e2.png", "s11220e.plist/s11220e3.png"], 1000, [-20, 34], 100]] ,

[11320, [["s11320e.plist/s11320e0.png", "s11320e.plist/s11320e1.png", "s11320e.plist/s11320e2.png", "s11320e.plist/s11320e3.png", "s11320e.plist/s11320e4.png", "s11320e.plist/s11320e5.png", "s11320e.plist/s11320e6.png", "s11320e.plist/s11320e7.png"], 1000, [-20, 34], 100]] ,

[11380, [["s11380e.plist/s11380e0.png", "s11380e.plist/s11380e1.png", "s11380e.plist/s11380e2.png", "s11380e.plist/s11380e3.png", "s11380e.plist/s11380e4.png", "s11380e.plist/s11380e5.png", "s11380e.plist/s11380e6.png", "s11380e.plist/s11380e7.png"], 1000, [-20, 34], 100]] ,


[1360, [["s1360e.plist/s1360e0.png", "s1360e.plist/s1360e1.png", "s1360e.plist/s1360e2.png", "s1360e.plist/s1360e3.png"], 1000, [-20, 34], 100]] ,

[11360, [["s11360e.plist/s11360e0.png", "s11360e.plist/s11360e1.png"], 1000, [-20, 34], 100]] ,

[21360, [["s21360e.plist/s21360e0.png", "s21360e.plist/s21360e1.png", "s21360e.plist/s21360e2.png", "s21360e.plist/s21360e3.png", "s21360e.plist/s21360e4.png"], 1000, [-20, 34], 100]] ,


[11230, [["s11230e.plist/s11230e0.png", "s11230e.plist/s11230e1.png", "s11230e.plist/s11230e2.png", "s11230e.plist/s11230e3.png", "s11230e.plist/s11230e4.png", "s11230e.plist/s11230e5.png", "s11230e.plist/s11230e6.png", "s11230e.plist/s11230e7.png"], 1000, [-20, 34], 100]] ,

[21230, [["s21230e.plist/s21230e0.png", "s21230e.plist/s21230e1.png", "s21230e.plist/s21230e2.png", "s21230e.plist/s21230e3.png", "s21230e.plist/s21230e4.png"], 1000, [-20, 34], 100]] ,


[1280, [["s1280e.plist/s1280e0.png", "s1280e.plist/s1280e1.png", "s1280e.plist/s1280e2.png", "s1280e.plist/s1280e3.png", "s1280e.plist/s1280e4.png", "s1280e.plist/s1280e5.png", "s1280e.plist/s1280e6.png", "s1280e.plist/s1280e7.png"], 1000, [-20, 34], 100]] ,

[11280, [["s11280e.plist/s11280e0.png", "s11280e.plist/s11280e1.png", "s11280e.plist/s11280e2.png", "s11280e.plist/s11280e3.png", "s11280e.plist/s11280e4.png", "s11280e.plist/s11280e5.png", "s11280e.plist/s11280e6.png", "s11280e.plist/s11280e7.png"], 1000, [-20, 34], 100]] ,

[21280, [["s21280e.plist/s21280e0.png", "s21280e.plist/s21280e1.png", "s21280e.plist/s21280e2.png", "s21280e.plist/s21280e3.png"], 400, [-20, 34], 100]] ,


[11290, [["s11290e.plist/s11290e0.png", "s11290e.plist/s11290e1.png", "s11290e.plist/s11290e2.png", "s11290e.plist/s11290e3.png", "s11290e.plist/s11290e4.png", "s11290e.plist/s11290e5.png", "s11290e.plist/s11290e6.png", "s11290e.plist/s11290e7.png"], 1000, [-20, 34], 100]] ,
[21290, [["s21290e.plist/s21290e0.png", "s21290e.plist/s21290e1.png", "s21290e.plist/s21290e2.png", "s21290e.plist/s21290e3.png", "s21290e.plist/s21290e4.png", "s21290e.plist/s21290e5.png", "s21290e.plist/s21290e6.png", "s21290e.plist/s21290e7.png"], 1000, [-20, 34], 100]] ,

[170, [["s170e.plist/s170e0.png", "s170e.plist/s170e1.png", "s170e.plist/s170e2.png", "s170e.plist/s170e3.png", "s170e.plist/s170e4.png"], 1000, [-20, 34], 100]] ,

[10170, [["s10170e.plist/s10170e0.png", "s10170e.plist/s10170e1.png", "s10170e.plist/s10170e2.png"], 1000, [-20, 34], 100]] ,

[10180, [["s10180e.plist/s10180e0.png", "s10180e.plist/s10180e1.png", "s10180e.plist/s10180e2.png", "s10180e.plist/s10180e3.png", "s10180e.plist/s10180e4.png", "s10180e.plist/s10180e5.png", "s10180e.plist/s10180e6.png", "s10180e.plist/s10180e7.png"], 1000, [-20, 34], 100]] ,

    [1170, [[], 0, [], 100]],

//地裂有点类似于groundBomb 但是要随着背景地图变换图片
[20050, [["s20050e.plist/s20050e0.png", "s20050e.plist/s20050e1.png", "s20050e.plist/s20050e2.png", "s20050e.plist/s20050e3.png", "s20050e.plist/s20050e4.png"], 1000, [-20, 34], 100]] ,

[1020050, [["s1020050e.plist/s1020050e0.png", "s1020050e.plist/s1020050e1.png", "s1020050e.plist/s1020050e2.png", "s1020050e.plist/s1020050e3.png", "s1020050e.plist/s1020050e4.png"], 1000, [-20, 34], 100]] ,

[2020050, [["s2020050e.plist/s2020050e0.png", "s2020050e.plist/s2020050e1.png", "s2020050e.plist/s2020050e2.png", "s2020050e.plist/s2020050e3.png", "s2020050e.plist/s2020050e4.png"], 1000, [-20, 34], 100]] ,

[3020050, [["s3020050e.plist/s3020050e0.png", "s3020050e.plist/s3020050e1.png", "s3020050e.plist/s3020050e2.png", "s3020050e.plist/s3020050e3.png", "s3020050e.plist/s3020050e4.png"], 1000, [-20, 34], 100]] ,

[4020050, [["s4020050e.plist/s4020050e0.png", "s4020050e.plist/s4020050e1.png", "s4020050e.plist/s4020050e2.png", "s4020050e.plist/s4020050e3.png", "s4020050e.plist/s4020050e4.png"], 1000, [-20, 34], 100]] ,

[5020050, [["s5020050e.plist/s5020050e0.png", "s5020050e.plist/s5020050e1.png", "s5020050e.plist/s5020050e2.png", "s5020050e.plist/s5020050e3.png", "s5020050e.plist/s5020050e4.png"], 1000, [-20, 34], 100]] ,



]);
//动画飞行

var magicAnimate = dict([

    [50, 20050],
    [51, 20050],
    [52, 20050],
    [53, 20050],

    [450, 20050],
    [451, 20050],
    [452, 20050],
    [453, 20050],

    [460, 20050],
    [461, 20050],
    [462, 20050],
    [463, 20050],

    [1060, 20050],
    [1070, 20050],
    [1120, 20050],
    [1350, 20050],

    //音乐
    [90, [90, 10001]],
    [91, [90, 10001]],
    [92, [90, 10001]],
    [93, [90, 10001]],

    //火箭
    [580, [580, 10000]],
    [581, [581, 10000]],
    [582, [582, 10000]],
    [583, [583, 10000]],
    //幻影射手
    [570, 570],
    [571, 571],
    [572, 572],
    [573, 573],
    [444, 444],
    //flybomb
    [590, [590, 10002]],
    [591, [590, 10002]],
    [592, [590, 10002]],
    [593, [590, 10002]],
    //magic
    [594, 594],

    //magic
    [520, 520],
    [521, 520],
    [522, 520],
    [523, 520],

    //magic
    [532, [532, 10004]],
    [533, [533, 10003]],

    //magic
    [540, [540, 10005]],
    [541, [540, 10005]],
    [542, [540, 10005]],
    [543, [540, 10005]],
    //rollball
    //[490, 490],

    [491, [491, 10491]],
    [492, 492],
    [493, [493, 10493]],

    //arrow
    [40, 40],
    [41, 41],
    [42, 42],
    [43, 43],
    //arrow
    [20, 20],
    [21, 21],
    [22, 22],
    [23, 23],
    
    //MAKE_FLY_ROLL
    [500, [500, 10500]],
    [501, [501, 10501, 20501]],
    [502, [-1, -1, 20502]],
    [503, [-1, -1, 20503]],

    [510, 10510],
    [511, [511, 10511]],
    [512, [512, 10512]],
    [513, [513, 10513]],

    [554, [-1, -1, 20554]],

    [550, [10550, 20550]],
    [551, [10550, 20550]],
    [552, [10550, 20550]],
    [553, [10550, 20550]],

    [10000, 10000],//抛到目的地 爆炸
    [10001, 10001],
    [10002, 10002],

    [1220, 11220],
    [1320, 11320],
    [1380, 11380],

    [1360, [1360, 11360, 21360]],
    [1230, [11230, 21230]],
    [1280, [1280, 11280, 21280]],

    [1290, [11290, 21290]],
    [170, [170, 10170]],
    [180, 10180],
    [1170, 1170],
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
var freeKey = ["id", "name", "free", "showGain"];
var freeData = dict([
[0, [0, "free0", 1, 0]],
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
const MAP_INFO = 19;
const FIGHT_COST = 20;
const MONEY_GAME_GOODS = 21;
const EXP_GAME_GOODS = 22;



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
    allTasksKey,
    herbKey,
    prescriptionKey,
    null,
    drugKey,
    fallThingKey,
    goodsListKey,
    magicStoneKey,
    skillsKey,
    statusPossibleKey,
    mapBloodKey,
    fightingCostKey,
    MoneyGameGoodsKey,
    ExpGameGoodsKey,
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
    allTasksData,
    herbData,
    prescriptionData,
    null,
    drugData,
    fallThingData,
    goodsListData,
    magicStoneData,
    skillsData,
    statusPossibleData,
    mapBloodData,
    fightingCostData,
    MoneyGameGoodsData,
    ExpGameGoodsData,
];

//更新商店load_sprite_sheet
var KindsPre = [
    "build[ID].png",
    "equip[ID].png",
    "drug[ID].png",
    "storeGold.png",
    "storeSilver.png",
    "storeCrystal.png",
    "Wplant[ID].png",
    "soldier[ID].png",
    //"soldierm[ID].plist/ss[ID]m0.png",
    "storeGold.png",
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
    null,
    null,
];

//260048  木牌位置
var obstacleBlock = 
dict(

[
[260048, 1], [250047, 1], [240046, 1],  [260046, 1], [250045, 1], [270045, 1], [270047, 1], [280046, 1],

[330055, 1], [330053, 1], [330051, 1], [650057, 1], [620052, 1], [650053, 1], [640042, 1], [660040, 1], [300028, 1], [640052, 1], [290045, 1], [290041, 1], [290043, 1], [650041, 1], [610031, 1], [640054, 1], [660054, 1], [660056, 1], [320062, 1], [280040, 1], [280042, 1], [320060, 1], [630037, 1], [620050, 1], [650055, 1], [630051, 1], [630053, 1], [280038, 1], [600046, 1], [600048, 1], [280034, 1], [280032, 1], [630043, 1], [610051, 1], [310027, 1], [640036, 1], [640038, 1], [600050, 1], [650039, 1], [610049, 1], [610045, 1], [610047, 1], [600030, 1], [300060, 1], [300062, 1], [630031, 1], [600028, 1], [270039, 1], [270033, 1], [310043, 1], [310041, 1], [310047, 1], [310045, 1], [310049, 1], [330061, 1], [300054, 1], [300050, 1], [300052, 1], [270041, 1], [290031, 1], [290033, 1], [650035, 1], [650037, 1], [290039, 1], [310051, 1], [310053, 1], [310055, 1], [310059, 1], [320052, 1], [300042, 1], [320050, 1], [300040, 1], [300046, 1], [320054, 1], [300044, 1], [300048, 1], [290027, 1], [290029, 1], [330049, 1], [660038, 1], [670055, 1], [670057, 1], [310061, 1], [660034, 1], [320046, 1], [320048, 1], [590047, 1], [300030, 1], [590049, 1]]


);


//temp = bg.addsprite("map0Def0.png").anchor(0, 0).pos(-5, 68).size(38, 339).color(100, 100, 100, 100);
//temp = bg.addsprite("map0Def1.png").anchor(0, 0).pos(775, 60).size(24, 353).color(100, 100, 100, 100);
//左边的防御装置 anchor 0 0 的位置   右边防御装置的位置 掉落物品类别0-21 药材 100-109 矿石 概率 掉落数量1个
//temp = bg.addsprite("map1.png").anchor(0, 0).pos(0, -5).size(800, 497).color(100, 100, 100, 100);
//temp = bg.addsprite("map1Def0.png").anchor(0, 0).pos(0, 77).size(51, 350).color(100, 100, 100, 100);
//temp = bg.addsprite("map1Def1.png").anchor(0, 0).pos(2, 65).size(798, 355).color(100, 100, 100, 100);

//temp = bg.addsprite("map2Def1.png").anchor(0, 0).pos(757, 76).size(43, 322).color(100, 100, 100, 100);
//temp = bg.addsprite("map2Def0.png").anchor(0, 0).pos(0, 57).size(57, 351).color(100, 100, 100, 100);
//temp = bg.addsprite("map3Def0.png").anchor(0, 0).pos(0, 57).size(43, 375).color(100, 100, 100, 100);
//temp = bg.addsprite("map3Def1.png").anchor(0, 0).pos(776, 80).size(24, 325).color(100, 100, 100, 100);
//temp = bg.addsprite("王国雪山防御装置右.png").anchor(0, 0).pos(760, 75).size(40, 325).color(100, 100, 100, 100);
//temp = bg.addsprite("王国雪山防御装置左.png").anchor(0, 0).pos(1, 48).size(44, 362).color(100, 100, 100, 100);
//temp = bg.addsprite("决斗场防御装置右.png").anchor(0, 0).pos(738, 41).size(62, 380).color(100, 100, 100, 100);
//temp = bg.addsprite("决斗场防御装置左.png").anchor(0, 0).pos(0, 0).size(83, 433).color(100, 100, 100, 100);
var mapInfo = dict([
    [0, [[-5, 68], [775, 60]]],
    [1, [[0, 77], [770, 65]]],
    [2, [[0, 57], [757, 76]]],
    [3, [[0, 57], [776, 80]]],
    [4, [[1, 48], [760, 75]]],
    [5, [[0, 0], [738, 41]]],
]);

const MAP_INITY = 87;
const MAP_INITX = 0;
const MAP_OFFX = 62;
const MAP_OFFY = 62;
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
const UPDATE_RESOURCE = 13;
const UPDATE_TASK = 14;
const UPDATE_SOL = 15;
const UPDATE_EXP = 16;
const NEW_USER = 17;
const FINISH_NAME = 18;
const UPGRADE_LOVE_TREE = 19;
const USE_DRUG = 20;
const SELL_SOL = 21;
const TRANSFER_SOL = 22;
const CALL_SOL = 23;
const UPDATE_DRUG = 24;
const BUY_DRUG = 25;
const BUY_EQUIP = 26;
const UPDATE_MAIL = 27;
const RATE_GAME = 28;
const INIT_NEIBOR_OVER = 29;
const BEGIN_BUILD = 30; //商店购买建筑物 发送建造请求 没有 接受者 将 提示不能建造
const GEN_NEW_BOX = 31;
const OPEN_BOX = 32;
const NEIBOR_RECORD = 33;
const BUY_TREASURE_STONE = 34;
const BUY_MAGIC_STONE = 35;
// 调整进度数字 param = number   每次调整之后 不是立即移动到目标而是有一个过程知道curProcess 速度由距离决定 
const LOAD_PROCESS = 36;
const SQUARE_SOL = 37;//通知buildLayer 将士兵组成方阵 以[x, y] 为中心点 同时启动所有士兵的游戏模式 可以将Game实体传递给buildLayer 调用回调函数即可
const ALL_ACTIVE_SOL = 38;//buildLayer 建立完方阵 返回士兵队列供游戏处理 
const REMOVE_SOL = 39;




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
const CHALLENGE_FIGHT = 5;//挑战擂台
const CHALLENGE_DEFENSE = 6;//防守擂台


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
const OTHER_MSG = 2;

const VISIT_PAPAYA = 0;
const VISIT_NEIBOR = 1;
const VISIT_RECOMMAND = 2;
const VISIT_RANK = 3;
const VISIT_OTHER = 4;

const UNVISIT_FRIEND = -1;
const EMPTY_SEAT = -2;
const ADD_NEIBOR_MAX = -3;
const INVITE_FRIEND = -4;


const FRIEND_CRY = 15;
const PAPAYA_CRY = 10;
const NEIBOR_CRY = 3;//3* neibornum

const ADD_MAX_CAE = 10;
const MINE_BUILD = 300;

//用户自己的水晶矿的数据是分离于普通建筑的 因此不能通过updateBuilding 来更新 需要额外的更新机制
const MINE_BID = -1;

//const MINE_BEGIN_LEVEL = 6;

const PLAN_BUILDING = 0;
const PLAN_SOLDIER = 1;

//const MAX_EQUIP_LEVEL = 12;

//const ROUND_MAP_NUM = 5;//闯关地图的数量 每关旗帜的数量由 LevelSelect 中旗帜的数量决定

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
const BOMB = 3;
const ROCKET = 4;
const MUSIC = 5;
const FLY_BOMB = 6;
const ROLL_BALL = 7;
const MAKE_FLY = 8;
const MAKE_FLY_ROLL = 9;
const FULL_STAGE = 10;
const GROUND_BOMB = 11;
const ROLL_FLY_BOMB = 12;
const EARTH_QUAKE = 13;


/*
//soldierDialog 士兵对话框
const ALL_SOL = 0;
const DEAD_SOl = 1;
const TRANSFER_SOL = 2;
*/

//NewBattle selectHero
const SETPOS = 0;
const WAIT = 1;
const CLOSEUP = 2; 
const SPEAK_NOW = 3;
const DARK_BACK = 4;
const MON_ATTACK = 5;
const MON_SPEAK = 6;


const HeroPos = dict([
    [480, [394, 240]],
    [590, [305, 311]],
    [550, [413, 387]],
    [440, [582, 317]],
]);
const HeroDir = dict([
    [480, -100],
    [590, -100],
    [550, -100],
    [440, 100],
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

//const SMOKE_SKILL_ID = 9;

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
const EXP_GAME = 10;
const PICK_GAME = 11;


const SOL_GAME = 1;
const MONEY_GAME = 2;
const GATHER_GAME = 3;

//const LOVE_TREE_ID = 208;//等级提升 则 ID 变化



var CAREER_TIT = ["career0", "career1", "career2", "career3"];

const MENU_EXP_LAYER = 10;



const RANK_BEGIN = 0;//头部数据不足
const RANK_END = 1;//尾部数据不足
const RANK_INIT = 2;//显示数据完全不在缓存中


//BackWord Command
const PRINT = 0;
const SET_TIME = 1;
const BACK_PRINT = 2;
const SET_WORD = 3;
const WAIT_PRINT = 4;
const SET_CURPOS = 5;
const BEGIN_REPEAT = 6;
const END_REPEAT = 7;


/*
const CHALLENGE_MON = 0;
const CHALLENGE_FRI = 1;
const CHALLENGE_SELF = 2;//怪兽布局 由数据库monX monY 决定
const CHALLENGE_NEIBOR = 3;
const CHALLENGE_TRAIN = 4;
const CHALLENGE_FIGHT = 5;//挑战擂台
const CHALLENGE_DEFENSE = 6;//防守擂台
*/
//NOTIP 类型 tip编号 以及对应的标题 内容 以及闯关地图对应的 NOTIP类型
const CHALLENGE_TIP = 0;
const TRAIN_TIP = 1;
const FIGHT_TIP = 2;
const HEART_TIP = 3;
const TIP_WORD = ["roundTip", "trainTitle", "fightTitle", "heartTip"];
const TIP_CON = ["noTip", "trainTipLine", "fightTip", "heartCon"];
const MAP_KIND_TIP = dict([
    [CHALLENGE_MON, CHALLENGE_TIP],
    [CHALLENGE_FRI, CHALLENGE_TIP],
    [CHALLENGE_SELF, CHALLENGE_TIP],
    [CHALLENGE_NEIBOR, CHALLENGE_TIP],
    [CHALLENGE_TRAIN, TRAIN_TIP],
    [CHALLENGE_FIGHT, FIGHT_TIP],
    [CHALLENGE_DEFENSE, FIGHT_TIP],
]);


const COLOR_INDEX = dict([
[1, 0],
[2, -163],
]);

const SOL_CATEGORY = dict([
[0, "closePhy"],
[1, "farPhy"],
[2, "farMagic"],
]);




//宝石 魔法石 
//物体类型 [物品ID ---> 语句]


const BUY_RES = dict([
    ["silver", "buySilver"],
    ["crystal", "buyCrystal"],
    ["gold", "buyGold"],
]);

//页面ID
const NEW_GOODS = 0;
const GOLD_PAGE = 1;
const SILVER_PAGE = 2;
const CRYSTAL_PAGE = 3;
const BUILD_PAGE = 4;
const DECOR_PAGE = 5;
const EQUIP_PAGE = 6;
const DRUG_PAGE = 7;

const ObjKind_Page_Map = dict([
    ["gold", GOLD_PAGE],
    ["silver", SILVER_PAGE],
    ["crystal", CRYSTAL_PAGE],
]);
const GOODS_PAGE = dict([
    [BUILD, BUILD_PAGE],
    [EQUIP, EQUIP_PAGE],
    [DRUG, DRUG_PAGE],
]);

const soldierDes = dict([
    [0, "solDes0"],
]);


const FREE_EQUIP = 0;
const USE_EQUIP = 1;
const EMPTY_PANEL = 2;


const EQUIP_KIND = 0;
const DETAIL_EQUIP = 1;
const ALL_EMPTY = 2;


const ChallengeRankKey = ["uid", "id", "score", "rank", "name", "level"];
const HeartRankKey = ["uid", "id", "score", "rank", "name", "level"];
const FightRankKey = ["uid", "id", "score", "rank", "name", "total", "level"]; 
const InviteRankKey = ["uid", "id", "score", "rank", "name", "level"];

//RankDialog
const CHALLENGE_RANK = 0;
const HEART_RANK = 1;
const FIGHT_RANK = 2;//attackRank defenseRank 大类型
const INVITE_RANK = 3; 

/*
//RankBase
const ATTACK_RANK = 3;
const DEFENSE_RANK = 4;
*/

const RANK_KEY = [ChallengeRankKey, HeartRankKey, FightRankKey, InviteRankKey];
const RANK_BUT = ["blueButton.png", "violetBut.png", "blueButton.png","blueButton.png"];
const RANK_TITLE = ["challengeRankTitle.png", "heartRankTitle.png", "defenseRankTitle.png", "inviteRankTitle.png"];
const RANK_API = ["challengeC/getRank", "friendC/getHeartRank", "fightC/getDefenseRank",  "friendC/getInviteRank"];

const Kind2Num = dict([
    [CHALLENGE_RANK, "score"],
    [HEART_RANK, "loveNum"],
    [FIGHT_RANK, "defenseNum"],
    [INVITE_RANK, "inviteNum"],
]);


const NEIBOR_REQ_KEY = ["uid", "papayaId", "name", "level", "time"];
const GIFT_KEY = ["uid", "name", "kind", "tid", "eqLevel", "time", "gid"];
const MSG_KEY = ["uid", "kind", "param", "time", "name", "mid"];

const NEIBOR_KEY = ["uid", "id", "name", "level", "mineLevel", "challengeYet", "heartYet", "heartLevel"];
const INGAME_FRIEND_KEY = ["uid", "name", "level", "id"];
const RECOMMAND_KEY = ["uid", "level", "name", "id"]; 
//更新好友的key 完全可以依赖于 服务器返回一批数据 及其对应的key
const ADD_FRIEND_KEY = ["uid", "name", "level"];

//宝箱类型
const BOX_SELF = 0;
const BOX_FRIEND = 1;

const KIND2STR = dict([
[SILVER, "silver"],
[CRYSTAL, "crystal"],
[GOLD, "gold"],
]);
const STR2KIND = dict([
["silver", SILVER],
["crystal", CRYSTAL],
["gold", GOLD],
]);

//主界面 访问 好友 还是 好友页面访问好友
const FRIEND_DIA_HOME = 0;
const FRIEND_DIA_INFRIEND = 1; 

const LOAD_CHALLENGE = 0;
const LOAD_ROUND = 1;
const LOAD_TRAIN = 2;

const TRAIN_CENTER = [465, 720];




const MAKE_NOW = 0;
const FLY_NOW = 1;
const BOMB_NOW = 2;

const PHYSIC_ATTACK = 0;
const MAGIC_ATTACK = 1;

const CLOSE_SOL = 0;
const FAR_SOL = 1;

