/**
 * 2013-12-25
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.sceneInfo
{
	public class SceneEffectParser
	{
		public function SceneEffectParser()
		{
		}
		
		public static function toObj(effectList:Array, mapId:int):Object
		{
			var res:Object = {};
			res.mapId = mapId;
			var arr:Array = [];
			res.effects = arr;
			for(var i:int=0;i<effectList.length;i++)
			{
				var effect:SceneEffectData = effectList[i];
				var obj:Object = {};
				obj.effectName = effect.effectName;
				obj.x = effect.x;
				obj.y = effect.y;
				arr.push(obj);
			}
			
			return res;
		}
		
		public static function fromObj(obj:Object):Array
		{
			var effectList:Array = [];
			if(obj == null)
			{
				return effectList;
			}
			var effects:Array = obj.effects as Array;
			if(effects == null)
			{
				return effectList;
			}
			
			for each(var o:Object in effects)
			{
				var effectData:SceneEffectData = new SceneEffectData();
				effectData.x = o.x;
				effectData.y = o.y;
				effectData.effectName = o.effectName;
				effectData.key = o.filename+"_"+o.x+"_"+o.y;
				effectList.push(effectData);
			}
			return effectList;
		}
	}
}