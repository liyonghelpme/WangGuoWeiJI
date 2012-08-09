//Map big 已经-1  因为0是村子
function getRoundMonster(big, small)
{
    var k = big*10+small;
    var data = mapMonsterData.get(k);
    var res = [];
    for(var i = 0; i < len(data); i++)
    {
        var r = dict();
        for(var j = 0; j < len(mapMonsterKey); j++)
        {
            r.update(mapMonsterKey[j], data[i][j]);
        }
        res.append(r);
    }
    trace("mapMonster", res);
    return res;
}

function getRandomMapReward(big, small)
{
    var reward = mapReward.get(big*10+small);
    var v1;
    var v2;
    var v3;
    var v4;
    var res;

    var k1;
    var k2;
    var k3;
    var k4;
    //小关最后一关4 种 数量 1-10
    if(small == 6)
    {
        v1 = rand(10)+1; 
        v2 = rand(10)+1; 
        v3 = rand(10)+1; 
        v4 = rand(10)+1;

        k1 = rand(len(reward));
        k2 = (k1+1)%len(reward);
        k3 = (k1+2)%len(reward);
        k4 = (k1+3)%len(reward);
        
        res = [[k1, v1], [k2, v2], [k3, v3], [k4, v4]];
    }
    //2种 1-5
    else
    {
        v1 = rand(5)+1;
        v2 = rand(5)+1;
        res = [[reward[0], v1], [reward[1], v2]];
    }
    return res;
}
