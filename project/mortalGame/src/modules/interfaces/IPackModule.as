package modules.interfaces
{
	import flash.geom.Point;
	
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.pack.PackItem;
	import mortal.mvc.interfaces.IView;

	public interface IPackModule extends IView
	{
//		function get selectItem():PackItem;
		function get pageTabBarSelect():int;
		function updateAllItems():void;
		function updateItems():void;
		function showUnLockItem(data:Object):void;
		function hideUnLockItem():void;
//		function setTabBarSelect(value:int):void;
//		function setPageTabBarSelect(value:int):void;
//		function setPackItemPanelSelect(value:int):void;
//		function setGuidePackIndex(value:int,text:String = "双击即可装备上"):void;
		function updataPackItemPanelSelectItem(index:int):void;
//		function showOrHideVIPBtn(isShow:Boolean,isGetReward:Boolean):void;
		function updateMoney():void;
//		function cacelPackIndexGuide():void;
		function updateCapacity():void;
//		function updataPackExtendItemPanelSelectItem(index:int):void;
//		function updateExtendAllItems(updateForce:Boolean=true):void;
//		function resetHangText():void;
//		function hideRightPart():void;
//		function getBindGoldPosition():Point;
//		function getWardrobeGlobalPosition():Point;
//		function wardrobeGuide():void;
//		function isSelectBackPack():Boolean;
	}
}