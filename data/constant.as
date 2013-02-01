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
const SOL_IN_TRANSFER = 5;
const SOL_IN_DEAD = 6;

const INSPIRE = 1; 


const ISLAND_LAYER = 1; 
const CLOUD_LAYER = 2; 
const FLY_LAYER = 3;
const MAX_MAP_LAYER = 1000;

const BANNER_LAYER = 10000;


const FLAG_Z = 1;
const LOCK_Z = 2;

const MAX_BUILD_ZORD = 100000;
const SCENE_MASK_ZORD = 150000;
const MASK_ZORD = 200000;

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
//then check in which zone

//id coin crystal cae possible
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
[FARM_BUILD, [["photo"], ["acc", "sell"]]],
[HOUSE_BUILD, [["photo"], [ "sell" ]]],//"upgradeBuild"
[DECOR_BUILD, [["photo"], ["sell"]]],
[CASTLE_BUILD, [["photo"], []]],
[GOD_BUILD, [["photo"], ["soldier"]]],
[DRUG_BUILD, [["photo"], ["allDrug"]]],
[FORGE_SHOP, [["photo"], ["allEquip"]]],
[MINE_KIND, [["photo"], ["acc"]]],
[LOVE_TREE, [["photo", "invite"], ["love", "loveRank"]]],//, "upgradeBuild"
[RING_FIGHTING, [[], []]],
[CAMP, [["photo"], ["call"]]],//accSoldier
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
//动画飞行

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
var addKey = ["people", "cityDefense", "attack", "defense", "gainsilver", "gaincrystal", "gaingold", "exp", 
    "healthBoundary",
    "percentHealth",
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
const EQUIP_SKILL = 23;
const PARTICLES = 24;
const LEVEL_MAX_FALL_GAIN = 25;
const MINE_PRODUCTION = 26;
const ROUND_MONSTER_NUM = 27;
const ROUND_MAP_REWARD = 28;


var ParticleData = [];
var ParticleKey = [];



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
    equipSkillKey,
    ParticleKey,
    levelMaxFallGainKey,
    mineProductionKey,
    RoundMonsterNumKey,
    RoundMapRewardKey,
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
    equipSkillData,
    ParticleData,
    levelMaxFallGainData,
    mineProductionData,
    RoundMonsterNumData,
    RoundMapRewardData,
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
//[260048, 1], [250047, 1], [240046, 1],  [260046, 1], [250045, 1], [270045, 1], [270047, 1], [280046, 1],
[320064, 1], [310065, 1], [310063, 1], [310067, 1], [330063, 1], [320066, 1], [320068, 1], 
[330065, 1], [620044, 1], [630045, 1], [620046, 1],

[680062, 1], [690061, 1], [690063, 1], [680062, 1], [680064, 1], [690065, 1],
[680066, 1], [690067, 1],


[330055, 1], [330053, 1], [330051, 1], [650057, 1], [620052, 1], [650053, 1], [640042, 1], [660040, 1], [300028, 1], [640052, 1], [290045, 1], [290041, 1], [290043, 1], [650041, 1], [610031, 1], [640054, 1], [660054, 1], [660056, 1], [320062, 1], [280040, 1], [280042, 1], [320060, 1], [630037, 1], [620050, 1], [650055, 1], [630051, 1], [630053, 1], [280038, 1], [600046, 1], [600048, 1], [280034, 1], [280032, 1], [630043, 1], [610051, 1], [310027, 1], [640036, 1], [640038, 1], [600050, 1], [650039, 1], [610049, 1], [610045, 1], [610047, 1], [600030, 1], [300060, 1], [300062, 1], [630031, 1], [600028, 1], [270039, 1], [270033, 1], [310043, 1], [310041, 1], [310047, 1], [310045, 1], [310049, 1], [330061, 1], [300054, 1], [300050, 1], [300052, 1], [270041, 1], [290031, 1], [290033, 1], [650035, 1], [650037, 1], [290039, 1], [310051, 1], [310053, 1], [310055, 1], [310059, 1], [320052, 1], [300042, 1], [320050, 1], [300040, 1], [300046, 1], [320054, 1], [300044, 1], [300048, 1], [290027, 1], [290029, 1], [330049, 1], [660038, 1], [670055, 1], [670057, 1], [310061, 1], [660034, 1], [320046, 1], [320048, 1], [590047, 1], [300030, 1], [590049, 1]]


);

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
//const BUY_EQUIP = 26;
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
const BEGIN_DOWNLOAD = 40;

