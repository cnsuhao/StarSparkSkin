//------------------------------------------------------------------------------
//
// ...
// classname: TabCloseEvent
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-10
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.events
{
	import flash.events.Event;

	public class TabCloseEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/** 当点击 TabBar 选项卡上关闭按钮时派发此通知  **/
		public static const CLOSE:String = "TabCloseEvent_Close";

		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function TabCloseEvent( type:String, index:int )
		{
			super( type, false, false );
			_index = index;
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  index
		//----------------------------------------

		private var _index:int;

		/**
		 * 在 TabBar 中的位置编号，从0开始
		 * @return
		 */
		public function get index():int
		{
			return _index;
		}

		//--------------------------------------------------------------------------
		//
		//	Override methods
		//
		//--------------------------------------------------------------------------

		override public function clone():Event
		{
			return new TabCloseEvent( type, index );
		}

	}
}
