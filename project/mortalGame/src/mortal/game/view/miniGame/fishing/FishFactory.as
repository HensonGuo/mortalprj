package mortal.game.view.miniGame.fishing
{
	import com.gengine.utils.pools.ObjectPool;
	
	import mortal.game.resource.StaticResUrl;
	import mortal.game.scene.modle.FishPlayer;
	import mortal.game.scene.modle.SWFPlayer;
	import mortal.game.scene.modle.data.ModelType;
	import mortal.game.scene.player.entity.SpritePlayer;
	import mortal.game.scene.player.item.SkillsPlayer;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.miniGame.fishing.Obj.Fish;
	import mortal.game.view.miniGame.fishing.Obj.FishActionObject;
	import mortal.game.view.miniGame.fishing.Obj.Obstacle;
	import mortal.game.view.miniGame.fishing.ObjController.FishBaseController;
	import mortal.game.view.miniGame.fishing.ObjController.ObstacleController;
	import mortal.game.view.miniGame.fishing.ObjController.PowerForceFishController;
	import mortal.game.view.miniGame.fishing.ObjController.UniformFishController;
	import mortal.game.view.miniGame.fishing.defin.FishDirection;
	import mortal.game.view.miniGame.fishing.defin.FishModelDefin;
	import mortal.game.view.miniGame.fishing.defin.Speed;

	public class FishFactory
	{
		public static function randomObj():FishActionObject
		{
			var random:Number = Math.random();
			if(random < 0.73)
			{
				return randomFish();
			}
			else
			{
				return getObstacle();
			}
		}
		
		/**
		 * 获得一个障碍物 
		 * @return 
		 * 
		 */
		public static function getObstacle():Obstacle
		{
			var randomDir:Number = Math.random();
			var dir:int = randomDir < 0.6?FishDirection.RIGHT:FishDirection.LEFT;
			var ctrl:ObstacleController = new ObstacleController(Speed.SLOW,dir);
			var obstacle:Obstacle = new Obstacle(ctrl,getFishPlayer("Obstacle.swf"));
			ctrl.autoRun();
			return obstacle;
		}
		
		/**
		 * 随即获得一个鱼 
		 * @return 
		 * 
		 */		
		public static function randomFish():Fish
		{
			var randomFishType:Number = Math.random();
			var random:Number = Math.random();
			var randomDir:Number = Math.random();
			var fishModel:FishModelDefin = randomFishModel();
			var dir:int = randomDir < 0.6?FishDirection.RIGHT:FishDirection.LEFT;
			var fish:Fish;
			if(fishModel.activeType == UniformFishController || fishModel.activeType == null && randomFishType < 0.7)
			{
				if(random < 0.6)
				{
					fish = getUniformFish(Speed.SLOW,dir,fishModel.url);
				}else if(random < 0.88)
				{
					fish = getUniformFish(Speed.NORMAL,dir,fishModel.url);
				}
				else
				{
					fish = getUniformFish(Speed.FAST,dir,fishModel.url);
				}
			}
			else
			{
				fish = getPowerForceFish(7,0.05,0.3,dir,fishModel.url);
			}
			fish.maxDepth = fishModel.maxDepth;
			fish.minDepth = fishModel.minDepth;
			return fish;
		}
		
		/**
		 * 获得一个匀速运动的鱼 
		 * @param speed
		 * @return
		 * 
		 */
		public static function getUniformFish(speed:int,horizontalDirection:int = FishDirection.RIGHT,url:String = ""):Fish
		{
			if(url == "")
			{
				url = getRandomFishUrl();
			}
			var ctrl:UniformFishController = new UniformFishController(speed,horizontalDirection);
			var fishPlayer:FishPlayer = getFishPlayer(url,horizontalDirection);
//			swfPlayer.load(StaticResUrl.Fish1,ModelType.Skill,null);
			var obj:Fish = new Fish(ctrl,fishPlayer);
			ctrl.autoRun();
			return obj;
		}
		
		/**
		 * 获得一个冲冲鱼 
		 * @param maxSpeed
		 * @param maxLastTime
		 * @param decTime
		 * @param horizontalDirection
		 * @return 
		 * 
		 */		
		public static function getPowerForceFish(maxSpeed:Number = 3,decPer:Number = 0.05,minSpeed:Number = 0.1,horizontalDirection:int = FishDirection.RIGHT,url:String = ""):Fish
		{
			if(url == "")
			{
				url = getRandomFishUrl();
			}
			var ctrl:PowerForceFishController = new PowerForceFishController(maxSpeed,decPer,minSpeed,horizontalDirection);
			var fishPlayer:FishPlayer = getFishPlayer(url,horizontalDirection);
			var obj:Fish = new Fish(ctrl,fishPlayer);
			ctrl.autoRun();
			return obj;
		}
		
		/**
		 * 随即得到一个鱼的模型 
		 * @return 
		 * 
		 */		
		public static function randomFishModel():FishModelDefin
		{
			var index:int = Math.floor(Math.random() * 8);
			return FishModelDefin.allFishType[index];
		}
		
		/**
		 * 得到一个爆炸的SWFPlayer 
		 * @return 
		 * 
		 */		
		public static function getSquibPlayer():SWFPlayer
		{
			var swfPlayer:SkillsPlayer = ObjectPool.getObject(SkillsPlayer);
			swfPlayer.load("FishSquib.swf",ModelType.Skill,null);
			return swfPlayer;
		}
		
		/**
		 * 获得一个鱼模型
		 * @param url
		 * @param dir
		 * @return 
		 * 
		 */		
		private static function getFishPlayer(url:String,dir:int = FishDirection.LEFT):FishPlayer
		{
			var fishPlayer:FishPlayer = ObjectPool.getObject(FishPlayer);
			fishPlayer.load(url,ModelType.Skill,null);
			if(dir == FishDirection.LEFT)
			{
				fishPlayer.isFishTurn = true;
			}
			else
			{
				fishPlayer.isFishTurn = false;
			}
			return fishPlayer;
		}
		
		/**
		 * 随即一个鱼资源路径 
		 * @return 
		 * 
		 */
		private static function getRandomFishUrl():String
		{
			var index:int = Math.ceil(Math.random() * 8);
			if(index == 0)
			{
				index = 1;
			}
			return "fish" + (index + 1) + ".swf";
		}
	}
}