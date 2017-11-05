package mortal.game.view.forging.view
{
	import baseEngine.core.Mesh3D;
	
	import com.mui.controls.GSprite;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import mortal.common.DisplayUtil;
	import mortal.component.window.Window;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.forging.ForgingModule;
	import mortal.game.view.palyer.PlayerEquipItem;
	
	/**
	 * @date   2014-3-27 上午11:09:40
	 * @author dengwj
	 */	 
	public class ForgingPanelBase extends GSprite
	{
		protected var _window:Window;
		
		protected var _gemSpr:Sprite
		/** 宝石格子 */
		protected var _gemItemArr:Array = new Array();
		/** 3D模型背景图 */
		protected var bg3d:BitmapData;
		/** mesh3D对象 */
		protected var meshObject:Mesh3D;
		
		public function ForgingPanelBase(window:Window = null)
		{
			this._window = window;
			
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl()
				
			this._gemSpr = UIFactory.sprite(0,0,this);
		}
		
		// 子类重写
		public function updateUI():void
		{
//			add3DModel();
		}
		
		// 子类重写
		public function updateGemList(gemList:Array):void
		{
			
		}
		
		// 子类重写 
		protected function add3DModel():void
		{
			
		}
		
		// 子类重写
		public function update3DModel():void
		{
			
		}
		
//		protected function remove3DModel():void
//		{
//			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
//			if(this.meshObject && rect3d)
//			{
//				rect3d.removeBackImg(bg3d);
//				rect3d.removeMesh3d(this.meshObject);
//				this.meshObject = null;
//			}
//		}
		
		/**
		 * 设置宝石开孔状态 
		 * @param holeNum
		 * 
		 */		
		public function setGemHoleStatus(holeNum:int):void
		{
			for(var i:int = 0; i < this._gemItemArr.length; i++)
			{
				if(i < holeNum)
				{
					if(this._gemItemArr[i].itemData == null)
					{
						this._gemItemArr[i].isOpened = true;
					}
				}
				else
				{
					this._gemItemArr[i].isOpened = false;
				}
			}
		}
		
		/**
		 * 创建宝石格子 
		 */		
		protected function createGemGrids():void
		{
			this._gemItemArr = [];
			for(var i:int = 0; i < 8; i++)
			{
				var gemItem:GemItem = new GemItem();
				this._gemItemArr.push(gemItem);
				var x:int = 8 + 287 * (int(i % 2));
				var y:int = 30 + 52 * (int(i / 2));
				gemItem.x = x;
				gemItem.y = y;
				gemItem.setItemStyle(ItemStyleConst.Small,ImagesConst.SkillRuneBg,6,6);
				this._gemSpr.addChild(gemItem);
				this.pushUIToDisposeVec(gemItem);
			}
		}
		
		public function get gemItemArr():Array
		{
			return this._gemItemArr;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			DisplayUtil.removeMe(PlayerEquipItem.SelEffectSwf);
			this._gemSpr = null;
			this._gemItemArr.length = 0;
		}
	}
}