const DO_NEW_TASK = 41;
const NEW_TASK_NEXT_STEP = 42;
const SHOW_NEW_TASK_REWARD = 43;
const INIT_NEW_TASK_FIN = 44;

const FINISH_STORY = 45;
const SHOW_HINT_WORD = 46;//经营页面或者 战斗页面 有dialogController 的 对象显示 当前的 提示文字  检测当期的系统 stack为空 
const CALL_SOL_FINISH = 47;
const HAS_CHALLENGE_MSG = 48; 
const PAUSE_GAME = 49;
const RESUME_GAME = 50;
const MOVE_TO_POINT = 51;
const FINISH_NEW_TASK = 52;
const INIT_TASK_DATA = 53;//只是初始化任务 数据但是不初始化任务模块
const FETCH_PARAM_OVER = 54;
const SWITCH_MUSIC = 55;



//新手任务命令 每个消息 都有唯一的一个代理 来接受 处理  变换代理之后 需要 重新发送消息
//这个消息编号 属于 MSG——ID 编号 因此不能重复
//accelate harvest
const MOVE_TO_CAMP = 100;
const CALL_IN_CAMP = 101;
const CALL_SOLDIER = 102;
const SURE_TO_CALL = 103;

const MENU_ICON = 104;
const MAP_ICON = 105;
const FOREST_ISLAND = 106;
const FIRST_LEVEL = 107;
const RANDOM_BUT = 108;
const OK_BUT = 109;
const MAKEUP_BUT = 110; 
const SHARE_WIN = 111;
const BACK_BUSI = 112;
const NOW_IN_BUSI = 113;


//开启第二阶段新手任务
const MOVE_TO_FARM = 114;
const PLANT_ICON = 115;
const HARVEST_ICON = 116;
const NOW_HARVEST = 117;

const MOVE_TO_FALL = 118;
const PICK_FALL = 119;

const MOVE_TO_SOL = 120;
const TOUCH_SOL = 121;
const STATUS_ICON = 122;

//每个新手任务的commandList
const SHOW_THREE_ICON = 123;
//正在显示 3个 图标
const NOW_SHOW_TRHEE_ICON = 124;

//箭头显示 不能 和 check_task_icon 相同 要避免 0号命令 的check 因为缺少依赖
const CHECK_TASK_ICON = 125;
const TASK_ICON = 126;

const SHOW_NEW_STAGE = 127;
//回到经营页面任务 ---> 显示箭头  新任务出现应该 比箭头先出来
const MOVE_SOL_PICK_FALL = 128; 

const ACC_SOL = 129;
const HARVEST_SOL = 130;

const HARVEST_MINE = 132;
const HARVEST_MINE_FINISH = 133;

const CHALLENGE_BUT = 134;
const CHALLENGE_INFO_BUT = 135;
const CHALLENGE_OK_BUT = 136;
const CHALLENGE_WIN_OK = 137;
const LEVEL_UP_NOW = 138;
const OPEN_TASK_DIALOG = 139;



//装备子消息类型
const UPDATE_BUY_EQUIP = 0;
const UPDATE_USE_EQUIP = 1;
const UPDATE_UPGRADE_EQUIP = 2;


//开始技能选择目标 释放技能选择目标结束
const MAP_START_SKILL = 0;
const MAP_FINISH_SKILL = 1;
const MAP_ARRANGE = 2;


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
const CHALLENGE_OTHER = 7;
const CHALLENGE_REVENGE = 8;


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
const NEW_TASK = 3;
const SOL_TASK = 4;//购买士兵任务


//邮件信息类型
const NEIBOR_REQ = 0;
const GIFT_REQ = 1;
//挑战消息
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
//soldier attack_type
const CLOSE_FIGHTING = 0;
const LONG_DISTANCE = 1;
const MAGIC = 2;
//const BOMB = 3;
const ROCKET = 4;
//const MUSIC = 5;
const FLY_BOMB = 6;
const ROLL_BALL = 7;
const MAKE_FLY = 8;
const MAKE_FLY_ROLL = 9;
const FULL_STAGE = 10;
const GROUND_BOMB = 11;
//const ROLL_FLY_BOMB = 12;
const EARTH_QUAKE = 13;
const MAGIC_FLY = 14;
const THREE_BALL = 15;
const FIRE_BALL = 16;
const GALAXY = 17;
const GUN_SMOKE = 18;
const MAKE_FLY_TRAIL = 19;


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

