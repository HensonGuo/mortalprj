package mortal.game.view.mount.panel
{
	import Message.DB.Tables.TMountUp;
	
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.MountConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mount.data.MountData;
	import mortal.game.view.mount.data.MountToolData;

	public class MountAtrribuitePanel extends GSprite
	{
		private var _mountData:MountData;
		
		//右边
		private var _vcAttributeName:Vector.<String> = new Vector.<String>();
		private var _vcAttributeName2:Vector.<String> = new Vector.<String>();
		private var _vcAttributeNameText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeAddValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		
		private var _addSpeed:GTextFiled;
		private var _rideSpeed:GTextFiled;
		
		public function MountAtrribuitePanel()
		{
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			//右边属性
			pushUIToDisposeVec(UIFactory.bg(465, 71, 208, 303, this));
			pushUIToDisposeVec(UIFactory.bg(465, 72, 208, 26, this, ImagesConst.TextBg2));
			pushUIToDisposeVec(UIFactory.bg(465, 140, 208, 26, this, ImagesConst.TextBg2));
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountText3,473,78,this));
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountText4,473,146,this));
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountText2,570,146,this));
			
			_vcAttributeName.length = 0;
			_vcAttributeName2.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_vcAttributeName.push("attack","life", "physDefense", "magicDefense", "penetration", "jouk", "hit", "crit", "toughness", "block", "expertise");
			_vcAttributeName2.push("attack","life", "physDefense", "magicDefense", "addPenetration", "addJouk", "addHit", "addCrit", "addToughness", "addBlock", "addExpertise");
			var tempTextField:GTextFiled;
			for (var i:int ; i < _vcAttributeName.length; i++)
			{
				//属性名
				tempTextField = UIFactory.gTextField(GameDefConfig.instance.getAttributeName(_vcAttributeName[i]), 473, 169 + 18 * i, 55, 20, this, GlobalStyle.textFormatAnjin);
				_vcAttributeNameText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性数值
				tempTextField = UIFactory.gTextField("0", 537, 169 + 18 * i, 60, 20, this, GlobalStyle.textFormatPutong);
				_vcAttributeValueText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性加成值
				tempTextField = UIFactory.gTextField("(+0)", 597, 169 + 18 * i, 60, 20, this, GlobalStyle.textFormatItemGreen);
				_vcAttributeAddValueText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
			}
			
			_addSpeed = UIFactory.gTextField("0", 560, 99 , 60, 20, this, GlobalStyle.textFormatPutong);
			
			_rideSpeed = UIFactory.gTextField("0", 560, 119 , 60, 20, this, GlobalStyle.textFormatPutong);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_addSpeed.dispose(isReuse);
			_rideSpeed.dispose(isReuse);
			
			_addSpeed = null;
			_rideSpeed = null;
			
			_vcAttributeName.length = 0;
			_vcAttributeName2.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
		}
		
		/**
		 * 本坐骑属性 
		 * @param data
		 * 
		 */		
		public function setMountInfo(data:MountData):void
		{
			_mountData = data;
			
			setInfo();
		}
		
		public function setInfo():void
		{
			
			for (var i:int = 0; i < _vcAttributeName.length; i++)
			{
				var extr:int = 0;
				var tmountUp:TMountUp = MountConfig.instance.getMountUpByLevel(_mountData.sPublicMount.level) as TMountUp;
				
				if(tmountUp.hasOwnProperty(_vcAttributeName[i]))  //计算等级属性加成
				{
					if(_mountData.sPublicMount.level > 0)
					{
						extr += tmountUp[_vcAttributeName[i]];
					}
				}
				
				for each(var n:MountToolData in _mountData.toolList)  //计算777属性加成
				{
					if(n.name.toLocaleLowerCase() == "add" + _vcAttributeName[i])
					{
						extr += (MountConfig.instance.getMountToolLevel(n.level).add / 10000)*_mountData.itemMountInfo[n.name]
					}
				}
				
				
				_vcAttributeAddValueText[i].text = String(_mountData.itemMountInfo[_vcAttributeName[i]] + extr);
			}
//			_mountData.atrribuiteObj;
			setAllMountsAtrribuite();
		}
		
		/**
		 * 设置总属性 
		 * 
		 */
		public function setAllMountsAtrribuite():void
		{
			var mounts:Vector.<MountData> = Cache.instance.mount.mountList;
			for (var i:int = 0; i < _vcAttributeName.length; i++)
			{
				var value:int = 0;
				for each(var m:MountData in mounts)
				{
					if(m.isOwnMount)
					{
						var extr:int = 0;
						var tmountUp:TMountUp = MountConfig.instance.mountUpDec[m.sPublicMount.level] as TMountUp;
						
						if(tmountUp.hasOwnProperty(_vcAttributeName[i]) && m.sPublicMount.level > 0)
						{
							extr += tmountUp[_vcAttributeName[i]];
						}
						
						for each(var n:MountToolData in m.toolList)  //计算777属性加成
						{
							if(n.name.toLocaleLowerCase() == "add" + _vcAttributeName[i])
							{
								extr += (MountConfig.instance.getMountToolLevel(n.level).add / 10000)*m.itemMountInfo[n.name]
							}
						}
						
						value += (m.itemMountInfo[_vcAttributeName[i]] + extr);
					}
			
				}
				
				_vcAttributeValueText[i].text = String(value);
			}
			
			
			getMaxValueByName();
		}
		
		private function getMaxValueByName():void
		{
			var mounts:Vector.<MountData> = Cache.instance.mount.ownMountList;
			var maxAddSpeed:int;
			var maxRideSpeed:int;
			for each(var i:MountData in mounts)
			{
				var mountUp:TMountUp = (MountConfig.instance.mountUpDec[i.sPublicMount.level] as TMountUp);
				
				var addSpeedvalue:int = i.itemMountInfo.addSpeed + mountUp.addSpeed;
				if(addSpeedvalue > maxAddSpeed)
				{
					maxAddSpeed = addSpeedvalue;
				}
				
				var rideSpeed:int = i.itemMountInfo.speed + mountUp.speed;
				if(rideSpeed > maxRideSpeed)
				{
					maxRideSpeed = rideSpeed;
				}
			}
			
			_addSpeed.text = maxAddSpeed.toString(); 
			_rideSpeed.text = maxRideSpeed.toString();
			
		}
		
		public function clearWin():void
		{
			for (var i:int = 0; i < _vcAttributeName.length; i++)
			{
				_vcAttributeValueText[i].text = "0";
				_vcAttributeAddValueText[i].text = "(+0)";
				_addSpeed.text = "0";
				_rideSpeed.text = "0";
			}
		}
	}
}