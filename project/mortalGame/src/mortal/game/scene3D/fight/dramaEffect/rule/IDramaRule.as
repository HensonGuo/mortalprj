package mortal.game.scene3D.fight.dramaEffect.rule
{
	import mortal.game.scene3D.fight.dramaEffect.data.DramaMoveData;
	import mortal.game.scene3D.model.player.EffectPlayer;

	public interface IDramaRule
	{
		//播放
		function play($effectPlayer:EffectPlayer,$dramaMoveData:DramaMoveData,endCallBack:Function = null):void
	}
}