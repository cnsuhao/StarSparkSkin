//------------------------------------------------------------------------------
//
// ...
// classname: ValidatorEvent
// author: 喵大斯( blog.csdn.net/aosnowasp )
// created: 2015-7-26
// copyright (c) 2013 喵大斯( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.events
{
	import flash.events.Event;

	/**
	 * 自动验证器事件
	 * @author AoSnow
	 */
	public class ValidatorEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/** 当验证器通过验证时派发  **/
		public static const VALID:String = "valid";

		/** 当验证器验证未通过时派发  **/
		public static const INVALID:String = "invalid";

		/** 当验证器验证结果发生变化时派发  **/
		public static const VALID_CHANGED:String = "validChanged";

		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function ValidatorEvent( type:String, valid:Boolean = false )
		{
			super( type, false, false );
			_valid = valid;
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  valid
		//----------------------------------------

		private var _valid:Boolean;

		/**
		 * 验证器验证是否通过验证
		 * @return
		 */
		public function get valid():Boolean
		{
			return _valid;
		}

		//--------------------------------------------------------------------------
		//
		//	Override methods
		//
		//--------------------------------------------------------------------------

		override public function clone():Event
		{
			return new ValidatorEvent( type, valid );
		}
	}
}