/*
temp = bg.addsprite("hero440.png").anchor(50, 100).pos(568, 292).size(174, 109).color(100, 100, 100, 100);
temp = bg.addsprite("hero480.png").anchor(50, 100).pos(417, 241).size(149, 93).color(100, 100, 100, 100);
temp = bg.addsprite("hero550.png").anchor(50, 100).pos(390, 401).size(110, 124).color(100, 100, 100, 100);
temp = bg.addsprite("hero590.png").anchor(50, 100).pos(315, 305).size(198, 127).color(100, 100, 100, 100);
*/
const HeroPos = dict([
    [480, [417, 241]],
    [590, [315, 305]],
    [550, [390, 401]],
    [440, [568, 292]],
]);
const HeroDir = dict([
    [480, -100],
    [590, -100],
    [550, -100],
    [440, 100],
]);
//temp = bg.addsprite("被粘贴的图层.png").anchor(0, 0).pos(17, 5).size(112, 107).color(100, 100, 100, 100);
//temp = bg.addsprite("被粘贴的图层.png").anchor(0, 0).pos(14, -14).size(104, 109).color(100, 100, 100, 100);
//temp = bg.addsprite("被粘贴的图层.png").anchor(0, 0).pos(-7, -15).size(103, 139).color(100, 100, 100, 100);
//temp = bg.addsprite("被粘贴的图层.png").anchor(0, 0).pos(19, 12).size(121, 111).color(100, 100, 100, 100);
const HERO_LIGHT_POS = dict([
    [440, [17, 5]],
    [480, [14, -14]],
    [550, [-7, -15]],
    [590, [19, 12]],
]);

const HERO_SIZE = dict([
    [440, [144, 91]],
    [480, [124, 77]],
    [550, [92, 104]],
    [590, [164, 106]],
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
    [CHALLENGE_OTHER, CHALLENGE_TIP],
]);

//兵营建筑的色相 0默认 1特征色 2变色 三种
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
    ["papaya", "buyPapaya"],
]);

//页面ID
const TREASURE_PAGE = 0;
const BUILD_PAGE = 1;
const DECOR_PAGE = 2;
const EQUIP_PAGE = 3;
const DRUG_PAGE = 4;

const ObjKind_Page_Map = dict([
    ["gold", TREASURE_PAGE],
    ["silver", TREASURE_PAGE],
    ["crystal", TREASURE_PAGE],
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
//param 包含
const MSG_KEY = ["uid", "kind", "param", "time", "name", "mid", "level"];

const NEIBOR_KEY = ["uid", "id", "name", "level", "mineLevel", "challengeYet"];
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
const FRIEND_NO_VISIT_FRIEND = 2;//非访问好友页面使用visitDialog 不需要替换场景

const LOAD_CHALLENGE = 0;
const LOAD_ROUND = 1;
const LOAD_TRAIN = 2;

const TRAIN_CENTER = [465, 720];
const RANDOM_SOL_ZONE = [200, 498, 500, 300];
const RANDOM_SOL_POS = [
[430, 566], [300, 626], [290, 758], [416, 834], [560, 776], [570, 630],
];




const MAKE_NOW = 0;
const FLY_NOW = 1;
const BOMB_NOW = 2;

const PHYSIC_ATTACK = 0;
const MAGIC_ATTACK = 1;

const CLOSE_SOL = 0;
const FAR_SOL = 1;


//一次性命令
const FIND_ENEMY = 0;
//等待时间 指令
const MOVE_CMD = 1;
//等待时间指令
const ATTACK_CMD = 2;
//最高优先级指令
const DEAD_CMD = 3;
const MAKEUP_CMD = 4;
const POS_MOVE_CMD = 5;
const POSING_CMD = 6;
const FINISH_ATTACK = 7;
const BEGIN_ATTACK = 8;


const DOWN = 0;
const LEFT = 1;
const RIGHT = 2;
const UP = 3;

//新手任务已经获取奖励但是这个新手阶段没有完成
const TASK_DOING = 0;
const TASK_CAN_FINISH = 1;
const TASK_REWARD_YET = 2;


const SOL_SHADOW_SIZE = dict([[1, 1], [2, 2], [3, 3]]);

//测试中， 不使用木瓜帐号

//好友的水晶矿编号
const FRIEND_MINE = -1;
