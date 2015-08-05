//------------------------------------------------------------------------------
//
// ...
// classname: DateField
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-8-4
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.comps
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	import mx.events.SandboxMouseEvent;

	import spark.components.PopUpAnchor;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.SkinnableTextBase;

	import starskin.events.DatePickerEvent;
	import starskin.namespaces.dx_internal;

	use namespace dx_internal;

	//----------------------------------------
	//  events
	//----------------------------------------

	/** 当日期选择器中的单元格被点击时派发  **/
	[Event( name = "dateSelected", type = "starskin.events.DatePickerEvent" )]

	/** 当日期选择器所选择的内容发生变化时派发  **/
	[Event( name = "dateChanged", type = "starskin.events.DatePickerEvent" )]

	/** 当与日期选择器执行清空时派发  **/
	[Event( name = "dateClear", type = "starskin.events.DatePickerEvent" )]

	//--------------------------------------
	//  SkinStates
	//--------------------------------------

	[SkinState( "open" )]

	/**
	 * 日期选择控件
	 * <p>由一个输入框，和一个 <code>starskin.comps.DatePicker</code> 控件组成。</p>
	 * @author AoSnow
	 */
	public class DateField extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function DateField()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//	Skin parts
		//
		//--------------------------------------------------------------------------

		[SkinPart( required = "false" )]
		/** 输入框控件  **/
		public var txtInput:TextInputIcon;

		[SkinPart( required = "false" )]
		/** 日期选择控件  **/
		public var datePicker:DatePicker;

		[SkinPart( required = "false" )]
		public var popUp:PopUpAnchor;

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  openState
		//----------------------------------------

		private var _openState:Boolean;

		/**
		 * 控件相关日期选择部件是否弹出
		 * @return
		 */
		public function get openState():Boolean
		{
			return _openState;
		}

		//----------------------------------------
		//  dateType
		//----------------------------------------

		/**
		 * 日期选择控件当前的选择类型
		 * <ul>
		 * <li>0 - 选择日类型（默认）</li>
		 * <li>1 - 选择月类型</li>
		 * <li>2 - 选择年类型</li>
		 * </ul>
		 * @return
		 */
		public function get dateType():int
		{
			return datePicker.dateType;
		}

		public function set dateType( value:int ):void
		{
			datePicker.dateType;
		}

		//----------------------------------------
		//  dateString
		//----------------------------------------

		/**
		 * 日期控件当前选择的内容
		 * <p><b>注意</b>：该内容会随着用户的选择而改变。</p>
		 * @return
		 */
		public function get dateString():String
		{
			return datePicker.dateString;
		}

		/**
		 * 通过指定年月日数值来更改当前选择的内容
		 * @param year 年份
		 * @param month 月份1-12
		 * @param date 日期 1-31
		 */
		public function setFullYear( year:Number, month:Number, date:Number ):void
		{
			datePicker.setFullYear( year, month, date );
		}

		/**
		 * 通过设置时间戳来更改当前选择的内容
		 * @param timestamp 自1970年1月1日以来的毫秒数（单位：毫秒）
		 */
		public function setTimestamp( timestamp:Number ):void
		{
			datePicker.setTimestamp( timestamp );
		}

		//----------------------------------------
		//  alwaysShowClear
		//----------------------------------------

		/**
		 * 是否始终显示“清除”按钮
		 * <p>清除按钮用于清除所选定的内容，以及所绑定文本控件的内容</p>
		 * <p>默认情况下，“清除”按钮是隐藏状态，只有当选择了内容后才会显示出来。</p>
		 * @return
		 */
		public function get alwaysShowClear():Boolean
		{
			return datePicker.alwaysShowClear;
		}

		public function set alwaysShowClear( value:Boolean ):void
		{
			datePicker.alwaysShowClear = value;
		}

		//----------------------------------------
		//  format
		//----------------------------------------

		/**
		 * 日期内容的格式
		 * <p>
		 * 日期内容格式可以是以下编码加任意符合的组合：
		 * <ul>
		 * <li>Y - 4 位数字完整表示的年份：例如：1999 或 2003</li>
		 * <li>y - 2 位数字表示的年份：99 或 03</li>
		 * <li>M - 三个字母缩写表示的月份：Jan 到 Dec</li>
		 * <li>m - 数字表示的月份，有前导零的 2 位数字：01 到 12</li>
		 * <li>n - 数字表示的月份，没有前导零：1 到 12</li>
		 * <li>D - 星期中的第几天，文本表示，3 个字母：Mon 到 Sun</li>
		 * <li>d - 月份中的第几天，有前导零的 2 位数字：01 到 31</li>
		 * <li>j - 月份中的第几天，没有前导零：1 到 31</li>
		 * </ul>
		 * </p>
		 * @return
		 */
		public function get format():String
		{
			return datePicker.format;
		}

		public function set format( value:String ):void
		{
			datePicker.format = value;
		}

		//--------------------------------------------------------------------------
		//
		//	Override methods
		//
		//--------------------------------------------------------------------------

		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );

			if( instance == txtInput )
			{
				txtInput.addEventListener( MouseEvent.CLICK, txtInputClickHandler );

				if( datePicker == null )
					datePicker = new DatePicker();

				datePicker.txtInput = txtInput;

				datePicker.addEventListener( DatePickerEvent.SELECTED, datePickerEventHandler );
				datePicker.addEventListener( DatePickerEvent.CHANGED, datePickerEventHandler );
				datePicker.addEventListener( DatePickerEvent.CLEAR, datePickerEventHandler );
			}

			if( instance == popUp )
			{
				popUp.popUp = datePicker;
			}
		}

		private function addCloseTriggers():void
		{
			if( systemManager )
			{
				systemManager.getSandboxRoot().addEventListener( MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler );
				systemManager.getSandboxRoot().addEventListener( SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, systemManager_mouseDownHandler );
				systemManager.getSandboxRoot().addEventListener( Event.RESIZE, systemManager_resizeHandler, false, 0, true );
			}
		}

		private function removeCloseTriggers():void
		{
			if( systemManager )
			{
				systemManager.getSandboxRoot().removeEventListener( MouseEvent.MOUSE_DOWN, systemManager_mouseDownHandler );
				systemManager.getSandboxRoot().removeEventListener( SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, systemManager_mouseDownHandler );
				systemManager.getSandboxRoot().removeEventListener( Event.RESIZE, systemManager_resizeHandler );
			}
		}

		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );

			if( instance == txtInput )
			{
				txtInput.addEventListener( MouseEvent.CLICK, txtInputClickHandler );

				datePicker.txtInput = null;

				datePicker.removeEventListener( DatePickerEvent.SELECTED, datePickerEventHandler );
				datePicker.removeEventListener( DatePickerEvent.CHANGED, datePickerEventHandler );
				datePicker.removeEventListener( DatePickerEvent.CLEAR, datePickerEventHandler );

				datePicker = null;
			}

			if( instance == popUp )
			{
				popUp.popUp = null;
			}
		}

		override protected function getCurrentSkinState():String
		{
			if( datePicker == null || !datePicker.enabled )
				return "disabled";
			else if( openState )
				return "open";
			else
				return "normal";
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		protected function openPopUpAnchor():void
		{
			if( !_openState )
			{
				datePicker.updateBeforeOpen();
				
				_openState = true;
				invalidateSkinState();
				addCloseTriggers();
			}
		}

		protected function closePopUpAnchor():void
		{
			if( _openState )
			{
				_openState = false;
				invalidateSkinState();
				removeCloseTriggers();
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		private function datePickerEventHandler( event:DatePickerEvent ):void
		{
			if( hasEventListener( event.type ))
				dispatchEvent( event );

			closePopUpAnchor();
		}

		private function txtInputClickHandler( event:MouseEvent ):void
		{
			if( _openState )
			{
				closePopUpAnchor();
			}
			else
			{
				openPopUpAnchor();
			}
		}

		dx_internal function systemManager_resizeHandler( event:Event ):void
		{
			closePopUpAnchor();
		}

		dx_internal function systemManager_mouseDownHandler( event:Event ):void
		{
			if( _openState //
			&& event.target != txtInput //
			&& event.target != datePicker //
			&& !txtInput.contains( DisplayObject( event.target )) //
			&& !datePicker.contains( DisplayObject( event.target )))
			{
				closePopUpAnchor();
			}
		}

		override protected function focusOutHandler( event:FocusEvent ):void
		{
			if( _openState //
			&& event.relatedObject != txtInput //
			&& event.relatedObject != datePicker //
			&& !txtInput.contains( DisplayObject( event.relatedObject )) //
			&& !datePicker.contains( DisplayObject( event.relatedObject )))
			{
				closePopUpAnchor();
			}

			super.focusOutHandler( event );
		}
	}
}
