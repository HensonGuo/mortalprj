/**
 * 头部血条 名字 称号等的容器
 * @heartspeak
 * 2014-1-15 
 */   	

package mortal.game.scene3D.player.head
{
	import com.gengine.global.Global;
	
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import baseEngine.core.Pivot3D;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.scene3D.display3d.blood.Blood3D;
	import mortal.game.scene3D.display3d.blood.BloodFactory;
	import mortal.game.scene3D.display3d.text3d.dynamicText3d.Text3D;
	import mortal.game.scene3D.display3d.text3d.dynamicText3d.Text3DFactory;
	import mortal.game.scene3D.player.entity.IHang;
	import mortal.game.view.common.UIFactory;
	
	public class HeadContainer extends Pivot3D
	{
		private static var textField:TextField;//文本源
		
		//生命血管
		protected var _bloodVisible:Boolean = true;
		protected var blood:Blood3D;//生命
		//名字文本
		protected var _nameVisible:Boolean = true;
		protected var text3D:Text3D;//文本
		//公会文本
		protected var _guildVisible:Boolean = true;
		protected var guildText3D:Text3D;
		
		private var _isLayout:Boolean = true;
		
		public function HeadContainer()
		{
			super("");
			createTextField();
		}
		
		public function get hangBoneName():String
		{
			return "nameHangBone";
		}

		/**
		 * 更新生命 
		 * @param life
		 * @param maxLife
		 * 
		 */		
		public function updateLife(life:Number,maxLife:Number,isAdd:Boolean = true):void
		{
			if(!blood)
			{
				blood = BloodFactory.createBlood3D();
				setLayout();
			}
			var bloodRate:Number = 0;
			if(maxLife > 0)
			{
				bloodRate = life/maxLife;
			}
			blood.bloodRate = bloodRate;
			this.addChild(blood);
		}
		
		/**
		 * 创建文本 
		 * 
		 */		
		private static function createTextField():void
		{
			if(!textField)
			{
				textField = UIFactory.textField("",0,0,-1,-1,null,GlobalStyle.textFormatItemWhite);
				textField.autoSize = TextFieldAutoSize.LEFT;
			}
		}
		
		/**
		 * 更新文本 
		 * @param paramText3D
		 * @param value
		 * @return 
		 * 
		 */		
		private function updateText(paramText3D:Text3D,value:String):Text3D
		{
			textField.htmlText = value;
			if(!paramText3D)
			{
				paramText3D = Text3DFactory.instance.createtext3D(textField);
			}
			else
			{
				Text3DFactory.instance.updateText3D(paramText3D,textField);
			}
			return paramText3D;
		}
		
		/**
		 * 更新名字 
		 * @param value
		 * 
		 */
		public function updateName(value:String):void
		{
			text3D = updateText(text3D,value);
			setLayout();
			this.addChild(text3D);
		}
		
		/**
		 * 更新公会名字 
		 * @param value
		 * 
		 */
		public function updateGuildName(value:String):void
		{
			if(value)
			{
				guildText3D = updateText(guildText3D,value);
				setLayout();
				this.addChild(guildText3D);
			}
			else
			{
				if(guildText3D)
				{
					Text3DFactory.instance.disposeText3D(guildText3D);
					guildText3D = null;
				}
			}
		}
		
		private function setLayout():void
		{
			if( _isLayout == true )
			{
				Global.instance.callLater(layout);
			}
			_isLayout = false;
		}
		
		private function layout():void
		{
			var w:Number = 0;
			var h:Number = 0;
			
			if( blood && blood.parent && _bloodVisible)
			{
				blood.y = h;
				h += 10;
			}
			
			if(text3D && text3D.parent && _nameVisible)
			{
				text3D.x = - int(text3D.textWidth/1.7) + 4;
				text3D.y = h;
				h += 21;
			}
			if(guildText3D && guildText3D.parent && _guildVisible)
			{
				guildText3D.x = - int(guildText3D.textWidth/1.7) + 4;
				guildText3D.y = h;
				h += 21;
			}
			_isLayout = true;
		}
		
		public function clear():void
		{
			if(blood)
			{
				BloodFactory.disposeBlood3D(blood);
				blood = null;
			}
			
			if(text3D)
			{
				Text3DFactory.instance.disposeText3D(text3D);
				text3D = null;
			}
			
			if(guildText3D)
			{
				Text3DFactory.instance.disposeText3D(guildText3D);
				guildText3D = null;
			}
			
			_bloodVisible = true;
			_nameVisible = true;
			_guildVisible = true;
		}
		
		public function show():void
		{
			updateBloodVisible(true);
			updateNameVisible(true);
			updateGuildVisible(true);
		}
		
		public function hide():void
		{
			updateBloodVisible(false);
			updateNameVisible(false);
			updateGuildVisible(false);
		}
		
		public function updateBloodVisible(isShow:Boolean = true):void
		{
			_bloodVisible = isShow;
			if(blood)
			{
				if(isShow)
				{
					blood.show();
				}
				else
				{
					blood.hide();
				}
			}
			setLayout();
		}
		
		public function updateNameVisible(isShow:Boolean = true):void
		{
			_nameVisible = isShow;
			if(text3D)
			{
				if(isShow)
				{
					text3D.show();
				}
				else
				{
					text3D.hide();
				}
			}
			setLayout();
		}
		
		public function updateGuildVisible(isShow:Boolean = true):void
		{
			_guildVisible = isShow;
			if(guildText3D)
			{
				if(isShow)
				{
					guildText3D.show();
				}
				else
				{
					guildText3D.hide();
				}
			}
			setLayout();
		}
		
		/**
		 * 返回是否为 null对象 
		 * @param display
		 * @return 
		 * 
		 */		
		private function addObject( obj:Pivot3D ):Boolean
		{
			if( obj)
			{
				if( this.contains(obj) == false )
				{
					this.addChild(obj);
				}
				return true;
			}
			return false;
		}
		
		/**
		 * 移除子对象 
		 * @param obj
		 * @return 
		 * 
		 */		
		private function removeObject( obj:Pivot3D ):Boolean
		{
			if( obj)
			{
				if( this.contains(obj) )
				{
					this.removeChild(obj);
				}
				return true;
			}
			return false;
		}
	}
}