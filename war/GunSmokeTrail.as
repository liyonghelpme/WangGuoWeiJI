class GunSmokeTrail extends MyNode
{
    function GunSmokeTrail(startPos, dir, particleId)
    {
        trace("GunSmokeTrail", startPos, particleId);
        bg = node();
        init();

        var pData = getData(PARTICLES, particleId);

        var smoke4 = dict([
              ["duration", 500], ["speed",-1], ["speedVar",1], 
              ["gravity_y", -18],
              ["position_var_x", 7], ["position_var_y", 7],
              ["angle",90], ["angle_var",10], ["particle_life",1000], ["particle_life_var",200], 
              ["start_color_red", 5], ["start_color_green", 5], ["start_color_blue", 5], ["start_color_alpha",255], 
              ["start_color_var_red",5], ["start_color_var_green",5], ["start_color_var_blue",5], 

              ["finish_color_red", 0], ["finish_color_green",0], ["finish_color_blue",0], ["finish_color_alpha", 0], 

              ["blend_additive", 0],
              ["emission_rate", 10],
              ["start_particle_size", 15],
              ["start_particle_size_var", 3],
              ["finish_particle_size", 15],
              ["finish_particle_size_var", 3],
              ["particle_life", 1000],
              ["max_particles", 100],
              ]);

        var p42 = bg.addparticle(smoke4).texture("smoke2.png").pos(startPos[0]+pData["offX"]*dir, startPos[1]+pData["offY"]);//.anchor(50, 50);
        p42.start();
    }
}
