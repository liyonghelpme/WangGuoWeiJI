class MiniSoldier
{
    var id;
    var health;
    var curMap;
    var color;
    var mapSolId;
    function MiniSoldier(fullSol)
    {
        if(fullSol != null)
        {
            id = fullSol.id;
            health = fullSol.health;
            curMap = copy(fullSol.curMap);
            color = fullSol.color;
            mapSolId = fullSol.mapSolId;
        }
    }
    function printSoldier()
    {
        trace("mapId", mapSolId, "Kind", id, "health", health, "curMap", curMap, "color", color);
    }
}
