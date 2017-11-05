package frEngine
{

	public class Engine3dEventName
	{
		
		public static const MATERIAL_REBUILDER:String = "material_rebuilder"; //agal programe 重新生成
		public static const FieldChange:String = "fieldChange"; //相机焦距变化
		public static const PIVOT3D_UPDATE:String = "pivot3d_update"; //物体更新事件
		public static const ADDED_EVENT:String = "added";
		public static const TRACK_CHANGE:String = "track_change";
		public static const ONFIGHT:String = "onfight";
		public static const SCENE_VIEWPORT_CHANGE:String = "scene_viewPort_change";//场景窗口发生改变
		public static const PARENT_CHANGE_EVENT:String = "changeParent";
		public static const REMOVED_EVENT:String = "removed";
		public static const ADDED_TO_SCENE_EVENT:String = "addedToScene";
		public static const REMOVED_FROM_SCENE_EVENT:String = "removedFromScene";
		public static const UNLOAD_EVENT:String = "unload";
		public static const ENTER_DRAW_EVENT:String = "enterDraw";
		public static const EXIT_DRAW_EVENT:String = "exitDraw";
		public static const UPDATE_TRANSFORM_EVENT:String = "updateTransform";
		public static const OVERLAY_RENDER_EVENT:String = "overlay_render_event";
		public static const VISIBLE_CHANGE_EVENT:String = "visible_change_event";
		public static const InitComplete:String = "InitComplete";
		public static const SetMeshSurface:String = "SetMeshSurface";
		public static const MATERIAL_CHANGE:String = "material_change";
		public static const FILTER_CHANGE:String = "changeFilters";
		public static const ALPHA_CHANGE:String = "alpha_change";
		public static const UVOFFSET_CHANGE:String = "uvoffset_change";
		public static const TEXTURE_LOADED:String = "texture_loaded";
		public static const TEXTURE_CREATE:String = "texture_create";
		public static const PARSEFINISH:String="parseFinish";
		public static const MOUSE_OVER:String="mouse_over";
		public static const MOUSE_OUT:String="mouse_out";
		public static const CHANGE_CAMERA:String="change_camera";
		public static const PLAYEND:String="playend";
		public static const CHECK_TO_DISPOSE:String="check_to_dispose";
	}
}
