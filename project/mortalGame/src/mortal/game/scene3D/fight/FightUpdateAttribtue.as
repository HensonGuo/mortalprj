/**
 * 定义伤害飘字的数据
 * @heartspeak
 * 2014-3-5 
 */   	

package mortal.game.scene3D.fight
{
	import mortal.game.scene3D.display3d.text3d.staticText3d.ENumberTextColor;

	public class FightUpdateAttribtue
	{
		public var hurtNumber:int = 0;//伤害数值
		public var suckNumber:int = 0;//吸收数值
		public var manaNumber:int = 0;//魔法数值
		public var reflexNumber:int = 0;//反射数值
		public var reboundNumber:int = 0;//反弹数值
		public var cureNumber:int = 0;//伤害转资料数值
		
		public var isJouk:Boolean = false;//是否闪避
		public var isImmune:Boolean = false;//是否免疫
		public var isCrit:Boolean = false;//是否暴击
		public var isCrush:Boolean = false;//是否碾压
		public var isBlock:Boolean = false;//是否格挡
		public var isAdd:Boolean = false;//是增益或者减益 正数为增益
		
		//飘字类型
		public var textDirection:int;
		public var fromX:Number = 0;
		public var fromY:Number = 0;
		public var toX:Number = 0;
		public var toY:Number = 0;
		
		/**
		 * 获取此次伤害飘字的颜色 
		 * @return 
		 * 
		 */		
		public function getColor():Number
		{
			if(manaNumber < 0)
			{
				return ENumberTextColor.blue0;
			}
			else if(manaNumber > 0)
			{
				return ENumberTextColor.blue1;
			}
			else if(hurtNumber < 0)
			{
				return ENumberTextColor.green0;
			}
			else if(hurtNumber > 0)
			{
				return ENumberTextColor.yellowAndRed;
			}
			//为0时判断增益或者减益
			else if(isAdd)
			{
				return ENumberTextColor.green0;
			}
			else
			{
				return ENumberTextColor.yellowAndRed;
			}
		}
		
		/**
		 * 获取此次攻击对应的显示文字 
		 * @return 
		 * 
		 */		
		public function getText():String
		{
			if(isJouk)
			{
				return "闪避";
			}
			else if(isImmune)
			{
				return "免疫";
			}
			else
			{
				var str:String = "";
				if(isCrit)
				{
					str += "暴击";
				}
				else if(isCrush)
				{
					str += "碾压";
				}
				else if(isBlock)
				{
					str += "格挡";
				}
				
				if(manaNumber < 0)
				{
					str += "+" + Math.abs(manaNumber);
				}
				else if(manaNumber > 0)
				{
					str += "-" + manaNumber;
				}
				else if(hurtNumber < 0)
				{
					str += "+" + Math.abs(hurtNumber);
				}
				else if(hurtNumber > 0)
				{
					str += "-" + hurtNumber;
				}
				else if(isAdd)
				{
					str += "+" + hurtNumber;
				}
				else
				{
					str += "-" + hurtNumber;
				}
				
				if(cureNumber > 0)
				{
					str += "(+" + cureNumber + ")";
				}
				
				if(suckNumber > 0)
				{
					str += "(吸收" + suckNumber + ")";
				}
				
				if(reflexNumber > 0)
				{
					str += "(反射" + reflexNumber + ")";
				}
				
				if(reboundNumber > 0)
				{
					str += "(反弹" + reboundNumber + ")";
				}
				return str;
			}
		}
		
		public function FightUpdateAttribtue()
		{
		}
	}
}