//------------------------------------------------------------------------------
//
// ...
// classname: LinkButton
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-27
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.comps
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import spark.components.supportClasses.ButtonBase;

	/** 默认属性  **/
	[DefaultProperty( "label" )]

	/**
	 * 超链接
	 * <p>相当于没有背景的按钮组件</p>
	 * @author AoSnow
	 */
	public class LinkButton extends ButtonBase
	{
		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function LinkButton()
		{
			super();

			// enables the hand cursor
			buttonMode = true;

			mouseChildren = false;
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  url
		//----------------------------------------

		private var _url:String;

		/**
		 * 点击该链接按钮时所指向的远程页面地址
		 * @return
		 */
		public function get url():String
		{
			return _url;
		}

		public function set url( value:String ):void
		{
			_url = value;
		}

		//----------------------------------------
		//  target
		//----------------------------------------

		private var _target:String = "_blank";

		/**
		 * 以指定的目标打开链接
		 * <p>
		 * <b>支持的值如下：</b>
		 * <ul>
		 * <li>"_self" 指定当前窗口中的当前帧。</li>
		 * <li>"_blank" 指定一个新窗口。</li>
		 * <li>"_parent" 指定当前帧的父级。</li>
		 * <li>"_top" 指定当前窗口中的顶级帧。</li>
		 * <ul>
		 * </p>
		 * @return
		 */
		public function get target():String
		{
			return _target;
		}

		public function set target( value:String ):void
		{
			_target = value;
		}

		//----------------------------------------
		//  title
		//----------------------------------------

		private var _title:String;

		/**
		 * 鼠标在链接上的提示文本
		 * @return
		 */
		public function get title():String
		{
			return _title;
		}

		public function set title( value:String ):void
		{
			if( _title == value )
				return;
			_title = value;
			invalidateProperties();
		}

		//--------------------------------------------------------------------------
		//
		//	Override properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  enabled
		//----------------------------------

		override public function set enabled( value:Boolean ):void
		{
			super.enabled = value;
			buttonMode = value;
		}

		//--------------------------------------------------------------------------
		//
		//	Override methods
		//
		//--------------------------------------------------------------------------

		override protected function createChildren():void
		{
			super.createChildren();

			// event
			addEventListener( MouseEvent.CLICK, linkClickHandler );
		}

		override protected function commitProperties():void
		{
			super.commitProperties();

			if( title && title.length > 0 )
			{
				toolTip = title;
			}
			else
			{
				toolTip = null;
			}
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * 使用当前系统默认的浏览器，打开指定的 url 网址
		 * @param value url 网址
		 */
		protected static function openurl( url:String, target:String ):void
		{
			navigateToURL( new URLRequest( url ), target );
		}

		public function destory():void
		{
			_url = _target = _title = "";
			toolTip = null;
			enabled = false;
			removeEventListener( MouseEvent.CLICK, linkClickHandler );
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		protected function linkClickHandler( event:MouseEvent ):void
		{
			if( url )
			{
				openurl( url, target );
			}
		}
	}
}
