package frEngine.render.layer
{

	public class Layer3DManager
	{
		public static const backGroudImgLayer:int = -2;//背景地图层
		public static const BackGroudEffectLayer:int = -1;//背景地图特效层
		public static const MapLayer:int = 5;//地图层
		public static const ShadowLayer:int = 6;//阴影层
		public static const gridLayer:int = 10; 		//网格层
		public static const MapExtendsLayer:int = 11;//地图扩展层
		public static const modelLayer0:int = 20; 	//模型底部层
		public static const modelLayer1:int = 30; 	//模型中间层
		public static const modelLayer2:int = 40; 	//模型顶部层
		public static const particleLayer:int = 50; 	//粒子层
		public static const AlphaLayer0:int = 60; 	//透明底部层
		public static const AlphaLayer1:int = 70; 	//透明中间层
		public static const AlphaLayer2:int = 80; 	//透明顶部层
		public static const IconLayer:int = 85; 	//图标层
		public static const swordLayer:int = 90; 		//刀光层
		public static const text3DLayer:int = 85; 	//图标层
		public static const BBoxLayer:int = 400; 		//边框层
		public static const HintDirection:int = 500; 	//方向层
		public static const NpcQuad:int = 600; 	//npc窗口层
		public static const Draw2dQuad:int = 700; 	//窗口层

		
		public function Layer3DManager()
		{

		}
		public static function getLayerByName(value:String):int
		{
			var targetValue:int = -1;
			switch (value)
			{
				case "groud":
					targetValue = backGroudImgLayer;
					break;
				case "model0":
					targetValue = modelLayer0;
					break;
				case "model1":
					targetValue = modelLayer1;
					break;
				case "model2":
					targetValue = modelLayer2;
					break;
				case "alpha0":
					targetValue = AlphaLayer0;
					break;
				case "alpha1":
					targetValue = AlphaLayer1;
					break;
				case "alpha2":
					targetValue = AlphaLayer2;
					break;
				default:
					throw new Error("层不存在！");
					break;
			}
			return targetValue;
		}
	}
}
