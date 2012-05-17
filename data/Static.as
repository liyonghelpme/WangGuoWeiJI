//id coin crystal cae possible
var fallThings = [[0, 5, 0, 0, 10], [1, 10, 0, 0, 10], [2, 20, 0, 0, 10], [3, 30, 0, 0, 10], [4, 40, 0, 0, 10], [5, 50, 0, 0, 10], [6, 0, 0, 1, 50], [7, 0, 2, 0, 50], [8, 0, 1, 0, 100], [9, 100, 0, 0, 50]];
//id costSilver costCrystal costGold kind/farm/normal-->which zone sx sy hasAnimate funcId
var buildingData = dict([
    [0, [0, 100, 0, 0, 0, 2, 2, "普通农田", 0, 0]], 
    [1, [1, 0, 100, 0, 0, 2, 2, "魔法农田", 1, 0]]]);

//anchor 50, 100
var buildAnimate = dict([
    [1, [["mb0.png", "mb1.png", "mb2.png", "mb3.png", "mb4.png", "mb5.png", "mb6.png", "mb7.png"], [62, 49], 2000]]
]);
var buildFunc = dict([
[0, [["photo"], ["acc", "sell"]]],
]);

//level time cost gain exp name
var plantData = [
[1, 20, 10, 40, 1, "小麦"],
[1, 10*60, 10, 40, 1, "小麦"],
[1, 10*60, 10, 40, 1, "小麦"],
[1, 10*60, 10, 40, 1, "小麦"],
[1, 10*60, 10, 40, 1, "小麦"],
[1, 10*60, 10, 40, 1, "小麦"],
[1, 10*60, 10, 40, 1, "小麦"],
[1, 10*60, 10, 40, 1, "小麦"],
[1, 10*60, 10, 40, 1, "小麦"],
[1, 10*60, 10, 40, 1, "小麦"],
];

